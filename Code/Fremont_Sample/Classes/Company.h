//
//  Company.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/5/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Employee.h"


@interface Company : NSObject
{
	NSString *name;
	NSString *description;
	NSDate *dateFounded;	
	NSString *location;
	NSDictionary *computers;
	NSArray *employees;
	NSData *logoImageData;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSDate *dateFounded;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSDictionary *computers;
@property (nonatomic, retain) NSArray *employees;
@property (nonatomic, retain) NSData *logoImageData;
@property (nonatomic, readonly) UIImage *logoImage;

- (NSString *)outputString;
- (NSString *)displayCompensation:(NSNumber *)compensation term:(CompensationTerm)term;

@end
