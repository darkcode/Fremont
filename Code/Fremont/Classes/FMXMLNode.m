//
//  FMXMLNode.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "FMXMLNode.h"


@implementation FMXMLNode

@synthesize prevNode;
@synthesize nextNode;
@synthesize name;
@synthesize modelClass;
@synthesize modelObject;
@synthesize modelProperty;
@synthesize modelEnum;
@synthesize modelArray;
@synthesize modelArrayElement;
@synthesize modelDictionary;
@synthesize modelDictionaryElement;
@synthesize characters;
@synthesize data;
@synthesize dataType;

- (id)initWithName:(NSString *)nodeName; 
{
	if (self = [super init])
	{
		self.name = nodeName;
		dataType = UNKNOWN;
	}
	
	return self;
}

- (void)addNode:(FMXMLNode *)node;
{
	if (nextNode) 
	{
		[nextNode addNode:node];
	}
	else 
	{
		self.nextNode = node;
		node.prevNode = self;
	}
}

- (FMXMLNode *)firstNode;
{
	if (prevNode) 
	{
		return [prevNode firstNode];
	}
	else 
	{
		return self;
	}
}

- (FMXMLNode *)lastNode;
{
	if (nextNode)
	{
		return [nextNode lastNode];
	}
	else
	{
		return self;
	}
}

- (BOOL)isModelClass;
{
	return dataType == UDC;
}

- (BOOL)isModelProperty;
{
	return modelProperty != nil;
}

- (BOOL)isModelEnum;
{
	return dataType == ENUM;
}

- (BOOL)isModelArray;
{
	return dataType == ARRAY;
}

- (BOOL)isModelArrayElement;
{
	return modelArrayElement != nil;
}

- (BOOL)isModelDictionary;
{
	return dataType == DICTIONARY;
}

- (BOOL)isModelDictionaryElement;
{
	return modelDictionaryElement != nil;
}

- (BOOL)isContainerType;
{
	return ([self isModelClass] || 
			  [self isModelArray] ||
			  [self isModelDictionary]);	
}

- (BOOL)shouldIgnore;
{
	return dataType == UNKNOWN;
}

- (void)dealloc;
{	
	[prevNode release];
	[nextNode release];
	[name release];
	[modelClass release];
	[modelObject release];
	[modelProperty release];
	[modelEnum release];
	[modelArray release];
	[modelArrayElement release];
	[modelDictionary release];
	[modelDictionaryElement release];
	[characters release];
	[data release];
	[super dealloc];
}

@end
