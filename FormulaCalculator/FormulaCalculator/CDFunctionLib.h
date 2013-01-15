//
//  CDFunctionLib.h
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 11/10/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDFormulas, CDParameters, CDPath;

@interface CDFunctionLib : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * friendlyname;
@property (nonatomic, retain) NSString * referenceURL;
@property (nonatomic, retain) NSNumber * noParameters;
@property (nonatomic, retain) NSNumber * noFormulas;
@property (nonatomic, retain) NSSet *cDParameters;
@property (nonatomic, retain) NSSet *cdFormulas;
@property (nonatomic, retain) CDPath *cdPath;
@end

@interface CDFunctionLib (CoreDataGeneratedAccessors)

- (void)addCDParametersObject:(CDParameters *)value;
- (void)removeCDParametersObject:(CDParameters *)value;
- (void)addCDParameters:(NSSet *)values;
- (void)removeCDParameters:(NSSet *)values;

- (void)addCdFormulasObject:(CDFormulas *)value;
- (void)removeCdFormulasObject:(CDFormulas *)value;
- (void)addCdFormulas:(NSSet *)values;
- (void)removeCdFormulas:(NSSet *)values;

@end
