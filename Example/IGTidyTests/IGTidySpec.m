//
//  IGTidySpec.m
//  IGTidy
//
//  Created by Chong Francis on 1/4/14.
//  Copyright 2014年 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "IGTidy.h"

SPEC_BEGIN(IGTidySpec)

describe(@"IGTidy", ^{
    describe(@"cleanString:error:", ^{
        it(@"clean html", ^{
            IGTidy* tidy = [[IGTidy alloc] initWithInputFormat:IGTidyFormatHTML
                                                  outputFormat:IGTidyFormatHTML
                                                      encoding:@"utf8"
                                                   tidyOptions:@{}];
            
            NSString* html = [tidy cleanString:@"<p>Hello World</p>" error:nil];
            [[html should] containString:@"<p>Hello World</p>"];
        });
    });
});

SPEC_END
