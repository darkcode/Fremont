//
//  FMXMLSerializer.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXMLModelProperty.h"
#import "FMXMLModelDefinition.h"

@interface FMXMLSerializer : NSObject 
{
	FMXMLModelDefinition *modelDefinition;
	NSError *error;
}

@property (nonatomic, retain) FMXMLModelDefinition *modelDefinition;
@property (nonatomic, retain) NSError *error;

#pragma mark -
#pragma mark Initialization

- (id)initWithModelDefinition:(FMXMLModelDefinition *)mDef;

#pragma mark -
#pragma mark Markup

+ (NSString *)getXMLEncodingString:(NSStringEncoding)encoding;
+ (NSString *)toXMLDocument:(NSString *)xml withEncoding:(NSStringEncoding)encoding;
+ (NSString *)startXMLDoc:(NSStringEncoding)encoding;
+ (NSString *)safeXMLStringFromString:(NSString *)value;
+ (NSString *)attribute:(NSString *)tagName withValue:(NSString *)value;
+ (NSString *)attributes:(NSMutableArray *)attributes;
+ (NSString *)element:(NSString *)tagName withAttributes:(NSMutableArray *)attributes;
+ (NSString *)elementBeginTag:(NSString *)tagName withAttributes:(NSMutableArray *)attributes;
+ (NSString *)elementEndTag:(NSString *)tagName;
+ (NSString *)element:(NSString *)tagName withAttributes:(NSMutableArray *)attributes withText:(NSString *)text;
+ (NSString *)element:(NSString *)tagName withText:(NSString *)text;
+ (NSString *)addAttributesToXML:(NSString *)xml attributes:(NSMutableArray *)attributes;
+ (NSString *)addElementToXML:(NSString *)xml withTagName:(NSString *)tagName;
+ (NSString *)addElementToXML:(NSString *)xml withTagName:(NSString *)tagName withAttributes:(NSMutableArray *)attributes;
+ (NSString *)addElementBeginTagToXML:(NSString *)xml withTagName:(NSString *)tagName withAttributes:(NSMutableArray *)attributes;
+ (NSString *)addElementEndTagToXML:(NSString *)xml withTagName:(NSString *)tagName;
+ (NSString *)makeCDATA:(NSString *)data;
+ (NSString *)addTextToXML:(NSString *)xml text:(NSString *)text;
+ (NSString *)addElementToXML:(NSString *)xml withTagName:(NSString *)tagName withAttributes:(NSMutableArray *)attributes withText:(NSString *)text;
+ (NSString *)addElementToXML:(NSString *)xml withTagName:(NSString *)tagName withText:(NSString *)text;
+ (NSString *)addElementToXML:(NSString *)xml withTagName:(NSString *)tagName withCDATA:(NSString *)data;

#pragma mark -
#pragma mark Document processing

- (NSString *)toXML:(id)object withEncoding:(NSStringEncoding)encoding;
- (NSString *)arrayToXML:(NSArray *)array xmlName:(NSString *)xmlName;
- (NSString *)dictionaryToXML:(NSDictionary *)dictionary xmlName:(NSString *)xmlName;
- (NSString *)udcToXML:(id)udc xmlName:(NSString *)xmlName;
- (NSString *)propertyToXML:(NSString *)propertyName dataType:(FMXMLDataType)dataType xmlType:(FMXMLXMLType)xmlType xmlName:(NSString *)xmlName formatString:(NSString *)formatString fromObject:(id)object withParentAttributes:(NSMutableArray *)attributes;
- (NSString *)typeToXML:(id)object dataType:(FMXMLDataType)dataType xmlType:(FMXMLXMLType)xmlType xmlName:(NSString *)xmlName formatString:(NSString *)formatString;

@end
