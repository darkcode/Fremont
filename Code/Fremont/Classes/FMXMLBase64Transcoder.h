//
//  Base64Transcoder.h
//  Fremont
//
//  Created by Bradley O'Hearne on 7/7/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMXMLBase64Transcoder : NSObject 
{

}

+ (NSData *)toDataFromBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
+ (NSString *)toBase64EncodedStringFromData:(NSData *)data;

@end
