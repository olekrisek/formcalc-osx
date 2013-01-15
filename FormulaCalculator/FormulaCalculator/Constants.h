//
//  Constants.h
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 11/11/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConstCategories;

@interface Constants : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSDecimalNumber * value;
@property (nonatomic, retain) ConstCategories *category;

@end
