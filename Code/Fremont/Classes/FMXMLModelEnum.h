//
//  FMXMLModelEnum.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/11/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMXMLModelEnum : NSObject
{
	NSMutableDictionary *itemsByName;
	NSMutableDictionary *itemsByValue;
	NSString *enumName;
	NSString *xmlName;
}

@property (nonatomic, retain) NSMutableDictionary *itemsByName;
@property (nonatomic, retain) NSMutableDictionary *itemsByValue;
@property (nonatomic, retain) NSString *enumName;
@property (nonatomic, retain) NSString *xmlName;

- (void)setItemWithName:(NSString *)name value:(NSString *)name;
- (NSString *)getValueForName:(NSString *)name;
- (NSString *)getNameForValue:(NSString *)value;

@end
