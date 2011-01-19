//
//  FMXMLModelRoot.h
//  Fremont
//
//  Created by Bradley O'Hearne on 7/9/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXMLEnums.h"


@interface FMXMLModelRoot : NSObject 
{
	FMXMLDataType dataType;
	NSString *xmlName;
	NSString *formatString;
}

@property (nonatomic, assign) FMXMLDataType dataType;
@property (nonatomic, retain) NSString *xmlName;
@property (nonatomic, retain) NSString *formatString;

@end
