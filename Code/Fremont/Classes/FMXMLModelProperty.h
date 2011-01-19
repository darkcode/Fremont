//
//  FMXMLModelProperty.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXMLEnums.h"

@interface FMXMLModelProperty : NSObject 
{
	NSString *propertyName;
	FMXMLDataType dataType;
	NSString *xmlName;
	FMXMLXMLType xmlType;
	NSString *formatString;
}

@property (nonatomic, retain) NSString *propertyName;
@property (nonatomic, assign) FMXMLDataType dataType;
@property (nonatomic, retain) NSString *xmlName;
@property (nonatomic, assign) FMXMLXMLType xmlType;
@property (nonatomic, retain) NSString *formatString;

@end
