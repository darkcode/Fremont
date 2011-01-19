//
//  FMXMLModelArray.m
//  Hackberry
//
//  Created by Bradley O'Hearne on 6/9/10.
//  Copyright 2010 Big Hill Software LLC. All rights reserved.
//

#import "FMXMLModelArray.h"


@implementation FMXMLModelArray

@synthesize xmlName;
@synthesize modelArrayElement;

- (void)dealloc;
{	
	[xmlName release];
	[modelArrayElement release];
	[super dealloc];
}

@end
