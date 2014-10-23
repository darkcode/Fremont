//
//  FMXMLDeserializer.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "FMXMLDeserializer.h"
#import <objc/runtime.h>
#import "FMXMLEnums.h"
#import "FMXMLDataTypeConverter.h"
#import "FMXMLError.h"
#import "FMXMLConstants.h"
#import "FMXMLModelClass.h"


@implementation FMXMLDeserializer

@synthesize modelDefinition;
@synthesize currentNode;
@synthesize model;
@synthesize error;

#pragma mark -
#pragma mark Initialization

- (id)initWithModelDefinition:(FMXMLModelDefinition *)mDef; 
{
	if (self = [super init]) 
	{
		self.modelDefinition = mDef;
	}
	
	return self;
}

#pragma mark -
#pragma mark Deserialization

- (id)fromXML:(NSString *)xml withEncoding:(NSStringEncoding)encoding;
{
	if (! modelDefinition)
	{
		[NSException raise:@"Model definition not found" format:@"There must be a model definition to convert the XML to an object."];		
	}
	
	if (modelDefinition) 
	{
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:encoding]];
		[parser setDelegate:self];
		[parser setShouldProcessNamespaces:NO];
		[parser setShouldReportNamespacePrefixes:NO];
		[parser setShouldResolveExternalEntities:NO];
		
		BOOL success = [parser parse];
		[parser release];
		
		if (success)
		{
			return [[model retain] autorelease];
		}
		else
		{
			// error should already be set
			return nil;
		}
	}
	else
	{
		self.error = [FMXMLError errorWithCode:ECD_MODEL_DEFINITION_NOT_FOUND description: @"Deserializing from XML"];
		return nil;
	}
}

#pragma mark -
#pragma mark Helper methods

- (SEL)selectorFromPropertyName:(NSString *)propertyName;
{
	NSString *firstChar = [propertyName substringToIndex:1];
	propertyName = [propertyName stringByReplacingOccurrencesOfString:firstChar withString:[firstChar uppercaseString] options:0 range: NSMakeRange(0, 1)];
	return NSSelectorFromString([@"set" stringByAppendingString:[propertyName stringByAppendingString:@":"]]);
}

- (void)setProperty:(NSString *)propertyName onObject:(id)obj withValue:(id)valueObject;
{
	if (valueObject) 
	{
		SEL propSelector = [self selectorFromPropertyName:propertyName];
		[obj performSelector:propSelector withObject:valueObject];						
	}
}

- (void)createContainerObject:(FMXMLNode *)node;
{
	if (node.dataType == ARRAY) 
	{
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		node.modelObject = arr;
		[arr release];
		
		node.modelArray = [modelDefinition getModelArrayByXMLName:node.name];
	}
	else if (node.dataType == DICTIONARY)
	{
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		node.modelObject = dict;
		[dict release];
		
		node.modelDictionary = [modelDefinition getModelDictionaryByXMLName:node.name];
	}
	else if (node.dataType == UDC) 
	{
		FMXMLModelClass *modelClass = [modelDefinition getModelClassByXMLName:node.name];
		node.modelClass = modelClass;
		
		Class class = NSClassFromString(modelClass.className);
		NSObject *obj = [[class alloc] init];
		node.modelObject = obj;
		[obj release];
	}	
	
	if (node.modelObject && node.prevNode && node.prevNode.modelObject) 
	{
		if ([node isModelProperty])
		{
			[self setProperty:node.modelProperty.propertyName onObject:node.prevNode.modelObject withValue:node.modelObject];
		}
		else if ([node isModelArrayElement])
		{
			[(NSMutableArray *)node.prevNode.modelObject addObject:node.modelObject];
		}
		else if ([node isModelDictionaryElement])
		{
			[(NSMutableDictionary *)node.prevNode.modelObject setObject:node.modelObject forKey:node.modelDictionaryElement.key];			
		}
	}
}

#pragma mark -
#pragma mark NSXMLParser delegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser;
{
	self.currentNode = nil;
	self.model = nil;
	self.error = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser;
{
	self.currentNode = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;
{
	//NSLog(@"start element: %@", elementName);
	
	// create a new node
	FMXMLNode *newNode = [[FMXMLNode alloc] initWithName:elementName];
	
	// determine if this is the root 
	if (currentNode) 
	{
		[currentNode addNode:newNode];
		
		// determine the type of parent, process accordingly
		if ([currentNode shouldIgnore])
		{
			// ignore
			newNode.dataType = UNKNOWN;
		}
		else if ([currentNode isModelClass])
		{
			// this node should be a property
			
			newNode.modelProperty = [currentNode.modelClass getPropertyByXMLName:elementName];
			
			if (newNode.modelProperty)
			{
				newNode.dataType = newNode.modelProperty.dataType;
				
				if ([newNode isContainerType])
				{
					[self createContainerObject:newNode];					
				}
			}
			else 
			{
				// no property found, ignore this node
				newNode.dataType = UNKNOWN;
			}
		}
		else if ([currentNode isModelArray])
		{
			// this node should be an array element
			
			newNode.modelArrayElement = currentNode.modelArray.modelArrayElement;
			
			if (newNode.modelArrayElement)
			{
				newNode.dataType = newNode.modelArrayElement.dataType;
				
				if ([newNode isContainerType])
				{
					[self createContainerObject:newNode];					
				}
			}
			else 
			{
				// no property found, ignore this node
				newNode.dataType = UNKNOWN;
			}			
		}
		else if ([currentNode isModelDictionary])
		{
			// this node should be a dictionary element
			
			newNode.modelDictionaryElement = [currentNode.modelDictionary getElementByXMLName:elementName];
			
			if (newNode.modelDictionaryElement)
			{
				newNode.dataType = newNode.modelDictionaryElement.dataType;
				
				if ([newNode isContainerType])
				{
					[self createContainerObject:newNode];					
				}
			}
			else 
			{
				// no property found, ignore this node
				newNode.dataType = UNKNOWN;
			}						
		}
		else
		{
			// this should never happen, but if it does, this should result in it begin ignored
			newNode.dataType = UNKNOWN;
		}
		
		if (newNode.dataType == ENUM)
		{
			newNode.modelEnum = [modelDefinition getModelEnumByXMLName:elementName];
		}
	}
	else
	{
		// this is the root
		FMXMLModelRoot *modelRoot = modelDefinition.modelRoot;	
		
		// check the element name, that it matches with the root
		if (! [modelRoot.xmlName isEqualToString:elementName]) 
		{
			//set error here
			[NSException raise:@"Model root doesn't match the document root" format:@"The model root in the model definition must match the document root in the XML file."];	
		}
		else 
		{
			newNode.dataType = modelRoot.dataType;
			
			if ([newNode isContainerType])
			{
				[self createContainerObject:newNode];					
			}
		}
	}
	
	// process model class attributes
	if ([newNode isModelClass]) 
	{
		//this is an UDC, and all attributes must be processed to set properties
		NSArray *attrKeys = [attributeDict allKeys];
		for (NSString *attrName in attrKeys) 
		{			
			FMXMLModelProperty *modelProperty = [newNode.modelClass getPropertyByXMLName:attrName];
			if (modelProperty) 
			{
				FMXMLDataType dataType = modelProperty.dataType;
				if (modelProperty.xmlType == ATTRIBUTE) 
				{
					// the model property is an attribute
					
					if (dataType == STRING || dataType == NUMBER || dataType == DATE || dataType == BOOLEAN) 
					{
						NSString *stringValue = [attributeDict objectForKey:attrName];
						
						if (stringValue) {
							id valueObject = [FMXMLDataTypeConverter convertToObject:stringValue withDataType:dataType withFormat:modelProperty.formatString];
							
							[self setProperty:modelProperty.propertyName onObject:newNode.modelObject withValue:valueObject];
						}
					}
					else if (dataType == ENUM) {
						FMXMLModelEnum *modelEnum = [modelDefinition getModelEnumByXMLName:modelProperty.xmlName];
						NSString *stringValue = [modelEnum getValueForName:[attributeDict objectForKey:attrName]];
						id valueObject = [FMXMLDataTypeConverter convertToObject:stringValue withDataType:dataType withFormat:modelProperty.formatString];
						[self setProperty:modelProperty.propertyName onObject:newNode.modelObject withValue:valueObject];
					}
				}
				else
				{
					// there is a model property, but it is not configured as an attribute, so ignore
				}
			}
			else
			{
				// there is no associated model property, so ignore
			}
		}
	}
	
	self.currentNode = newNode;	
	[newNode release];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
	//NSLog(@"end element: %@", elementName);
	
	if (currentNode)
	{
		// determine the type of parent, process accordingly
		if ([currentNode shouldIgnore])
		{
			// ignore
		}
		else 
		{
			
			
			if (! [currentNode isContainerType])
			{		
				id valueObject = nil;
				FMXMLDataType dataType = currentNode.dataType;
				
				if (dataType == STRING || dataType == NUMBER || dataType == DATE || dataType == BOOLEAN) 
				{
					if (currentNode.characters && ! [currentNode.characters isEqualToString:@""]) 
					{
						valueObject = [FMXMLDataTypeConverter convertToObject:currentNode.characters withDataType:dataType withFormat:currentNode.modelProperty.formatString];					
					}
				}
				else if (dataType == ENUM) 
				{				
					NSString *stringValue = [currentNode.modelEnum getValueForName:currentNode.characters];
					valueObject = [FMXMLDataTypeConverter convertToObject:stringValue withDataType:dataType withFormat:currentNode.modelProperty.formatString];
				}
				else if (dataType == DATA) 
				{
					if (currentNode.data)
					{
						valueObject = currentNode.data;
					}
				}
				
				if (valueObject)
				{
					if ([currentNode isModelProperty])
					{
						[self setProperty:currentNode.modelProperty.propertyName onObject:currentNode.prevNode.modelObject withValue:valueObject];
					}
					else if ([currentNode isModelArrayElement])
					{
						[(NSMutableArray *)currentNode.prevNode.modelObject addObject:valueObject];
					}
					else if ([currentNode isModelDictionaryElement])
					{
						[(NSMutableDictionary *)currentNode.prevNode.modelObject setObject:valueObject forKey:currentNode.modelDictionaryElement.key];	
					}
				}
				
			}
			else if ([currentNode isModelClass]) 
			{
				currentNode.characters = [currentNode.characters stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				// process any text property 
				if (currentNode.characters && ! [currentNode.characters isEqualToString:@""] && 
					currentNode.modelClass.textPropertyName && ! [currentNode.modelClass.textPropertyName isEqualToString:@""]) 
				{
					id valueObject = [FMXMLDataTypeConverter convertToObject:currentNode.characters withDataType:currentNode.modelClass.textDataType withFormat:currentNode.modelClass.textFormatString];					
					[self setProperty:currentNode.modelClass.textPropertyName onObject:currentNode.modelObject withValue:valueObject];
				}
			}
			
		}
	}
	
	
	if (self.currentNode.prevNode) 
	{
		self.currentNode = [currentNode prevNode];
		self.currentNode.nextNode = nil;			
	}
	else
	{
		//parsing is finished, set the model object
		self.model = currentNode.modelObject;
		self.currentNode = nil;
	}
}

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI;
{
	// ignore
}

- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix;
{
	// ignore
}

- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)entityName systemID:(NSString *)systemID;
{
	// ignore
	return nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;
{
	self.model = nil;
	self.error = parseError;
	
	[parser abortParsing];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError;
{
	self.model = nil;
	self.error = validError;
	
	[parser abortParsing];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
{
	if (! currentNode.characters)
	{
		currentNode.characters = string;		
	}
	else
	{
		currentNode.characters = [currentNode.characters stringByAppendingString:string];		
	}
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString;
{
	// ignore
}

- (void)parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data;
{
	// ignore
}

- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment;
{
	// ignore
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock;
{
    FMXMLDataType dataType = currentNode.dataType;
    
    if ( dataType == STRING ) {
        NSString *cdataString = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        currentNode.characters = cdataString;
        [cdataString release];
        
    } else {
        
        NSString *base64String = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        currentNode.data = [FMXMLDataTypeConverter stringToData:base64String];
        [base64String release];
    }
}

- (void)dealloc {
	[modelDefinition release];
	[currentNode release];
	[model release];
	[error release];
	[super dealloc];
}

@end
