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

-(instancetype) initWithInputFormat:(IGTidyFormat)inputFormat
                       outputFormat:(IGTidyFormat)outputFormat;

-(instancetype) initWithInputFormat:(IGTidyFormat)inputFormat
                       outputFormat:(IGTidyFormat)outputFormat
                            options:(NSDictionary*)options;

-(void) setOptions:(NSDictionary*)options;

-(NSString*) cleanString:(NSString*)string error:(NSError**)outError;

@end
