//
//  ConstCategories.h
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 11/11/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Constants;

@interface ConstCategories : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *constants;
@end

@interface ConstCategories (CoreDataGeneratedAccessors)

- (void)addConstantsObject:(Constants *)value;
- (void)removeConstantsObject:(Constants *)value;
- (void)addConstants:(NSSet *)values;
- (void)removeConstants:(NSSet *)values;

@end
