//
//  FMXMLDataTypeConverter.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/7/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "FMXMLDataTypeConverter.h"
#import "FMXMLBase64Transcoder.h"


@implementation FMXMLDataTypeConverter

+ (NSString *)numberIdToString:(id)object;
{
	NSNumber *numberValue = (NSNumber *)object;
	return [FMXMLDataTypeConverter numberToString:numberValue];
}

+ (NSString *)dateIdToString:(id)object withFormat:(NSString *)formatString;
{
	NSDate *dateValue = (NSDate *)object;
	return [FMXMLDataTypeConverter dateToString:dateValue withFormat:formatString];
}

+ (NSString *)booleanIdToString:(id)object;
{
	BOOL booleanValue = (BOOL)(long)object;	
	return [FMXMLDataTypeConverter booleanToString:booleanValue];
}

+ (NSString *)dataIdToString:(id)object;
{
	NSData *dataValue = (NSData *)object;
	return [FMXMLDataTypeConverter dataToString:dataValue];
}

+ (NSString *)enumIdToString:(id)object;
{
	return [FMXMLDataTypeConverter enumToString:(int)object];
}

+ (NSString *)numberToString:(NSNumber *)value {
	return [value stringValue];	
}

+ (NSString *)dateToString:(NSDate *)value withFormat:(NSString *)formatString;
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:formatString];
	NSString *dateString = [dateFormatter stringFromDate:value];
	[dateFormatter release];
	return dateString;
}

+ (NSString *)booleanToString:(BOOL)value;
{
	if (value)
		return @"YES";
	else 
		return @"NO";
}

+ (NSString *)dataToString:(NSData *)value;
{
	return [FMXMLBase64Transcoder toBase64EncodedStringFromData:value];
}

+ (NSString *)enumToString:(int)value;
{
	return [NSString stringWithFormat:@"%d", value];
}

+ (NSNumber *)stringToNumber:(NSString *)value;
{
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	NSNumber *number = [numberFormatter numberFromString:value];
	[numberFormatter release];
	return number;
}

+ (NSDate *)stringToDate:(NSString *)value withFormat:(NSString *)formatString;
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:formatString];
	NSDate *date = [dateFormatter dateFromString:value];
	[dateFormatter release];	
	return date;
}

+ (BOOL)stringToBoolean:(NSString *)value;
{
	return [value boolValue];
}

+ (id)stringToBooleanId:(NSString *)value;
{
	return (id)(long)[FMXMLDataTypeConverter stringToBoolean:value];
}

+ (NSData *)stringToData:(NSString *)value;
{
	return [FMXMLBase64Transcoder toDataFromBase64EncodedString:value];
}

+ (int)stringToEnum:(NSString *)value;
{
	return [value intValue];
}

+ (id)stringToEnumId:(NSString *)value;
{
	return (id)(long)[FMXMLDataTypeConverter stringToEnum:value];
}

+ (FMXMLDataType)stringToDataType:(NSString *)value;
{
	if ([value isEqualToString:@"STRING"]) return STRING;
	else if ([value isEqualToString:@"NUMBER"]) return NUMBER;
    else if ([value isEqualToString:@"DATE"]) return DATE;
    else if ([value isEqualToString:@"BOOLEAN"]) return BOOLEAN;
    else if ([value isEqualToString:@"ARRAY"]) return ARRAY;
    else if ([value isEqualToString:@"DICTIONARY"]) return DICTIONARY;
    else if ([value isEqualToString:@"DATA"]) return DATA;
	else if ([value isEqualToString:@"UDC"]) return UDC;
	else if ([value isEqualToString:@"ENUM"]) return ENUM;
    else return STRING;
}

+ (FMXMLXMLType)stringToXMLType:(NSString *)value;
{
	if ([value isEqualToString:@"ATTRIBUTE"]) return ATTRIBUTE;
	else if ([value isEqualToString:@"ELEMENT"]) return ELEMENT;
	else return ELEMENT;
}

+ (NSString *)convertToString:(id)object withDataType:(FMXMLDataType)dataType withFormat:(NSString *)formatString;
{
	switch (dataType)
	{
		case STRING:
			return [(NSString *)object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		case NUMBER:
			return [FMXMLDataTypeConverter numberIdToString:object];
		case DATE:
			return [FMXMLDataTypeConverter dateIdToString:object withFormat:formatString];
		case BOOLEAN:
			return [FMXMLDataTypeConverter booleanIdToString:object];
		case ARRAY:
			return nil;
		case DATA:
			return [FMXMLDataTypeConverter dataIdToString:object];
		case UDC:
			return nil;
		case ENUM:
			return [FMXMLDataTypeConverter enumIdToString:object];
		default:
			return nil;
	}		
}

+ (id)convertToObject:(NSString *)stringValue withDataType:(FMXMLDataType)dataType withFormat:(NSString *)formatString;
{
	switch (dataType)
	{
		case STRING:
			return [stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		case NUMBER:
			return [FMXMLDataTypeConverter stringToNumber:stringValue];
		case DATE:
			return [FMXMLDataTypeConverter stringToDate:stringValue withFormat:formatString];
		case BOOLEAN:
			return [FMXMLDataTypeConverter stringToBooleanId:stringValue];
		case ARRAY:
			return nil;
		case DATA:
			return [FMXMLDataTypeConverter stringToData:stringValue];
		case UDC:
			return nil;
		case ENUM:
			return [FMXMLDataTypeConverter stringToEnumId:stringValue];
		default:
			return nil;
	}			
}

@end
