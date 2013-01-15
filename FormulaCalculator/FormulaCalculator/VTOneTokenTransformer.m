//
//  VTOneTokenTransformer.m
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 11/13/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import "VTOneTokenTransformer.h"

@implementation VTOneTokenTransformer
- (id)init {
    if (self = [super init]) {
       
        
    }
    return self;
}

+(Class)transformedValueClass {
    return [NSString class];
}

+(BOOL)allowsReverseTransformation {
    return YES;
}

- (id)reverseTransformedValue:(id)value
{
    if ([value length]) {
        NSMutableString *EnteredValue=[NSMutableString stringWithString:value];
        [EnteredValue replaceOccurrencesOfString:@"." withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@"-" withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@"+" withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@"/" withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@"$" withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@"!" withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@"(" withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@")" withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@"%" withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@"&" withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@"#" withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@"?" withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@"'" withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];
        [EnteredValue replaceOccurrencesOfString:@" " withString:@"_" options:NSCaseInsensitiveSearch range:(NSRange){0,[EnteredValue length]}];

        NSString *firstchar = [EnteredValue substringToIndex:1] ;
        if (([firstchar isGreaterThanOrEqualTo:@"0"]) && ([firstchar isLessThanOrEqualTo:@"9"])) {
            [EnteredValue insertString:@"_" atIndex:0];
        }
        return EnteredValue;
    } else return @"xx";
}


-(id)transformedValue:(NSString *)value {
    
    
    return value;
}

@end
