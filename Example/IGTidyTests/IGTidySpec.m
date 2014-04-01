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
    __block IGTidy* tidy;
    
    beforeEach(^{
        tidy = [[IGTidy alloc] initWithInputFormat:IGTidyFormatHTML outputFormat:IGTidyFormatHTML];
        [tidy setOptions:@{@"wrap": @"0"}];
    });

    afterEach(^{
        tidy = nil;
    });

    describe(@"cleanString:error:", ^{
        it(@"clean html", ^{
            NSString* html = [tidy cleanString:@"<p>Hello World</p>" error:nil];
            [[html should] containString:@"<p>Hello World</p>"];
        });
        
        it(@"clean mismatched end tags", ^{
            NSString* html = [tidy cleanString:@"<h2>subheading</h3>" error:nil];
            [[html should] containString:@"<h2>subheading</h2>"];
        });
        
        it(@"clean misnested tags", ^{
            NSString* html = [tidy cleanString:@"<p>here is a para <b>bold <i>bold italic</b> bold?</i> normal?" error:nil];
            [[html should] containString:@"<p>here is a para <b>bold <i>bold italic</i></b> <i>bold?</i> normal?</p>"];
        });
        
        it(@"clean missing end tags", ^{
            NSString* html = [tidy cleanString:@"<h1>heading<h2>subheading</h2>" error:nil];
            [[html should] containString:@"<h1>heading</h1>\n<h2>subheading</h2>"];
            
            html = [tidy cleanString:@"<h1><i>italic heading</h1>" error:nil];
            [[html should] containString:@"<h1><i>italic heading</i></h1>"];
        });
        
        it(@"clean mixed up tags", ^{
            NSString* html = [tidy cleanString:@"<i><h1>heading</h1></i>\n<p>new paragraph <b>bold text\n<p>some more bold text" error:nil];
            [[html should] containString:@"<h1><i>heading</i></h1>"];
            [[html should] containString:@"<p>new paragraph <b>bold text</b>"];
            [[html should] containString:@"<p><b>some more bold text</b>"];
        });
        
        it(@"clean tag in wrong place", ^{
            NSString* html = [tidy cleanString:@"<h1><hr>heading</h1><h2>sub<hr>heading</h2>" error:nil];
            [[html should] containString:@"<hr>\n<h1>heading</h1>\n<h2>sub</h2>\n<hr>\n<h2>heading</h2>"];
        });
        
        it(@"clean Missing / in end tags", ^{
            NSString* html = [tidy cleanString:@"<a href=\"#refs\">References<a>" error:nil];
            [[html should] containString:@"<a href=\"#refs\">References</a>"];
        });
        
        it(@"clean List markup with missing tags", ^{
            NSString* html = [tidy cleanString:@"<li>1st list item<li>2nd list item" error:nil];
            [[html should] containString:@"<ul>\n<li>1st list item</li>\n<li>2nd list item</li>\n</ul>"];
        });
        
        it(@"clean missing quotation around attributes", ^{
            NSString* html = [tidy cleanString:@"<img src=abc>" error:nil];
            [[html should] containString:@"<img src=\"abc\">"];
        });
    });
});

SPEC_END
