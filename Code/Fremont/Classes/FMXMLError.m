//
//  FMXMLError.m
//  Hackberry
//
//  Created by Bradley O'Hearne on 5/26/10.
//  Copyright 2010 Big Hill Software LLC. All rights reserved.
//

#import "FMXMLError.h"
#import "FMXMLConstants.h"


@implementation FMXMLError

+ (FMXMLError *)errorWithCode:(int)code description:(NSString *)description;
{
	NSString *failureReason, *recoverySuggestion; 
	NSObject *recoveryOptions = [NSNull null]; //[NSArray array];
	
	switch (code)
	{
		case ECD_MODEL_DEFINITION_NOT_FOUND:
			description = [NSString stringWithFormat:EDF_MODEL_DEFINITION_NOT_FOUND, description];
			failureReason = EFR_MODEL_DEFINITION_NOT_FOUND;
			recoverySuggestion = ERS_MODEL_DEFINITION_NOT_FOUND;
			break;
		case ECD_UNRECOGNIZED_ELEMENT_NAME:
			description = [NSString stringWithFormat:EDF_UNRECOGNIZED_ELEMENT_NAME, description];
			failureReason = EFR_UNRECOGNIZED_ELEMENT_NAME;
			recoverySuggestion = ERS_UNRECOGNIZED_ELEMENT_NAME;
			break;
		default:
			return nil;
	}
	
	NSArray *objArray = [NSArray arrayWithObjects:
						 description, 
						 failureReason,
						 recoverySuggestion,
						 recoveryOptions,
						 nil];

	NSArray *keyArray = [NSArray arrayWithObjects:
						 NSLocalizedDescriptionKey,
						 NSLocalizedFailureReasonErrorKey, 
						 NSLocalizedRecoverySuggestionErrorKey, 
						 NSLocalizedRecoveryOptionsErrorKey,
						 nil];
	
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray
													  forKeys:keyArray];

	return [[[NSError alloc] initWithDomain:EDM_FREMONT
									   code:code
								   userInfo:userInfo] autorelease];	
}

@end
