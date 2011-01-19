//
//  FMXMLModelRoot.m
//  Fremont
//
//  Created by Bradley O'Hearne on 7/9/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "FMXMLModelRoot.h"


@implementation FMXMLModelRoot

@synthesize dataType;
@synthesize xmlName;
@synthesize formatString;

- (void)dealloc;
{
	[xmlName release];
	[formatString release];
	[super dealloc];
}

@end
