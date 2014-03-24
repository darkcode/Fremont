//
//  FMXMLSerializer.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "FMXMLSerializer.h"
#import <objc/runtime.h>
#import "FMXMLEnums.h"
#import "FMXMLModelClass.h"
#import "FMXMLModelArray.h"
#import "FMXMLModelArrayElement.h"
#import "FMXMLModelDictionary.h"
#import "FMXMLModelDictionaryElement.h"
#import "FMXMLDataTypeConverter.h"

@implementation FMXMLSerializer

@synthesize modelDefinition;
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
#pragma mark Markup

+ (NSString *)getXMLEncodingString:(NSStringEncoding)encoding;
{
	switch (encoding) 
	{
		case NSUTF8StringEncoding:
			return @"UTF-8";
		case NSUTF16StringEncoding:
			return @"UTF-16";
		case NSUTF32StringEncoding:
			return @"UTF-32";
		default:
			[NSException raise:@"Unsupported string encoding" format:@"The following string encoding is not supported: %lu", (unsigned long)encoding];
	}	
	
	return nil;
}

+ (NSString *)toXMLDocument:(NSString *)xml withEncoding:(NSStringEncoding)encoding;
{
	return [[FMXMLSerializer startXMLDoc:encoding] stringByAppendingString:xml];	
}

+ (NSString *)startXMLDoc:(NSStringEncoding)encoding;
{
	return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"%@\"?>", [FMXMLSerializer getXMLEncodingString:encoding]];
}

+ (NSString *)safeXMLStringFromString:(NSString *)value;
{
	return [value stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];	
}

+ (NSString *)attribute:(NSString *)tagName withValue:(NSString *)value;
{
	NSString *attrString = @"";
	attrString = [attrString stringByAppendingString:@" "];
	attrString = [attrString stringByAppendingString:tagName];
	attrString = [attrString stringByAppendingString:@"=\""];
	
	if (value)
	{
		value = [self safeXMLStringFromString:value];
		attrString = [attrString stringByAppendingString:value];
	}
	
	attrString = [attrString stringByAppendingString:@"\""];
	return attrString;
}

+ (NSString *)attributes:(NSMutableArray *)attrs;
{
	NSString *attrString = @"";
	
	if (attrs)
	{	
		for (NSString *attr in attrs)
		{
			attrString = [attrString stringByAppendingString:attr];
		}	
	}
	
	return attrString;
}

+ (NSString *)element:(NSString *)tagName withAttributes:(NSMutableArray *)attributes;
{
	NSString *element = [@"<" stringByAppendingString:tagName];
	element = [element stringByAppendingString:[FMXMLSerializer attributes:attributes]];
	element = [element stringByAppendingString:@"/>"];
	return element;
}

+ (NSString *)elementBeginTag:(NSString *)tagName withAttributes:(NSMutableArray *)attributes;
{
	NSString *element = [@"<" stringByAppendingString:tagName];
	element = [element stringByAppendingString:[FMXMLSerializer attributes:attributes]];
	element = [element stringByAppendingString:@">"];		
	return element;
}

+ (NSString *)elementEndTag:(NSString *)tagName;
{
	NSString *element = [@"</" stringByAppendingString:tagName];
	element = [element stringByAppendingString:@">"];		
	return element;	
}

+ (NSString *)element:(NSString *)tagName withAttributes:(NSMutableArray *)attributes withText:(NSString *)text;
{
	NSString *element = [FMXMLSerializer elementBeginTag:tagName withAttributes:attributes];
	
	if (text)
	{
		element = [element stringByAppendingString:text];	
	}
	
	element = [element stringByAppendingString:[FMXMLSerializer elementEndTag:tagName]];
	return element;
}

+ (NSString *)element:(NSString *)tagName withText:(NSString *)text;
{
	return [FMXMLSerializer element:tagName withAttributes:nil withText:text];
}

+ (NSString *)addAttributesToXML:(NSString *)xml attributes:(NSMutableArray *)attributes;
{
	return [xml stringByAppendingString:[FMXMLSerializer attributes:attributes]];
}

+ (NSString *)addElementToXML:(NSString *)xml withTagName:(NSString *)tagName;
{
	return [xml stringByAppendingString:[FMXMLSerializer element:tagName withAttributes:nil]];
}

+ (NSString *)addElementToXML:(NSString *)xml withTagName:(NSString *)tagName withAttributes:(NSMutableArray *)attributes;
{
	return [xml stringByAppendingString:[FMXMLSerializer element:tagName withAttributes:attributes]];
}

+ (NSString *)addElementBeginTagToXML:(NSString *)xml withTagName:(NSString *)tagName withAttributes:(NSMutableArray *)attributes;
{
	return [xml stringByAppendingString:[FMXMLSerializer elementBeginTag:tagName withAttributes:attributes]];	
}

+ (NSString *)addElementEndTagToXML:(NSString *)xml withTagName:(NSString *)tagName;
{
	return [xml stringByAppendingString:[FMXMLSerializer elementEndTag:tagName]];	
}

+ (NSString *)makeCDATA:(NSString *)data;
{
	if (! data)
	{
		data = @"";
	}
	
	return [NSString stringWithFormat:@"<![CDATA[%@]]>", data];
}

+ (NSString *)addTextToXML:(NSString *)xml text:(NSString *)text;
{
	if (text)
	{
		return [xml stringByAppendingString:text];	
	}
	else
	{
		return xml;
	}	
}

+ (NSString *)addElementToXML:(NSString *)xml withTagName:(NSString *)tagName withAttributes:(NSMutableArray *)attributes withText:(NSString *)text;
{
	return [xml stringByAppendingString:[FMXMLSerializer element:tagName withAttributes:attributes withText:text]];
}

+ (NSString *)addElementToXML:(NSString *)xml withTagName:(NSString *)tagName withText:(NSString *)text;
{
	return [FMXMLSerializer addElementToXML:xml withTagName:tagName withAttributes:nil withText:text];
}

+ (NSString *)addElementToXML:(NSString *)xml withTagName:(NSString *)tagName withCDATA:(NSString *)data;
{
	NSString *cdata;
	if (data)
	{
		cdata = [FMXMLSerializer makeCDATA:data];		
	}
	else 
	{
		cdata = @"";
	}
	
	return [FMXMLSerializer addElementToXML:xml withTagName:tagName withText:cdata];
}


#pragma mark -
#pragma mark Document processing

- (NSString *)toXML:(id)object withEncoding:(NSStringEncoding)encoding;
{
	if (! modelDefinition)
		[NSException raise:@"Model definition not found" format:@"There must be a model definition to convert the object to XML."];
	
	//start the document
	NSString *xml = [FMXMLSerializer startXMLDoc:encoding];
	
	FMXMLModelRoot *modelRoot = modelDefinition.modelRoot;	
	
	xml = [FMXMLSerializer addTextToXML:xml text:[self typeToXML:object dataType:modelRoot.dataType xmlType:ELEMENT xmlName:modelRoot.xmlName
													formatString:modelRoot.formatString]];
	
	//NSLog(@"%@", xml);
	
	return xml;
}

- (NSString *)arrayToXML:(NSArray *)array xmlName:(NSString *)xmlName;
{
	NSString *xml = @"";
	xml = [FMXMLSerializer addElementBeginTagToXML:xml withTagName:xmlName withAttributes:nil];
	
	FMXMLModelArray *modelArray = [modelDefinition getModelArrayByXMLName:xmlName];
	FMXMLModelArrayElement *modelArrayElement = modelArray.modelArrayElement;
	
	if (modelArray)
	{				
		for (id arrayObject in array)
		{
			xml = [FMXMLSerializer addTextToXML:xml text:[self typeToXML:arrayObject dataType:modelArrayElement.dataType xmlType:ELEMENT xmlName:modelArrayElement.xmlName formatString:nil]];
		}
	}
	
	xml = [FMXMLSerializer addElementEndTagToXML:xml withTagName:xmlName];	
	
	return xml;
}

- (NSString *)dictionaryToXML:(NSDictionary *)dictionary xmlName:(NSString *)xmlName;
{
	NSString *xml = @"";
	xml = [FMXMLSerializer addElementBeginTagToXML:xml withTagName:xmlName withAttributes:nil];
	
	FMXMLModelDictionary *modelDictionary = [modelDefinition getModelDictionaryByXMLName:xmlName];
	
	if (modelDictionary)
	{
		NSArray *modelDictionaryElements = [modelDictionary getElements];
		
		for (FMXMLModelDictionaryElement *modelDictionaryElement in modelDictionaryElements) 
		{
			id dictObject = [dictionary objectForKey:modelDictionaryElement.key];
			
			if (dictObject)
			{
				xml = [FMXMLSerializer addTextToXML:xml text:[self typeToXML:dictObject dataType:modelDictionaryElement.dataType xmlType:ELEMENT xmlName:modelDictionaryElement.xmlName formatString:nil]];						
			}
		}
	}
	
	xml = [FMXMLSerializer addElementEndTagToXML:xml withTagName:xmlName];	
	
	return xml;
}

- (NSString *)udcToXML:(id)udc xmlName:(NSString *)xmlName;
{
	NSString *xml = @"";
	
	//get the class name	
	const char *className = object_getClassName(udc);
	NSString *classNameStr = [NSString stringWithCString:className encoding:NSUTF8StringEncoding];
	
	//get the model class
	id modelObject = [modelDefinition getModelClassByClassName:classNameStr];
	if (modelObject)
	{
		FMXMLModelClass *modelClass = (FMXMLModelClass *)modelObject;
		
		NSString *childXML = @"";
		
		//serialize text property
		if (modelClass.textPropertyName && ! [modelClass.textPropertyName isEqualToString:@""]) {
			childXML = [FMXMLSerializer addTextToXML:childXML text:[self propertyToXML:modelClass.textPropertyName dataType:modelClass.textDataType xmlType:TEXT xmlName:nil formatString:modelClass.textFormatString fromObject:udc withParentAttributes:nil]];
		}
		
		//serialize properties
		NSArray *properties = [modelClass getProperties];
		NSMutableArray *attributes = [[NSMutableArray alloc] initWithCapacity:[properties count]];
		
		for (FMXMLModelProperty *modelProperty in properties)
		{
			childXML = [FMXMLSerializer addTextToXML:childXML text:[self propertyToXML:modelProperty.propertyName dataType:modelProperty.dataType xmlType:modelProperty.xmlType xmlName:modelProperty.xmlName formatString:modelProperty.formatString fromObject:udc withParentAttributes:attributes]];
		}
		
		//add the begin tag
		xml = [FMXMLSerializer addElementBeginTagToXML:xml withTagName:classNameStr withAttributes:attributes];
		//add any children
		xml = [FMXMLSerializer addTextToXML:xml text:childXML];
		//add the end tag
		xml = [FMXMLSerializer addElementEndTagToXML:xml withTagName:classNameStr];
		
		//release vars
		[attributes release];
		
	}
	
	return xml;
}

- (NSString *)propertyToXML:(NSString *)propertyName dataType:(FMXMLDataType)dataType xmlType:(FMXMLXMLType)xmlType xmlName:(NSString *)xmlName formatString:(NSString *)formatString fromObject:(id)object withParentAttributes:(NSMutableArray *)attributes;
{	
	//NSLog(@"Property name: %@", modelProperty.propertyName);
	
	SEL propSelector = NSSelectorFromString(propertyName);
	
	// error for no property found
	
	id value = [object performSelector:propSelector];	
	
	NSString *xml = @"";
	
	NSString *stringValue = [self typeToXML:value dataType:dataType xmlType:xmlType xmlName:xmlName formatString:formatString];
	
	if (xmlType == ATTRIBUTE && (dataType == STRING || dataType == NUMBER || dataType == DATE || dataType == BOOLEAN || dataType == ENUM))
	{
		[attributes addObject:stringValue];
	}
	else
	{
		xml = stringValue;
	}
	
	//NSLog(@"xml = %@", xml);
	
	return xml;
}

- (NSString *)typeToXML:(id)object dataType:(FMXMLDataType)dataType xmlType:(FMXMLXMLType)xmlType xmlName:(NSString *)xmlName formatString:(NSString *)formatString;
{
	NSString *xml = @"";
	NSString *stringValue;
	
	switch (dataType) 
	{
		case STRING:
			stringValue = [FMXMLSerializer safeXMLStringFromString:object];
			break;
		case NUMBER:
			stringValue = [FMXMLDataTypeConverter numberIdToString:object];
			break;
		case DATE:
			stringValue = [FMXMLDataTypeConverter dateIdToString:object withFormat:formatString];
			break;
		case BOOLEAN:
			stringValue = [FMXMLDataTypeConverter booleanIdToString:object];
			break;
		case ARRAY:
			stringValue = [self arrayToXML:object xmlName:xmlName];
			break;
		case DICTIONARY:
			stringValue = [self dictionaryToXML:object xmlName:xmlName];
			break;
		case DATA:
			stringValue = [FMXMLDataTypeConverter dataIdToString:object];
			break;
		case UDC:
			stringValue = [self udcToXML:object xmlName:xmlName];
			break;
		case ENUM:
			// this is the string value of the int
			stringValue = [FMXMLDataTypeConverter enumIdToString:object];
			FMXMLModelEnum *mEnum = [modelDefinition getModelEnumByXMLName:xmlName];
			stringValue = [mEnum getNameForValue:stringValue];
			break;
		default:
			break;
	}		
	
	if (dataType == DATA)
	{
		xml = [FMXMLSerializer addElementToXML:xml withTagName:xmlName withCDATA:stringValue];				
	}
	else if (dataType == STRING || dataType == NUMBER || dataType == DATE || dataType == BOOLEAN || dataType == ENUM)
	{
		switch (xmlType)
		{
			case ATTRIBUTE:
				xml = [FMXMLSerializer attribute:xmlName withValue:stringValue];
				break;
			case ELEMENT:
				xml = [FMXMLSerializer addElementToXML:xml withTagName:xmlName withText:stringValue];
				break;
			case TEXT:
				xml = stringValue;
				break;
			default:
				break;
		}
	}
	else if (dataType == ARRAY || dataType == DICTIONARY || dataType == UDC) 
	{
		xml = stringValue;
	}
	
	return xml;
}

- (void)dealloc;
{
	[modelDefinition release];
	[error release];
	[super dealloc];
}

@end
