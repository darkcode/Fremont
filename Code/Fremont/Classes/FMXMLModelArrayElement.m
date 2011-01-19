//
//  FMXMLModelArrayElement.m
//  Hackberry
//
//  Created by Bradley O'Hearne on 6/10/10.
//  Copyright 2010 Big Hill Software LLC. All rights reserved.
//

#import "FMXMLModelArrayElement.h"


@implementation FMXMLModelArrayElement

@synthesize xmlName;
@synthesize dataType;
@synthesize formatString;

- (void)dealloc;
{	
	[xmlName release];
	[formatString release];
	[super dealloc];
}


@end
