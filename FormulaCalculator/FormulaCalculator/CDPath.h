//
//  CDPath.h
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 11/10/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDFunctionLib;

@interface CDPath : NSManagedObject

@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * friendlyname;
@property (nonatomic, retain) NSSet *cdFunctions;
@end

@interface CDPath (CoreDataGeneratedAccessors)

- (void)addCdFunctionsObject:(CDFunctionLib *)value;
- (void)removeCdFunctionsObject:(CDFunctionLib *)value;
- (void)addCdFunctions:(NSSet *)values;
- (void)removeCdFunctions:(NSSet *)values;

@end
