//
//  FMXMLModelManager.m
//  Fremont
//
//  Created by Bradley O'Hearne on 5/22/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "FMXMLModelManager.h"
#import "FMXMLSerializer.h"
#import "FMXMLDeserializer.h"
#import "FMXMLConstants.h"
#import "FMXMLError.h"


@implementation FMXMLModelManager

@synthesize modelDefinition;

#pragma mark -
#pragma mark Initialization

- (id)initWithModelDefinitionFile:(NSString *)fileName;
{
	if (self = [super init]) 
	{
		self.modelDefinition = [FMXMLModelDefinition modelDefinitionFromFile:fileName];		
	}
	
	return self;
}

#pragma mark -
#pragma mark XML serialization/deserialization

- (NSString *)objectToXML:(id)object withEncoding:(NSStringEncoding)encoding error:(NSError **)error;
{
	if (*error)
	{
		*error = nil;		
	}

	if (modelDefinition) 
	{
		FMXMLSerializer *xmlSerializer = [[FMXMLSerializer alloc] initWithModelDefinition:modelDefinition];
		NSString *xml = [xmlSerializer toXML:object withEncoding:encoding];
		
		if (! xml) 
		{
			//there was an error somewhere
			*error = xmlSerializer.error;
		}	

		[xmlSerializer release];
		
		return xml;
	}
	else
	{
		*error = [FMXMLError errorWithCode:ECD_MODEL_DEFINITION_NOT_FOUND description: @"Serializing to XML"];
		return nil;
	}
}

- (id)xmlToObject:(NSString *)xml withEncoding:(NSStringEncoding)encoding error:(NSError **)error;
{
	if (*error)
	{
		*error = nil;		
	}

	if (modelDefinition) 
	{
		FMXMLDeserializer *xmlDeserializer = [[FMXMLDeserializer alloc] initWithModelDefinition:modelDefinition];
		id object = [xmlDeserializer fromXML:xml withEncoding:encoding];
		
		if (! object) 
		{
			//there was an error somewhere
			*error = xmlDeserializer.error;
		}				

		[xmlDeserializer release];

		return object;
	}
	else
	{
		*error = [FMXMLError errorWithCode:ECD_MODEL_DEFINITION_NOT_FOUND description: @"Deserializing from XML"];
		return nil;
	}	
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc;
{
	[modelDefinition release];
	[super dealloc];
}

@end
