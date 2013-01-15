//
//  FunctionLibrary.h
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 10/29/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalcFunctions.h"

@interface FunctionLibrary : NSObject

@property NSMutableArray* FuncLib;

- (CalcFunctions*) FindFunction:(NSString*)str;
- (BOOL) AddFunction:(CalcFunctions*)fu; 

@end
