//
//  FMXMLModelEnum.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/11/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "FMXMLModelEnum.h"


@implementation FMXMLModelEnum

@synthesize itemsByName;
@synthesize itemsByValue;
@synthesize enumName;
@synthesize xmlName;

- (id)init;
{
	if (self = [super init])
	{
		itemsByName = [[NSMutableDictionary alloc] init];
		itemsByValue = [[NSMutableDictionary alloc] init];		
	}
	
	return self;
}

- (void)setItemWithName:(NSString *)name value:(NSString *)value;
{	
	[itemsByName setObject:value forKey:name];
	[itemsByValue setObject:name forKey:value];
}

- (NSString *)getValueForName:(NSString *)name;
{
	return [itemsByName objectForKey:name];
}

- (NSString *)getNameForValue:(NSString *)value;
{
	/*
	for (NSString *val in [itemsByValue allKeys])
		NSLog(@"name: %@, value: %@", [itemsByValue objectForKey:val], val);
	*/
	
	return [itemsByValue objectForKey:value];
}

- (void)dealloc;
{
	[itemsByName release];
	[itemsByValue release];
	[enumName release];
	[xmlName release];
	[super dealloc];
}

@end
