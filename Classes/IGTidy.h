//
//  IGTidy.h
//  IGTidy
//
//  Created by Chong Francis on 1/4/14.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const IGTidyErrorDomain;

typedef enum {
    IGTidyFormatHTML,
    IGTidyFormatXML,
    IGTidyFormatXHTML,
} IGTidyFormat;

@interface IGTidy : NSObject

/**
 * Initialize Tidy with the input and output format.
 * @param inputFormat Input file format
 * @param outputFormat Output file format
 */
-(instancetype) initWithInputFormat:(IGTidyFormat)inputFormat
                       outputFormat:(IGTidyFormat)outputFormat;

/**
 * Initialize Tidy with the input and output format.
 * @param inputFormat Input file format
 * @param outputFormat Output file format
 * @param options Options to configure Tidy
 * @see setOptions:
 */
-(instancetype) initWithInputFormat:(IGTidyFormat)inputFormat
                       outputFormat:(IGTidyFormat)outputFormat
                            options:(NSDictionary*)options;

/**
 * Configure options with Tidy
 * @param options Options to configure Tidy
 * @throw NSInvalidArgumentException if there is error setting options
 */
-(void) setOptions:(NSDictionary*)options;

/**
 * Clean the input HTML and optionally getting an NSError in case of failed cleaning.
 * @param html HTML to be cleaned
 * @param outError output error
 * @return cleaned HTML string
 */
-(NSString*) cleanHTML:(NSString*)html error:(NSError**)outError;

@end
