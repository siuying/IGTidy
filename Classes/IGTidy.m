//
//  IGTidy.m
//  IGTidy
//
//  Created by Chong Francis on 1/4/14.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "IGTidy.h"

#import "tidy.h"
#import "buffio.h"

NSString* const IGTidyErrorDomain = @"IGTidyErrorDomain";

@interface IGTidy() {
    TidyDoc _tidyDocument;
}
@end

@implementation IGTidy

+ (IGTidy *)tidy
{
    return [[self alloc] init];
}

-(instancetype) initWithInputFormat:(IGTidyFormat)inputFormat
                       outputFormat:(IGTidyFormat)outputFormat
{
    return [self initWithInputFormat:inputFormat outputFormat:outputFormat options:nil];
}

-(instancetype) initWithInputFormat:(IGTidyFormat)inputFormat
                       outputFormat:(IGTidyFormat)outputFormat
                            options:(NSDictionary*)options
{
    self = [super init];

    _tidyDocument = tidyCreate();
    Bool result = NO;

    // Set input format if input is XML (xhtml & html are the tidy 'default')
    if (inputFormat == IGTidyFormatXML) {
        tidyOptSetBool(_tidyDocument, TidyXmlTags, YES);
        NSAssert(result, @"tidyOptSetBool(TidyXmlTags) should return YES, now return NO");
    }

    // Force output even if errors found
    result = tidyOptSetBool(_tidyDocument, TidyForceOutput, YES);
    NSAssert(result >= 0, @"tidyOptSetBool() should return 0");

    // Set output format
    switch (outputFormat) {
        case IGTidyFormatXHTML:
        {
            result = tidyOptSetBool(_tidyDocument, TidyXhtmlOut, YES);
            NSAssert(result, @"tidyOptSetBool(TidyXhtmlOut) should return YES, now return NO");
            break;
        };
        case IGTidyFormatHTML:
        {
            result = tidyOptSetBool(_tidyDocument, TidyHtmlOut, YES);
            NSAssert(result, @"tidyOptSetBool(TidyHtmlOut) should return YES, now return NO");
            break;
        };
        case IGTidyFormatXML:
        {
            result = tidyOptSetBool(_tidyDocument, TidyXmlOut, YES);
            NSAssert(result, @"tidyOptSetBool(TidyXmlOut) should return YES, now return NO");
            break;
        };
    }

    [self setOptions:options];

    return self;
}

-(void) setOptions:(NSDictionary*)options
{
    // Set extra option
    [options enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* value, BOOL *stop) {
        Bool result = tidyOptParseValue(_tidyDocument, key.UTF8String, value.UTF8String);
        if (!result) {
            [NSException raise:NSInvalidArgumentException
                        format:@"tidyOptParseValue(%@, %@) should return YES, now return NO", key, value];
        }
    }];
}

-(NSString*) cleanHTML:(NSString*)html error:(NSError**)outError
{
    // Create an error buffer
    TidyBuffer errorBuffer;
    tidyBufInit(&errorBuffer);
    tidySetErrorBuffer(_tidyDocument, &errorBuffer);
    
    // Set encoding - same for input and output
    tidySetInCharEncoding(_tidyDocument, "utf-8");
    tidySetOutCharEncoding(_tidyDocument, "utf-8");

    // parse the data
    int returnCode = tidyParseString(_tidyDocument, [html UTF8String]);
    if (returnCode < 0) {
        if (outError) {
            NSDictionary *theUserInfo = @{NSLocalizedDescriptionKey: [NSString stringWithUTF8String:(char *)errorBuffer.bp]};
            *outError = [NSError errorWithDomain:IGTidyErrorDomain
                                            code:returnCode
                                        userInfo:theUserInfo];
        }
        return nil;
    }
    
    // repair the data
    returnCode = tidyCleanAndRepair(_tidyDocument);
    if (returnCode < 0) {
        if (outError) {
            NSDictionary *theUserInfo = @{NSLocalizedDescriptionKey: [NSString stringWithUTF8String:(char *)errorBuffer.bp]};
            *outError = [NSError errorWithDomain:IGTidyErrorDomain
                                            code:returnCode
                                        userInfo:theUserInfo];
        }
        return nil;
    }

    // find the buffer size required
    uint bufferLength = 0;
    tidySaveString(_tidyDocument, NULL, &bufferLength);

    // output the result
    NSMutableData *outputBuffer = [NSMutableData dataWithLength:bufferLength];
    if (!outputBuffer) {
        return nil;
    }
    tidySaveString(_tidyDocument, [outputBuffer mutableBytes], &bufferLength);
    tidyBufFree(&errorBuffer);

    return [[NSString alloc] initWithData:outputBuffer encoding:NSUTF8StringEncoding];
}

-(void) dealloc
{
    tidyRelease(_tidyDocument);
    _tidyDocument = nil;
}

@end
