//
//  FMXMLError.h
//  Hackberry
//
//  Created by Bradley O'Hearne on 5/26/10.
//  Copyright 2010 Big Hill Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMXMLError : NSError 
{

}

+ (FMXMLError *)errorWithCode:(int)code description:(NSString *)description;

@end
