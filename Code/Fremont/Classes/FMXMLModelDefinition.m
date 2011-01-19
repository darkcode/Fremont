//
//  FMXMLModelDefinition.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "FMXMLModelDefinition.h"
#import "FMXMLDataTypeConverter.h"
#import "FMXMLError.h"
#import "FMXMLConstants.h"


@implementation FMXMLModelDefinition

@synthesize classDictByClassName;
@synthesize classDictByXMLName;
@synthesize enumDictByEnumName;
@synthesize enumDictByXMLName;
@synthesize arrayDictByXMLName;
@synthesize dictionaryDictByXMLName;
@synthesize modelRoot;
@synthesize currentNode;
@synthesize error;

#pragma mark -
#pragma mark Static convenience methods

+ (FMXMLModelDefinition *)modelDefinitionFromFile:(NSString *)fileName;
{
	FMXMLModelDefinition *modelDefinition = [[[FMXMLModelDefinition alloc] init] autorelease];
	BOOL success = [modelDefinition loadModelDefinitionFromFile:fileName];
	
	if (! success)
	{
		NSLog(@"Model definition error: %@", [modelDefinition.error localizedDescription]);
	}
	
	return modelDefinition;
}

#pragma mark -
#pragma mark Initialization

- (id)init;
{
	if (self = [super init]) 
	{
		classDictByClassName = [[NSMutableDictionary alloc] init];
		classDictByXMLName = [[NSMutableDictionary alloc] init];
		enumDictByEnumName = [[NSMutableDictionary alloc] init];
		enumDictByXMLName = [[NSMutableDictionary alloc] init];
		arrayDictByXMLName = [[NSMutableDictionary alloc] init];
		dictionaryDictByXMLName = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

#pragma mark -
#pragma mark Loading methods

- (BOOL)loadModelDefinitionFromFile:(NSString *)fileName; 
{
	[classDictByClassName removeAllObjects];
	[classDictByXMLName removeAllObjects];
	[enumDictByEnumName removeAllObjects];
	[enumDictByXMLName removeAllObjects];
	self.modelRoot = nil;
	self.currentNode = nil;
	self.error = nil;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
	NSData *xml = [NSData dataWithContentsOfFile:path];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xml];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
	BOOL success = [parser parse];
	
	[parser release];
	
	return success;
}

#pragma mark -
#pragma mark Model class methods

- (void)addModelClass:(FMXMLModelClass *)modelClass;
{
	[classDictByClassName setObject:modelClass forKey:modelClass.className];
	[classDictByXMLName setObject:modelClass forKey:modelClass.xmlName];	
}

- (void)removeModelClassByClassName:(NSString *)className;
{
	FMXMLModelClass *modelClass = [self getModelClassByClassName:className];
	if (! modelClass) 
	{
		return;		
	}
	
	[classDictByClassName removeObjectForKey:className];
	[classDictByXMLName removeObjectForKey:modelClass.xmlName];	
}

- (void)removeModelClassByXMLName:(NSString *)xmlName;
{
	FMXMLModelClass *modelClass = [self getModelClassByXMLName:xmlName];
	if (! modelClass) 
	{
		return;		
	}
	
	[classDictByClassName removeObjectForKey:modelClass.className];
	[classDictByXMLName removeObjectForKey:xmlName];	
}

- (FMXMLModelClass *)getModelClassByClassName:(NSString *)className;
{
	return [classDictByClassName objectForKey:className];
}

- (FMXMLModelClass *)getModelClassByXMLName:(NSString *)xmlName;
{
	return [classDictByXMLName objectForKey:xmlName];
}


- (NSArray *)getAllModelClasses;
{
	return [classDictByClassName allValues];
}

#pragma mark -
#pragma mark Model enum methods

- (void)addModelEnum:(FMXMLModelEnum *)modelEnum;
{
	[enumDictByEnumName setObject:modelEnum forKey:modelEnum.enumName];
	[enumDictByXMLName setObject:modelEnum forKey:modelEnum.xmlName];
}

- (void)removeModelEnumByEnumName:(NSString *)enumName;
{
	FMXMLModelEnum *modelEnum = [self getModelEnumByEnumName:enumName];
	if (! modelEnum) 
	{
		return;		
	}
	
	[enumDictByEnumName removeObjectForKey:enumName];
	[enumDictByXMLName removeObjectForKey:modelEnum.xmlName];	
}

- (void)removeModelEnumByXMLName:(NSString *)xmlName;
{
	FMXMLModelEnum *modelEnum = [self getModelEnumByXMLName:xmlName];
	if (! modelEnum)
	{
		return;		
	}
	
	[enumDictByEnumName removeObjectForKey:modelEnum.enumName];
	[enumDictByXMLName removeObjectForKey:xmlName];	
}

- (FMXMLModelEnum *)getModelEnumByEnumName:(NSString *)enumName; 
{
	return [enumDictByEnumName objectForKey:enumName];
}

- (FMXMLModelEnum *)getModelEnumByXMLName:(NSString *)xmlName;
{
	return [enumDictByXMLName objectForKey:xmlName];
}

- (NSArray *)getAllModelEnums;
{
	return [enumDictByEnumName allValues];
}

#pragma mark -
#pragma mark Model array methods

- (void)addModelArray:(FMXMLModelArray *)modelArray;
{
	[arrayDictByXMLName setObject:modelArray forKey:modelArray.xmlName];		
}

- (void)removeModelArrayByXMLName:(NSString *)xmlName;
{
	FMXMLModelArray *modelArray = [self getModelArrayByXMLName:xmlName];
	if (! modelArray) 
	{
		return;		
	}
	
	[arrayDictByXMLName removeObjectForKey:xmlName];		
}

- (FMXMLModelArray *)getModelArrayByXMLName:(NSString *)xmlName;
{
	return [arrayDictByXMLName objectForKey:xmlName];
}

- (NSArray *)getAllModelArrays;
{
	return [arrayDictByXMLName allValues];
}

#pragma mark -
#pragma mark Model dictionary methods
- (void)addModelDictionary:(FMXMLModelDictionary *)modelDictionary {
	[dictionaryDictByXMLName setObject:modelDictionary forKey:modelDictionary.xmlName];		
}

- (void)removeModelDictionaryByXMLName:(NSString *)xmlName {
	FMXMLModelDictionary *modelDictionary = [self getModelDictionaryByXMLName:xmlName];
	if (! modelDictionary) 
	{
		return;		
	}
	
	[dictionaryDictByXMLName removeObjectForKey:xmlName];			
}

- (FMXMLModelDictionary *)getModelDictionaryByXMLName:(NSString *)xmlName;
{
	return [dictionaryDictByXMLName objectForKey:xmlName];
}

- (NSArray *)getAllModelDictionaries;
{
	return [dictionaryDictByXMLName allValues];
}

#pragma mark -
#pragma mark NSXMLParser delegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser;
{
	// do nothing
}

- (void)parserDidEndDocument:(NSXMLParser *)parser;
{
	self.currentNode = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;
{
	FMXMLNode *newNode = [[FMXMLNode alloc] initWithName:elementName]; 
	
	if (currentNode) 
	{
		[self.currentNode addNode:newNode];
	}
	
	newNode.name = elementName;
	self.currentNode = newNode;
	
	[newNode release];	
	
	if ([elementName isEqualToString:@"Model"]) 
	{
		modelRoot = [[FMXMLModelRoot alloc] init];
		modelRoot.dataType = [FMXMLDataTypeConverter stringToDataType:[attributeDict objectForKey:@"rootDataType"]];
		modelRoot.xmlName = [attributeDict objectForKey:@"rootXMLName"];
		modelRoot.formatString = [attributeDict objectForKey:@"rootFormatString"];		
	}
	else if ([elementName isEqualToString:@"ModelClass"]) 
	{			
		FMXMLModelClass *mClass = [[FMXMLModelClass alloc] init];
		mClass.className = [attributeDict objectForKey:@"className"];
		mClass.xmlName = [attributeDict objectForKey:@"xmlName"];
		mClass.textPropertyName = [attributeDict objectForKey:@"textPropertyName"];
		mClass.textDataType = [FMXMLDataTypeConverter stringToDataType:[attributeDict objectForKey:@"textDataType"]];
		mClass.textFormatString = [attributeDict objectForKey:@"textFormatString"];
		[self addModelClass:mClass];
		currentNode.modelClass = mClass;
		[mClass release];
	}
	else if ([elementName isEqualToString:@"ModelProperty"]) 
	{
		FMXMLModelProperty *mProp = [[FMXMLModelProperty alloc] init];
		mProp.propertyName = [attributeDict objectForKey:@"propertyName"];
		mProp.dataType = [FMXMLDataTypeConverter stringToDataType:[attributeDict objectForKey:@"dataType"]];
		mProp.xmlType = [FMXMLDataTypeConverter stringToXMLType:[attributeDict objectForKey:@"xmlType"]];
		mProp.xmlName = [attributeDict objectForKey:@"xmlName"];
		mProp.formatString = [attributeDict objectForKey:@"formatString"];
		[currentNode.prevNode.modelClass setProperty:mProp];
		currentNode.modelProperty = mProp;
		[mProp release];
	}
	else if ([elementName isEqualToString:@"ModelEnum"]) 
	{
		FMXMLModelEnum *mEnum = [[FMXMLModelEnum alloc] init];
		mEnum.enumName = [attributeDict objectForKey:@"enumName"];
		mEnum.xmlName = [attributeDict objectForKey:@"xmlName"];
		[self addModelEnum:mEnum];
		currentNode.modelEnum = mEnum;
		[mEnum release];
	}
	else if ([elementName isEqualToString:@"ModelEnumItem"]) 
	{
		NSString *name = [attributeDict objectForKey:@"name"];
		NSString *value = [attributeDict objectForKey:@"value"];
		[currentNode.prevNode.modelEnum setItemWithName:name value:value];
	}
	else if ([elementName isEqualToString:@"ModelArray"]) 
	{			
		FMXMLModelArray *mArray = [[FMXMLModelArray alloc] init];
		mArray.xmlName = [attributeDict objectForKey:@"xmlName"];
		[self addModelArray:mArray];
		currentNode.modelArray = mArray;
		[mArray release];
	}
	else if ([elementName isEqualToString:@"ModelArrayElement"]) 
	{			
		FMXMLModelArrayElement *mArrayElement = [[FMXMLModelArrayElement alloc] init];
		mArrayElement.xmlName = [attributeDict objectForKey:@"xmlName"];
		mArrayElement.dataType = [FMXMLDataTypeConverter stringToDataType:[attributeDict objectForKey:@"dataType"]];
		mArrayElement.formatString = [attributeDict objectForKey:@"formatString"];
		currentNode.prevNode.modelArray.modelArrayElement = mArrayElement;
		currentNode.modelArrayElement = mArrayElement;
		[mArrayElement release];
	}
	else if ([elementName isEqualToString:@"ModelDictionary"]) 
	{			
		FMXMLModelDictionary *mDictionary = [[FMXMLModelDictionary alloc] init];
		mDictionary.xmlName = [attributeDict objectForKey:@"xmlName"];
		[self addModelDictionary:mDictionary];
		currentNode.modelDictionary = mDictionary;
		[mDictionary release];
	}
	else if ([elementName isEqualToString:@"ModelDictionaryElement"]) 
	{			
		FMXMLModelDictionaryElement *mDictionaryElement = [[FMXMLModelDictionaryElement alloc] init];
		mDictionaryElement.xmlName = [attributeDict objectForKey:@"xmlName"];
		mDictionaryElement.dataType = [FMXMLDataTypeConverter stringToDataType:[attributeDict objectForKey:@"dataType"]];
		mDictionaryElement.formatString = [attributeDict objectForKey:@"formatString"];
		mDictionaryElement.key = [attributeDict objectForKey:@"key"];
		[currentNode.prevNode.modelDictionary setElement:mDictionaryElement];
		currentNode.modelDictionaryElement = mDictionaryElement;
		[mDictionaryElement release];
	}
	else 
	{
		self.error = [FMXMLError errorWithCode:ECD_UNRECOGNIZED_ELEMENT_NAME description:elementName];
		[parser abortParsing];
		return;
	}		
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	self.currentNode = currentNode.prevNode;
	self.currentNode.nextNode = nil;
}

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI;
{
	// do nothing
}

- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix;
{
	// do nothing
}

- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)entityName systemID:(NSString *)systemID;
{
	return nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	if (! error) 
	{
		self.error = parseError;
	}

	[classDictByClassName removeAllObjects];
	[classDictByXMLName removeAllObjects];
	[enumDictByEnumName removeAllObjects];
	[enumDictByXMLName removeAllObjects];
	self.modelRoot = nil;
	self.currentNode = nil;
		
	[parser abortParsing];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError;
{
	if (! error) 
	{
		self.error = validError;
	}
	
	[classDictByClassName removeAllObjects];
	[classDictByXMLName removeAllObjects];
	[enumDictByEnumName removeAllObjects];
	[enumDictByXMLName removeAllObjects];
	self.modelRoot = nil;
	self.currentNode = nil;
	
	[parser abortParsing];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
{
	// do nothing
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString;
{
	// do nothing
}

- (void)parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data;
{
	// do nothing
}

- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment;
{
	// do nothing
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock;
{
	// do nothing
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[classDictByClassName release];
	[classDictByXMLName release];
	[enumDictByEnumName release];
	[enumDictByXMLName release];
	[arrayDictByXMLName release];
	[dictionaryDictByXMLName release];
	[modelRoot release];
	[currentNode release];
	[error release];
	[super dealloc];
}

@end
