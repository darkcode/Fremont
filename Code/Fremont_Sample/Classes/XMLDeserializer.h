//
//  XMLDeserializer.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDefinition.h"
#import "DoublyLinkedListNode.h"
#import "ModelProperty.h"

@interface XMLDeserializer : NSObject {
	ModelDefinition *modelDefinition;
	DoublyLinkedListNode *currentNode;
	id model;
	NSError *error;
	NSXMLParser *parser;
}

@property (nonatomic, retain) ModelDefinition *modelDefinition;
@property (nonatomic, retain) DoublyLinkedListNode *currentNode;
@property (nonatomic, retain) id model;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) NSXMLParser *parser;


//parser delegate methods
- (void)parserDidStartDocument:(NSXMLParser *)parser;
- (void)parserDidEndDocument:(NSXMLParser *)parser;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock;

/* UNNEEDED DELEGATE METHODS
 - (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI;
 - (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix;
 - (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)entityName systemID:(NSString *)systemID;
 - (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError;
 - (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString;
 - (void)parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data;
 - (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment;
 */

- (id)initWithModelDefinition:(ModelDefinition *)mDef;
- (id)fromXML:(NSString *)xml WithEncoding:(NSStringEncoding)encoding;
- (SEL)selectorFromPropertyName:(NSString *)propertyName;

@end
