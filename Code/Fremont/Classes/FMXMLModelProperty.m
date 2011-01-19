//
//  FMXMLModelProperty.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "FMXMLModelProperty.h"


@implementation FMXMLModelProperty

@synthesize propertyName;
@synthesize dataType;
@synthesize xmlName;
@synthesize xmlType;
@synthesize formatString;

- (void)dealloc;
{
	[propertyName release];
	[xmlName release];
	[formatString release];
	[super dealloc];
}

@end
