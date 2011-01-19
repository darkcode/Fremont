//
//  FMXMLEnums.h
//  Fremont
//
//  Created by Bradley O'Hearne on 3/6/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum DataTypes 
{
	UNKNOWN		= 0,
	STRING		= 1,
	NUMBER		= 2,
	DATE		= 3,
	BOOLEAN		= 4,
	ARRAY		= 5,
	DICTIONARY	= 6, 
	DATA		= 7,
	UDC			= 8,
	ENUM		= 9
} FMXMLDataType;


typedef enum XMLTypes 
{
	ATTRIBUTE	= 0,
	ELEMENT		= 1,
	TEXT		= 2
} FMXMLXMLType;
