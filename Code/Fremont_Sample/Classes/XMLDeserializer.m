//
//  XMLDeserializer.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "XMLDeserializer.h"
#import <objc/runtime.h>
#import "Enums.h"
#import "DataTypeConverter.h"

@implementation XMLDeserializer

@synthesize modelDefinition, currentNode, model, error, parser;

- (id)initWithModelDefinition:(ModelDefinition *)mDef {
	self = [super init];
	self.modelDefinition = mDef;
	return self;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	self.currentNode = nil;
	self.model = nil;
	self.error = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	self.currentNode = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	ModelClass *mClass = nil;
	ModelProperty *mProp = nil;
	id mObject = nil;
	SEL propSelector = nil;
	
	//determine if this is a model property of the parent model class
	if (! currentNode) {
		//this must be the root, so attempt to find a model class
		mClass = [modelDefinition getModelClassByXMLName:elementName];
		id classDef = objc_getClass([mClass.className UTF8String]);
		mObject = class_createInstance(classDef, 0);
	}
	else if (! currentNode.modelClass) {
		//parent node has no model class definition, so this cannot be a model property
		//the only case we want to handle is if the parent is an array type
		//check if the parent is an array, otherwise, ignore
		if (currentNode.modelProperty.dataType == ARRAY) {
			//the parent is an array
			NSMutableArray *array = (NSMutableArray *)currentNode.modelObject;
			//create the child object
			mClass = [modelDefinition getModelClassByXMLName:elementName];			
			id classDef = objc_getClass([mClass.className UTF8String]);
			mObject = class_createInstance(classDef, 0);			
			[array addObject:mObject];
		} 
	} else {
		//there is a parent model class, so check if this element is a property 
		mProp = [currentNode.modelClass getPropertyByXMLName:elementName];
		if (mProp) {
			//this is a property, so handle the two containment types
			switch (mProp.dataType) {
				case ARRAY:
					mObject = [NSMutableArray arrayWithCapacity:5];
					break;
				case UDF:
					mClass = [modelDefinition getModelClassByXMLName:elementName];
					id classDef = objc_getClass([mClass.className UTF8String]);
					mObject = class_createInstance(classDef, 0);
					break;
				default:
					break;
			}
		}
	}
	
	if (mProp && mObject) {
		//this is a property, with an object ready to set
		propSelector = [self selectorFromPropertyName:mProp.propertyName];
		objc_msgSend(currentNode.modelObject, propSelector, mObject);	
	}
		
	if (mClass) {
		//this is a UDF, and all attributes must be processed to set properties
		NSArray *attrKeys = [attributeDict allKeys];
		for (NSString *attrName in attrKeys) {
			ModelProperty *childProp = [mClass getPropertyByXMLName:attrName];
			if (childProp) {
				DataType dataType = childProp.dataType;
				if (childProp.xmlType == ATTRIBUTE && (dataType == STRING || dataType == NUMBER || dataType == DATE || dataType == BOOLEAN)) {
					NSString *stringValue = [attributeDict objectForKey:attrName];
					if (! stringValue)
						continue;					
					id valueObject = [DataTypeConverter convertToObject:stringValue WithDataType:dataType WithFormat:childProp.formatString];
					propSelector = [self selectorFromPropertyName:childProp.propertyName];
					objc_msgSend(mObject, propSelector, valueObject);	
				}
			}
		}
	}
		
	//create the new node
	DoublyLinkedListNode *newNode = [[[DoublyLinkedListNode alloc] initWithName:elementName] autorelease]; 
	newNode.modelClass = mClass;
	newNode.modelObject = mObject;
	newNode.modelProperty = mProp;
	
	if (! currentNode) {
		self.currentNode = newNode;
	}
	else {
		[self.currentNode addNode:newNode];
		self.currentNode = newNode;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	DoublyLinkedListNode *thisNode = currentNode;
	self.currentNode = [currentNode removeThisNode];
	
	//if the current node is a non-containment type set the value
	if (thisNode) {
		NSObject *mObject;
		DataType dataType;
		NSString *propertyName = nil;
		NSString *formatString;
		ModelProperty *mProp;
		
		if (thisNode.modelClass) {
			//this is a UDF
			ModelClass *mClass = thisNode.modelClass;
			mObject = thisNode.modelObject;
			dataType = mClass.textDataType;
			propertyName = mClass.textPropertyName;
			formatString = mClass.textFormatString;
		}
		else if (thisNode.modelProperty) {
			//this is a non-containment type
			mProp = thisNode.modelProperty;
			mObject = currentNode.modelObject;
			dataType = mProp.dataType;
			propertyName = mProp.propertyName;
			formatString = mProp.formatString;
		}
		
		if (propertyName && ! [propertyName isEqualToString:@""]) {
			SEL propSelector = [self selectorFromPropertyName:propertyName];
			
			if (dataType == STRING || dataType == NUMBER || dataType == DATE || dataType == BOOLEAN) {
				if (thisNode.characters && ! [thisNode.characters isEqualToString:@""]) {
					id valueObject = [DataTypeConverter convertToObject:thisNode.characters WithDataType:dataType WithFormat:formatString];
					objc_msgSend(mObject, propSelector, valueObject);	
				}
			}
			else if (dataType == ENUM) {				
				ModelEnum *mEnum = [modelDefinition getModelEnumByXMLName:mProp.xmlName];
				NSString *stringValue = [mEnum getValueForName:thisNode.characters];
				id valueObject = [DataTypeConverter convertToObject:stringValue WithDataType:dataType WithFormat:formatString];
				objc_msgSend(mObject, propSelector, valueObject);	
			}
			else if (dataType == DATA) {
				if (thisNode.data)
					objc_msgSend(mObject, propSelector, thisNode.data);
			}
			else if (dataType == IMG_PNG || dataType == IMG_JPEG) {
				if (thisNode.data) {
					id valueObject = [DataTypeConverter dataToImage:thisNode.data];
					objc_msgSend(mObject, propSelector, valueObject);	
				}
			}
		}
		
		thisNode.characters = nil;
		thisNode.data = nil;
	}
	
	if (! self.currentNode) {
		//parsing is finished, set the model object
		self.model = thisNode.modelObject;
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	self.model = nil;
	self.error = parseError;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (! currentNode.characters)
		currentNode.characters = string;
	else
		currentNode.characters = [currentNode.characters stringByAppendingString:string];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
	currentNode.data = CDATABlock;
}

- (SEL)selectorFromPropertyName:(NSString *)propertyName {
	NSString *firstChar = [propertyName substringToIndex:1];
	propertyName = [propertyName stringByReplacingOccurrencesOfString:firstChar withString:[firstChar uppercaseString] options:0 range: NSMakeRange(0, 1)];
	return NSSelectorFromString([@"set" stringByAppendingString:[propertyName stringByAppendingString:@":"]]);
}

- (id)fromXML:(NSString *)xml WithEncoding:(NSStringEncoding)encoding {
	if (! modelDefinition)
		[NSException raise:@"Model definition not found" format:@"There must be a model definition to convert the XML to an object."];

	BOOL success;
	parser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:encoding]];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	success = [parser parse];
	self.parser = nil;
	
	if (success)
		return model;
	else
		return nil;
}

- (void)dealloc {
	[modelDefinition release];
	[currentNode release];
	[model release];
	[error release];
	[parser release];
	[super dealloc];
}

@end
