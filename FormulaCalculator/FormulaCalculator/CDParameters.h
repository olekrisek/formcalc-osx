//
//  CDParameters.h
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 11/10/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDFunctionLib;

@interface CDParameters : NSManagedObject

@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * intoVariable;
@property (nonatomic, retain) CDFunctionLib *cDFunction;

@end
