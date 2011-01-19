//
//  FMXMLModelDefinition.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXMLModelClass.h"
#import "FMXMLModelEnum.h"
#import "FMXMLModelArray.h"
#import "FMXMLModelDictionary.h"
#import "FMXMLNode.h"
#import "FMXMLModelRoot.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
@interface FMXMLModelDefinition : NSObject <NSXMLParserDelegate> 
#else
@interface FMXMLModelDefinition : NSObject
#endif
{
	NSMutableDictionary *classDictByClassName;
	NSMutableDictionary *classDictByXMLName;
	NSMutableDictionary *enumDictByEnumName;
	NSMutableDictionary *enumDictByXMLName;
	NSMutableDictionary *arrayDictByXMLName;
	NSMutableDictionary *dictionaryDictByXMLName;
	FMXMLModelRoot *modelRoot;
	FMXMLNode *currentNode;
	NSError *error;
}

@property (nonatomic, retain) NSMutableDictionary *classDictByClassName;
@property (nonatomic, retain) NSMutableDictionary *classDictByXMLName;
@property (nonatomic, retain) NSMutableDictionary *enumDictByEnumName;
@property (nonatomic, retain) NSMutableDictionary *enumDictByXMLName;
@property (nonatomic, retain) NSMutableDictionary *arrayDictByXMLName;
@property (nonatomic, retain) NSMutableDictionary *dictionaryDictByXMLName;
@property (nonatomic, retain) FMXMLModelRoot *modelRoot;
@property (nonatomic, retain) FMXMLNode *currentNode;
@property (nonatomic, retain) NSError *error;

#pragma mark -
#pragma mark Loading methods
+ (FMXMLModelDefinition *)modelDefinitionFromFile:(NSString *)fileName;
- (BOOL)loadModelDefinitionFromFile:(NSString *)fileName;

#pragma mark -
#pragma mark Model class methods
- (void)addModelClass:(FMXMLModelClass *)modelClass;
- (void)removeModelClassByClassName:(NSString *)className;
- (void)removeModelClassByXMLName:(NSString *)xmlName;
- (FMXMLModelClass *)getModelClassByClassName:(NSString *)className;
- (FMXMLModelClass *)getModelClassByXMLName:(NSString *)xmlName;
- (NSArray *)getAllModelClasses;

#pragma mark -
#pragma mark Model enum methods
- (void)addModelEnum:(FMXMLModelEnum *)modelEnum;
- (void)removeModelEnumByEnumName:(NSString *)enumName;
- (void)removeModelEnumByXMLName:(NSString *)xmlName;
- (FMXMLModelEnum *)getModelEnumByEnumName:(NSString *)enumName;
- (FMXMLModelEnum *)getModelEnumByXMLName:(NSString *)xmlName;
- (NSArray *)getAllModelEnums;

#pragma mark -
#pragma mark Model array methods
- (void)addModelArray:(FMXMLModelArray *)modelArray;
- (void)removeModelArrayByXMLName:(NSString *)xmlName;
- (FMXMLModelArray *)getModelArrayByXMLName:(NSString *)xmlName;
- (NSArray *)getAllModelArrays;

#pragma mark -
#pragma mark Model dictionary methods
- (void)addModelDictionary:(FMXMLModelDictionary *)modelDictionary;
- (void)removeModelDictionaryByXMLName:(NSString *)xmlName;
- (FMXMLModelDictionary *)getModelDictionaryByXMLName:(NSString *)xmlName;
- (NSArray *)getAllModelDictionaries;

@end
