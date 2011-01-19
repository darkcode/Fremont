//
//  FMXMLModelManager.h
//  Fremont
//
//  Created by Bradley O'Hearne on 5/22/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXMLModelDefinition.h"


@interface FMXMLModelManager : NSObject 
{
	FMXMLModelDefinition *modelDefinition;
}
	
@property (nonatomic, retain) FMXMLModelDefinition *modelDefinition;

// initializers
- (id)initWithModelDefinitionFile:(NSString *)fileName;

// xml methods
- (NSString *)objectToXML:(id)object withEncoding:(NSStringEncoding)encoding error:(NSError **)error;
- (id)xmlToObject:(NSString *)xml withEncoding:(NSStringEncoding)encoding error:(NSError **)error;

@end
