//
//  Calculator.m
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 10/19/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

@synthesize result;
@synthesize formula;
@synthesize entry; 
@synthesize valuestack;
@synthesize tokidx;
@synthesize arrTokens;
@synthesize history;
@synthesize wherehistory; 
@synthesize clearOnDataEntry;
@synthesize memory;
@synthesize multiparfunc;
@synthesize multiparDescr;
@synthesize multiparCount;
@synthesize multiparIndex;
@synthesize doingMultiParEntry;
@synthesize multiparHelpDesc;
@synthesize errorflag;
@synthesize errormessage;
@synthesize lastFunctionType;
@synthesize lastButtonStr;
@synthesize mem_a;
@synthesize mem_b;
@synthesize mem_c;
@synthesize mem_d;
@synthesize mem_h;
@synthesize mem_r;
@synthesize mem_w;
@synthesize mem_x;
@synthesize mem_y;
@synthesize mem_z;

@synthesize cLabel_x;
@synthesize cLabel_y;
@synthesize cLabel_z;
@synthesize cLabel_a;
@synthesize cLabel_b;
@synthesize cLabel_c;
@synthesize cLabel_d;
@synthesize cLabel_r;
@synthesize cLabel_h;
@synthesize cLabel_w;

@synthesize arrUsedVariables;
@synthesize calc2;
@synthesize memoryUpdated;
@synthesize FunctionStructure;
@synthesize functionLib; 
@synthesize arrUsedFunctions;
@synthesize nf;
@synthesize context;
@synthesize derivativeLevel; 


- (id)init
{
    self = [super init];
 //   NSLog(@"Calculator init");
    if (self) {
        FunctionStructure = nil;
        functionLib = nil; 
        calc2 = nil;
        [self clearObjectData];
        
        nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        [nf setGroupingSeparator:groupingSeparator];
        [nf setGroupingSize:3];
        [nf setAlwaysShowsDecimalSeparator:NO];
        [nf setUsesGroupingSeparator:YES];
        [nf setUsesSignificantDigits:YES];
        [nf setMaximumSignificantDigits:18];
        [nf setMaximumFractionDigits:10];
        

    }
    return self;
}

- (NSString *) formatNumber: (double) d {
    BOOL sci=NO;
    double dd = d;
    if (dd<0.0) dd = (-d);
    if ((dd>0.0) && (dd<1e-3)) sci=YES;
    if (dd>1e+8) sci=YES;
    if (sci) [nf setNumberStyle:NSNumberFormatterScientificStyle];
    else [nf setNumberStyle:NSNumberFormatterDecimalStyle]; 
    return  [nf stringFromNumber:[NSNumber numberWithDouble:d]];
    
}

- (double) doubleFromString: (NSString*)s {
    NSNumber *nn = [nf numberFromString:s];
    return  [nn doubleValue]; 
}


- (void) clearObjectData {
    formula = [NSMutableString stringWithCapacity:50];
    history = [NSMutableString stringWithCapacity:50];
    wherehistory = [NSMutableString stringWithCapacity:50];
    entry = [NSMutableString stringWithCapacity:20];
    arrTokens = [NSMutableArray arrayWithCapacity:20] ;
    valuestack =[NSMutableArray arrayWithCapacity:20] ;
    arrUsedVariables = [NSMutableArray arrayWithCapacity:10] ;
    arrUsedFunctions = [NSMutableArray arrayWithCapacity:5] ;
    result = 0.0;
    clearOnDataEntry = 0;
    memory = 0.0;
    doingMultiParEntry = NO;
    errorflag = NO;
    lastFunctionType = CalcTypeClearAll;
    lastButtonStr = @"";
 

}

- (void) setLabel: (NSString*)str variable:(calcMemoryLocations)var {
    switch (var) {
        case memory_x:
            cLabel_x = [NSString stringWithString:str];
            break;
        case memory_y:
            cLabel_y = [NSString stringWithString:str];
            break;
        case memory_z:
            cLabel_z = [NSString stringWithString:str];
            break;
        case memory_a:
            cLabel_a = [NSString stringWithString:str];
            break;
        case memory_b:
            cLabel_b = [NSString stringWithString:str];
            break;
        case memory_c:
            cLabel_c = [NSString stringWithString:str];
            break;
        case memory_d:
            cLabel_d = [NSString stringWithString:str];
            break;
        case memory_r:
            cLabel_r = [NSString stringWithString:str];
            break;
        case memory_h:
            cLabel_h = [NSString stringWithString:str];
            break;
        case memory_w:
            cLabel_w = [NSString stringWithString:str];
            break;
            
        default:
            break;
    }
}

- (void)initShadowCalc:(FunctionLibrary*)fulib //
{
    functionLib = fulib; 
    calc2 = [[Calculator alloc] init] ;
    if (calc2)
        [calc2 registerFunctionLibrary:fulib];
    //[self InitFunctionStructure]; 
}

- (void)registerFunctionLibrary:(FunctionLibrary*)fulib {
    functionLib = fulib; 
}

- (BOOL) iscalc2running {
    BOOL ok = NO;
    if (calc2) ok = YES;
    else {
        calc2 = [[Calculator alloc] init] ;
        if (calc2)
            [calc2 registerFunctionLibrary:functionLib];
        if (calc2) ok = YES;
    }
    return ok;
}


- (double) calcWithCalc2: (NSString*)equation par1:(double)x par2:(double)y par3:(double)z par4:(double)a par5:(double)b par6:(double)c {
    if ([self iscalc2running]) {
        //[calc2 clearAll];
        [calc2 setVariableDoubleValue:x varName:memory_x];
        [calc2 setVariableDoubleValue:y varName:memory_y];
        [calc2 setVariableDoubleValue:z varName:memory_z];
        [calc2 setVariableDoubleValue:a varName:memory_a];
        [calc2 setVariableDoubleValue:b varName:memory_b];
        [calc2 setVariableDoubleValue:c varName:memory_c];
        [calc2 SetCurrentFormula:equation];
        return [calc2 GetResult];
    } else return 0.0;
}

- (void) popNoOfParstoCalc2FromStack: (NSInteger)cnt {
    if (cnt>=10)[calc2 setVariableDoubleValue:[self doubleFromString:[self pop]] varName:memory_w];
    if (cnt>=9)[calc2 setVariableDoubleValue:[self doubleFromString:[self pop]] varName:memory_h];
    if (cnt>=8)[calc2 setVariableDoubleValue:[self doubleFromString:[self pop]] varName:memory_r];
    if (cnt>=7)[calc2 setVariableDoubleValue:[self doubleFromString:[self pop]] varName:memory_d];
    if (cnt>=6)[calc2 setVariableDoubleValue:[self doubleFromString:[self pop]] varName:memory_c];
    if (cnt>=5)[calc2 setVariableDoubleValue:[self doubleFromString:[self pop]] varName:memory_b];
    if (cnt>=4)[calc2 setVariableDoubleValue:[self doubleFromString:[self pop]] varName:memory_a];
    if (cnt>=3)[calc2 setVariableDoubleValue:[self doubleFromString:[self pop]] varName:memory_z];
    if (cnt>=2)[calc2 setVariableDoubleValue:[self doubleFromString:[self pop]] varName:memory_y];
    if (cnt>=1)[calc2 setVariableDoubleValue:[self doubleFromString:[self pop]] varName:memory_x];

}

- (double) calcWithCalc2FromStack: (NSString*)equation noOfPars:(NSInteger)cnt {
    if ([self iscalc2running]) {
       // [calc2 clearAll];
        [self popNoOfParstoCalc2FromStack:cnt];

        [calc2 SetCurrentFormula:equation];
        return [calc2 GetResult];
    } else return 0.0;
}
// This uses calc2 to calculate a serie of equations. The last equation is the one returning value, the others need
// to be on the form <variable>=<equation>, where variables can be any x, y, z, a, b, c, d, r, h, w
// c=sqrt(x^2+y^2). Variables assigned should then be used in the final formula. They can also be re-used
// if there is no need for them anymore in the computation. 
- (double) calcWithCalc2Array: (NSArray*)equations noOfPars:(NSInteger)cnt {
    NSString *thisFormula;
    double arg=0;
    if ([self iscalc2running]) {
       // [calc2 clearAll];
        [self popNoOfParstoCalc2FromStack:cnt];        
      
        for (thisFormula in equations) {
                [calc2 SetCurrentFormula:thisFormula];
                arg = [calc2 GetResult];
        }

    } 
     return arg;
}



- (double)calcWithCalc2UsingFunction: (CalcFunctions*)function {
    double arg = 0.0;
    NSInteger noPars;
    NSString *thisFormula;
    if ([self iscalc2running]) {
        if (function) {
            noPars = [[function parameters]count];
            [self popNoOfParstoCalc2FromStack:noPars];
            for (thisFormula in [function formulas]) {
                if (! calc2.errorflag) { // if one of the formulas fail, skip the remaining ones.
                    [calc2 SetCurrentFormula:thisFormula];
                    arg = [calc2 GetResult];
                }
            }
        }
    }
    return arg;
}

- (void) registerObjectContext: (NSManagedObjectContext *) contex {
    context = contex;
    if (calc2) [calc2 registerObjectContext:contex];
}


- (BOOL) isUserConstant: (NSString*) c result: (double*) arg {
    BOOL ok=YES;
    NSError *error = nil;
    
    if (context) {
        
        
        Constants * obj=nil;
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Constants" inManagedObjectContext:context]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"key=%@",c]];
        obj = [[[self context] executeFetchRequest:request error:&error] lastObject];
        
        if (error) {
            NSLog(@"Error retriving value from ValueStore, name=%@, error=%@", c, error);
            ok=NO;
        }
        
        if (!obj) { // Create a new one....
            ok=NO;
        } else {
            *arg = [obj.value doubleValue];
             [ self addToWhere:c];
        }
    }
    return ok;
}



- (BOOL) calcWithCalc2UsingName: (NSString*)name resulting: (double*)argp {
    CalcFunctions* fu=nil;
    NSInteger calcMethod; 
    BOOL ok = NO;
    double arg1, arg2, arg3, arg4;
    fu = [functionLib FindFunction:name];
    if (fu) {
        [self addToUsedFunctins:name ];
        (void) [ self Token]; // function shold have ( - remove this
        [self doEvaluate]; // argument on top of stack after this
         
        calcMethod = [fu calcMethod];
        switch (calcMethod) {
            case calc_UsingFormulas:
                *argp = [self calcWithCalc2UsingFunction: fu];
                if (calc2.errorflag) {
                    errorflag = YES;
                    errormessage = [NSString stringWithFormat:@"%@: %@", name, calc2.errormessage]; 
                }
                break;
            case calc_min:
                arg1 = [self doubleFromString:[self pop]];
                arg2 = [self doubleFromString:[self pop]];
                if (arg1<arg2) *argp = arg1; else *argp = arg2;
                break;
            case calc_max:
                arg1 = [self doubleFromString:[self pop]];
                arg2 = [self doubleFromString:[self pop]];
                if (arg1>arg2) *argp = arg1; else *argp = arg2;
                break;
            case calc_annualIRforloan:
                arg1 = [self doubleFromString:[self pop]]; // payment sum
                arg2 = [self doubleFromString:[self pop]]; // Number of payments pr year
                arg3 = [self doubleFromString:[self pop]]; // Number of months
                arg4 = [self doubleFromString:[self pop]]; // loan sum
                *argp = [self annuIRforloan:arg4 Months:arg3 Peryear:arg2 Payent:arg1];
                break;
            case calc_perimeterEllipse:
                arg1 = [self doubleFromString:[self pop]]; // payment sum
                arg2 = [self doubleFromString:[self pop]]; // Number of payments pr year
                *argp = [self calcEllipsePerimeterInfFormWith:arg1 hight:arg2 ];
                break;
            default:
                errorflag = YES;
                errormessage = [NSString stringWithFormat:@"Invalid calculation method for library function:%@, %ld", name, calcMethod]; 
                break;
        }
        
        ok=YES;
    }
    return ok;
}


- (NSString *) variableStringValue: (calcMemoryLocations)variable {
    double var; 
   // NSMutableString *var;
    
    
    switch (variable) {
        case memory_x:
            var = mem_x; 
            break;
        case memory_y:
            var = mem_y;
            break;
        case memory_z:
            var = mem_z;
            break;
        case memory_a:
            var = mem_a;
            break;
        case memory_b:
            var = mem_b;
            break;
        case memory_c:
            var = mem_c;
            break;
        case memory_d:
            var = mem_d;
            break;
        case memory_r:
            var = mem_r;
            break;
        case memory_h:
            var = mem_h;
            break;
        case memory_w:
            var = mem_w;
            break;
            
        default:
            var = 0.0;
            break;
    }
    return [self formatNumber:var];
}

- (NSString *) variableLabelValue: (calcMemoryLocations)variable {
    NSMutableString *var;
    
    
    switch (variable) {
        case memory_x:
            var = [NSMutableString stringWithFormat:@"(%@)", cLabel_x];
            break;
        case memory_y:
            var = [NSMutableString stringWithFormat:@"(%@)", cLabel_y];
            break;
        case memory_z:
            var = [NSMutableString stringWithFormat:@"(%@)", cLabel_z];
            break;
        case memory_a:
            var = [NSMutableString stringWithFormat:@"(%@)", cLabel_a];
            break;
        case memory_b:
            var = [NSMutableString stringWithFormat:@"(%@)", cLabel_b];
            break;
        case memory_c:
            var = [NSMutableString stringWithFormat:@"(%@)", cLabel_c];
            break;
        case memory_d:
            var = [NSMutableString stringWithFormat:@"(%@)", cLabel_d];
            break;
        case memory_r:
            var = [NSMutableString stringWithFormat:@"(%@)", cLabel_r];
            break;
        case memory_h:
            var = [NSMutableString stringWithFormat:@"(%@)", cLabel_h];
            break;
        case memory_w:
            var = [NSMutableString stringWithFormat:@"(%@)", cLabel_w];
            break;
            
        default:
            var = [NSMutableString stringWithString:@""];
            break;
    }
    if ([var isEqualToString:@"()"]) [var setString:@""];
    return var;
}


- (void) updateVariable:(calcMemoryLocations)variable {
    double value;
    if ([entry length]) {
        value = [self doubleFromString:entry];
    } else {
        if ([formula length]) {
            value = result;
        } else value=0.0; 
    }
    
    switch (variable) {
        case memory_x:
            mem_x = value; 
            break;
        case memory_y:
            mem_y = value;
            break;
        case memory_z:
            mem_z = value;
            break;
        case memory_a:
            mem_a = value;
            break;
        case memory_b:
            mem_b = value;
            break;
        case memory_c:
            mem_c = value;
            break;
        case memory_d:
            mem_d = value;
            break;
        case memory_r:
            mem_r = value;
            break;
        case memory_h:
            mem_h = value;
            break;
        case memory_w:
            mem_w = value;
            break;
            
        default:
            break;
    }
}

- (void) setVariableDoubleValue:(double)value varName:(calcMemoryLocations)variable {
    
    switch (variable) {
        case memory_x:
            mem_x = value;
            break;
        case memory_y:
            mem_y = value;
            break;
        case memory_z:
            mem_z = value;
            break;
        case memory_a:
            mem_a = value;
            break;
        case memory_b:
            mem_b = value;
            break;
        case memory_c:
            mem_c = value;
            break;
        case memory_d:
            mem_d = value;
            break;
        case memory_r:
            mem_r = value;
            break;
        case memory_h:
            mem_h = value;
            break;
        case memory_w:
            mem_w = value;
            break;
            
        default:
            break;
    }
}


- (void) setVariableValue:(NSString*)value varName:(calcMemoryLocations)variable {
    
    if ([self entry]) [self AddString:@"" WithOption:CalcTypeOperator]; // flush the entry so we dont calc on uncomplete formula.
    [self setVariableDoubleValue:[self doubleFromString:value] varName:variable];
}



- (void) save2memory{
    if ([entry length]) {
        memory = [self doubleFromString:entry];
    } else {
        if ([formula length]) {
            
            memory = result;
        }
    }
}
- (void) recallMemory{
    if (memory != 0.0) {
    if ([entry length]) {
        [formula appendString:entry];
        [entry setString:[self formatNumber:memory]]; 
        [formula appendString:@"*"];
    } else {
      [entry setString:[self formatNumber:memory]]; 
    }
    }
}
- (void) memoryAdd{
    if ([entry length]) {
        memory += [self doubleFromString:entry];
    } else {
        if ([formula length]) {
            memory += result;
        }
    }

}
- (void) memorySubtract{
    if ([entry length]) {
        memory -= [self doubleFromString:entry];
    } else {
        if ([formula length]) {
      
            memory -= result;
        }
    }
}

- (void) memoryClear{
    memory = 0.0;
}

- (id) getStatusLine {
    NSMutableString *statusl = [NSMutableString stringWithCapacity:100];
    [statusl setString:@""];
    if (memory != 0.0) {
        [statusl appendString:@" M="];
        [statusl appendString:[self formatNumber:memory]];
    }
    
    [statusl appendString:@" [Deg]"];

    return statusl;
}

- (id) getHelpInfoTitle {
    NSMutableString *statusl = [NSMutableString stringWithCapacity:100];
    [statusl setString:@""];
    if (doingMultiParEntry){
        NSInteger cnt = [multiparDescr count];
        if ((multiparIndex+1)<=cnt) {
            [statusl appendString:@"Enter "];
            [statusl appendString:[multiparDescr objectAtIndex:multiparIndex]];
            [statusl appendString:@", then press TAB"];
        }
    }

    return statusl;
}

- (id) getHelpInfoInfo {
    NSMutableString *statusl = [NSMutableString stringWithCapacity:100];
    [statusl setString:@""];
    if (doingMultiParEntry){
        [statusl setString:multiparHelpDesc];
        [statusl appendString:@"\n"];
        [statusl appendString:multiparfunc];
        [statusl appendString:@"( "];
        NSInteger cnt = [multiparDescr count];
        NSInteger i; 
        for ( i=1; i<=cnt;  i++) {
            [statusl appendString:[multiparDescr objectAtIndex:(i-1)]];
            if (i!=cnt)
            [statusl appendString:@"; "];
        }
        [statusl appendString:@") "];
    }
    return statusl;
}



- (double) memoryValue {
    return memory;
}

- (void) prepareFunction {
    char xx;
    if ([formula length]){
        xx = [formula characterAtIndex:([formula length]-1)];
    } else xx = 0;
    if (xx==')') [formula appendString:@"*"];
}


- (BOOL) StartLibFunction: (NSString*)str {
    BOOL ok=NO;
    CalcFunctions* fu=nil;
    NSInteger noPar;
    fu = [functionLib FindFunction:str];
    if (fu) {
        noPar = [[fu parameters] count];
        
        
        if (!doingMultiParEntry) { // ignore if currently doing one
            [self prepareFunction];
            multiparfunc = str;
            multiparCount = noPar;
            multiparDescr = [fu parameters];
            multiparHelpDesc = [fu description];
            doingMultiParEntry = YES;
            multiparIndex = 0;
            ok=YES;
       
            [formula appendString:str];
            [formula appendString:@"("];
            
            
            if ([entry length]) {
                [formula appendString:entry];
                
                multiparIndex = 1;
                if (multiparIndex == noPar) {
                    [formula appendString:@")"];
                    doingMultiParEntry = NO;
                }
                else [formula appendString:@";"];
                [entry setString:@""];
                
            }
        }
    }
    return ok;
}

- (void) multiparFunction: (NSString*)str {
    if ([self StartLibFunction:str]) {} // we did all this in the function. Just ignore the rest if found and OK.
    else if (!doingMultiParEntry) { // ignore if currently doing one
        multiparfunc = str;
       
        doingMultiParEntry = YES;
        BOOL didFindFunction = NO; 
        [self prepareFunction];
        
        
         if ([str isEqualToString:@"PaymentAnnuityLoan"]) {
            multiparCount = 4;
            multiparDescr = [NSArray arrayWithObjects:
                             @"loan sum",
                             @"number of months (12*Years)",
                             @"number of payments pr year",
                             @"annual interest rate",nil];
            multiparHelpDesc = @"Calculate fixed payments toward a loan";
            didFindFunction = YES; 

                    
        } else  if ([str isEqualToString:@"InterestPVFV"]) {
            // Interest = PV(1+k)^n
            multiparCount = 3;
            multiparDescr = [NSArray arrayWithObjects:
                             @"Present value",
                             @"Future Value",
                             @"Compounding periods (years)",nil];
            multiparHelpDesc = @"Calculate interest persentage";
            didFindFunction = YES; 
            
        } else  if ([str isEqualToString:@"FutureValueOfSavings"]) {
            // Future Value = PV(1+k)^n
            multiparCount = 5;
            multiparDescr = [NSArray arrayWithObjects:
                             @"Present value",
                             @"Periodical payment amount",
                             @"No of annual payments(12)",
                             @"No of years",
                             @"annual interest rate",nil];
            multiparHelpDesc = @"Calculate future value of savings";
            
            didFindFunction = YES;
        }

        
      
        else  if ([str isEqualToString:@"SavingsYearsToTarget"]) {
            // Interest Rate = Iterations
            multiparCount = 5;
            multiparDescr = [NSArray arrayWithObjects:
                             @"savings target",
                             @"Present Value",
                             @"Number of payments pr year",
                             @"payment sum",
                             @"annual interest rate",
                             nil];
            multiparHelpDesc = @"Calculate years needed for a savings target";
            
            didFindFunction = YES;
        }

        else  if ([str isEqualToString:@"PaymentSavings"]) {
            // Interest Rate = Iterations
            multiparCount = 4;
            multiparDescr = [NSArray arrayWithObjects:
                             @"Savings target",
                             @"Present Value",
                             @"number of months (12*Years)",
                             @"Number of payments pr year",
                             @"annual interest rate",
                             nil];
            multiparHelpDesc = @"Calculate payments needed for a savings target";
            didFindFunction = YES;
        }
        
        else  if ([str isEqualToString:@"InterestNeededForSavings"]) {
            // Interest Rate = Iterations
            multiparCount = 4;
            multiparDescr = [NSArray arrayWithObjects:
                             @"Savings target",
                             @"Present Value",
                             @"Number of payments pr year",
                             @"payment sum",
                             nil];
            multiparHelpDesc = @"Calculate years needed for a savings target";
            didFindFunction = YES;
        }

        
        
        
        
        
        
        if (didFindFunction) {
            [formula appendString:str];
            [formula appendString:@"("];
        }
        
        if ([entry length]) {
            [formula appendString:entry];
            [formula appendString:@";"];
            [entry setString:@""]; 
            multiparIndex = 1;
        } else multiparIndex = 0;
    }
}


- (void) AddString: (NSString*) str WithOption:(CalcFunctionType)opt {
    //[entry setString:@" "];
    char xx;
    
    switch (opt) {
        case CalcTypeOperator:
            // first check for +- in scientific number notation.
            if ([lastButtonStr isEqualToString:@"e"] && (lastFunctionType == CalcTypeNumber) &&
                ([str isEqualToString:@"+"] || [str isEqualToString:@"-"])) {
                [self.entry appendString:str];
            } else {
                
                if ([entry length]) {
                    [self.formula appendString:entry];
                    [ entry setString:@""];
                } else {
                    long lastpos = [formula length]-1;
                    if (lastpos>=0) {
                        NSSet *operators = [NSSet setWithObjects:@"+",@"-",@"*",@"/",@"^", nil];
                        NSString *last = [self.formula substringFromIndex:([formula length]-1)];
                        
                        // switch operator ?
                        if (([operators containsObject:last])
                            && ([operators containsObject:str])){
                            [formula deleteCharactersInRange:NSMakeRange(lastpos, 1)];
                        }
                    }
                }
                if ([formula length]) [self.formula appendString:str]; // ignore leading operators.
                else if ([str isEqualToString:@"-"])[self.formula appendString:str]; // leading "-" is OK.
            }

            break;
            
        case CalcTypeNumber:
            if (clearOnDataEntry)
            {
                [self.entry setString:@""];
                clearOnDataEntry = 0;
            }
            if ([str isEqualToString:@"."]){
                if (![entry length])[self.entry appendString:@"0"]; // avoid naked zeroes.
                [self.entry appendString:[nf decimalSeparator]];
            }
            else [self.entry appendString:str];
            if (lastFunctionType == CalcTypeConstant)[self.formula appendString:@"*"];
            break;
            
        case CalcTypeFunction:
            if (lastFunctionType == CalcTypeConstant)[self.formula appendString:@"*"];
            if ([entry length]) {
                [self.formula appendString:str];
                [self.formula appendString:@"("];
                [self.formula appendString:entry];
                [self.formula appendString:@")"];
                [ entry setString:@""];
            } else {
                [self.formula appendString:str];
                [self.formula appendString:@"("];
            }
            break;
            
        case CalcTypeChangeSign:
            if ([entry length]) {
                if ([self doubleFromString:entry]<0.0)
                    (void)[entry replaceOccurrencesOfString:@"-" withString:@"" options: NSLiteralSearch range:NSMakeRange(0, [entry length])];
                else
                    [entry insertString:@"-" atIndex:0];
            } else {
                [self.entry appendString:@"-"];
            }
            break;
            
        case CalcTypeEqualSign:
            if ([entry length]) {
                [self.formula appendString:entry];
            }
            [self.formula appendString:str];
            result = [ self evaluate];
            [entry setString:[self formatNumber:result]];
            
            clearOnDataEntry = 1;
            [self.formula appendString:entry];
            // [self.formula appendString:@"\n"];
            [self.history setString:formula];
            [self.wherehistory setString:[self WhereLine]];
            [self.formula deleteCharactersInRange:NSMakeRange(0, [formula length])];
            [arrUsedVariables removeAllObjects];
            break;
            
        case CalcTypeConstant:
            if (clearOnDataEntry)
            {
                [self.entry setString:@""];
                clearOnDataEntry = 0;
            } else if ([entry length]) {
                [self.formula appendString:entry];
                [self.formula appendString:@"*"];
            } else if (lastFunctionType == CalcTypeConstant)[self.formula appendString:@"*"];
            [self.formula appendString:str];
            [ entry setString:@""];
            break;
            
        case CalcTypeInsertOperator:
            [self.formula appendString:str];
            if ([entry length]) {
                [self.formula appendString:entry];
                [ entry setString:@""];
            }
            break;
            
        case CalcTypeLeftParenthesis:
             if ([entry length]) {
                [self.formula appendString:entry];
                [self.formula appendString:@"*("];
                [ entry setString:@""];
             } else {
                if ([formula length]){
                    char xx = [formula characterAtIndex:([formula length]-1)];
                    if ((xx == ')') ||
                        ((xx >= 'a') && (xx<= 'z')) ||
                        ((xx >= '0') && (xx<= '9')) ||
                        (xx == '.')
                        ){
                        [self.formula appendString:@"*"];
                    }
                } 
               [self.formula appendString:@"("];
            }
           
            break;
            
        case CalcTypeRightParenthesis:
            if ([entry length]) {
               [self.formula appendString:entry];
               [ entry setString:@""];
            }
            [self.formula appendString:str];
         
            break;
            
        case CalcTypeMultiParameterFunctionStart:
            [self multiparFunction:str];
            break;
            
        case CalcTypeMultiParameterFunctionNext:
           
            if (doingMultiParEntry) {
                xx = [formula characterAtIndex:([formula length]-1)];
                if ((xx==';') && (! [entry length])) {} // do nothing;
                else {
                    if ([entry length]) {
                        [self.formula appendString:entry];
                        [entry setString:@""];
                    }
                    if ((multiparIndex+1) == multiparCount) {
                        [self.formula appendString:@")"];
                        doingMultiParEntry = NO; // Complete
                    }
                    else {
                        [self.formula appendString:@";"];
                        multiparIndex ++;
                    }
                }
            } else {
                if ([entry length]) {
                    [self.formula appendString:entry];
                    [entry setString:@""];
                }
            }

            break;
            
        case CalcTypeArbitaryText:
            if ([entry length]) {
                [self.formula appendString:entry];
                [entry setString:@""];
            }
            [self.formula appendString:str];
            
            break;

            
            
            
            
        default:
            break;
    }
    lastButtonStr = str;
    lastFunctionType = opt;
    
}

- (void) ChangeFormula:(NSString*)str {
    formula = [NSString stringWithString:str];
}


- (void) clearAll {
    [self clearObjectData];
}

- (void) clearNumber {
    if ([entry length]) {
        [[self entry]setString:@""];
        result = 0.0;
    }
    else {
        if ([formula length] >0){
            BOOL ok=YES;
            [self tokenizeFormula];
            NSString *lastToken=[arrTokens lastObject]; 
            if ([lastToken isEqualToString:@";"]) {ok=NO; }
            
            if (ok) {
                [arrTokens removeLastObject];
                [self rebuildFormulaFromTokens];
            }
            
        }
    }
    
}

- (NSString *) getUsedFunctionDocumentation {
    NSMutableString * doc = [NSMutableString stringWithCapacity:100];
    NSArray *varnames = [NSArray arrayWithObjects:@"x", @"y", @"z", @"a", @"b", @"c", @"d", @"r", @"h", @"w", nil];
    NSString *name, *par;
    NSInteger cnt, noPar;
    CalcFunctions *fu; 
    if ([arrUsedFunctions count]) {
        [doc appendString:@"------------------\n"];
        [doc appendString:@"functions used in this formula\n"];
        [doc appendString:@"------------------\n"];
        for (name in arrUsedFunctions) {
            [doc appendString:name];
            [doc appendString:@"("];
            fu = [functionLib FindFunction:name];
            if (fu) {
                // first include the parameters in function call
                cnt = 0;
                noPar = [fu.parameters count];
                for (par in fu.parameters) {
                    if (cnt<10)
                        [doc appendString:[varnames objectAtIndex:cnt]];
                    cnt ++;
                    if (noPar != cnt) [doc appendString:@"; "];
                    else [doc appendString:@" ) - "];
                }
                [doc appendString:fu.description];
                
            [doc appendString:@"\nWhere \n"];
            cnt = 0;
            for (par in fu.parameters) {
                [doc appendString:@"    "];
                if (cnt<10)
                    [doc appendString:[varnames objectAtIndex:cnt]];
                [doc appendString:@" = "];
                [doc appendString:par];
                [doc appendString:@"\n"];
                cnt ++;
            }
            switch (fu.calcMethod) {
                case calc_UsingFormulas:
                    [doc appendString:@"Using the following formulas\n"];
                    noPar = [fu.formulas count];
                     cnt = 0;
                    for (par in fu.formulas) {
                        cnt ++;
                        [doc appendString:@"    "];
                        if (cnt == noPar) [doc appendString:@"result = "];
                        
                        [doc appendString:par];
                        [doc appendString:@"\n"];
                         
                    }
                    break;
                case calc_min:
                case calc_max:
                    [doc appendString:@"Using internal procedure returning max/min parameter\n"];
                    break;
                case calc_annualIRforloan:
                    [doc appendString:@"Formula is calculated used iteration of the standard annuity loan formula\n"];
                    break;
                case calc_perimeterEllipse:
                    [doc appendString:@"Using a infinite series method of calculating the perimeter\n"];
                    break;
                    
                default:
                    break;
            }
        
        
        
        
        
    } else [doc appendString:@" - no documentation found - ]\n"];
    [doc appendString:@"------------------\n"];
}




}
    
    return doc;
}

- (double) GetResult {
    if ([entry length]) result = [self doubleFromString:entry];
    else if ([formula length]) result = [self evaluate];
    return result;
}

- (id) GetFormula {
    return self.formula; 
}

- (NSString*) getCurrentFormula {
    if (![formula length])
    return self.history;
    else return self.formula;
    
}

- (void) SetCurrentFormula: (NSString*)str {
    [self.formula setString:str];
    if ([formula length])clearOnDataEntry=NO;
    [entry setString:@""];
}

- (NSString*) WhereLine {
    NSInteger cnt, i;
    double arg; 
    NSString *vars, *value, *label;
    NSMutableString *wline  = [NSMutableString stringWithString:@"Where "];
    cnt = [arrUsedVariables count];
     if (cnt) {
         i = 0;
         for (vars in arrUsedVariables) {
             i++;
        
             if ([vars isEqualToString:@"x"]) {value = [self variableStringValue: memory_x];
                                                label = [self variableLabelValue: memory_x];}
             else if ([vars isEqualToString:@"y"]) {value = [self variableStringValue: memory_y];
                 label = [self variableLabelValue: memory_y];}
             else if ([vars isEqualToString:@"z"]) {value = [self variableStringValue: memory_z];
                 label = [self variableLabelValue: memory_z];}
             else if ([vars isEqualToString:@"a"]) {value = [self variableStringValue: memory_a];
                 label = [self variableLabelValue: memory_a];}
             else if ([vars isEqualToString:@"b"]) {value = [self variableStringValue: memory_b];
                 label = [self variableLabelValue: memory_b];}
             else if ([vars isEqualToString:@"c"]) {value = [self variableStringValue: memory_c];
                 label = [self variableLabelValue: memory_c];}
             else if ([vars isEqualToString:@"d"]) {value = [self variableStringValue: memory_d];
                 label = [self variableLabelValue: memory_d];}
             else if ([vars isEqualToString:@"r"]) {value = [self variableStringValue: memory_r];
                 label = [self variableLabelValue: memory_r];}
             else if ([vars isEqualToString:@"h"]) {value = [self variableStringValue: memory_h];
                 label = [self variableLabelValue: memory_h];}
             else if ([vars isEqualToString:@"w"]) {value = [self variableStringValue: memory_w];
                 label = [self variableLabelValue: memory_w];}
             else if ([self isUserConstant:vars result:&arg]) {
                 value = [self formatNumber:arg];
                 label = @""; 
             }
             else value = @"";
             if (cnt!=i)[wline appendFormat:@"%@%@=%@, ", vars, label, value];
             else [wline appendFormat:@"%@%@=%@", vars, label, value];
             
             if ((i+1) == cnt) {[wline appendString:@" and "];}
         }
     } else wline = [NSMutableString stringWithString:@""];
    return wline; 
}


- (id) GetFormulaHistory {
    NSMutableString *form;
    NSInteger cnt;
    form = [NSMutableString stringWithCapacity:100];
    [form setString:formula];
    if ([entry length]) {
        if (clearOnDataEntry){
           
            [form appendString:entry];
             [form appendString:@" _?"];
        } else {
            [form appendString:entry];
            [form appendString:@"_"];
        }
    }
    cnt = [arrUsedVariables count]; 
    if (cnt) {
        [form appendString:@"\n"];
        if (! [entry length])[form appendFormat:@"=>%@, ", [self formatNumber:result]];
        [form appendString:[self WhereLine]];
    }
    
    if ([history length]) {
        [form appendString:@"\n"];
        [form appendString:history];
        [form appendString:@"\n"];
        [form appendString:wherehistory];
    }
    return form; 
}

- (id) Token {
    NSUInteger cnt;
    cnt = [arrTokens count];
    

    int fail = 1;
    if (! cnt) fail = 1;
    else if (tokidx <0) fail = 2;
    else if (tokidx >= cnt) fail = 3;
    else fail = 0;
    
    if (fail) {
        return nil;
    }
    else
    {
        tokidx++;
        return [arrTokens objectAtIndex: (tokidx-1)];
    }
}

- (void) push: (NSString *)obj {
   // NSLog(@"Push %@", obj);
    if (obj)
        [valuestack addObject:obj];
    else [valuestack addObject:@"nil"];
}

- (NSString*) pop {
    NSString *obj;
    obj = [valuestack lastObject];
  //  NSLog(@"Pop %@", obj);
    if (obj) {
         [valuestack removeLastObject];
        if ([obj isEqualToString:@"nil"]) return nil;
        else  return obj;
    } else return nil;
}


- (int) iFuncPriority: (NSString*) ifunc {
    int pri ;
    if ([ifunc length]==0) pri=0;
    else if ([ifunc isEqualToString:@"+"]) pri=2;
    else if ([ifunc isEqualToString:@"-"]) pri = 2;
    else if ([ifunc isEqualToString:@"*"]) pri = 3;
    else if ([ifunc isEqualToString:@"/"]) pri = 3;
    else if ([ifunc isEqualToString:@"^"]) pri = 4;
    else if ([ifunc isEqualToString:@"%^"]) pri = 4;
    else if ([ifunc isEqualToString:@";"]) pri = 1; // parameter separator,
    else if ([ifunc isEqualToString:@")"]) pri = 0; // Closing parenthesis,
    else if ([ifunc isEqualToString:@"="]) pri = 0; // Closing parenthesis,
    else {
        pri=0;
        errorflag = YES;
        errormessage = [NSString stringWithFormat:@"Error: Unknown operator: '%@'", ifunc];
    }

    return pri;
}

- (void) doCalc: (NSString*)ifunc {
    double val1;
    double val2;
  //  NSLog (@"doCalc :-) %@", ifunc);
    if (![ifunc isEqualToString:@";"]) { // do nothing in the case of parameter collection
        val2 = [self doubleFromString:[self pop]];
        val1 = [self doubleFromString:[self pop]];
    
        if ([ifunc isEqualToString:@"+"]) val1 = val1+val2; 
        else if ([ifunc isEqualToString:@"-"]) val1 = val1-val2;
        else if ([ifunc isEqualToString:@"*"]) val1 = val1*val2;
        else if ([ifunc isEqualToString:@"/"]) if (val2==0.0) {
            val1=0.0;
            errorflag = YES;
            errormessage = @"Divide by zero error"; 
        } else val1 = val1 / val2;
        else if ([ifunc isEqualToString:@"^"]) val1 = pow(val1,val2);
        else if ([ifunc isEqualToString:@"%^"]) {
            val1 = val1 / (double)100.0;
            val1 = pow(val1,val2);}
        [self push:[NSString stringWithString: [self formatNumber:val1]]];
    }
}


- (double) CalcAnnuityForloan:(double)loan months:(double)mnt pmtPrYear:(double)noPmtYear annualIR:(double)ir {
    double arg; 
    
    if (ir==0.0) {
        arg = loan / mnt * 12/noPmtYear;
    } else {
        double noPeriods = mnt/12.0*noPmtYear;
        double interestPrPeriod = (ir/noPmtYear/100);
        arg = loan *  interestPrPeriod / (1- pow(1+interestPrPeriod, -noPeriods));
    }

    return arg; 
}

- (double) calcEllipsePerimeterInfFormWith: (double )w hight: (double)h {
    double infFact1, inFfact2, arg = 0 ; 
    double a = w/2.0;
    double b = h/2.0;
    double perimeter; 
    double counter;
    double x = pow(a-b, 2) / pow(a+b, 2);
    infFact1 = 4.0;
    arg =  (1/infFact1)*x+1;
    inFfact2 = 64.0;
    arg =  arg + (1/inFfact2)*pow(x,2);
    counter = 3.0;
    while (counter < 200) {
        infFact1 = infFact1 * inFfact2; 
        arg =  arg + ((1/infFact1)*pow(x, counter));
        counter = counter + 1;
        inFfact2 = infFact1;
    }
    perimeter = M_PI * (a+b) * arg;
    return perimeter;
}



- (double) dabsolute:(double)x {
    if (x<0)return -x;
    else return x; 
}

- (double) annuIRforloan: (double) loanSum Months: (double)Mnts Peryear:(double)PmntYear Payent:(double)pmtSum{
    double arg;
    double oldint, newint, testint;
    errorflag = NO; 
    NSInteger maxiter = 200; // far less should do, 
    // where do we go with zero interest.
    double r_0ir = [self CalcAnnuityForloan:loanSum months:Mnts pmtPrYear:PmntYear annualIR:0.0];
    if (pmtSum==r_0ir) arg=0.0; // the rare case of no interest.
    else if (pmtSum<r_0ir) { // the even rarer case of negative interest.
        newint = 0;
        testint = newint;
        double r_oldint = [self CalcAnnuityForloan:loanSum months:Mnts pmtPrYear:PmntYear annualIR:testint];
        if (pmtSum<r_oldint) { // We know its less than 0 and greather than -100.
            oldint = -100.0;
            while ([self dabsolute:(pmtSum-r_oldint)]>0.1) {
                testint = oldint + (newint- oldint)/2;
                r_oldint = [self CalcAnnuityForloan:loanSum months:Mnts pmtPrYear:PmntYear annualIR:testint];
                if (r_oldint < pmtSum) oldint = testint; // we pay more, higher interest.
                else newint = testint; // or less
                maxiter --;
                if (maxiter == 0) {
                    r_oldint = pmtSum; // get us out of here.
                    errorflag = YES;
                }
            }
            // testint is the winner.
            arg = testint;
        } else {
            errorflag = YES;
            arg = 0;
        }
        
        
    } else { // the regular case, should do.
        // lets try a huge interest, and see how it works out.
        newint = 100.0;
        testint = newint;
        double r_oldint = [self CalcAnnuityForloan:loanSum months:Mnts pmtPrYear:PmntYear annualIR:testint];
        if (pmtSum<r_oldint) { // We know its less than 100 and greather than zero.
            oldint = 0;
            while ([self dabsolute:(pmtSum-r_oldint)]>0.1) {
                testint = oldint + (newint - oldint)/2;
                r_oldint = [self CalcAnnuityForloan:loanSum months:Mnts pmtPrYear:PmntYear annualIR:testint];
                if (r_oldint < pmtSum) oldint = testint; // we pay more, higher interest.
                else newint = testint; // or less
                 maxiter --;
                if (maxiter == 0) {
                    r_oldint = pmtSum; // get us out of here.
                    errorflag = YES;
                }
            }
            // testint is the winner.
            arg = testint;
        } else {
            errorflag = YES;
            arg = 0;
        }
    }
    if (errorflag) errormessage = @"Could not solve the function, look at the parameters";
    return arg; 
}


- (double) yearsForSavings: (double) target PresentValue: (double)PV  Peryear:(double)PmntprYear Payent:(double)pmtSum AnnualInterest:(double) annint {
    double arg = 0.0;
    
    double CurrentValue = PV;
    double periodinterest = annint/PmntprYear/100;
    double interestvalue;
    NSInteger cnt=0;
    errorflag = NO;
    if ((target>0) && (PV<0))errorflag=YES; // bank uses different interest for overdrawn and regular deposit. Cant solve function.
    
    if (pmtSum < 0) errorflag=YES;
    if (! errorflag) {
        while (CurrentValue<target) {
            
            interestvalue = CurrentValue*periodinterest;
            CurrentValue=CurrentValue+interestvalue+pmtSum;
            cnt++;
            
        }
        
        arg = cnt;
        double lastperiod = (pmtSum - (CurrentValue-target))/pmtSum;
        arg = arg -1 + lastperiod;
        arg = arg / PmntprYear;
    }
    
    
    if (errorflag) errormessage = @"Could not solve the function, look at the parameters";
    return arg;
}
- (void) addToWhere:(NSString *)str {
    // find out if it is allready there.
    NSInteger cnt = [arrUsedVariables count];
    NSString *instance;
    BOOL allreadythere = NO;
    if (cnt) {
        for (instance in arrUsedVariables) {
            if ([instance isEqualToString:str]) allreadythere = YES;
        }
        
    } else allreadythere = NO;
    
    if (! allreadythere) [arrUsedVariables addObject:str];
}

- (void) addToUsedFunctins:(NSString *)str {
    // find out if it is allready there.
    NSInteger cnt = [arrUsedFunctions count];
    NSString *instance;
    BOOL allreadythere = NO;
    if (cnt) {
        for (instance in arrUsedFunctions) {
            if ([instance isEqualToString:str]) allreadythere = YES;
        }
        
    } else allreadythere = NO;
    
    if (! allreadythere) [arrUsedFunctions addObject:str];
}


- (BOOL) doFunctionWithCalc2: (NSString *)xtok {
    NSSet *functionsCalc2 = [NSSet setWithObjects:@"pyth",nil];
    double arg;
    BOOL complete = YES;
    
    if ([functionsCalc2 containsObject:xtok]) {
        (void) [ self Token]; // function shold have ( - remove this
        [self doEvaluate]; // argument on top of stack after this
    
        if ([xtok isEqualToString: @"pyth"])
            arg = [self calcWithCalc2FromStack:@"sqrt(x^2+y^2)=" noOfPars:2];
  /*      if ([xtok isEqualToString: @"YearAnnuityLoan"])
            complete = [self calcWithCalc2UsingName:xtok resulting:&arg];*/
        
            else {
            complete = NO;
            errorflag = YES;
            errormessage = [NSString stringWithFormat:@"SE; calc2 function not found: %@", xtok];
        }
        if (complete) [self push:[NSString stringWithString:[self formatNumber:arg]]];
    } else complete = NO; 
    return complete; 
}

- (BOOL) iConstVar:(NSString*)xtok {
    NSSet *constset = [NSSet setWithObjects:@"x",@"y",@"z",@"a",@"b",@"c",@"d",@"r",@"h",@"w",@"e",@"pi", nil];
    BOOL complete = YES; 
    if ([constset containsObject: xtok]) {
    
        if ([xtok isEqualToString: @"pi"]) {
            [self push:[NSString stringWithString:[self formatNumber:M_PI]]];
        } else if ([xtok isEqualToString: @"e"]) {
            [self push:[NSString stringWithString:[self formatNumber:M_E]]];
        } else if ([xtok isEqualToString: @"x"]) {
            [self push:[NSString stringWithString:[self formatNumber:mem_x]]];
            [self addToWhere:xtok];
        } else if ([xtok isEqualToString: @"y"]) {
            [self push:[NSString stringWithString:[self formatNumber:mem_y]]];
            [ self addToWhere:xtok];
        } else if ([xtok isEqualToString: @"z"]) {
            [self push:[NSString stringWithString:[self formatNumber:mem_z]]];
            [ self addToWhere:xtok];
        } else if ([xtok isEqualToString: @"a"]) {
            [self push:[NSString stringWithString:[self formatNumber:mem_a]]];
            [ self addToWhere:xtok];
        } else if ([xtok isEqualToString: @"b"]) {
            [self push:[NSString stringWithString:[self formatNumber:mem_b]]];
            [ self addToWhere:xtok];
        } else if ([xtok isEqualToString: @"c"]) {
            [self push:[NSString stringWithString:[self formatNumber:mem_c]]];
            [ self addToWhere:xtok];
        } else if ([xtok isEqualToString: @"d"]) {
            [self push:[NSString stringWithString:[self formatNumber:mem_d]]];
            [ self addToWhere:xtok];
        } else if ([xtok isEqualToString: @"r"]) {
            [self push:[NSString stringWithString:[self formatNumber:mem_r]]];
            [ self addToWhere:xtok];
        } else if ([xtok isEqualToString: @"h"]) {
            [self push:[NSString stringWithString:[self formatNumber:mem_h]]];
            [ self addToWhere:xtok];
        } else if ([xtok isEqualToString: @"w"]) {
            [self push:[NSString stringWithString:[self formatNumber:mem_w]]];
            [ self addToWhere:xtok];
        } else {
            complete = NO;
            errorflag = YES;
            errormessage = [NSString stringWithFormat:@"SE; const/var not found: %@", xtok];
        }

    
    } else complete = NO;
    return complete;
}

- (BOOL) iStdMathFunctions:(NSString*)xtok {
    NSSet *constset = [NSSet setWithObjects:@"sin",@"cos",@"tan", @"sqrt",@"log",@"ln",@"sinh",@"cosh",@"tanh", @"fact",
                       @"cbrt",@"arcsin",@"arccos",@"arctan",@"arcsinh",@"arctanh",@"abs", @"deg", @"rad", nil];
    NSSet *noNegArg = [NSSet setWithObjects:@"sqrt",@"log",@"ln",nil];
    
    BOOL complete = YES;
    long long nn;
    long long i;
    double arg = 0.0 ;
    if ([constset containsObject: xtok]) {
        (void) [ self Token]; // function shold have ( - remove this
        [self doEvaluate]; // argument on top of stack after this
        arg = [self doubleFromString:[self pop]];
        if ([noNegArg containsObject: xtok]) {
            if (arg<0) {
                errorflag = YES;
                errormessage =[NSString stringWithFormat:@"Negative argument to '%@', %@", xtok, [self formatNumber:arg]];
            }
        }
        if (errorflag) {}
        else if ([xtok isEqualToString: @"sqrt"])
            [self push:[NSString stringWithString:[self formatNumber:sqrt(arg)]]];
        else if ([xtok isEqualToString: @"cbrt"])
            [self push:[NSString stringWithString:[self formatNumber:cbrt(arg)]]];
        else if ([xtok isEqualToString: @"log"])
            [self push:[NSString stringWithString:[self formatNumber:log10(arg)]]];
        else if ([xtok isEqualToString: @"ln"])
            [self push:[NSString stringWithString:[self formatNumber:log(arg)]]];
        else if ([xtok isEqualToString: @"sin"])
            [self push:[NSString stringWithString:[self formatNumber:sin(arg* M_PI/180)]]];
        else if ([xtok isEqualToString: @"cos"])
            [self push:[NSString stringWithString:[self formatNumber:cos(arg* M_PI/180)]]];
        else if ([xtok isEqualToString: @"tan"])
            [self push:[NSString stringWithString:[self formatNumber:tan(arg* M_PI/180)]]];
        else if ([xtok isEqualToString: @"sinh"])
            [self push:[NSString stringWithString:[self formatNumber:sinh(arg)]]];
        else if ([xtok isEqualToString: @"cosh"])
            [self push:[NSString stringWithString:[self formatNumber:cosh(arg)]]];
        else if ([xtok isEqualToString: @"tanh"])
            [self push:[NSString stringWithString:[self formatNumber:tanh(arg)]]];        
        else if ([xtok isEqualToString: @"arcsin"])
            [self push:[NSString stringWithString:[self formatNumber:(asin(arg)*180/ M_PI)]]];
        else if ([xtok isEqualToString: @"arccos"])
            [self push:[NSString stringWithString:[self formatNumber:(acos(arg)*180/ M_PI)]]];
        else if ([xtok isEqualToString: @"arctan"])
            [self push:[NSString stringWithString:[self formatNumber:(atan(arg)*180/ M_PI)]]];
        else if ([xtok isEqualToString: @"arcsinh"])
            [self push:[NSString stringWithString:[self formatNumber:asinh(arg)]]];
        else if ([xtok isEqualToString: @"arccosh"])
            [self push:[NSString stringWithString:[self formatNumber:acosh(arg)]]];
        else if ([xtok isEqualToString: @"arctanh"])
            [self push:[NSString stringWithString:[self formatNumber:atanh(arg)]]];
        else if ([xtok isEqualToString: @"deg"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*180/M_PI)]]];
        else if ([xtok isEqualToString: @"rad"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*M_PI/180)]]];
        else if ([xtok isEqualToString: @"fact"]) {// factorial
            double nres = 1;
            nn=arg;
            for (i=2; i<=nn; i++) nres *= i;
            arg = nres;
            [self push:[NSString stringWithString:[self formatNumber:arg]]];
        } else if ([xtok isEqualToString: @"abs"]) {// factorial
            if (arg<0) arg=(-arg);
            [self push:[NSString stringWithString:[self formatNumber:arg]]];
         } else {
            complete = NO;
            errorflag = YES;
            errormessage = [NSString stringWithFormat:@"SE; math function not found: %@", xtok];
        }
 
    } else complete = NO;
    return complete;
}

- (BOOL) iConversionFunctions:(NSString*)xtok {
    NSSet *constset = [NSSet setWithObjects:@"cm2in", @"in2cm", 
                       @"chain2m", @"fathom2m", @"furlong2m", @"leage2m", @"lighty2m",@"m2chain", @"m2fathom", @"m2furlong",
                       @"m2leage", @"m2lighty",@"angstrom2m", @"au2m", @"m2angstrom", @"m2au",
                       @"fldr2ml", @"floz2l",@"UKfloz2l", @"gal2l", @"UKgal2l", @"gill2l", @"USdryPk2l", @"pt2l",
                       @"UKpt2l", @"USdryPt2l", @"qt2l", @"UKqt2l", @"USdryQt2l", @"ml2fldr", @"l2floz", @"l2UKfloz",
                       @"l2gal", @"l2UKgal", @"l2gill", @"l2USdryPk", @"l2pt", @"l2UKpt", @"l2USdryPt", @"l2qt",
                       @"l2UKqt", @"l2USdryQt",
                       @"c2f", @"f2c",@"c2k", @"f2k", @"k2c", @"k2f",
                       
                       @"amu2g", @"carat2g", @"cental2kg", @"dram2g", @"grain2g", @"hundredwt2kg",
                       @"N2kg", @"oz2g", @"dwt2g", @"lb2kg", @"quarter2kg", @"stone2kg", @"troyOz2g",
                       @"g2amu", @"g2carat", @"kg2cental", @"g2dram", @"g2grain", @"kg2hundredwt",
                       @"kg2N", @"g2oz", @"g2dwt", @"kg2lb", @"kg2quarter", @"kg2stone", @"g2troyoz", 
                       
                       nil];
    BOOL complete = YES;
    if ([constset containsObject: xtok]) {
        (void) [ self Token]; // function shold have ( - remove this
        [self doEvaluate]; // argument on top of stack after this
        double arg = [self doubleFromString:[self pop]];
        if ([xtok isEqualToString: @"in2cm"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*2.54)]]];
        else if ([xtok isEqualToString: @"cm2in"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/2.54)]]];
       
        else if ([xtok isEqualToString: @"chain2m"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*20.1168)]]];
        else if ([xtok isEqualToString: @"fathom2m"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*1.8288)]]];
        else if ([xtok isEqualToString: @"furlong2m"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*201.168)]]];
        else if ([xtok isEqualToString: @"leage2m"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*4828.032)]]];
        else if ([xtok isEqualToString: @"lighty2m"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*9460730472581000.0)]]];
        else if ([xtok isEqualToString: @"m2chain"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/20.1168)]]];
        else if ([xtok isEqualToString: @"m2fathom"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/1.8288)]]];
        else if ([xtok isEqualToString: @"m2furlong"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/201.168)]]];
        else if ([xtok isEqualToString: @"m2leage"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/4828.032)]]];
        else if ([xtok isEqualToString: @"m2lighty"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/9460730472581000.0)]]];
        else if ([xtok isEqualToString: @"angstrom2m"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*1.0E-10)]]];
        else if ([xtok isEqualToString: @"m2angstrom"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/1.0E-10)]]];
        else if ([xtok isEqualToString: @"au2m"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*149597870700.0)]]];
        else if ([xtok isEqualToString: @"m2au"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/149597870700.0)]]];
        
        
        else if ([xtok isEqualToString: @"fldr2ml"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*3.696691195313)]]];
        else if ([xtok isEqualToString: @"floz2l"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*0.0295735295625)]]];
        else if ([xtok isEqualToString: @"UKfloz2l"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*0.0284130625)]]];
        else if ([xtok isEqualToString: @"gal2l"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*3.785411784)]]];
        else if ([xtok isEqualToString: @"UKgal2l"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*4.54609)]]];
        else if ([xtok isEqualToString: @"gill2l"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*0.11829411825)]]];
        else if ([xtok isEqualToString: @"USdryPk2l"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*8.80976754172)]]];
        else if ([xtok isEqualToString: @"pt2l"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*0.473176473)]]];
        else if ([xtok isEqualToString: @"UKpt2l"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*0.56826125)]]];
        else if ([xtok isEqualToString: @"USdryPt2l"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*0.5506104713575)]]];
        else if ([xtok isEqualToString: @"qt2l"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*0.946352946)]]];
        else if ([xtok isEqualToString: @"UKqt2l"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*1.1365225)]]];
        else if ([xtok isEqualToString: @"USdryQt2l"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*1.101220942715)]]];
        
        else if ([xtok isEqualToString: @"ml2fldr"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/3.696691195313)]]];
        else if ([xtok isEqualToString: @"l2floz"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/0.0295735295625)]]];
        else if ([xtok isEqualToString: @"l2UKfloz"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/0.0284130625)]]];
        else if ([xtok isEqualToString: @"l2gal"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/3.785411784)]]];
        else if ([xtok isEqualToString: @"l2UKgal"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/4.54609)]]];
        else if ([xtok isEqualToString: @"l2gill"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/0.11829411825)]]];
        else if ([xtok isEqualToString: @"l2USdryPk"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/8.80976754172)]]];
        else if ([xtok isEqualToString: @"l2pt"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/0.473176473)]]];
        else if ([xtok isEqualToString: @"l2UKpt"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/0.56826125)]]];
        else if ([xtok isEqualToString: @"l2USdryPt"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/0.5506104713575)]]];
        else if ([xtok isEqualToString: @"l2qt"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/0.946352946)]]];
        else if ([xtok isEqualToString: @"l2UKqt"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/1.1365225)]]];
        else if ([xtok isEqualToString: @"l2USdryQt"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/1.101220942715)]]];
        
        
        else if ([xtok isEqualToString: @"c2f"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*9/5+32)]]];
        else if ([xtok isEqualToString: @"f2c"])
            [self push:[NSString stringWithString:[self formatNumber:((arg-32)*5/9)]]];
        else if ([xtok isEqualToString: @"c2k"])
            [self push:[NSString stringWithString:[self formatNumber:(arg+273.15)]]];
        else if ([xtok isEqualToString: @"f2k"])
            [self push:[NSString stringWithString:[self formatNumber:((arg+459.67)*5.0/9.0)]]];
        else if ([xtok isEqualToString: @"k2c"])
            [self push:[NSString stringWithString:[self formatNumber:(arg-273.15)]]];
        else if ([xtok isEqualToString: @"k2f"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*9.0/5.0-459.67)]]];
        
        
        else if ([xtok isEqualToString: @"amu2g"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*1.6605402E-24)]]];
        else if ([xtok isEqualToString: @"carat2g"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/5.0)]]];
        else if ([xtok isEqualToString: @"cental2kg"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*45.359237)]]];
        else if ([xtok isEqualToString: @"dram2g"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*1.771845195312)]]];
        else if ([xtok isEqualToString: @"grain2g"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*0.06479891)]]];
        else if ([xtok isEqualToString: @"hundredwt2kg"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*50.80234544)]]];
        else if ([xtok isEqualToString: @"N2kg"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*0.1019716212978)]]];
        else if ([xtok isEqualToString: @"oz2g"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*28.349523125)]]];
        else if ([xtok isEqualToString: @"dwt2g"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*1.55517384)]]];
        else if ([xtok isEqualToString: @"lb2kg"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*0.45359237)]]];
        else if ([xtok isEqualToString: @"quarter2kg"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*12.70058636)]]];
        else if ([xtok isEqualToString: @"stone2kg"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*6.35029318)]]];
        else if ([xtok isEqualToString: @"troyOz2g"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*31.1034768)]]];
        else if ([xtok isEqualToString: @"g2amu"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/1.6605402E-24)]]];
        else if ([xtok isEqualToString: @"g2carat"])
            [self push:[NSString stringWithString:[self formatNumber:(arg*5.0)]]];
        else if ([xtok isEqualToString: @"kg2cental"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/45.359237)]]];
        else if ([xtok isEqualToString: @"g2dram"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/1.771845195312)]]];
        else if ([xtok isEqualToString: @"g2grain"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/0.06479891)]]];
        else if ([xtok isEqualToString: @"kg2hundredwt"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/50.80234544)]]];
        else if ([xtok isEqualToString: @"kg2N"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/0.1019716212978)]]];
        else if ([xtok isEqualToString: @"g2oz"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/28.349523125)]]];
        else if ([xtok isEqualToString: @"g2dwt"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/1.55517384)]]];
        else if ([xtok isEqualToString: @"kg2lb"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/0.45359237)]]];
        else if ([xtok isEqualToString: @"kg2quarter"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/12.70058636)]]];
        else if ([xtok isEqualToString: @"kg2stone"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/6.35029318)]]];
        else if ([xtok isEqualToString: @"g2troyoz"])
            [self push:[NSString stringWithString:[self formatNumber:(arg/31.1034768)]]];
       
        
        
        
        
        
        else {
            complete = NO;
            errorflag = YES;
            errormessage = [NSString stringWithFormat:@"SE; Converter not found: %@", xtok];
        }

    } else complete = NO;
    return complete;
}


- (BOOL) iFinanceFunctions:(NSString*)xtok {
    NSSet *constset = [NSSet setWithObjects:@"PaymentAnnuityLoan", nil];
    BOOL complete = YES;
    double arg; 
    if ([constset containsObject: xtok]) {
        (void) [ self Token]; // function shold have ( - remove this
        [self doEvaluate]; // argument on top of stack after this
        arg = [self doubleFromString:[self pop]];
        if ([xtok isEqualToString: @"PaymentAnnuityLoan"]){
            double paymentsPrYear = [self doubleFromString:[self pop]];
            double months = [self doubleFromString:[self pop]];
            double loan = [self doubleFromString:[self pop]];
            double interest = arg;
            
            arg = [self CalcAnnuityForloan:loan months:months pmtPrYear:paymentsPrYear annualIR:interest];
        }
       else {
            complete = NO;
            errorflag = YES;
            errormessage = [NSString stringWithFormat:@"SE; Finance function not found: %@", xtok];
        }
    } else complete = NO;
    if (complete) [self push:[NSString stringWithString:[self formatNumber:arg]]];
    
    return complete;
}

- (BOOL) iDerivative: (NSString*)xtok  {
 //   NSLog (@"iDerivative: %@", xtok);
    calcMemoryLocations var;
    double varValue;
    NSSet *constset = [NSSet setWithObjects:@"ddx", @"ddy", @"ddz", @"dda",@"ddb", @"ddc", @"ddd", @"ddr",@"ddh",@"ddw", nil];
    BOOL complete = NO;
    long double d1, d2, dx, dx2, arg, factor;
    double c1, c2;
    if ([constset containsObject: xtok]) {
        derivativeLevel++;
        BOOL complete = YES;
        if ([xtok isEqualToString: @"ddx"]){
            var = memory_x;
            varValue = mem_x;
        } else if ([xtok isEqualToString: @"ddy"]){
            var = memory_y;
            varValue = mem_y;
        } else if ([xtok isEqualToString: @"ddz"]){
            var = memory_z;
            varValue = mem_z;
        } else if ([xtok isEqualToString: @"dda"]){
            var = memory_a;
            varValue = mem_a;
        } else if ([xtok isEqualToString: @"ddb"]){
            var = memory_b;
            varValue = mem_b;
        } else if ([xtok isEqualToString: @"ddc"]){
            var = memory_c;
            varValue = mem_c;
        } else if ([xtok isEqualToString: @"ddd"]){
            var = memory_d;
            varValue = mem_d;
        } else if ([xtok isEqualToString: @"ddr"]){
            var = memory_r;
            varValue = mem_r;
        } else if ([xtok isEqualToString: @"ddh"]){
            var = memory_h;
            varValue = mem_h;
        } else if ([xtok isEqualToString: @"ddw"]){
            var = memory_w;
            varValue = mem_w;
        } else complete = NO;
        
        if (complete) {
            
            (void) [ self Token]; // function shold have ( - remove this
            int d_tokidx = tokidx;
            if (derivativeLevel ==1) factor = 5.0E-7;
            else if (derivativeLevel ==2) factor = 1.0E-7;
            else factor = 5.0E-8;
            dx = varValue*factor;
            dx2 = dx + dx;
            c1 = varValue-dx;
            c2 = varValue+dx;
            [self setVariableDoubleValue: c1 varName:var];
            [self doEvaluate]; // argument on top of stack after this
            d1 = [self doubleFromString:[self pop]];
            
            [self setVariableDoubleValue: c2 varName:var];
            
            tokidx = d_tokidx; // redo the function with applied diff.
            [self doEvaluate]; // argument on top of stack after this
            d2 = [self doubleFromString:[self pop]];
            
            arg = (d2-d1)/(dx2); // calculate the derivative;
            [nf setMaximumSignificantDigits:7];
            [self push:[NSString stringWithString:[self formatNumber:arg]]];
            [nf setMaximumSignificantDigits:18];
            // restore old varvalue;
            [self setVariableDoubleValue: (varValue) varName:var];
            
        }
        derivativeLevel--;
    }
    return complete; 
}


- (BOOL) iFactor {
  
    BOOL negate = NO;
    BOOL complete = YES;
    double arg; 
    NSString *xtok = [ self Token];
    NSSet *numbers = [NSSet setWithObjects:@"-",@".",@",", nil];
    
    if (xtok) { // ignore if no more tokens
 //       NSLog(@"iFactor: %@", xtok);

        if ([xtok isEqualToString:@"-"]) { // we have a "-" in front of the formula !
            negate = YES;
            xtok = [ self Token];
        }
    }
    if (xtok) { // ignore if no more tokens
        long len = [xtok length];
        if (len> 0) {
            NSString *firstchar = [xtok substringToIndex:1];
        //    NSLog(@"firstchar = ('%@')", firstchar);
            
            const char *cfirstchar = [firstchar UTF8String];
            char  ch = cfirstchar[0];
            
            if (((ch<='9') && (ch>='0')) || ([numbers containsObject:firstchar])) {
            // We have a number
                [ self push: xtok];
            } else if ([firstchar isEqualToString:@"("]){
                [self doEvaluate];
            } else if ([self iConstVar:xtok]) {
                // we did complete constant.
            } else if ([self iStdMathFunctions:xtok]) {
                // we did complete with standard math.
            } else if ([self iDerivative:xtok]) {
                // we did complete with standard math.
            } else if ([self calcWithCalc2UsingName:xtok resulting:&arg]) {
                [self push:[NSString stringWithString:[self formatNumber:arg]]];
                // We did function with the function library
            } else if ([self isUserConstant:xtok result:&arg ]) {
                [self push:[NSString stringWithString:[self formatNumber:arg]]];
                // user constant. 
            } else if ([self iConversionFunctions:xtok]) {
                // we did complete with Conversion functions.
            } else if ([self iFinanceFunctions:xtok]) {
                // we did complete with Finance functions.
            }  else {
                complete=NO;
                errorflag = YES;
                errormessage = [NSString stringWithFormat:@"Error: Not identified token '%@'", xtok];
            }
        } else complete = NO;
    } else complete=NO;
    if ((complete) && (negate)) {
        arg = [self doubleFromString:[self pop]];
        [self push:[NSString stringWithString:[self formatNumber:(-arg)]]];
    }
    
//    NSLog(@"-end iFactor");
    return complete;
}

- (NSString*) doExecute: (NSString*)xFunc {
    NSString *ifunc, *ifunc1;
    int pri1=0;
    int pri2=200;
 //     NSLog(@"-doExecute %@",xFunc);
    ifunc1 = [NSString stringWithString:xFunc];
    do {
        pri1 = [self iFuncPriority:ifunc1];
        if (pri1) {
        
            if ([self iFactor]) {
                ifunc = [self Token];
                pri2 = [self iFuncPriority:ifunc];
                while (pri2>pri1) {
                    ifunc = [self doExecute:ifunc];
                    pri2 = [self iFuncPriority:ifunc];
                }
                
                [self doCalc: ifunc1];
            } else {
                ifunc = nil;
                pri1 = pri2+1; // get us out of here .....
            }
        }
        if (pri1==pri2) {
            ifunc1 = ifunc; 
        }
    } while (pri1 == pri2);
//    NSLog(@"-end doExecute, returning %@",ifunc);
    return ifunc;
}


- (void) doEvaluate {
    
    NSString *ifunc ;
    BOOL finished = NO; 
    if ([self iFactor]) {
        ifunc = [self Token];
         if ( ! ifunc) finished = YES; 
        else if ([ifunc isEqualToString:@")"]) finished = YES; // evaluation of inner paranthesis complete.
    } else finished = YES; 
    while (! finished) {
    //    NSLog(@"doEvaluate loop, %@", ifunc);
        ifunc =  [self doExecute: ifunc ];
        if (!ifunc) finished = YES; 
        else if ([ifunc isEqualToString:@")"] ) finished = YES; // evaluation of inner paranthesis complete.
    }
    //xtok = self.pop;
    //return xtok ;
}

- (BOOL) isMemoryUpdated {
    return memoryUpdated; 
}

- (void) rebuildFormulaFromTokens {
    NSString *str;
    [formula setString:@""];
    for (str in arrTokens) {
        [formula appendString:str];
    }
}


- (void)tokenizeFormula {
    [arrTokens removeAllObjects] ;
    [valuestack removeAllObjects];
    [arrUsedVariables removeAllObjects];
    [arrUsedFunctions removeAllObjects];

    tokidx = -1;
    errorflag = NO; // new shot
    
    NSInteger tokenNr = 0;
   // BOOL storeInMemory = NO;
    NSString * storeInVariable;
    NSString *s = self.formula;
    PKTokenizer *t = [PKTokenizer tokenizerWithString:s];
    [t setTokenizerState:t.wordState from:'_' to:'_'];
    t.numberState.allowsScientificNotation = YES;
    t.numberState.allowsTrailingDecimalSeparator = YES;
    int decsep = [[nf decimalSeparator] characterAtIndex:0]; 
    t.numberState.decimalSeparator = decsep;
    
    if ([[nf groupingSeparator] length] == 0) {
        t.numberState.allowsGroupingSeparator = NO;
    } else {
        int groupsep = [[nf groupingSeparator] characterAtIndex:0];
        t.numberState.groupingSeparator = groupsep;
        t.numberState.allowsGroupingSeparator = YES;
    }
    
    [t.wordState setWordChars:NO from:'-' to:'-'];
     [t.wordState setWordChars:YES from:'_' to:'_'];
    [t.symbolState add:@":="];
    PKToken *eof = [PKToken EOFToken];
    PKToken *tok = nil;
    
    memoryUpdated = NO;
    
    tokidx = 0;
    while ((tok = [t nextToken]) != eof) {
        if ([tok stringValue]) {
            if (([[[tok stringValue]substringToIndex:1] isEqualToString:@"-"]) &&
                ([tok isNumber])) {
                [arrTokens addObject:@"-"];
                [arrTokens addObject:[[tok stringValue]substringFromIndex:1]];
                
            } else [arrTokens addObject:[tok stringValue]];
            if ((tokenNr==1) && ([[tok stringValue] isEqualToString:@":="])) {
             //   storeInMemory = YES;
                storeInVariable = [NSString stringWithString:[self Token]];
                (void) [self Token]; // remove the :=
            }
        }
        
        //   NSLog(@" (%@), (%d)", tok, [tok tokenType]);
        tokenNr ++;
    }
}



- (double) evaluate {
    double resx;
   // NSInteger cnt;
  //  NSMutableString *str;
 //   NSMutableString *str2 = [NSMutableString stringWithCapacity:10];

    [arrTokens removeAllObjects] ;
    [valuestack removeAllObjects];
    [arrUsedVariables removeAllObjects];
    [arrUsedFunctions removeAllObjects];
    derivativeLevel=0;
    if (! doingMultiParEntry) { // no need to evaluate during multipart entry, wait until we are finished with that. 
        tokidx = -1;
        errorflag = NO; // new shot
        if (calc2) // reset before we start, so we can complete formula even if previous evaluation failed. 
            calc2.errorflag = NO;
        
        NSInteger tokenNr = 0;
        BOOL storeInMemory = NO;
        NSString * storeInVariable; 
        NSString *s = [NSString stringWithString: self.formula];
        PKTokenizer *t = [PKTokenizer tokenizerWithString:s];
        [t setTokenizerState:t.wordState from:'_' to:'_'];
        t.numberState.allowsScientificNotation = YES;
        t.numberState.allowsTrailingDecimalSeparator = YES;
        int decsep = [[nf decimalSeparator] characterAtIndex:0];
        t.numberState.decimalSeparator = decsep;
        
        if ([[nf groupingSeparator] length] == 0) {
            t.numberState.allowsGroupingSeparator = NO;
        } else {
            int groupsep = [[nf groupingSeparator] characterAtIndex:0];
            t.numberState.groupingSeparator = groupsep;
            t.numberState.allowsGroupingSeparator = YES;
        }
        
        [t.wordState setWordChars:NO from:'-' to:'-'];
        [t.wordState setWordChars:NO from:'.' to:'.'];
        [t.wordState setWordChars:YES from:'_' to:'_'];
        [t.symbolState add:@":="];
        [t.symbolState add:@"%^"];
        PKToken *eof = [PKToken EOFToken];
        PKToken *tok = nil;
        
        memoryUpdated = NO; 
        NSString *ss; 
        tokidx = 0;
        while ((tok = [t nextToken]) != eof) {
            if ([tok stringValue]) {
                ss = [NSString stringWithString:[tok stringValue]];
                if (([[ss substringToIndex:1] isEqualToString:@"-"]) &&
                    ([tok isNumber])) {
                        [arrTokens addObject:@"-"];
                        [arrTokens addObject:[[tok stringValue]substringFromIndex:1]]; 
                
                } else if ([ss isEqualToString:@"%"]) {
                        [arrTokens addObject:@"/"];
                        [arrTokens addObject:@"100"];
                    
                } else if ([ss isEqualToString:@"ww"]) { // bug in parsekit
                    [arrTokens addObject:@"w"];
                }
                else [arrTokens addObject:ss];
                if ((tokenNr==1) && ([ss isEqualToString:@":="])) {
                    storeInMemory = YES;
                    storeInVariable = [NSString stringWithString:[self Token]];
                    (void) [self Token]; // remove the :=
                }
            }
            
           // NSLog(@" (%@), (%d)", tok, [tok tokenType]);
            tokenNr ++; 
        }
        if (!tokenNr) return 0.0;
        else {
           
            [self doEvaluate] ; // result on top of stack
            resx = [self doubleFromString:[self pop]];
            if (storeInMemory) {
            
                if ([storeInVariable isEqualToString:@"x"]) mem_x = resx; 
                else if ([storeInVariable isEqualToString:@"y"]) mem_y = resx; 
                else if ([storeInVariable isEqualToString:@"z"]) mem_z = resx;
                else if ([storeInVariable isEqualToString:@"a"]) mem_a = resx;
                else if ([storeInVariable isEqualToString:@"b"]) mem_b = resx;
                else if ([storeInVariable isEqualToString:@"c"]) mem_c = resx;
                else if ([storeInVariable isEqualToString:@"d"]) mem_d = resx; 
                else if ([storeInVariable isEqualToString:@"r"]) mem_r = resx;
                else if ([storeInVariable isEqualToString:@"h"]) mem_h = resx; 
                else if ([storeInVariable isEqualToString:@"w"]) mem_w = resx;
                else {errorflag = YES; errormessage = [NSString stringWithFormat:@"Unknown variable: '%@'", storeInVariable];}
                memoryUpdated = YES; 
            }
            
            
            return resx;
        }
    } else return 0.0; 
 
}


- (id) GetTokens {
    NSString *s = self.formula; 
    PKTokenizer *t = [PKTokenizer tokenizerWithString:s];
    
    PKToken *eof = [PKToken EOFToken];
    PKToken *tok = nil;
    
    while ((tok = [t nextToken]) != eof) {
      //  NSLog(@" (%@)", tok);
    }
    return nil; 

}
@end
