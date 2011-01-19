//
//  FMXMLModelClass.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "FMXMLModelClass.h"


@implementation FMXMLModelClass

@synthesize className;
@synthesize xmlName;
@synthesize textPropertyName;
@synthesize textDataType;	
@synthesize textFormatString;	
@synthesize orderedProperties;
@synthesize propertiesByXMLName;
@synthesize propertiesByPropertyName;

- (id)init;
{
	if (self = [super init]) 
	{
		orderedProperties = [[NSMutableArray alloc] init];
		propertiesByXMLName = [[NSMutableDictionary alloc] init];
		propertiesByPropertyName = [[NSMutableDictionary alloc] init];		
	}
	
	return self;
}

- (void)setProperty:(FMXMLModelProperty *)property;
{
	[orderedProperties addObject:property];
	[propertiesByXMLName setObject:property forKey:property.xmlName];
	[propertiesByPropertyName setObject:property forKey:property.propertyName];
}

- (void)removePropertyByXMLName:(NSString *)propXMLName;
{
	FMXMLModelProperty *property = [self getPropertyByXMLName:propXMLName];
	if (property) 
	{
		[orderedProperties removeObject:property];
		[propertiesByXMLName removeObjectForKey:propXMLName];
		[propertiesByPropertyName removeObjectForKey:property.propertyName];
	}	
}

- (void)removePropertyByPropertyName:(NSString *)propertyName;
{
	FMXMLModelProperty *property = [self getPropertyByPropertyName:propertyName];
	if (property) 
	{
		[orderedProperties removeObject:property];
		[propertiesByXMLName removeObjectForKey:property.xmlName];
		[propertiesByPropertyName removeObjectForKey:propertyName];
	}
}

- (FMXMLModelProperty *)getPropertyByXMLName:(NSString *)propXMLName;
{
	return [propertiesByXMLName objectForKey:propXMLName];
}

- (FMXMLModelProperty *)getPropertyByPropertyName:(NSString *)propertyName;
{
	return [propertiesByPropertyName objectForKey:propertyName];
}

- (NSArray *)getProperties;
{
	return orderedProperties;
}

- (void)dealloc;
{	
	[className release];
	[xmlName release];
	[textPropertyName release];
	[textFormatString release];
	[orderedProperties release];
	[propertiesByXMLName release];
	[propertiesByPropertyName release];
	[super dealloc];
}

@end
