//
//  Employee.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/5/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "Employee.h"


@implementation Employee

@synthesize name;
@synthesize isActive;
@synthesize compensation;
@synthesize compensationTerm;

- (void)dealloc;
{
	[name release];
	[compensation release];
	[super dealloc];
}

@end
