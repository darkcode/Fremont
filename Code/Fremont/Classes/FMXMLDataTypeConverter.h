//
//  FMXMLDataTypeConverter.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/7/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMXMLEnums.h"

@interface FMXMLDataTypeConverter : NSObject 
{

}

+ (NSString *)numberIdToString:(id)object;
+ (NSString *)dateIdToString:(id)object withFormat:(NSString *)formatString;
+ (NSString *)booleanIdToString:(id)object;
+ (NSString *)dataIdToString:(id)object;		
+ (NSString *)enumIdToString:(id)object;

+ (NSString *)numberToString:(NSNumber *)value;
+ (NSString *)dateToString:(NSDate *)value withFormat:(NSString *)formatString;
+ (NSString *)booleanToString:(BOOL)value;
+ (NSString *)dataToString:(NSData *)value;
+ (NSString *)enumToString:(int)value;

+ (FMXMLXMLType)stringToXMLType:(NSString *)value;
+ (FMXMLDataType)stringToDataType:(NSString *)value;
+ (NSNumber *)stringToNumber:(NSString *)value;
+ (NSDate *)stringToDate:(NSString *)value withFormat:(NSString *)formatString;
+ (BOOL)stringToBoolean:(NSString *)value;
+ (id)stringToBooleanId:(NSString *)value;
+ (NSData *)stringToData:(NSString *)value;
+ (int)stringToEnum:(NSString *)value;
+ (id)stringToEnumId:(NSString *)value;

+ (NSString *)convertToString:(id)object withDataType:(FMXMLDataType)dataType withFormat:(NSString *)formatString;
+ (id)convertToObject:(NSString *)stringValue withDataType:(FMXMLDataType)dataType withFormat:(NSString *)formatString;

@end
