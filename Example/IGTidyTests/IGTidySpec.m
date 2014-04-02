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

    describe(@"cleanHTML:error:", ^{
        it(@"clean html", ^{
            NSString* html = [tidy cleanHTML:@"<p>Hello World</p>" error:nil];
            [[html should] containString:@"<p>Hello World</p>"];
        });
        
        it(@"clean mismatched end tags", ^{
            NSString* html = [tidy cleanHTML:@"<h2>subheading</h3>" error:nil];
            [[html should] containString:@"<h2>subheading</h2>"];
        });
        
        it(@"clean misnested tags", ^{
            NSString* html = [tidy cleanHTML:@"<p>here is a para <b>bold <i>bold italic</b> bold?</i> normal?" error:nil];
            [[html should] containString:@"<p>here is a para <b>bold <i>bold italic</i></b> <i>bold?</i> normal?</p>"];
        });
        
        it(@"clean missing end tags", ^{
            NSString* html = [tidy cleanHTML:@"<h1>heading<h2>subheading</h2>" error:nil];
            [[html should] containString:@"<h1>heading</h1>\n<h2>subheading</h2>"];
            
            html = [tidy cleanHTML:@"<h1><i>italic heading</h1>" error:nil];
            [[html should] containString:@"<h1><i>italic heading</i></h1>"];
        });
        
        it(@"clean mixed up tags", ^{
            NSString* html = [tidy cleanHTML:@"<i><h1>heading</h1></i>\n<p>new paragraph <b>bold text\n<p>some more bold text" error:nil];
            [[html should] containString:@"<h1><i>heading</i></h1>"];
            [[html should] containString:@"<p>new paragraph <b>bold text</b>"];
            [[html should] containString:@"<p><b>some more bold text</b>"];
        });
        
        it(@"clean tag in wrong place", ^{
            NSString* html = [tidy cleanHTML:@"<h1><hr>heading</h1><h2>sub<hr>heading</h2>" error:nil];
            [[html should] containString:@"<hr>\n<h1>heading</h1>\n<h2>sub</h2>\n<hr>\n<h2>heading</h2>"];
        });
        
        it(@"clean Missing / in end tags", ^{
            NSString* html = [tidy cleanHTML:@"<a href=\"#refs\">References<a>" error:nil];
            [[html should] containString:@"<a href=\"#refs\">References</a>"];
        });
        
        it(@"clean List markup with missing tags", ^{
            NSString* html = [tidy cleanHTML:@"<li>1st list item<li>2nd list item" error:nil];
            [[html should] containString:@"<ul>\n<li>1st list item</li>\n<li>2nd list item</li>\n</ul>"];
        });
        
        it(@"clean missing quotation around attributes", ^{
            NSString* html = [tidy cleanHTML:@"<img src=abc>" error:nil];
            [[html should] containString:@"<img src=\"abc\">"];
        });
    });
    
    describe(@"Test with real html", ^{
        it(@"should clean html5 from Mashable", ^{
            NSString* filename = [[NSBundle bundleForClass:[self class]] pathForResource:@"mashable" ofType:@"html"];
            NSString* html = [[NSString alloc] initWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
            html = [tidy cleanHTML:html error:nil];
            [[html should] containString:@"<div class=\"article-info\"><a class=\"byline\" href=\"/people/mgoldin/\"><img alt=\"Photo\" class=\"author_image\" src=\"http://rack.3.mshcdn.com/media/ZgkyMDE0LzAxLzE0LzVhL3Bob3RvLjZlMjQyLmpwZwpwCXRodW1iCTkweDkwIwplCWpwZw/414ad639/597/photo.jpg\">\n<div class=\"author_and_date\"><span class=\"author_name\">By Melissa Goldin</span><time datetime=\"Mon, 24 Mar 2014 04:00:09 +0000\">2014-03-24 04:00:09 UTC</time></div>\n</a></div>"];
        });
    });
});

SPEC_END
