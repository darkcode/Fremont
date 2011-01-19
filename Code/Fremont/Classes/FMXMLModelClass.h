//
//  FMXMLModelClass.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXMLModelProperty.h"

@interface FMXMLModelClass : NSObject 
{
	NSString *className;
	NSString *xmlName;
	NSString *textPropertyName;
	FMXMLDataType textDataType;	
	NSString *textFormatString;	
	NSMutableArray *orderedProperties;
	NSMutableDictionary *propertiesByXMLName;
	NSMutableDictionary *propertiesByPropertyName;
}

@property (nonatomic, retain) NSString *className;
@property (nonatomic, retain) NSString *xmlName;
@property (nonatomic, retain) NSString *textPropertyName;
@property (nonatomic, assign) FMXMLDataType textDataType;
@property (nonatomic, retain) NSString *textFormatString;
@property (nonatomic, retain) NSMutableArray *orderedProperties;
@property (nonatomic, retain) NSMutableDictionary *propertiesByXMLName;
@property (nonatomic, retain) NSMutableDictionary *propertiesByPropertyName;

- (void)setProperty:(FMXMLModelProperty *)property;
- (void)removePropertyByXMLName:(NSString *)propXMLName;
- (void)removePropertyByPropertyName:(NSString *)propertyName;
- (FMXMLModelProperty *)getPropertyByXMLName:(NSString *)propXMLName;
- (FMXMLModelProperty *)getPropertyByPropertyName:(NSString *)propertyName;
- (NSArray *)getProperties;

@end
