//
//  FMXMLModelDictionary.h
//  Hackberry
//
//  Created by Bradley O'Hearne on 6/9/10.
//  Copyright 2010 Big Hill Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXMLModelDictionaryElement.h"


@interface FMXMLModelDictionary : NSObject
{
	NSString *xmlName;
	NSMutableDictionary *elementsByXMLName;
	NSMutableDictionary *elementsByKey;
	NSMutableArray *orderedElements;
}

@property (nonatomic, retain) NSString *xmlName;
@property (nonatomic, retain) NSMutableDictionary *elementsByXMLName;
@property (nonatomic, retain) NSMutableDictionary *elementsByKey;
@property (nonatomic, retain) NSMutableArray *orderedElements;

- (void)setElement:(FMXMLModelDictionaryElement *)element;
- (void)removeElementByXMLName:(NSString *)elementXMLName;
- (FMXMLModelDictionaryElement *)getElementByXMLName:(NSString *)elementXMLName;
- (FMXMLModelDictionaryElement *)getElementByKey:(NSString *)elementKey;
- (NSArray *)getElements;

@end
