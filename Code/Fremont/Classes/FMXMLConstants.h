//
//  FMXMLConstants.h
//  Hackberry
//
//  Created by Bradley O'Hearne on 5/26/10.
//  Copyright 2010 Big Hill Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// error domain (EDM)
#define EDM_FREMONT							@"FremontErrorDomain"

// error codes (ECD)
#define ECD_MODEL_DEFINITION_NOT_FOUND		001
#define ECD_UNRECOGNIZED_ELEMENT_NAME		002

// error descriptions (EDF)
#define EDF_MODEL_DEFINITION_NOT_FOUND		@"Model definition not found for operation: %@"
#define EDF_UNRECOGNIZED_ELEMENT_NAME		@"Unrecognized element name: %@"

// error failure reasons (EFR)
#define EFR_MODEL_DEFINITION_NOT_FOUND		@"The model manager must have a model definition to serialize / deserialize."
#define EFR_UNRECOGNIZED_ELEMENT_NAME		@"An unrecognized element name was encountered."

// error recovery suggestions (ERS)
#define ERS_MODEL_DEFINITION_NOT_FOUND		@"Check that the model definition file exists and is valid."
#define ERS_UNRECOGNIZED_ELEMENT_NAME		@"Check the model definition XML for legal types."
