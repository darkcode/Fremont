//
//  Company.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/5/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "Company.h"
#import "FMXMLDataTypeConverter.h"


@implementation Company

@synthesize name;
@synthesize description;
@synthesize dateFounded;	
@synthesize location;
@synthesize computers;
@synthesize employees;
@synthesize logoImageData;

- (UIImage *)logoImage;
{
	return [UIImage imageWithData:logoImageData];
}

- (NSString *)outputString;
{
	NSString *outputText = @"";
	outputText = [outputText stringByAppendingString:@"Company Info\n"];	
	outputText = [outputText stringByAppendingString:[NSString stringWithFormat:@"Name: %@\n", name]];
	outputText = [outputText stringByAppendingString:[NSString stringWithFormat:@"Date founded: %@\n", 
													  [FMXMLDataTypeConverter dateToString:dateFounded withFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"]]];
	outputText = [outputText stringByAppendingString:[NSString stringWithFormat:@"Location: %@\n", location]];
	outputText = [outputText stringByAppendingString:[NSString stringWithFormat:@"Description: %@\n\n", description]];

	int count = 0;
	for (NSString *computer in [computers allValues]) 
	{
		count++;
		outputText = [outputText stringByAppendingString:[NSString stringWithFormat:@"Computer %d: %@\n", count, computer]];	
	}
	
	count = 0;
	for (Employee *emp in employees) 
	{
		count++;
		outputText = [outputText stringByAppendingString:[NSString stringWithFormat:@"\nEmployee %d Info\n", count]];	
		outputText = [outputText stringByAppendingString:[NSString stringWithFormat:@"Name: %@\n", emp.name]];
		outputText = [outputText stringByAppendingString:[NSString stringWithFormat:@"Is Active?: %@\n", emp.isActive ? @"YES" : @"NO"]];
		outputText = [outputText stringByAppendingString:[self displayCompensation:emp.compensation term:emp.compensationTerm]];
	}
	return outputText;
}

- (NSString *)displayCompensation:(NSNumber *)compensation term:(CompensationTerm)term;
{
	NSString *readableTerm;
	
	switch (term)
	{
		case PERHOUR:
			readableTerm = @"per hour";
			break;
		case PERMONTH:
			readableTerm = @"per month";
			break;
		case PERYEAR:
			readableTerm = @"per year";
			break;
		default:
			readableTerm = @"";
			break;
	}
	
	return [NSString stringWithFormat:@"Compensation: $%d %@\n", [compensation intValue], readableTerm];
}

- (void)dealloc;
{
	[name release];
	[description release];
	[dateFounded release];
	[location release];
	[computers release];
	[employees release];
	[logoImageData release];
	[super dealloc];
}

@end
