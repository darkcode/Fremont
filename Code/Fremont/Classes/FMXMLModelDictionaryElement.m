//
//  FMXMLModelDictionaryElement.m
//  Hackberry
//
//  Created by Bradley O'Hearne on 6/10/10.
//  Copyright 2010 Big Hill Software LLC. All rights reserved.
//

#import "FMXMLModelDictionaryElement.h"


@implementation FMXMLModelDictionaryElement

@synthesize xmlName;
@synthesize dataType;
@synthesize formatString;
@synthesize key;

- (void)dealloc;
{	
	[xmlName release];
	[formatString release];
	[key release];
	[super dealloc];
}


@end
