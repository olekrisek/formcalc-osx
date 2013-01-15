//
//  PrintRoll.h
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 11/9/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PrintRoll : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSDate * dateModified;
@property (nonatomic, retain) NSMutableString * printRollText;
@property (nonatomic, retain) NSString * key;

@end
