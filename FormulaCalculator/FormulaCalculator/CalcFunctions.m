//
//  CalcFunctions.m
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 10/29/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import "CalcFunctions.h"

@implementation CalcFunctions

@synthesize description;
@synthesize parameters;
@synthesize formulas;
@synthesize category;
@synthesize FunctionID;
@synthesize name; 




- (id)init
{
    self = [super init];
    if (self) {
        description = nil;
        parameters = nil;
        formulas = nil;
        name = nil; 
        category = CalcCatNoFunction;
        FunctionID = 0;
    }
    return self;
}

- (CalcFunctions*) FunctionWithValues:(NSString*)newname
                 Category:(CalcFunctionCategory)cat
                   Method:(NSInteger)fuID
              Description:(NSString*)desc
               Parameters:(NSArray* )param
                 Formulas:(NSArray*)form {

    //self = [super init];
     if (self) {
         name = [NSString stringWithString:newname];
         category = cat;
         FunctionID = fuID;
         description = [NSString stringWithString:desc];
         parameters = [NSArray arrayWithArray:param];
         if (form)
             formulas = [NSArray arrayWithArray:form];
         else formulas = nil; 
     }
    return self; 
}
// when comparing objects, we only care about the name. 
- (BOOL) isEqual:(id) str{
    BOOL equal = NO;
    if (self) {
        if ([name isEqualToString:str]) equal = YES;
    }
    return equal; 
}

- (NSInteger) calcMethod {
    return FunctionID;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:description forKey:@"description"];
    [encoder encodeObject:parameters forKey:@"parameters"];
    [encoder encodeObject:formulas forKey:@"formulas"];
    [encoder encodeInteger:category forKey:@"category"];
    [encoder encodeInteger:FunctionID forKey:@"method"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *xname = [decoder decodeObjectForKey:@"name"];
    NSString *xdesc = [decoder decodeObjectForKey:@"description"];
    NSArray *xpar = [decoder decodeObjectForKey:@"parameters"];
    NSArray *xform = [decoder decodeObjectForKey:@"formulas"];
    CalcFunctionCategory xcat = [decoder decodeInt32ForKey:@"category"];
    NSInteger xid = [decoder decodeIntegerForKey:@"method"];
    
    return [self FunctionWithValues:xname Category:xcat Method:xid Description:xdesc Parameters:xpar Formulas:xform];
    
}

- (BOOL) buildXMLnode:(NSXMLElement *)parent {
    NSInteger noPar, noForm;
    NSString *item; 
    NSXMLElement *container, *params, *functions;
    container = (NSXMLElement *)[NSXMLNode elementWithName:@"CalcFunction"];
    [[container attributeForName:@"idnum"] setStringValue:[self name]];
    [parent addChild:container];
    [container addChild:[NSXMLElement elementWithName:@"description" stringValue:[self description]]];
    [container addChild:[NSXMLElement elementWithName:@"category" stringValue:[NSString stringWithFormat:@"%d", category]]];
    noPar = [self.parameters count];
    noForm = [self.formulas count];
    params = (NSXMLElement *)[NSXMLNode elementWithName:@"parameters"];
    [container addChild:params];
   [params addChild:[NSXMLElement elementWithName:@"NumberOfParams"
                                      stringValue:[NSString stringWithFormat:@"%ld", noPar]]];
    for (item in parameters) {
        [params addChild:[NSXMLElement elementWithName:@"parameter" stringValue:item]];
    }
                                  
    functions = (NSXMLElement *)[NSXMLNode elementWithName:@"formulas"];
    [container addChild:functions];
    [functions addChild:[NSXMLElement elementWithName:@"NumberOfFunctions"
                                       stringValue:[NSString stringWithFormat:@"%ld", noForm]]];
    for (item in formulas) {
        [params addChild:[NSXMLElement elementWithName:@"formula" stringValue:item]];
    }

    return YES; 
    
}
- (BOOL) buildFunctionFromXML:(NSXMLElement *)node {



    return YES; 
}


@end
