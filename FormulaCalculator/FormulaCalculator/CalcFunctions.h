//
//  CalcFunctions.h
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 10/29/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CalcCatNoFunction, // 0
    CalcCatFinance,
    CalcCatStatistics,
    CalcCatGeometry,
    CalcCatConverters,
    CalcCatCurrency,
    CalcCatMath,
    CalcCatPhysics
} CalcFunctionCategory;

typedef enum {
    calc_UsingFormulas=0,
    calc_min,
    calc_max,
    calc_annualIRforloan,
    calc_perimeterEllipse
} calcMethod;


@interface CalcFunctions : NSString
@property NSString *name; 
@property NSString *description;
@property NSArray *parameters;
@property NSArray *formulas;
@property CalcFunctionCategory category;
@property NSInteger FunctionID; 

- (CalcFunctions*) FunctionWithValues:(NSString*)newname
                   Category:(CalcFunctionCategory)cat
                     Method:(NSInteger)fuID
                Description:(NSString*)desc
                 Parameters:(NSArray* )param
                   Formulas:(NSArray*)form;
- (BOOL) buildXMLnode:(NSXMLElement *)parent;
- (BOOL) buildFunctionFromXML:(NSXMLElement *)node;
- (BOOL) isEqual:(id) str;
- (NSInteger) calcMethod;
- (void) encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder; 


@end
