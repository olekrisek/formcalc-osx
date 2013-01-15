//
//  ValueStore.h
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 11/10/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ValueStore : NSManagedObject

@property (nonatomic, retain) NSString * string;
@property (nonatomic, retain) NSString * key;

@end
