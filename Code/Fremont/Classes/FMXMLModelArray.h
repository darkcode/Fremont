//
//  FMXMLModelArray.h
//  Hackberry
//
//  Created by Bradley O'Hearne on 6/9/10.
//  Copyright 2010 Big Hill Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXMLModelArrayElement.h"


@interface FMXMLModelArray : NSObject 
{
	NSString *xmlName;
	FMXMLModelArrayElement *modelArrayElement;
}

@property (nonatomic, retain) NSString *xmlName;
@property (nonatomic, retain) FMXMLModelArrayElement *modelArrayElement;

@end
