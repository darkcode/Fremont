//
//  FMXMLModelDictionaryElement.h
//  Hackberry
//
//  Created by Bradley O'Hearne on 6/10/10.
//  Copyright 2010 Big Hill Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXMLEnums.h"

@interface FMXMLModelDictionaryElement : NSObject 
{
	NSString *xmlName;
	FMXMLDataType dataType;
	NSString *formatString;
	NSString *key;
}

@property (nonatomic, retain) NSString *xmlName;
@property (nonatomic, assign) FMXMLDataType dataType;
@property (nonatomic, retain) NSString *formatString;
@property (nonatomic, retain) NSString *key;

@end
