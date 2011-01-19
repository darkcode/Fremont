//
//  FMXMLModelDictionary.m
//  Hackberry
//
//  Created by Bradley O'Hearne on 6/9/10.
//  Copyright 2010 Big Hill Software LLC. All rights reserved.
//

#import "FMXMLModelDictionary.h"


@implementation FMXMLModelDictionary

@synthesize xmlName;
@synthesize elementsByXMLName;
@synthesize elementsByKey;
@synthesize orderedElements;

- (id)init;
{
	if (self = [super init]) 
	{
		elementsByXMLName = [[NSMutableDictionary alloc] init];
		elementsByKey = [[NSMutableDictionary alloc] init];
		orderedElements = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)setElement:(FMXMLModelDictionaryElement *)element;
{
	[elementsByXMLName setObject:element forKey:element.xmlName];
	[elementsByKey setObject:element forKey:element.key];
	[orderedElements addObject:element];
}

- (void)removeElementByXMLName:(NSString *)elementXMLName;
{
	FMXMLModelDictionaryElement *element = [self getElementByXMLName:elementXMLName];
	if (element) 
	{
		[elementsByXMLName removeObjectForKey:elementXMLName];
		[elementsByKey removeObjectForKey:element.key];
		[orderedElements removeObject:element];
	}	
}

- (FMXMLModelDictionaryElement *)getElementByXMLName:(NSString *)elementXMLName;
{
	return [elementsByXMLName objectForKey:elementXMLName];
}

- (FMXMLModelDictionaryElement *)getElementByKey:(NSString *)elementKey;
{
	return [elementsByKey objectForKey:elementKey];
}

- (NSArray *)getElements;
{
	return orderedElements;
}

- (void)dealloc;
{	
	[xmlName release];
	[elementsByXMLName release];
	[elementsByKey release];
	[orderedElements release];
	[super dealloc];
}

@end
