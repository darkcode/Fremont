//
//  ApplicationState.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/8/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "ApplicationState.h"
#import "Employee.h"


@implementation ApplicationState

static ApplicationState *instance;

@synthesize modelManager;
@synthesize deserializedCompany;
@synthesize xml;

+ (ApplicationState *)getInstance
{
	if (! instance)
	{
		instance = [[ApplicationState alloc] init];
		[instance createModelManager];
		[instance serializeCompany];
		[instance deserializeCompany];
	}
	
	return instance;	
}

- (void)createModelManager
{
	modelManager = [[FMXMLModelManager alloc] initWithModelDefinitionFile:@"ModelDefinition"];
}

- (Company *)createCompany 
{
	Company *company = [[[Company alloc] init] autorelease];

	// company properties
	company.name = @"Big Hill Software";
	company.dateFounded = [NSDate date];
	company.location = @"Gilbert, AZ";
	company.description = @"Big Hill Software is an iPhone & iPad app development shop.";
	
	UIImage *image = [UIImage imageNamed:@"logo-bighillsoftware.png"];
	company.logoImageData = UIImagePNGRepresentation(image);
	
	// computers
	NSMutableDictionary *computers = [NSMutableDictionary dictionary];
	company.computers = computers;
	
	// computer 1
	NSString *computerType = @"Mac Pro";
	NSString *key = @"Computer 1";
	[computers setObject:computerType forKey:key];
	
	// computer 2
	computerType = @"Macbook Pro";
	key = @"Computer 2";
	[computers setObject:computerType forKey:key];
	
	// computer 3
	computerType = @"iMac";
	key = @"Computer 3";
	[computers setObject:computerType forKey:key];

	// employees
	NSMutableArray *employees = [NSMutableArray array];
	company.employees = employees;
	
	// employee 1
	Employee *employee = [[[Employee alloc] init] autorelease];
	employee.name = @"Yuri Asamoah";
	employee.isActive = YES;
	employee.compensation = [NSNumber numberWithInt:80];
	employee.compensationTerm = PERHOUR;
	[employees addObject:employee];
	
	// employee 2
	employee = [[[Employee alloc] init] autorelease];
	employee.name = @"Finneas Dunbar";
	employee.isActive = NO;
	employee.compensation = [NSNumber numberWithInt:96000];
	employee.compensationTerm = PERYEAR;
	[employees addObject:employee];
	
	// employee 3
	employee = [[[Employee alloc] init] autorelease];
	employee.name = @"Sketcher Jones";
	employee.isActive = YES;
	employee.compensation = [NSNumber numberWithInt:12000];
	employee.compensationTerm = PERMONTH;
	[employees addObject:employee];
	
	return company;
}


- (void)serializeCompany
{
	NSError *error = nil;
	Company *company = [self createCompany];
	self.xml = [modelManager objectToXML:company withEncoding:NSUTF8StringEncoding error:&error];	
	
	//NSLog(@"%@", self.xml);
}

- (void)deserializeCompany
{
	NSError *error = nil;
	Company *company = [modelManager xmlToObject:xml withEncoding:NSUTF8StringEncoding error:&error];	
	self.deserializedCompany = company;
}

- (void)dealloc
{
	[modelManager release];
	[deserializedCompany release];
	[xml release];
	[super dealloc];
}

@end
