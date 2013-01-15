//
//  FunctionLibrary.m
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 10/29/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import "FunctionLibrary.h"

@implementation FunctionLibrary
@synthesize FuncLib;



- (id)init
{
    self = [super init];
    if (self) {
        FuncLib = [NSMutableArray arrayWithCapacity:100] ;
        [self InitFunctionStructure]; 
    }
    return self;
}

- (CalcFunctions*) FindFunction:(NSString*)str {
    NSInteger cnt;
    CalcFunctions * fu = nil;
    if (FuncLib) {
        cnt = [FuncLib count];
        
        NSInteger idx = [FuncLib indexOfObject:str] ;
        if ((idx>=0) && (idx<cnt)) {
            fu = [FuncLib objectAtIndex:idx];
        }
    }
    return fu;
}


- (BOOL) AddFunction:(CalcFunctions*)fu {
    BOOL ok = YES;
    if (fu) [FuncLib addObject:fu];
    else ok = NO;
    return ok;
}

- (void) InitFunctionStructure {
    
    
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"GoldenSectionA"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Calculate the golden section A of a line"
                       Parameters:[NSArray arrayWithObjects:
                                   @"Lengt of line A+B", // x
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"x/((1+sqrt(5))/2)", nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"SavingsYearsToTarget"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Calculate Years to reach a savings target"
                       Parameters:[NSArray arrayWithObjects:
                                   @"Savings target", // x
                                   @"Present value", // y
                                   @"No of annual payments(12)", // z
                                   @"Periodic payment sum", // a
                                   @"annual interest rate", // b
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"r:=b/z/100",
                                 @"log((a+x*r)/(a+y*r))/log(1+r)/z", nil]]];

    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"PaymentSavings"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Calculate payment needed for a savings target"
                       Parameters:[NSArray arrayWithObjects:
                                   @"Savings target", // x
                                   @"Present value", // y
                                   @"No of annual payments(12)", // z
                                   @"No of years", // a
                                   @"annual interest rate", // b
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"r:=b/z/100",
                                 @"c:=z*a",
                                 @"(x*r-y*r*(1+r)^c)/((1+r)^c-1)", nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"FutureValueOfSavings"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Calculate future value of savings"
                       Parameters:[NSArray arrayWithObjects:
                                   @"Present value", // x
                                   @"Periodical payment amount", // y
                                   @"No of annual payments(12)", // z
                                   @"No of years", // a
                                   @"annual interest rate", // b
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"r:=b/z/100",
                                 @"c:=z*a",
                                 @"x*(1+r)^c+y/r*((1+r)^c-1)", nil]]];

    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"PaymentBallonLoan"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Calculate payment on a ballon loan"
                       Parameters:[NSArray arrayWithObjects:
                                   @"loan sum (PV)", // x
                                   @"ballon balance (rest payment)", // y
                                   @"months (year*12)", // z
                                   @"number of payments pr year", // a
                                   @"annual interest rate", // b
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"r:=b/a/100",
                                 @"(x-y/(1+r)^z)*r/(1-(1+r)^-z)", nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"BalanceAnnuityLoan"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Calculate the balance of an annuity loan after n periods (ballon balance)"
                       Parameters:[NSArray arrayWithObjects:
                                   @"loan sum (PV)", // x
                                   @"number of months (12*years)", // y
                                   @"periodic payment", // z
                                   @"number of payments pr year", // a
                                   @"annual interest rate", // b
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"r:=b/a/100",
                                 @"x*(1+r)^y-z*(((1+r)^y-1)/r)", nil]]];

    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"YearAnnuityLoan"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Calculate years for an annuity loan given payment"
                       Parameters:[NSArray arrayWithObjects:
                                   @"loan sum", // x
                                   @"Number of payments pr year", // y
                                   @"payment sum", // z
                                   @"annual interest rate", // a
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"b:=a/y/100",
                                 @"c:=z*(1+b)",
                                 @"log(c/(b*(-x)+c))/log(1+b)/y", nil]]];

    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"annuityLoanValue"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Calculate the maximum loan value given payment and time"
                       Parameters:[NSArray arrayWithObjects:
                                   @"Number of years", // x
                                   @"Number of payments pr year", // y
                                   @"payment sum", // z
                                   @"annual interest rate", // a
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"b:=a/y/100",
                                 @"c:=z*(1+b)",
                                 @"-(c/10^(x*y*log(b+1))-c)/b", nil]]];

    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"FutureValueOfDeposit"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Calculate future Value"
                       Parameters:[NSArray arrayWithObjects:
                                   @"Present value",
                                   @"Compounding periods (years)",
                                   @"interest rate", // a
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"x*(1+z/100)^y", nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"YearsToFutureValue"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Calculate years to future value (1 compounding periods pr year)"
                       Parameters:[NSArray arrayWithObjects:
                                   @"Present value",
                                   @"Future value",
                                   @"annual interest rate", // a
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"(ln(y)-ln(x))/ln(1+z/100)", nil]]];

    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"diagonalRect"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the diagonal length of an rectangle"
                       Parameters:[NSArray arrayWithObjects:
                                   @"length of first side", // x
                                   @"length of second side", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"sqrt(x^2+y^2)", nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"angleRegPolygon"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Get the size of one interior angle of a regular polygon"
                       Parameters:[NSArray arrayWithObjects:
                                   @"Number of sides", // x
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"180*(x-2)/x", nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"areaHollowCyl"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the area of an hollow cylinder, including ends"
                       Parameters:[NSArray arrayWithObjects:
                                   @"outher diameter", // x
                                   @"wall tichness", // y
                                   @"length", // z
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"pi*x*z+pi*z*(x-2*y)+2*(pi*x^2/4-pi*(x/2-y)^2)",
                                 nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"areaCyl"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the area of an cylinder, including ends"
                       Parameters:[NSArray arrayWithObjects:
                                   @"outher diameter", // x
                                   @"length", // z
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"a:=x/2",
                                 @"2*pi*a*y+2*pi*a^2",
                                 nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"sphereArea"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the area of an sphere (ball)"
                       Parameters:[NSArray arrayWithObjects:
                                   @"outher diameter", // x
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"4*pi*(x/2)*2",
                                 nil]]];

    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"cylVolume"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the volume of an cylinder"
                       Parameters:[NSArray arrayWithObjects:
                                   @"outher diameter", // x
                                   @"length", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"pi*(x/2)^2*y",
                                 nil]]];

    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"boxVolume"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the volum of an box"
                       Parameters:[NSArray arrayWithObjects:
                                   @"width", // x
                                   @"hight", // y
                                   @"depth", // z
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"x*y*z",
                                 nil]]];

    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"ballVolume"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the volum of a ball"
                       Parameters:[NSArray arrayWithObjects:
                                   @"diameter", // x
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"4/3*pi*(x/2)^3",
                                 nil]]];

    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"ballSurface"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the area of a ball"
                       Parameters:[NSArray arrayWithObjects:
                                   @"diameter", // x
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"4*pi*(x/2)^2",
                                 nil]]];

    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"circleArea"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the area of an circle"
                       Parameters:[NSArray arrayWithObjects:
                                   @"diameter", // x
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"pi*(x/2)^2",
                                 nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"perimeterCircle"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the perimeter of an circle"
                       Parameters:[NSArray arrayWithObjects:
                                   @"diameter", // x
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"pi*x",
                                 nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"perimeterEllipse"
                       Category:CalcCatGeometry
                       Method:calc_perimeterEllipse
                       Description:@"Calculate the perimeter of an ellipse"
                       Parameters:[NSArray arrayWithObjects:
                                   @"height of ellipse", // x
                                    @"width of ellipse", // x
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                  @"a:=x/2",@"b:=y/2",
                                  @"pi*(3*(a+b)-sqrt((3*a+b)*(a+3*b)))",
                                 nil]]];


    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"perimeterRectangle"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the perimeter of an rectangle"
                       Parameters:[NSArray arrayWithObjects:
                                   @"width", // x
                                   @"hight", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"2*x*y",
                                 nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"perimeterRegPolygon"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the perimeter of an regular polygon"
                       Parameters:[NSArray arrayWithObjects:
                                   @"number of sides", // x
                                   @"distance from center to one of its corners", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"2*x*y*cos(90*(x-2)/x)",
                                 nil]]];

    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"areaRegPolygon"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the area of an regular polygon"
                       Parameters:[NSArray arrayWithObjects:
                                   @"number of sides", // x
                                   @"distance from center to one of its corners", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"a:=90*(x-2)/x", 
                                 @"x*cos(a)*sin(a)*y^2",
                                 nil]]];
    
    // area of star polygon
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"areaRegStarPolygon"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the area of an regular star polygon"
                       Parameters:[NSArray arrayWithObjects:
                                   @"number of sides", // x
                                   @"distance from center to one of its inner corners", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"a:=90*(x-2)/x",
                                 @"x*tan(180-2*a)*y^2*cos(a)^2+x*sin(a)*y^2*cos(a)", // 
                                 nil]]];
    
    // area of star polygon
    //@"x*tan(180-a)*y^2*cos(a/2)^2+x*sin(a/2)*y^2*cos(a/2)"

    
    [self AddFunction:[[[CalcFunctions alloc]init] // 2
                       FunctionWithValues:@"polyDiaCC2IC"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Regular polygon diameters: Circumcircle to Inscribed Circle"
                       Parameters:[NSArray arrayWithObjects:
                                   @"number of corners", // x
                                   @"diameter of Circumcircle", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"y*sin(90*(x-2)/x)",
                                 nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init] // 1
                       FunctionWithValues:@"polyDiaIC2CC"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Regular polygon diameters: Inscribed Circle to Circumcircle"
                       Parameters:[NSArray arrayWithObjects:
                                   @"number of sides", // x
                                   @"diameter of Inscribed Circle", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"y/sin(90*(x-2)/x)",
                                 nil]]];

    // regular star polygon
    
    [self AddFunction:[[[CalcFunctions alloc]init] // 1
                       FunctionWithValues:@"polyStarDiaIC2CC"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Regular star polygon diameters: Inscribed Circle to Circumcircle"
                       Parameters:[NSArray arrayWithObjects:
                                   @"number of sides", // x
                                   @"diameter of Inscribed Circle", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"a:=90*(x-2)/x",
                                 @"tan(180-2*a)*y*cos(a)+y*sin(a)",
                                 nil]]];

    [self AddFunction:[[[CalcFunctions alloc]init] // 1
                       FunctionWithValues:@"polyStarDiaCC2IC"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Regular star polygon diameters: Circumcircle to Inscribed Circle"
                       Parameters:[NSArray arrayWithObjects:
                                   @"number of sides", // x
                                   @"diameter of Circumcircle", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"a:=90*(x-2)/x",
                                 @"y*sin(a)-tan(90-a)*y*cos(a)",
                                 nil]]];

    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"coneVolum"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the volum of a cone or truncated cone"
                       Parameters:[NSArray arrayWithObjects:
                                   @"bottom diameter", // x
                                   @"top diameter (=0)", // y
                                   @"hight", // z
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"h:=z/(1-y/x)-z",
                                 @"1/3*pi*(x/2)^2*(z+h)-1/3*pi*(y/2)^2*h",
                                 nil]]];

    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"areaCone"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the area of a cone or truncated cone"
                       Parameters:[NSArray arrayWithObjects:
                                   @"bottom diameter", // x
                                   @"top diameter (=0)", // y
                                   @"hight", // z
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"h:=z/(1-y/x)-z", // cut of part
                                 @"w:=pi*(y/2)*sqrt((y/2)^2+h^2)",
                                 @"pi*(x/2)^2+pi*(y/2)^2+pi*(x/2)*sqrt((x/2)^2+(z+h)^2)-w",
                                 nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"areaCone"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the area of a cone or truncated cone"
                       Parameters:[NSArray arrayWithObjects:
                                   @"bottom diameter", // x
                                   @"top diameter (=0)", // y
                                   @"hight", // z
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"h:=z/(1-y/x)-z", // cut of part
                                 @"w:=pi*(y/2)*sqrt((y/2)^2+h^2)",
                                 @"pi*(x/2)^2+pi*(y/2)^2+pi*(x/2)*sqrt((x/2)^2+z^2)-w",
                                 nil]]];

    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"areaPyramide"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the area of an Pyramide"
                       Parameters:[NSArray arrayWithObjects:
                                   @"length of one side of square", // x
                                   @"height from center of base to top", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"2*x*sqrt((x/2)^2+y^2)+x^2", // use phytagoras to calculate the slant height. 
                                 nil]]];

    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"PyramidVolume"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the volume of an Pyramide with four sides."
                       Parameters:[NSArray arrayWithObjects:
                                   @"length of one side of base", // x
                                   @"length of second side of base", // y
                                   @"height from center of base to top", // z
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"x*y*z/3", // 
                                 nil]]];

    
    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"areaEllipse"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the area of an ellipse"
                       Parameters:[NSArray arrayWithObjects:
                                   @"width", // x
                                   @"height", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"pi*x*y/4", // Standard ellipse area formula.
                                 nil]]];

    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"areaTriangle"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the area of an triangle from its sides using herons formula"
                       Parameters:[NSArray arrayWithObjects:
                                   @"length first side", // x
                                   @"length of second side", // y
                                   @"length of third side", // z
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"c:=(x+y+z)/2", // calculate the semiperimeter.
                                 @"sqrt(c*(c-x)*(c-y)*(c-z))", // herons formula
                                 nil]]];

    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"elipsoidVolume"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the volume of an elipsoid"
                       Parameters:[NSArray arrayWithObjects:
                                   @"diameter x-plane", // x
                                   @"diameter y-plane", // y
                                   @"diameter z-plane", // z
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"pi*x*y*z/8", // elipsoid formula
                                 nil]]];

    
    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"TriangleHeight"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the height of an triangle from its sides, using herons formula"
                       Parameters:[NSArray arrayWithObjects:
                                   @"length of base", // x
                                   @"length of second side", // y
                                   @"length of third side", // z
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"c:=(x+y+z)/2", // calculate the semiperimeter.
                                 @"a:=sqrt(c*(c-x)*(c-y)*(c-z))", // herons formula
                                 @"2*a/x",
                                 nil]]];

    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"diagonalAngle"
                       Category:CalcCatGeometry
                       Method:calc_UsingFormulas
                       Description:@"Calculate the angle of the diagonal and the base of an rectangle"
                       Parameters:[NSArray arrayWithObjects:
                                   @"width of rectangle", // x
                                   @"hight of rectangle", // y
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"arcsin(y/sqrt(x^2+y^2))",
                                 nil]]];


    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"min"
                       Category:CalcCatMath
                       Method:calc_min
                       Description:@"Minumum value of 2"
                       Parameters:[NSArray arrayWithObjects:
                                   @"value 1", // x
                                   @"value 2", // y
                                   nil]
                       Formulas:nil]];

    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"max"
                       Category:CalcCatMath
                       Method:calc_max
                       Description:@"Greatest value of 2"
                       Parameters:[NSArray arrayWithObjects:
                                   @"value 1", // x
                                   @"value 2", // y
                                   nil]
                       Formulas:nil]];
    
    [self AddFunction:[[[CalcFunctions alloc]init] // we do iterations for this. 
                       FunctionWithValues:@"InterestRateAnnuityLoan"
                       Category:CalcCatFinance
                       Method:calc_annualIRforloan
                       Description:@"Calculate interest rate of an annuity loan"
                       Parameters:[NSArray arrayWithObjects:
                                   @"loan sum",
                                   @"number of months (12*Years)",
                                   @"Number of payments pr year",
                                   @"payment sum",
                                   nil]
                       Formulas:nil]];
    
    [self AddFunction:[[[CalcFunctions alloc]init] 
                       FunctionWithValues:@"PresentValue"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Calculate the present value from future value"
                       Parameters:[NSArray arrayWithObjects:
                                   @"Future Value",
                                   @"Number of Years",
                                   @"Annual interest rate",
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"x/(z/100+1)^y",
                                 nil]]];
    
    [self AddFunction:[[[CalcFunctions alloc]init] 
                       FunctionWithValues:@"CompoundInterest"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Calculate the Compound Interest From a investment that is reinvested."
                       Parameters:[NSArray arrayWithObjects:
                                   @"Original Balance",
                                   @"Number of compounding periods",
                                   @"Period interest rate",
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"x*((1+z/100)^y-1)",
                                 nil]]];

    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"QuadraticPlus"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Quadratic formula: x of ax^2+bx+c=0 (plus version)"
                       Parameters:[NSArray arrayWithObjects:
                                   @"Value of a",
                                   @"Value of b",
                                   @"Value of c",
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"a:=x",@"b:=y",@"c:=z",
                                 @"(-b+sqrt(b^2-4*a*c))/(2*a)", 
                                 nil]]];

    [self AddFunction:[[[CalcFunctions alloc]init]
                       FunctionWithValues:@"QuadraticMinus"
                       Category:CalcCatFinance
                       Method:calc_UsingFormulas
                       Description:@"Quadratic formula: x of ax^2+bx+c=0 (Minus version)"
                       Parameters:[NSArray arrayWithObjects:
                                   @"Value of a",
                                   @"Value of b",
                                   @"Value of c",
                                   nil]
                       Formulas:[NSArray arrayWithObjects:
                                 @"a:=x",@"b:=y",@"c:=z",
                                 @"(-b-sqrt(b^2-4*a*c))/(2*a)",
                                 nil]]];
    
    
}


@end
