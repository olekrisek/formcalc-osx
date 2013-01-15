//
//  RDTransformer.m
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 11/12/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import "RDTransformer.h"

@implementation RDTransformer
- (id)init {
    if (self = [super init]) {
        self.formatter = [[NSNumberFormatter alloc] init];
         
        [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        [self.formatter setGroupingSeparator:groupingSeparator];
        [self.formatter setGroupingSize:3];
        [self.formatter setAlwaysShowsDecimalSeparator:NO];
        [self.formatter setUsesGroupingSeparator:YES];
        [self.formatter setUsesSignificantDigits:YES];
        [self.formatter setMaximumSignificantDigits:18];
        [self.formatter setMaximumFractionDigits:10];

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
    [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [self.formatter numberFromString:value];
}


-(id)transformedValue:(NSNumber *)value {
    
    BOOL sci=NO;
    double dd = [value doubleValue]; 
    if (dd<0.0) dd = (-dd);
    if ((dd>0.0) && (dd<1e-3)) sci=YES;
    if (dd>1e+8) sci=YES;
    if (sci) [self.formatter setNumberStyle:NSNumberFormatterScientificStyle];
    else [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [self.formatter stringFromNumber:value];
}
@end
