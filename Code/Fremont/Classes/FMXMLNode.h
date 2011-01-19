//
//  FMXMLDoublyLinkedListNode.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXMLModelClass.h"
#import "FMXMLModelProperty.h"
#import "FMXMLModelEnum.h"
#import "FMXMLModelArray.h"
#import "FMXMLModelArrayElement.h"
#import "FMXMLModelDictionary.h"
#import "FMXMLModelDictionaryElement.h"
#import "FMXMLEnums.h"


@interface FMXMLNode : NSObject 
{
	FMXMLNode *prevNode;
	FMXMLNode *nextNode;
	NSString *name;
	FMXMLModelClass *modelClass;
	NSObject *modelObject;
	FMXMLModelProperty *modelProperty;
	FMXMLModelEnum *modelEnum;
	FMXMLModelArray *modelArray;
	FMXMLModelArrayElement *modelArrayElement;
	FMXMLModelDictionary *modelDictionary;
	FMXMLModelDictionaryElement *modelDictionaryElement;
	NSString *characters;
	NSData *data;
	FMXMLDataType dataType;
}

@property (nonatomic, retain) FMXMLNode *prevNode;
@property (nonatomic, retain) FMXMLNode *nextNode;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) FMXMLModelClass *modelClass;
@property (nonatomic, retain) NSObject *modelObject;
@property (nonatomic, retain) FMXMLModelProperty *modelProperty;
@property (nonatomic, retain) FMXMLModelEnum *modelEnum;
@property (nonatomic, retain) FMXMLModelArray *modelArray;
@property (nonatomic, retain) FMXMLModelArrayElement *modelArrayElement;
@property (nonatomic, retain) FMXMLModelDictionary *modelDictionary;
@property (nonatomic, retain) FMXMLModelDictionaryElement *modelDictionaryElement;
@property (nonatomic, retain) NSString *characters;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, assign) FMXMLDataType dataType;

- (id)initWithName:(NSString *)nodeName;
- (void)addNode:(FMXMLNode *)node;
- (FMXMLNode *)firstNode;
- (FMXMLNode *)lastNode;
- (BOOL)isModelClass;
- (BOOL)isModelProperty;
- (BOOL)isModelEnum;
- (BOOL)isModelArray;
- (BOOL)isModelArrayElement;
- (BOOL)isModelDictionary;
- (BOOL)isModelDictionaryElement;
- (BOOL)isContainerType;
- (BOOL)shouldIgnore;

@end
