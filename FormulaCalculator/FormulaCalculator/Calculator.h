//
//  Calculator.h
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 10/19/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/ParseKit.h>
#import "CalcFunctions.h"
#import "FunctionLibrary.h"
#import "Constants.h"

typedef enum {
    CalcTypeOperator, // 0
    CalcTypeNumber,
    CalcTypeFunction,
    CalcTypeChangeSign,
    CalcTypeEqualSign,
    CalcTypeConstant, // 5
    CalcTypeInsertOperator,
    CalcTypeLeftParenthesis,
    CalcTypeRightParenthesis,
    CalcTypeMultiParameterFunctionStart,
    CalcTypeMultiParameterFunctionNext,
    CalcTypeArbitaryText,
    CalcTypeClearAll,
    CalcTypeDerivative
} CalcFunctionType;

typedef enum {
    memory_x, // 0
    memory_y,
    memory_z,
    memory_a,
    memory_b,
    memory_c, // 5
    memory_d,
    memory_r,
    memory_h,
    memory_w,
} calcMemoryLocations;


@interface Calculator : NSObject {
@private NSMutableString *formula ;
@private NSMutableString *entry; 
@private NSMutableArray *arrTokens;
@private NSMutableArray *arrUsedVariables;
@private int tokidx;
@private int clearOnDataEntry;
@private NSMutableArray *valuestack;
@private NSString *multiparfunc;
@private NSString *multiparHelpDesc; 
@private NSArray *multiparDescr;
@private NSInteger multiparCount;
@private NSInteger multiparIndex;
@private BOOL doingMultiParEntry;
@private CalcFunctionType lastFunctionType;
@private NSString *lastButtonStr;
@private double mem_x;
@private double mem_y;
@private double mem_z;
@private double mem_a;
@private double mem_b;
@private double mem_c;
@private double mem_d;
@private double mem_r;
@private double mem_h;
@private double mem_w;
@private Calculator *calc2; 
    
@public double result;
@public BOOL errorflag;
@public NSString *errormessage; 
}

@property double result;
@property NSMutableString *formula ;
@property NSMutableString *entry; 
@property NSMutableString *history ;
@property NSMutableString *wherehistory ;
@property NSMutableArray *valuestack;
@property NSMutableArray *arrTokens;
@property NSMutableArray *arrUsedFunctions;
@property int tokidx;
@property int clearOnDataEntry;
@property double memory; 
@property NSString *multiparfunc;
@property NSArray *multiparDescr;
@property NSInteger multiparCount;
@property NSInteger multiparIndex; 
@property BOOL doingMultiParEntry;
@property NSString *multiparHelpDesc;
@property BOOL errorflag;
@property NSString *errormessage;
@property CalcFunctionType lastFunctionType;
@property NSString *lastButtonStr;
@property double mem_x;
@property double mem_y;
@property double mem_z;
@property double mem_a;
@property double mem_b;
@property double mem_c;
@property double mem_d;
@property double mem_r;
@property double mem_h;
@property double mem_w;
@property NSInteger derivativeLevel; 
@property NSString * cLabel_x;
@property NSString * cLabel_y;
@property NSString * cLabel_z;
@property NSString * cLabel_a;
@property NSString * cLabel_b;
@property NSString * cLabel_c;
@property NSString * cLabel_d;
@property NSString * cLabel_r;
@property NSString * cLabel_h;
@property NSString * cLabel_w;
@property NSManagedObjectContext * context; 

@property NSNumberFormatter *nf;

@property BOOL memoryUpdated; 
@property NSMutableArray *arrUsedVariables;
@property Calculator *calc2;
@property NSArray *FunctionStructure;
@property FunctionLibrary *functionLib;

- (double) GetResult ;
- (id) GetFormula;
- (id) GetFormulaHistory;
- (void)initShadowCalc:(FunctionLibrary*)fulib ;
- (void)registerFunctionLibrary:(FunctionLibrary*)fulib; 
- (BOOL) isMemoryUpdated ; 

- (NSString *) variableStringValue: (calcMemoryLocations)variable;
- (void) updateVariable:(calcMemoryLocations)variable;
- (void) setVariableValue:(NSString*)value varName:(calcMemoryLocations)variable;
- (void) setVariableDoubleValue:(double)value varName:(calcMemoryLocations)variable;
- (NSString *) getUsedFunctionDocumentation; 
 
// AddString (Content from calculator buttons)
// WithOption: 0=Operators, 1=Numbers, 2=Functions, 3=change sign
// option 4 = Equal sign, 5 = constant, 6=infront-operators (10^x)
// option 7 = parenthesis
// option 10 = multi parameter functions.


- (void) AddString: (NSString*) str WithOption:(CalcFunctionType)x;
- (void) InitFunctionStructure; 

- (double) dabsolute:(double)x;
- (id) GetTokens ;
- (id) Token;
- (void) clearAll;
- (void) clearNumber;
- (void) save2memory;
- (void) recallMemory;
- (void) memoryAdd;
- (void) memorySubtract;
- (void) memoryClear;
- (double) memoryValue;
- (id) getStatusLine;
- (void) multiparFunction: (NSString*)str;
- (NSString*) getCurrentFormula;
- (void) SetCurrentFormula: (NSString*)str;
- (id) getHelpInfoTitle ;
- (id) getHelpInfoInfo ;
- (NSString *) formatNumber: (double) d;
- (double) doubleFromString: (NSString*)s; 
- (void) setLabel: (NSString*)str variable:(calcMemoryLocations)var;
- (void) registerObjectContext: (NSManagedObjectContext *) contex ;


@end
