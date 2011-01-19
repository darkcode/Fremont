//
//  ApplicationState.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/8/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "FMXMLModelManager.h"
#import "Company.h"


@interface ApplicationState : NSObject 
{
	FMXMLModelManager *modelManager;
	Company *deserializedCompany;
	NSString *xml;
}

@property (nonatomic, retain) FMXMLModelManager *modelManager;
@property (nonatomic, retain) Company *deserializedCompany;
@property (nonatomic, retain) NSString *xml;

+ (ApplicationState *)getInstance;

- (void)createModelManager;
- (Company *)createCompany;
- (void)serializeCompany;
- (void)deserializeCompany;

@end
