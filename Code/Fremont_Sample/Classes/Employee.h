//
//  Employee.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/5/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum enum_compensationTerm 
{
	PERHOUR = 0,
	PERMONTH = 1,
	PERYEAR = 2
} CompensationTerm;


@interface Employee : NSObject 
{
	NSString *name;
	BOOL isActive;
	NSNumber *compensation;
	CompensationTerm compensationTerm;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, retain) NSNumber *compensation;
@property (nonatomic, assign) CompensationTerm compensationTerm;

@end
