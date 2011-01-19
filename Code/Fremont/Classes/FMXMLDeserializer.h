//
//  FMXMLDeserializer.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXMLModelDefinition.h"
#import "FMXMLNode.h"
#import "FMXMLModelProperty.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
@interface FMXMLDeserializer : NSObject <NSXMLParserDelegate> 
#else
@interface FMXMLDeserializer : NSObject 
#endif
{
	FMXMLModelDefinition *modelDefinition;
	FMXMLNode *currentNode;
	id model;
	NSError *error;
}

@property (nonatomic, retain) FMXMLModelDefinition *modelDefinition;
@property (nonatomic, retain) FMXMLNode *currentNode;
@property (nonatomic, retain) id model;
@property (nonatomic, retain) NSError *error;

#pragma mark -
#pragma mark Initialization

- (id)initWithModelDefinition:(FMXMLModelDefinition *)mDef;

#pragma mark -
#pragma mark Deserialization

- (id)fromXML:(NSString *)xml withEncoding:(NSStringEncoding)encoding;

#pragma mark -
#pragma mark Helper methods

- (SEL)selectorFromPropertyName:(NSString *)propertyName;
- (void)setProperty:(NSString *)propertyName onObject:(id)obj withValue:(id)valueObject;
- (void)createContainerObject:(FMXMLNode *)node;

@end
