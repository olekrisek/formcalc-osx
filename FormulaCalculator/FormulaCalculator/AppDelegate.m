//
//  AppDelegate.m
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 10/19/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize standardUserDefaults;
@synthesize calc;
@synthesize topDisplay; 
@synthesize display;
@synthesize topStatus;
@synthesize shiftkey;

@synthesize sqrt_btn;
@synthesize ln_btn;
@synthesize log_btn;
@synthesize sin_btn;
@synthesize cos_btn;
@synthesize tan_btn;
@synthesize sinh_btn;
@synthesize cosh_btn;
@synthesize tanh_btn;
@synthesize in2cm_btn;
@synthesize cm2in_btn;
//@synthesize window = _window;
@synthesize editww = _editww;
@synthesize editTextField;
@synthesize hlpDrawer;
@synthesize drawer_convert;
@synthesize drawer_Finance;
@synthesize drawer_geometry;
@synthesize currentFunctionLib; 

@synthesize popup_annuity;
@synthesize popup_interest;
@synthesize popup_savings;
@synthesize popup_functionLib;

@synthesize pop_geo_gen;
@synthesize pop_geo_area;
@synthesize pop_geo_vol;
@synthesize pop_geo_circ;
@synthesize checkIncludeDoc;
@synthesize bracketsbeforeMultiPart;
@synthesize rightbracketkey;

// variables
@synthesize var_x;
@synthesize var_y;
@synthesize var_z;
@synthesize var_a;
@synthesize var_b;
@synthesize var_c;
@synthesize var_d;
@synthesize var_r;
@synthesize var_h;
@synthesize var_w;
// variable buttons
@synthesize but_titx;
@synthesize but_tity;
@synthesize but_titz;
@synthesize but_tita;
@synthesize but_titb;
@synthesize but_titc;
@synthesize but_titd;
@synthesize but_titr;
@synthesize but_tith;
@synthesize but_titw;
@synthesize functionLib; 
@synthesize printroll_view;
@synthesize roll;
@synthesize unduManager;
@synthesize var_drawer;
@synthesize btnTabKey;
@synthesize shftKey;
@synthesize label_x;
@synthesize label_y;
@synthesize label_z;
@synthesize label_a;
@synthesize label_b;
@synthesize label_c;
@synthesize label_d;
@synthesize label_r;
@synthesize label_h;
@synthesize label_w;
@synthesize currentFormula;
@synthesize currententry;
@synthesize memoryValues;
@synthesize variableLabels;
@synthesize prefDP; // preference - decimal point.
@synthesize prefNumFormat;
@synthesize StoredMainView;
//ConstCategoryPop, ConstantPop, ConstantsFromPop
@synthesize ConstCategoryPop;
@synthesize ConstantPop;
@synthesize ConstantsFromPop; // Mutable Array
@synthesize StoreFileLocation;
@synthesize prefTableValueColumn;
@synthesize derivativeEntry;
@synthesize factBtn;
// unit converters
@synthesize lengthUnitPop;
@synthesize volumUnitsPop;
@synthesize tempUnitsPop;
@synthesize weightUnitPop; 


- (ValueStore *) valueStoreObjectForKey: (NSString*)key defaultValue: (NSString *)def{
    NSError *error = nil;
    
    NSManagedObjectContext * context = [self managedObjectContext];

    ValueStore * obj=nil;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"ValueStore" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"key=%@",key]];
    obj = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];

    if (error) {
        NSLog(@"Error retriving value from ValueStore, name=%@, error=%@", key, error);
    }
    
    if (!obj) { // Create a new one....
        obj = (ValueStore *)[NSEntityDescription insertNewObjectForEntityForName:@"ValueStore" inManagedObjectContext:[self managedObjectContext]];
        if (obj) {
            obj.key = key;
            obj.string = def;
        }
    }
    
    return obj;
}

- (BOOL) updateConstPopupII {
    BOOL ok=YES;
    NSError *error = nil;
    ConstCategories *x;
    Constants *y; 
    [ConstantPop removeAllItems];
    NSString * xname = [ConstCategoryPop titleOfSelectedItem];
    if (xname) {
        if (xname.length) {
            NSManagedObjectContext * context = [self managedObjectContext];
            NSFetchRequest * request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"ConstCategories" inManagedObjectContext:context]];
            [request setPredicate:[NSPredicate predicateWithFormat:@"name=%@",xname]];
            
            //Ask for it
            x = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];
            
            if (error) {
                NSLog(@"FetchRequest error...");
                //Handle any errors
                ok = NO;
            }
            [ConstantsFromPop removeAllObjects];
            NSMutableString *item;
            double val;
            if (x) {
                for (y in x.constants) {
                    [ConstantsFromPop addObject:y.key];
                    val = [y.value doubleValue]; 
                    item = [NSString stringWithFormat:@"%@ - %@=%@", y.key, y.desc, [calc formatNumber:val]];
                    [ConstantPop addItemWithTitle:item];
                }
            }
        }
    }
    return ok;
}

- (ConstCategories* ) createConstantCategory: (NSString*)str {
    ConstCategories * root;
    root = (ConstCategories *)[NSEntityDescription insertNewObjectForEntityForName:@"ConstCategories" inManagedObjectContext:[self managedObjectContext]];
    root.name = [NSString stringWithString:str];
    return root;
}

- (Constants * ) createConstantInCategory: (ConstCategories*) cat Constant: (NSString *)ckey Description: (NSString*) desc value:(double)val {

    Constants * root;
    root = (Constants *)[NSEntityDescription insertNewObjectForEntityForName:@"Constants" inManagedObjectContext:[self managedObjectContext]];
    root.key = [NSString stringWithString:ckey];
    root.desc = [NSString stringWithString:desc];
    root.value = [[NSDecimalNumber alloc] initWithDouble:val];
    [cat addConstantsObject:root];
    root.category = cat;
    return root;

}


- (BOOL) updateConstPopup {
    NSManagedObjectContext * context = [self managedObjectContext];
    BOOL ok = YES;
    NSError *error = nil;
    NSArray *cats ;
    ConstCategories *x; 
    //ConstCategoryPop, ConstantPop, ConstantsFromPop
    [ConstCategoryPop removeAllItems];
    [ConstantPop removeAllItems];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ConstCategories"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
  //                                                                 ascending:YES];
  //  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  //  [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    cats = [context executeFetchRequest:fetchRequest error:&error];
    
    if (cats == nil) {
        ok=NO;
        NSLog (@"Error loading constants. Message=%@", error);
    } else if (![cats count]) { // no categories
        // Construct some initial data
        ConstCategories *x1 = [self createConstantCategory:@"Math"];
        Constants *c1 = [self createConstantInCategory:x1 Constant:@"Bruns" Description:@"Bruns Constant" value:1.902160583104];
        Constants *c2 = [self createConstantInCategory:x1 Constant:@"fdelta" Description:@"Feigenbaum delta" value:4.66920160910299];
        Constants *c3 = [self createConstantInCategory:x1 Constant:@"aa" Description:@"Absolute Answer" value:42];
      
        ConstCategories *x2 = [self createConstantCategory:@"Physics"];
        Constants *p1 = [self createConstantInCategory:x2 Constant:@"ls" Description:@"Speed of light" value:2.99792458E8];
        Constants *p2 = [self createConstantInCategory:x2 Constant:@"planc_Js" Description:@"Plancs Constant (Js)" value:6.62606957E-34];
        Constants *p3 = [self createConstantInCategory:x2 Constant:@"me" Description:@"Electron Mass" value:9.109382914E-31];
        cats = [NSArray arrayWithObjects:x1,x2, nil];
        // silence the not used warning......
        if ((c1) && (c2) && (c3) && (p1) && (p2) && (p3)) ok=YES; else ok=NO;
    }
    NSInteger i=0;
    NSMutableSet * catset = [[NSMutableSet alloc] initWithObjects:@"", nil];
    NSMutableSet * constset = [[NSMutableSet alloc] initWithObjects:@"", nil];
    Constants *y;
    NSInteger j;
    NSString *catname; 
    for (x in cats) {
        // Integrety check.... Ensure all categories and constants have a unike name/key. 
        j=1;
        catname = [NSString stringWithString:x.name];
        while ([catset containsObject:x.name]) {
            x.name = [NSString stringWithFormat:@"%@%ld", catname, j];
            j++;
        }
        [catset addObject:x.name]; 
        for (y in x.constants) {
            catname = [NSString stringWithString:y.key];
            j=1;
            while ([constset containsObject:y.key]) {
                y.key = [NSString stringWithFormat:@"%@%ld", catname, j];
                j++; 
            }
            [constset addObject:y.key]; 
        }
        
       // NSLog(@"object : %@", x.name);
        [ConstCategoryPop addItemWithTitle:x.name ];
        i++;
    }
    if (i) {
        [ConstCategoryPop selectItemAtIndex:0];
        [self updateConstPopupII]; 
    }
    
    return ok; 
    
}


- (BOOL)loadManagedObectData {
    BOOL ok = YES;
    NSError *error = nil;
    
    NSManagedObjectContext * context = [self managedObjectContext];
    
    //Set up to get the thing you want to update
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"PrintRoll" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"key=%@",@"Current"]];
    
    //Ask for it
    roll = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];
    
    if (error) {
        NSLog(@"FetchRequest error...");
        //Handle any errors
        ok = NO;
    }
    
    if (!roll) {
        roll = (PrintRoll *)[NSEntityDescription insertNewObjectForEntityForName:@"PrintRoll" inManagedObjectContext:[self managedObjectContext]];
        if (roll) {
            roll.key = @"Current";
            roll.printRollText = [NSMutableString stringWithString: @" === FormulaCalculator === ver. 1.0 - Printroll ===\n"];
            roll.dateCreated = [NSDate date];
            roll.dateModified = [NSDate date];
        } else ok = NO;
    }
    if (ok)
    [ self.printroll_view  setString:roll.printRollText];
    
    currentFormula = [self valueStoreObjectForKey:@"currentFormula" defaultValue:@""];
    [calc setFormula:[NSMutableString stringWithString:currentFormula.string]];
    currententry = [self valueStoreObjectForKey:@"currentEntry" defaultValue:@""];
    calc.entry =[NSMutableString stringWithString:currententry.string];
    ValueStore *vx = [self valueStoreObjectForKey:@"current_x" defaultValue:@""];
    calc.mem_x = [vx.string doubleValue];
    ValueStore *vy = [self valueStoreObjectForKey:@"current_y" defaultValue:@""];
    calc.mem_y = [vy.string doubleValue];
    ValueStore *vz = [self valueStoreObjectForKey:@"current_z" defaultValue:@""];
    calc.mem_z = [vz.string doubleValue];
    ValueStore *va = [self valueStoreObjectForKey:@"current_a" defaultValue:@""];
    calc.mem_a = [va.string doubleValue];
    ValueStore *vb = [self valueStoreObjectForKey:@"current_b" defaultValue:@""];
    calc.mem_b = [vb.string doubleValue];
    ValueStore *vc = [self valueStoreObjectForKey:@"current_c" defaultValue:@""];
    calc.mem_c = [vc.string doubleValue];
    ValueStore *vd = [self valueStoreObjectForKey:@"current_d" defaultValue:@""];
    calc.mem_d = [vd.string doubleValue];
    ValueStore *vr = [self valueStoreObjectForKey:@"current_r" defaultValue:@""];
    calc.mem_r = [vr.string doubleValue];
    ValueStore *vh = [self valueStoreObjectForKey:@"current_h" defaultValue:@""];
    calc.mem_h = [vh.string doubleValue];
    ValueStore *vw = [self valueStoreObjectForKey:@"current_w" defaultValue:@""];
    calc.mem_w = [vw.string doubleValue];
    ValueStore *vm = [self valueStoreObjectForKey:@"current_m" defaultValue:@""];
    calc.memory = [vm.string doubleValue];

    
    
    memoryValues = [NSDictionary dictionaryWithObjectsAndKeys:vx,@"current_x",
                    vy, @"current_y",
                    vz, @"current_z",
                    va, @"current_a",
                    vb, @"current_b",
                    vc, @"current_c",
                    vd, @"current_d",
                    vr, @"current_r",
                    vh, @"current_h",
                    vw, @"current_w",
                    vm, @"current_m", nil];
    
    ValueStore *lx = [self valueStoreObjectForKey:@"label_x" defaultValue:@""];
    calc.cLabel_x = lx.string ;
    ValueStore *ly = [self valueStoreObjectForKey:@"label_y" defaultValue:@""];
    calc.cLabel_y = ly.string ;
    ValueStore *lz = [self valueStoreObjectForKey:@"label_z" defaultValue:@""];
    calc.cLabel_z = lz.string ;
    ValueStore *la = [self valueStoreObjectForKey:@"label_a" defaultValue:@""];
    calc.cLabel_a = la.string ;
    ValueStore *lb = [self valueStoreObjectForKey:@"label_b" defaultValue:@""];
    calc.cLabel_b = lb.string ;
    ValueStore *lc = [self valueStoreObjectForKey:@"label_c" defaultValue:@""];
    calc.cLabel_c = lc.string ;
    ValueStore *ld = [self valueStoreObjectForKey:@"label_d" defaultValue:@""];
    calc.cLabel_d = ld.string ;
    ValueStore *lr = [self valueStoreObjectForKey:@"label_r" defaultValue:@""];
    calc.cLabel_r = lr.string ;
    ValueStore *lh = [self valueStoreObjectForKey:@"label_h" defaultValue:@""];
    calc.cLabel_h = lh.string ;
    ValueStore *lw = [self valueStoreObjectForKey:@"label_w" defaultValue:@""];
    calc.cLabel_w = lw.string ;

    [label_a setStringValue:la.string];
    [label_b setStringValue:lb.string];
    [label_c setStringValue:lc.string];
    [label_d setStringValue:ld.string];
    [label_r setStringValue:lr.string];
    [label_h setStringValue:lh.string];
    [label_w setStringValue:lw.string];
    [label_x setStringValue:lx.string];
    [label_y setStringValue:ly.string];
    [label_z setStringValue:lz.string];
    
    
    variableLabels = [NSDictionary dictionaryWithObjectsAndKeys:lx,@"label_x",
                    ly, @"label_y",
                    lz, @"label_z",
                    la, @"label_a",
                    lb, @"label_b",
                    lc, @"label_c",
                    ld, @"label_d",
                    lr, @"label_r",
                    lh, @"label_h",
                    lw, @"label_w", nil];
    
    
    NSNumberFormatter *xx = [[NSNumberFormatter alloc]init];
    //NSLog(@"Desimaltegn = '%@'",[xx decimalSeparator]);
    
    prefDP = [self valueStoreObjectForKey:@"desimalpoint" defaultValue:[xx decimalSeparator]];
    
    NSString *nf;
    if ([prefDP.string isEqualToString:@"."]) {
        nf = @"%.10lg";
    } else {
        nf = @"%,10lg";
    }
    
    prefNumFormat = [self valueStoreObjectForKey:@"numberFormat" defaultValue:nf];
    ok = [self updateConstPopup];
    return ok;
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //NSLog(@"Before calc");
    // Insert code here to initialize your application
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    
    calc = [[Calculator alloc] init] ;
    functionLib = [[FunctionLibrary alloc] init] ;
    
    [calc registerFunctionLibrary:functionLib];
    ConstantsFromPop = [NSMutableArray arrayWithCapacity:20];

    roll = nil;
    
    if ([self loadManagedObectData]) {
        // data loaded
    
    }
  //  [prefTableValueColumn
    [calc registerObjectContext:[self managedObjectContext]]; 
    
    [self UpdateDisplay];
    shiftkey = NO;
    [popup_annuity removeAllItems];
    [popup_annuity addItemsWithTitles:[NSArray arrayWithObjects:@"Periodic payment value", @"Years with fixed payment", @"Interest rate",@"Future balance (ballon bal)", @"Payment Balloon loan",@"Maximum loan amounth", nil]];
     
    [popup_interest removeAllItems];
    [popup_interest addItemsWithTitles:[NSArray arrayWithObjects:@"Future value", @"Interest for given Future Value",@"Years to given Future Value", @"Present Value from Future Value", @"Compound Interest", nil]];
    
    [popup_savings removeAllItems];
    [popup_savings addItemsWithTitles:[NSArray arrayWithObjects:@"Future value of savings", @"Payment Needed For Savings", @"Years to reach a savings target", nil]];
    [popup_functionLib removeAllItems];
    [popup_functionLib addItemsWithTitles:[NSArray arrayWithObjects:@"Select lib", @"Finance", @"Geometry", @"Converters and constants", nil]];
    
    [pop_geo_gen removeAllItems];
    [pop_geo_area removeAllItems];
    [pop_geo_vol removeAllItems];
    [pop_geo_circ removeAllItems];
    
    [pop_geo_gen addItemsWithTitles:[NSArray arrayWithObjects:@"Diagonal of rectangle", @"Angle of diagonal", @"Hight of triangle", @"Golden section of a line", @"reg Polygon Inscribed Circle to Circumcircle", @"reg Polygon Circumcircle to Inscribed Circle", @"interior angle of reg polygon",@"reg Star Polygon Inscribed Circle to Circumcircle", @"reg Star Polygon Circumcircle to Inscribed Circle",@"Quadratic Formula (plus)",@"Quadratic Formula (minus)",nil]];
    
    [pop_geo_area addItemsWithTitles:[NSArray arrayWithObjects:@"Area of circle", @"Area of sphere", @"Area of cylinder", @"Area of tube",@"Area of cone",@"Area of pyramide",@"Area of a triangle", @"Area of ellipse",@"area of regular polygon",@"Area of regular star polygon",nil]];
    
    [pop_geo_vol addItemsWithTitles:[NSArray arrayWithObjects:@"Volume of an box", @"Volume of sphere", @"Volume of cylinder", @"Volume of cone",@"Volume of pyramide",@"Volume of an ellipsoid", nil]];
    
    [pop_geo_circ addItemsWithTitles:[NSArray arrayWithObjects:@"Perimeter of circle", @"Perimeter of ellipse", @"Perimeter of regular polygon", @"Perimeter of rectangle",  nil]];
    
    [lengthUnitPop removeAllItems];
    [volumUnitsPop removeAllItems];
    [tempUnitsPop removeAllItems];
    [weightUnitPop removeAllItems];
    
    [lengthUnitPop addItemsWithTitles:[NSArray arrayWithObjects:
                                       @"Inches to Centimeters",//0
                                       @"Chain to Meters",//1
                                       @"fathom to Meters",//2
                                       @"furlong to Meters",//3
                                       @"leage to Meters",//4
                                       @"light year to Meters",//5
                                       @"Centimeter to Inches",//6
                                       @"Meters to Chain",//7
                                       @"Meters to fathom",//8
                                       @"Meters to furlong",//9
                                       @"Meters to leage",//10
                                       @"Meters to light year",//11
                                       @"Angstrom to Meters", //12
                                       @"Astronomical unit to Meters",//13
                                       @"Meters to Angstrom", //14
                                       @"Meters to Astronomical unit",//15
                                       nil]];
    
    [volumUnitsPop addItemsWithTitles:[NSArray arrayWithObjects:
                                       @"fluid dram (fl dr) to milliLiter(ml)",
                                       @"fluid ounce (fl oz) to Liter(l)",
                                       @"fluid ounce (UK)(fl oz) to Liter(l)",
                                       @"gallon (gal) to Liter(l)",
                                       @"gallon (UK)(gal) to Liter(l)",
                                       @"gill to Liter(l)",
                                       @"peck (US dry) (pk) to Liter (l)",
                                       @"pint (liquid) (pt) to Liter (l)",
                                       @"pint (UK) (pt) to Liter (l)",
                                       @"pint (US dry) (pt) to Liter (l)",
                                       @"quart (liquid) (qt) to Liter (l)",
                                       @"quart (UK) (qt) to Liter (l)",
                                       @"quart (US dry) (qt) to Liter (l)",
                                       
                                       @"milliLiter(ml) to fluid dram (fl dr)",
                                       @"Liter(l) to fluid ounce (fl oz)",
                                       @"Liter(l) to fluid ounce (UK)(fl oz)",
                                       @"Liter(l) to gallon (gal)",
                                       @"Liter(l) to gallon (UK)(gal)",
                                       @"Liter(l) to gill",
                                       @"Liter(l) to peck (US dry) (pk)",
                                       @"Liter(l) to pint (liquid) (pt)",
                                       @"Liter(l) to pint (UK) (pt)",
                                       @"Liter(l) to pint (US dry) (pt)",
                                       @"Liter(l) to quart (liquid) (qt)",
                                       @"Liter(l) to quart (UK) (qt)",
                                       @"Liter(l) to quart (US dry) (qt)",
                                       
                                       nil]];
    
    [tempUnitsPop addItemsWithTitles:[NSArray arrayWithObjects:
                                      @"Celcius to Farenheit",
                                      @"Farenheit to Celcius",
                                      @"Celcius to Kelvin",
                                      @"Farenheit to Kelvin",
                                      @"Kelvin to Celcius",
                                      @"Kelvin to Farenheit", nil]];
    
    [weightUnitPop addItemsWithTitles:[NSArray arrayWithObjects:
                                       @"atomic mass unit (amu) to gram(g)",
                                       @"carat (metric) to gram (g)",
                                       @"cental to kilogram (kg)",
                                       @"dram (dr) to gram (g)",
                                       @"grain (gr) to gram (g)",
                                       @"hundredweight (UK) to kilogram (kg)",
                                       @"newton (earth) to kilogram (kg)",
                                       @"ounce (oz) to gram (g)",
                                       @"pennyweight (dwt) to gram (g)",
                                       @"pound (lb) to kilogram (kg)",
                                       @"quarter to kilogram (kg)",
                                       @"stone to kilogram (kg)",
                                       @"troy ounce to gram (g)",
                                       
                                       @"gram(g) to atomic mass unit (amu)",
                                       @"gram(g) to carat (metric)",
                                       @"kilogram (kg) to cental",
                                       @"gram(g) to dram (dr)",
                                       @"gram(g) to grain (gr)",
                                       @"kilogram (kg) to hundredweight (UK)",
                                       @"kilogram (kg) to newton (earth)",
                                       @"gram(g) to ounce (oz)",
                                       @"gram(g) to pennyweight (dwt)",
                                       @"kilogram (kg) to pound (lb)",
                                       @"kilogram (kg) to quarter",
                                       @"kilogram (kg) to stone",
                                       @"gram(g) to troy ounce",
                                       nil]];
    
    
    
    [btnTabKey setKeyEquivalent:@"\t"] ; 
    
    [rightbracketkey setEnabled:NO];
    [rightbracketkey setToolTip:@"No opening brackets to match"];
    
    
    // popup for constants:
   
    

}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "humlegaarden.FormulaCalculator" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"humlegaarden.FormulaCalculator"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FormulaCalculator" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (IBAction)changeConstCat:(id)sender {
    [self updateConstPopupII];
}

- (IBAction)ChangeConstant:(id)sender { // do nothing....
}

- (IBAction)BtnConstantInsert:(id)sender {
    if (ConstantsFromPop) {
        NSInteger cnt = [ConstantsFromPop count]; 
        if (cnt){
            NSInteger idx = [ConstantPop indexOfSelectedItem];
            if ((idx<cnt) && (idx>=0)) {
                [self sendButtonMsg:[ConstantsFromPop objectAtIndex:idx] WithOption:CalcTypeConstant];
                [self UpdateDisplay];
            }
        }
    }
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"FormulaCalculatorXML.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error]; 
     
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

- (void) SetCurrentFormula: (NSString *)str {
    [calc SetCurrentFormula:str]; 
}

- (NSInteger) closingsBracketsLeft {
    NSString *str = [NSString stringWithString:[calc getCurrentFormula]];
    NSInteger lb = [self CountOccurencesOf:@"(" in:str];
    NSInteger rb = [self CountOccurencesOf:@")" in:str];

    if (lb>rb) return (lb-rb);
    else return 0;
}

- (void) updateParenthesisState {

    NSInteger cnt = [self closingsBracketsLeft] - bracketsbeforeMultiPart;
    
    if (cnt) {
        [rightbracketkey setTitle:[NSString stringWithFormat:@")%ld", cnt]];
        [rightbracketkey setEnabled:YES];
        [rightbracketkey setToolTip:@"hit to close matching opening parenthesis"];
        
    } else {
        [rightbracketkey setEnabled:NO];
        [rightbracketkey setTitle:@")"];
        if (! calc.doingMultiParEntry)
            [rightbracketkey setToolTip:@"No opening brackets to match"];
        else
            [rightbracketkey setToolTip:@"Use tab-key (--->!) to complete function"];
    }



}



- (void) sendButtonMsg:(NSString*)str WithOption:(CalcFunctionType)opt {
    BOOL canClose = NO;
    
    if ((opt == CalcTypeConstant) && (derivativeEntry) ) {
        if ((![str isEqualToString:@"pi"]) && (![str isEqualToString:@"e"])) {
            NSString *fstr = [NSString stringWithFormat:@"dd%@", str];
            [calc AddString:fstr WithOption:CalcTypeFunction];
            derivativeEntry = NO;
        }
    } else {
        
        if ((opt == CalcTypeMultiParameterFunctionStart) && (! calc.doingMultiParEntry)) {
            [self.hlpInfo setStringValue:@""];
            canClose = YES;
            bracketsbeforeMultiPart = 0;
        }
        [calc AddString:str WithOption:opt];
        if ((opt == CalcTypeMultiParameterFunctionStart) && ( calc.doingMultiParEntry)) {
            bracketsbeforeMultiPart = [self closingsBracketsLeft];
            [hlpDrawer open];
        } else if (canClose) [hlpDrawer close];
    }
    if ((bracketsbeforeMultiPart) && (! calc.doingMultiParEntry)) bracketsbeforeMultiPart = 0;
    [self updateParenthesisState];
}
    
         


// Actions for the variable fields.

- (IBAction)toolPreferences:(id)sender {
    // preference_window
    if (_window.contentView == _preference_window) {
        _window.contentView = _main_view;
    } else {
        _window.contentView = _preference_window;
    }
}

- (IBAction)btn_toolbar_log:(id)sender {
    [_printroll_window makeKeyAndOrderFront:sender];
    [_printroll_window setTitle:@"FormulaCalculator printroll"];
}

- (IBAction)edit_x:(id)sender {
   [calc setVariableValue:[var_x stringValue] varName:memory_x];
    [self UpdateDisplay]; 
}

- (IBAction)edit_y:(id)sender {
   [calc setVariableValue:[var_y stringValue] varName:memory_y];
    [self UpdateDisplay]; 
}

- (IBAction)edit_z:(id)sender {
  [calc setVariableValue:[var_z stringValue] varName:memory_z];
    [self UpdateDisplay]; 
}

- (IBAction)edit_a:(id)sender {
   [calc setVariableValue:[var_a stringValue] varName:memory_a];
    [self UpdateDisplay]; 
}

- (IBAction)edit_b:(id)sender {
   [calc setVariableValue:[var_b stringValue] varName:memory_b];
    [self UpdateDisplay]; 
}

- (IBAction)edit_c:(id)sender {
   [calc setVariableValue:[var_c stringValue] varName:memory_c];
    [self UpdateDisplay]; 
}

- (IBAction)edit_d:(id)sender {
    [calc setVariableValue:[var_d stringValue] varName:memory_d];
    [self UpdateDisplay]; 
}

- (IBAction)edit_r:(id)sender {
    [calc setVariableValue:[var_r stringValue] varName:memory_r];
    [self UpdateDisplay]; 
}

- (IBAction)edit_h:(id)sender {
     [calc setVariableValue:[var_h stringValue] varName:memory_h];
    [self UpdateDisplay]; 
}

- (IBAction)edit_w:(id)sender {
    [calc setVariableValue:[var_w stringValue] varName:memory_w];
    [self UpdateDisplay]; 
}

- (IBAction)change_label_x:(id)sender {
    [calc setLabel:[label_x stringValue] variable:memory_x];
}

- (IBAction)change_label_y:(id)sender {
    [calc setLabel:[label_y stringValue] variable:memory_y];
}

- (IBAction)change_label_z:(id)sender {
    [calc setLabel:[label_z stringValue] variable:memory_z];
}

- (IBAction)change_label_a:(id)sender {
    [calc setLabel:[label_a stringValue] variable:memory_a];
}

- (IBAction)change_label_b:(id)sender {
    [calc setLabel:[label_b stringValue] variable:memory_b];
}

- (IBAction)change_label_c:(id)sender {
    [calc setLabel:[label_c stringValue] variable:memory_c];
}

- (IBAction)change_label_d:(id)sender {
    [calc setLabel:[label_d stringValue] variable:memory_d];
}

- (IBAction)change_label_r:(id)sender {
    [calc setLabel:[label_r stringValue] variable:memory_r];
}

- (IBAction)change_label_h:(id)sender {
    [calc setLabel:[label_h stringValue] variable:memory_h];
}

- (IBAction)change_label_w:(id)sender {
    [calc setLabel:[label_w stringValue] variable:memory_w];
}

- (IBAction)clrLabels:(id)sender {
    calcMemoryLocations i;
    
    NSInteger alertmsg = NSRunAlertPanel(@"Clear ALL the variable labels", @"This cannot be undone", @"Yes", @"Cancel", nil);
    
    if (alertmsg == 1) {
        for (i=memory_x; i<memory_w; i++) {
            [calc setLabel:@"" variable:i];
        }
        [label_x setStringValue:@""];
        [label_y setStringValue:@""];
        [label_z setStringValue:@""];
        [label_a setStringValue:@""];
        [label_b setStringValue:@""];
        [label_c setStringValue:@""];
        [label_d setStringValue:@""];
        [label_r setStringValue:@""];
        [label_h setStringValue:@""];
        [label_w setStringValue:@""];
    }
    
}

- (NSInteger) CountOccurencesOf: (NSString*) substr in: (NSString*) string{

    
    NSUInteger count = 0, length = [string length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [string rangeOfString: substr options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++; 
        }
    }
    
   // NSLog(@"Found %li",count);
    return count; 
}


- (IBAction)but_varx:(id)sender {
    if (shiftkey) {[calc updateVariable:memory_x];[self shiftoff];}
    else [self sendButtonMsg:@"x" WithOption:CalcTypeConstant];
    [self UpdateDisplay]; 
}

- (IBAction)but_vary:(id)sender {
    if (shiftkey) {[calc updateVariable:memory_y];[self shiftoff];}
    else [self sendButtonMsg:@"y" WithOption:CalcTypeConstant];
    [self UpdateDisplay]; 
}

- (IBAction)but_varz:(id)sender {
    if (shiftkey) {[calc updateVariable:memory_z];[self shiftoff];}
    else [self sendButtonMsg:@"z" WithOption:CalcTypeConstant];
    [self UpdateDisplay];
}

- (IBAction)but_vara:(id)sender {
    if (shiftkey) {[calc updateVariable:memory_a];[self shiftoff];}
    else [self sendButtonMsg:@"a" WithOption:CalcTypeConstant];
    [self UpdateDisplay];
}

- (IBAction)but_varb:(id)sender {
    if (shiftkey) {[calc updateVariable:memory_b];[self shiftoff];}
    else [self sendButtonMsg:@"b" WithOption:CalcTypeConstant];
    [self UpdateDisplay];
}

- (IBAction)but_varc:(id)sender {
    if (shiftkey) {[calc updateVariable:memory_c];[self shiftoff];}
    else [self sendButtonMsg:@"c" WithOption:CalcTypeConstant];
    [self UpdateDisplay];
}

- (IBAction)but_vard:(id)sender {
    if (shiftkey) {[calc updateVariable:memory_d];[self shiftoff];}
    else [self sendButtonMsg:@"d" WithOption:CalcTypeConstant];
    [self UpdateDisplay];
}

- (IBAction)but_varr:(id)sender {
    if (shiftkey) {[calc updateVariable:memory_r];[self shiftoff];}
    else [self sendButtonMsg:@"r" WithOption:CalcTypeConstant];
    [self UpdateDisplay];
}

- (IBAction)but_varh:(id)sender {
    if (shiftkey) {[calc updateVariable:memory_h];[self shiftoff];}
    else [self sendButtonMsg:@"h" WithOption:CalcTypeConstant];
    [self UpdateDisplay];
}

- (IBAction)but_varw:(id)sender {
    if (shiftkey) {[calc updateVariable:memory_w];[self shiftoff];}
    else [self sendButtonMsg:@"w" WithOption:CalcTypeConstant];
    [self UpdateDisplay];
}


- (BOOL)isTextFieldInFocus:(NSTextField *)textField
{
	BOOL inFocus = NO;
    NSText *editor;
    editor = [textField currentEditor];
    if (editor) {
        
      //  [textField validateEditing];
        [textField abortEditing];
      //  [textField setHidden:YES];
      //  [textField setHidden:NO];
        inFocus = YES; 
    }
	
    /*
	inFocus = ([[[textField window] firstResponder] isKindOfClass:[NSTextView class]]
			   && [[textField window] fieldEditor:NO forObject:nil]!=nil
			   && [textField isEqualTo:(id)[(NSTextView *)[[textField window] firstResponder]delegate]]);
	
    if (inFocus) {
        [textField setHidden:YES];
        [textField setHidden:NO];
    }
    */
	return inFocus;
}

- (BOOL) saveFormulasToFile {
    BOOL ok = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        // Path to save array data
        NSString  *arrayPath = [[paths objectAtIndex:0]
                                stringByAppendingPathComponent:@"functionlib.fulib"];
        
        
        // Write array
       // [functionLib.FuncLib  writeToFile:arrayPath atomically:YES];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:functionLib.FuncLib];
        ok = [data  writeToFile:arrayPath atomically:YES];
        //ok = [NSKeyedArchiver archiveRootObject:functionLib.FuncLib toFile:arrayPath];
    } else ok = NO; 
    return ok; 
}




- (IBAction)btn_go_gengeo:(id)sender {
    NSInteger idx = [pop_geo_gen indexOfSelectedItem];
    // [pop_geo_gen addItemsWithTitles:[NSArray arrayWithObjects:@"Diagonal of rectangle",@"Angle of diagonal", @"Hight of triangle", nil]];
    
    switch (idx) {
        case 0:
            [self sendButtonMsg:@"diagonalRect" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 1:
            [self sendButtonMsg:@"diagonalAngle" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 2:
            [self sendButtonMsg:@"TriangleHeight" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
            
        case 3:
            [self sendButtonMsg:@"GoldenSectionA" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
    
        case 4:
            [self sendButtonMsg:@"polyDiaIC2CC" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
            
        case 5:
            [self sendButtonMsg:@"polyDiaCC2IC" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 6:
            [self sendButtonMsg:@"angleRegPolygon" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 7:
            [self sendButtonMsg:@"polyStarDiaIC2CC" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 8:
            [self sendButtonMsg:@"polyStarDiaCC2IC" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
            
        case 9:
            [self sendButtonMsg:@"QuadraticPlus" WithOption:CalcTypeMultiParameterFunctionStart];
            break;
        case 10:
            [self sendButtonMsg:@"QuadraticMinus" WithOption:CalcTypeMultiParameterFunctionStart];
            break;

          default:
            break;
    }
    [self UpdateDisplay];
}

- (IBAction)btn_go_geoArea:(id)sender {
    NSInteger idx = [pop_geo_area indexOfSelectedItem];
    //  [pop_geo_area addItemsWithTitles:[NSArray arrayWithObjects:@"Area of circle", @"Area of sphere", @"Area of cylinder", @"Area of tube",@"Area of cone",@"Area of pyramide",@"Area of a triangle", nil]];
    
    switch (idx) {
        case 0:
            [self sendButtonMsg:@"circleArea" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 1:
            [self sendButtonMsg:@"sphereArea" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            //TODO
            break;
        case 2:
            [self sendButtonMsg:@"areaCyl" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 3:
            [self sendButtonMsg:@"areaHollowCyl" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 4:
            [self sendButtonMsg:@"areaCone" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 5:
            [self sendButtonMsg:@"areaPyramide" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 6:
            [self sendButtonMsg:@"areaTriangle" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 7:
            [self sendButtonMsg:@"areaEllipse" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 8:
            [self sendButtonMsg:@"areaRegPolygon" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 9:
            [self sendButtonMsg:@"areaRegStarPolygon" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;

            

        default:
            break;
    }
    [self UpdateDisplay];
    
    
}

- (IBAction)btn_go_geoVol:(id)sender {
    NSInteger idx = [pop_geo_vol indexOfSelectedItem];
  //  [pop_geo_vol addItemsWithTitles:[NSArray arrayWithObjects:@"Volume of an box", @"Volume of sphere", @"Volume of cylinder", @"Volume of cone",@"Volume of pyramide", nil]];

    switch (idx) {
        case 0:
            [self sendButtonMsg:@"boxVolume" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            
            break;
        case 1:
            [self sendButtonMsg:@"ballVolume" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 2:
            [self sendButtonMsg:@"cylVolume" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 3:
            [self sendButtonMsg:@"coneVolum" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 4:
            [self sendButtonMsg:@"PyramidVolume" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 5:
            [self sendButtonMsg:@"elipsoidVolume" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;

        default:
            break;
    }
    [self UpdateDisplay];
}

- (IBAction)btn_go_geicirc:(id)sender {
    NSInteger idx = [pop_geo_circ indexOfSelectedItem];
 //   [pop_geo_circ addItemsWithTitles:[NSArray arrayWithObjects:@"Perimeter of circle", @"Perimeter of ellipse", @"Perimeter of regular polygon", @"Perimeter of rectangle",  nil]];

    switch (idx) {
        case 0:
            [self sendButtonMsg:@"perimeterCircle" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 1:
            [self sendButtonMsg:@"perimeterEllipse" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 2:
            [self sendButtonMsg:@"perimeterRegPolygon" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 3:
            [self sendButtonMsg:@"perimeterRectangle" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;

        default:
            break;
    }
    [self UpdateDisplay];
}

- (IBAction)HomeFormulaCalculator:(id)sender {
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://formcalc-osx.com/"]];
    
}

- (IBAction)DocumentationWiki:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://formcalc-osx.com/wiki/"]];
}

- (IBAction)ClickDisplay:(id)sender {
      [self performSelector:@selector(SelectableOn:) withObject:(display) afterDelay:0];
}

- (IBAction)popup_selectFunction:(id)sender {
   // [popup_functionLib addItemsWithTitles:[NSArray arrayWithObjects:@"Select lib", @"Finance", @"Geometry", @"Converers",@"Statistics",@"Currency", nil]];
    
    NSInteger idx = [popup_functionLib indexOfSelectedItem];
    if (currentFunctionLib) {
    
        switch (currentFunctionLib) {
            case 1:
                [drawer_Finance close];
                currentFunctionLib = 0;
                break;
            case 2:
                [drawer_geometry close];
                currentFunctionLib = 0;
                break;
            case 3:
                [drawer_convert close];
                currentFunctionLib = 0;
                break;

                
            default:
                break;
        }
    }
    switch (idx) {
        case 1: // finance
            [drawer_Finance openOnEdge:NSMaxXEdge];
            currentFunctionLib = 1;
            break;
            
        case 2: // geometry
            [drawer_geometry openOnEdge:NSMaxXEdge];
            currentFunctionLib = 2;
            break;
        case 3: // converters
            [drawer_convert openOnEdge:NSMaxXEdge];
            currentFunctionLib = 3;
            break; 
            
        default:
            break;
            
    }

}

- (IBAction)saveAction:(id)sender
{
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    [self todoBeforeSave]; 
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (IBAction) showTheSheet:(id)sender {
    NSString * form=nil;
    NSRange xx;
    [NSApp beginSheet:_editww modalForWindow: [sender window] modalDelegate:self didEndSelector:nil contextInfo:nil];
    
    form = [NSString stringWithString:[calc getCurrentFormula]];
    xx = [form rangeOfString:@"="];
   // NSLog(@"position = %ld", xx.location);
    if (xx.location < 5000)  {
        form = [form substringToIndex:xx.location];
    }
    [editTextField setStringValue: form];
}
    

-(IBAction)endTheSheet:(id)sender {
    [calc SetCurrentFormula:[editTextField stringValue]]; 
    [[NSApplication sharedApplication] endSheet:_editww];
    [_editww orderOut:sender];
    [self UpdateDisplay]; 
    
}

- (void)SelectableOn: (NSTextField*)obj1 {
    [display setHidden:YES];
    [display setHidden:NO];
 }



- (void) UpdateDisplay {
    double res;
    NSString *formula;
    res = [[self calc ]GetResult];
    formula = [[self calc]GetFormulaHistory];
    [_bottom_bar setStringValue:[[self calc]getStatusLine]];
    
    if (! [calc errorflag])
        [ self.toolbar_textDisplay setStringValue: [calc formatNumber:res]];
    else [ self.toolbar_textDisplay setStringValue:@"Error"]; 
    if (formula)
        [ self.display  setStringValue: formula];
    else
        [ self.display setStringValue:@"<empty>"]; 
    
    if ( [calc doingMultiParEntry]) { // help drawe open - huu?
        [self.hlpTitle setStringValue:[[self calc] getHelpInfoTitle]]; 
        [self.hlpInfo setStringValue:[[self calc] getHelpInfoInfo]]; 
    } else if (![calc errorflag])[self.hlpTitle setStringValue:@""];
    else [self.hlpTitle setStringValue:[calc errormessage]];
    
    [self.var_a setStringValue:[calc variableStringValue:memory_a]];
    [self.var_b setStringValue:[calc variableStringValue:memory_b]];
    [self.var_c setStringValue:[calc variableStringValue:memory_c]];
    [self.var_d setStringValue:[calc variableStringValue:memory_d]];
    [self.var_x setStringValue:[calc variableStringValue:memory_x]];
    [self.var_y setStringValue:[calc variableStringValue:memory_y]];
    [self.var_z setStringValue:[calc variableStringValue:memory_z]];
    [self.var_r setStringValue:[calc variableStringValue:memory_r]];
    [self.var_h setStringValue:[calc variableStringValue:memory_h]];
    [self.var_w setStringValue:[calc variableStringValue:memory_w]];
    
    if ([self isTextFieldInFocus:display]) {}
    else if ([self isTextFieldInFocus:topDisplay]){}
    else if ([self isTextFieldInFocus:topStatus]){}
    else if ([self isTextFieldInFocus:var_a]){}
    else if ([self isTextFieldInFocus:var_b]){}
    else if ([self isTextFieldInFocus:var_c]){}
    else if ([self isTextFieldInFocus:var_d]){}
    else if ([self isTextFieldInFocus:var_h]){}
    else if ([self isTextFieldInFocus:var_r]){}
    else if ([self isTextFieldInFocus:var_w]){}
    else if ([self isTextFieldInFocus:var_x]){}
    else if ([self isTextFieldInFocus:var_y]){}
    else if ([self isTextFieldInFocus:var_z]){}

    else if ([self isTextFieldInFocus:label_x]){}
    else if ([self isTextFieldInFocus:label_y]){}
    else if ([self isTextFieldInFocus:label_z]){}
    else if ([self isTextFieldInFocus:label_a]){}
    else if ([self isTextFieldInFocus:label_b]){}
    else if ([self isTextFieldInFocus:label_c]){}
    else if ([self isTextFieldInFocus:label_d]){}
    else if ([self isTextFieldInFocus:label_r]){}
    else if ([self isTextFieldInFocus:label_h]){}
    else if ([self isTextFieldInFocus:label_w]){}
  
    else {} 
    
}

- (void) UpdateTooltip {
    if (shiftkey) {
        [sqrt_btn setToolTip:@"Cubic (3) root - push before number to use it as a function"];
        [ln_btn setToolTip:@"e (2.718281828459) to the power of X"];
        [log_btn setToolTip:@"10 to the power of X"];
        [sin_btn setToolTip:@"arcsin - size angle from ratio of opposite catheter to hypotenuse."];
        [cos_btn setToolTip:@"arccos - size angle from ratio of adjacent catheter to hypotenuse."];
        [tan_btn setToolTip:@"arctan - size angle from ratio of opposite to adjacent catheter."];
        [sinh_btn setToolTip:@"asinh - arcus hyperbolic sine"];
        [cosh_btn setToolTip:@"acosh - arcus hyperbolic cosine"];
        [tanh_btn setToolTip:@"atanh - arcus hyperbolic tangent"];
        
        [but_titx setToolTip:@"Assign to variable 'x' the current result in display"];
        [but_tity setToolTip:@"Assign to  variable 'y' the current result in display"];
        [but_titz setToolTip:@"Assign to  variable 'z' the current result in display"];
        [but_tita setToolTip:@"Assign to  variable 'a' the current result in display"];
        [but_titb setToolTip:@"Assign to  variable 'b' the current result in display"];
        [but_titc setToolTip:@"Assign to  variable 'c' the current result in display"];
        [but_titd setToolTip:@"Assign to  variable 'd' the current result in display"];
        [but_titr setToolTip:@"Assign to  variable 'r' the current result in display"];
        [but_tith setToolTip:@"Assign to  variable 'h' the current result in display"];
        [but_titw setToolTip:@"Assign to  variable 'w' the current result in display"];
        
    } else {
        [sqrt_btn setToolTip:@"Square root - push before number to use it as a function"];
        [ln_btn setToolTip:@"Natural logaritm (base=e : 2.718281828459"];
        [log_btn setToolTip:@"briggs logaritm (base=10)"];
        [sin_btn setToolTip:@"sin of angle x = length ratio: opposing catheter to hypotenuse."];
        [cos_btn setToolTip:@"cos of angle x = length ratio: adjacent catheter to hypotenuse."];
        [tan_btn setToolTip:@"tan of angle x = length ratio: opposite to adjacent catheter"];
        [sinh_btn setToolTip:@"sinh - hyperbolic sine"];
        [cosh_btn setToolTip:@"cosh - hyperbolic cosine"];
        [tanh_btn setToolTip:@"tanh - hyperbolic tangent"];
        
        [but_titx setToolTip:@"Insert variable 'x' into your formula"];
        [but_tity setToolTip:@"Insert variable 'y' into your formula"];
        [but_titz setToolTip:@"Insert variable 'z' into your formula"];
        [but_tita setToolTip:@"Insert variable 'a' into your formula"];
        [but_titb setToolTip:@"Insert variable 'b' into your formula"];
        [but_titc setToolTip:@"Insert variable 'c' into your formula"];
        [but_titd setToolTip:@"Insert variable 'd' into your formula"];
        [but_titr setToolTip:@"Insert variable 'r' into your formula"];
        [but_tith setToolTip:@"Insert variable 'h' into your formula"];
        [but_titw setToolTip:@"Insert variable 'w' into your formula"];

    }
}



- (void) shiftoff {
    [sqrt_btn setTitle:@"sqrt"];
    [sqrt_btn setToolTip:@"Square root - push before number to use it as a function"];
    [ln_btn setTitle:@"ln"];
    [ln_btn setToolTip:@"Natural logaritm"];
    [log_btn setTitle:@"log"];
    [sin_btn setTitle:@"sin"];
    [cos_btn setTitle:@"cos"];
    [tan_btn setTitle:@"tan"];
    [sinh_btn setTitle:@"sinh"];
    [cosh_btn setTitle:@"cosh"];
    [tanh_btn setTitle:@"tanh"];
    
    
    [but_titx setTitle:@"x"];
    [but_tity setTitle:@"y"];
    [but_titz setTitle:@"z"];
    [but_tita setTitle:@"a"];
    [but_titb setTitle:@"b"];
    [but_titc setTitle:@"c"];
    [but_titd setTitle:@"d"];
    [but_titr setTitle:@"r"];
    [but_tith setTitle:@"h"];
    [but_titw setTitle:@"w"];
    [factBtn setTitle:@"x !"];
     
    shiftkey = NO;
    [shftKey setState:NO];
    [ self UpdateTooltip]; 
}

- (void) shifton {
    [sqrt_btn setTitle:@"cbrt"];
    [ln_btn setTitle:@"e^x"];
    [log_btn setTitle:@"10^x"];
    [sin_btn setTitle:@"arcsin"];
    [cos_btn setTitle:@"arccos"];
    [tan_btn setTitle:@"arctan"];
    [sinh_btn setTitle:@"asinh"];
    [cosh_btn setTitle:@"acosh"];
    [tanh_btn setTitle:@"atanh"];
    
    [but_titx setTitle:@"->x"];
    [but_tity setTitle:@"->y"];
    [but_titz setTitle:@"->z"];
    [but_tita setTitle:@"->a"];
    [but_titb setTitle:@"->b"];
    [but_titc setTitle:@"->c"];
    [but_titd setTitle:@"->d"];
    [but_titr setTitle:@"->r"];
    [but_tith setTitle:@"->h"];
    [but_titw setTitle:@"->w"];
    [factBtn setTitle:@"ddx..w"];
    
    shiftkey = YES;
    [shftKey setState:YES];
    [ self UpdateTooltip]; 
}

- (IBAction)btnOne:(id)sender {
    [self sendButtonMsg:@"1" WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}

- (IBAction)btnTwo:(id)sender {
    [self sendButtonMsg:@"2" WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}

- (IBAction)btnThree:(id)sender {
    [self sendButtonMsg:@"3" WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}

- (IBAction)btnFour:(id)sender {
    [self sendButtonMsg:@"4" WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}

- (IBAction)btnFive:(id)sender {
    [self sendButtonMsg:@"5" WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}

- (IBAction)btnSix:(id)sender {
    [self sendButtonMsg:@"6" WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}

- (IBAction)btnSeven:(id)sender {
    [self sendButtonMsg:@"7" WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}

- (IBAction)btnEigth:(id)sender {
    [self sendButtonMsg:@"8" WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}

- (IBAction)btnNine:(id)sender {
    [self sendButtonMsg:@"9" WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}

- (IBAction)btnZero:(id)sender {
    [self sendButtonMsg:@"0" WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}

- (IBAction)btnComma:(id)sender {
    [self sendButtonMsg:@"." WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}

- (IBAction)btnPlus:(id)sender {
  
        [self sendButtonMsg:@"+" WithOption:CalcTypeOperator];
        [self UpdateDisplay];
}

- (IBAction)btnMinus:(id)sender {
    [self sendButtonMsg:@"-" WithOption:CalcTypeOperator];
    [self UpdateDisplay];
}

- (IBAction)btnMultiply:(id)sender {
    [self sendButtonMsg:@"*" WithOption:CalcTypeOperator];
    [self UpdateDisplay];
}

- (IBAction)btnDivide:(id)sender {
    [self sendButtonMsg:@"/" WithOption:CalcTypeOperator];
    [self UpdateDisplay];
}

- (void) sendToPrintRoll: (NSString*)str {
    NSMutableString * proll = [NSMutableString stringWithString:[printroll_view string]];
    [proll appendString:str];
    
    [proll appendString:@"\n"];
    roll.printRollText = proll;
    [ self.printroll_view  setString:roll.printRollText];
}

- (IBAction)btnEqual:(id)sender {
    
    
    [self sendButtonMsg:@"=" WithOption:CalcTypeEqualSign];
    [self UpdateDisplay];
    if ([checkIncludeDoc state]) {
     // ask the calculator for documentation of used functions. 
        [ self sendToPrintRoll:[calc getUsedFunctionDocumentation]];
    }
    if ( calc.errorflag )
        [ self sendToPrintRoll:[NSString stringWithFormat:@"The calculation resulted in error: %@\n", calc.errormessage]];
    

    [ self sendToPrintRoll:calc.history];
    if (!([calc.wherehistory isEqualToString:@""])) {
        [ self sendToPrintRoll:calc.wherehistory];
    }
}

- (IBAction)btn_e:(id)sender {
    [self sendButtonMsg:@"e" WithOption:CalcTypeConstant];
    [self UpdateDisplay];
}

- (IBAction)btn_pi:(id)sender {
    [self sendButtonMsg:@"pi" WithOption:CalcTypeConstant];
    [self UpdateDisplay];
}

- (IBAction)btnClear:(id)sender {
    [self.calc clearNumber];
    [self updateParenthesisState]; 
    [self UpdateDisplay];
}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
    NSLog (@"control %@", control); 
    return NO;
    
}

- (void)controlDidBecomeFirstResponder:(NSResponder *)responder
{
    NSLog(@"controlDidBecomeFirstResponder"); 
    //self.focusedTextField = (NSTextField*) responder;
}

- (IBAction)btn_AllClear:(id)sender {
    double mem = [calc memoryValue];
    [self.calc clearAll];
    derivativeEntry = FALSE; 
    [calc setMemory:mem];
    [hlpDrawer close];
    [rightbracketkey setEnabled:NO];
    [rightbracketkey setTitle:@")"];
    [rightbracketkey setToolTip:@"No opening brackets to match"];
    bracketsbeforeMultiPart = 0; 
    [self UpdateDisplay];
   // [self sendToPrintRoll:@"(All Clear)\n"];
}

- (IBAction)btn_pow:(id)sender {
    [self sendButtonMsg:@"^" WithOption:CalcTypeOperator];
    [self UpdateDisplay];
}

- (IBAction)btn_leftpar:(id)sender {
    [self sendButtonMsg:@"(" WithOption:CalcTypeLeftParenthesis];
    [self UpdateDisplay];
}

- (IBAction)btn_rightpar:(id)sender {
    [self sendButtonMsg:@")" WithOption:CalcTypeRightParenthesis];
    [self UpdateDisplay];
}

- (IBAction)btn_percent:(id)sender {
    [self sendButtonMsg:@"%" WithOption:CalcTypeOperator];
    [self UpdateDisplay];
}

- (IBAction)btn_1x:(id)sender {
    [self sendButtonMsg:@"1/" WithOption:CalcTypeInsertOperator];
    [self UpdateDisplay];

}

- (IBAction)btn_sqrt:(id)sender {
    if (shiftkey) {[self sendButtonMsg:@"cbrt" WithOption:CalcTypeFunction];[self shiftoff];}
    else    [self sendButtonMsg:@"sqrt" WithOption:CalcTypeFunction];
    [self UpdateDisplay];

}

- (IBAction)btn_pow2:(id)sender {
    [self sendButtonMsg:@"^2" WithOption:CalcTypeOperator];
    [self UpdateDisplay];
}

- (IBAction)btn_pow3:(id)sender {
    [self sendButtonMsg:@"^3" WithOption:CalcTypeOperator];
    [self UpdateDisplay];
}

- (IBAction)btn_ln:(id)sender {
    if (shiftkey) {[self sendButtonMsg:@"e^" WithOption:CalcTypeInsertOperator];[self shiftoff];}
    else [self sendButtonMsg:@"ln" WithOption:CalcTypeFunction];
    [self UpdateDisplay];
}

- (IBAction)btn_log10:(id)sender {
    if (shiftkey) {[self sendButtonMsg:@"10^" WithOption:CalcTypeInsertOperator];[self shiftoff];}
    else [self sendButtonMsg:@"log" WithOption:CalcTypeFunction];
    [self UpdateDisplay];
}

- (IBAction)btn_sin:(id)sender {
    if (shiftkey) {[self sendButtonMsg:@"arcsin" WithOption:CalcTypeFunction];[self shiftoff];}
    else [self sendButtonMsg:@"sin" WithOption:CalcTypeFunction];
    [self UpdateDisplay];
}

- (IBAction)btn_cos:(id)sender {
    if (shiftkey) {[self sendButtonMsg:@"arccos" WithOption:CalcTypeFunction];[self shiftoff];}
    else [self sendButtonMsg:@"cos" WithOption:CalcTypeFunction];
    [self UpdateDisplay];
}

- (IBAction)btn_tan:(id)sender {
    if (shiftkey) {[self sendButtonMsg:@"arctan" WithOption:CalcTypeFunction];[self shiftoff];}
    else [self sendButtonMsg:@"tan" WithOption:CalcTypeFunction];
    [self UpdateDisplay];
}

- (IBAction)btn_sinh:(id)sender {
    if (shiftkey) {[self sendButtonMsg:@"arcsinh" WithOption:CalcTypeFunction];[self shiftoff];}
    else [self sendButtonMsg:@"sinh" WithOption:CalcTypeFunction];
    [self UpdateDisplay];
}

- (IBAction)btn_cosh:(id)sender {
    if (shiftkey) {[self sendButtonMsg:@"arccosh" WithOption:CalcTypeFunction];[self shiftoff];}
    else [self sendButtonMsg:@"cosh" WithOption:CalcTypeFunction];
    [self UpdateDisplay];
}

- (IBAction)btn_tanh:(id)sender {
    if (shiftkey) {[self sendButtonMsg:@"arctanh" WithOption:CalcTypeFunction];[self shiftoff];}
    else [self sendButtonMsg:@"tanh" WithOption:CalcTypeFunction];
    [self UpdateDisplay];
}

- (IBAction)btn_fact:(id)sender {
    if (shiftkey) {
        [self.hlpTitle setStringValue:@"Push variable used in derivative function (x)!!"];
        [self shiftoff];
        if ([var_drawer state] == NSDrawerClosedState) {
            [var_drawer openOnEdge:NSMinXEdge]; // NSMaxXEdge = right edge.
        }
        derivativeEntry = YES; 
    } else {
        [self sendButtonMsg:@"fact" WithOption:CalcTypeFunction];
        [self UpdateDisplay];
    }
}

- (IBAction)btn_shift:(id)sender {
    if (shiftkey) [self shiftoff];
    else [self shifton]; 
}

- (IBAction)btn_chsign:(id)sender {
    [self sendButtonMsg:@"-" WithOption:CalcTypeChangeSign];
    [self UpdateDisplay];
}

- (IBAction)btn_memplus:(id)sender {
    [calc memoryAdd];
     [self UpdateDisplay];
}

- (IBAction)btn_memclear:(id)sender {
    [calc memoryClear];
    [self UpdateDisplay];
}

- (IBAction)btn_memminus:(id)sender {
    [calc memorySubtract];
    [self UpdateDisplay];
}

- (IBAction)mem_save:(id)sender {
    [calc save2memory];
    [self UpdateDisplay];
}

- (IBAction)btn_memrecall:(id)sender {
    [calc recallMemory];
    [self UpdateDisplay];
}

- (IBAction)btn_EE:(id)sender {
    [self sendButtonMsg:@"e" WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}

- (IBAction)in2cm:(id)sender {
    [self sendButtonMsg:@"in2cm" WithOption:CalcTypeFunction];
    [self UpdateDisplay];
}

- (IBAction)cm2in:(id)sender {
    
    [self sendButtonMsg:@"cm2in" WithOption:CalcTypeFunction];
    [self UpdateDisplay];
}

- (IBAction)btn_c2f:(id)sender {
    [self sendButtonMsg:@"c2f" WithOption:CalcTypeFunction];
    [self UpdateDisplay];
}

- (IBAction)btnLengthUnits:(id)sender {
  /*  [lengthUnitPop addItemsWithTitles:[NSArray arrayWithObjects:
                                       @"Inches to Centimeters",//0
                                       @"Chain to Meters",//1
                                       @"fathom to Meters",//2
                                       @"furlong to Meters",//3
                                       @"leage to Meters",//4
                                       @"light year to Meters",//5
                                       @"Centimeter to Inches",//6
                                       @"Meters to Chain",//7
                                       @"Meters to fathom",//8
                                       @"Meters to furlong",//9
                                       @"Meters to leage",//10
                                       @"Meters to light year",//11
   @"Angstrom to Meters", //12
   @"Astronomical unit to Meters",//13
   @"Meters to Angstrom", //14
   @"Meters to Astronomical unit",//15
                                       nil]];
   
   */
    NSInteger idx = [lengthUnitPop indexOfSelectedItem];

    switch (idx) {
        case 0:
            [self sendButtonMsg:@"in2cm" WithOption:CalcTypeFunction]; 
            break;
        case 1:
            [self sendButtonMsg:@"chain2m" WithOption:CalcTypeFunction];
            break;
        case 2:
            [self sendButtonMsg:@"fathom2m" WithOption:CalcTypeFunction];
            break;
        case 3:
            [self sendButtonMsg:@"furlong2m" WithOption:CalcTypeFunction];
            break;
        case 4:
            [self sendButtonMsg:@"leage2m" WithOption:CalcTypeFunction];
            break;
        case 5:
            [self sendButtonMsg:@"lighty2m" WithOption:CalcTypeFunction];
            break;
        case 6:
            [self sendButtonMsg:@"cm2in" WithOption:CalcTypeFunction];
            break;
        case 7:
            [self sendButtonMsg:@"m2chain" WithOption:CalcTypeFunction];
            break;
        case 8:
            [self sendButtonMsg:@"m2fathom" WithOption:CalcTypeFunction];
            break;
        case 9:
            [self sendButtonMsg:@"m2furlong" WithOption:CalcTypeFunction];
            break;
        case 10:
            [self sendButtonMsg:@"m2leage" WithOption:CalcTypeFunction];
            break;
        case 11:
            [self sendButtonMsg:@"m2lighty" WithOption:CalcTypeFunction];
            break;
        case 12:
            [self sendButtonMsg:@"angstrom2m" WithOption:CalcTypeFunction];
            break;
        case 13:
            [self sendButtonMsg:@"au2m" WithOption:CalcTypeFunction];
            break;
        case 14:
            [self sendButtonMsg:@"m2angstrom" WithOption:CalcTypeFunction];
            break;
        case 15:
            [self sendButtonMsg:@"m2au" WithOption:CalcTypeFunction];
            break;

        default:
            break;
        }
    [self UpdateDisplay];
}

- (IBAction)btnVolumeUnits:(id)sender {
    /*  
     @"fluid dram (fl dr) to milliLiter(ml)",//0
     @"fluid ounce (fl oz) to Liter(l)",//1
     @"fluid ounce (UK)(fl oz) to Liter(l)",//2
     @"gallon (gal) to Liter(l)",//3
     @"gallon (UK)(gal) to Liter(l)",//4
     @"gill to Liter(l)",//5
     @"peck (US dry) (pk) to Liter (l)",//6
     @"pint (liquid) (pt) to Liter (l)",//7
     @"pint (UK) (pt) to Liter (l)",//8
     @"pint (US dry) (pt) to Liter (l)",//9
     @"quart (liquid) (qt) to Liter (l)",//10
     @"quart (UK) (qt) to Liter (l)",//11
     @"quart (US dry) (qt) to Liter (l)",//12
     
     @"milliLiter(ml) to fluid dram (fl dr)",//13
     @"Liter(l) to fluid ounce (fl oz)",//14
     @"Liter(l) to fluid ounce (UK)(fl oz)",//15
     @"Liter(l) to gallon (gal)",//16
     @"Liter(l) to gallon (UK)(gal)",//17
     @"Liter(l) to gill",//18
     @"Liter(l) to peck (US dry) (pk)",//19
     @"Liter(l) to pint (liquid) (pt)",//20
     @"Liter(l) to pint (UK) (pt)",//21
     @"Liter(l) to pint (US dry) (pt)",//22
     @"Liter(l) to quart (liquid) (qt)",//23
     @"Liter(l) to quart (UK) (qt)",//24
     @"Liter(l) to quart (US dry) (qt)",//25

     
     
     */
    NSInteger idx = [volumUnitsPop indexOfSelectedItem];
    
    switch (idx) {
        case 0:
            [self sendButtonMsg:@"fldr2ml" WithOption:CalcTypeFunction];
            break;
        case 1:
            [self sendButtonMsg:@"floz2l" WithOption:CalcTypeFunction];
            break;
        case 2:
            [self sendButtonMsg:@"UKfloz2l" WithOption:CalcTypeFunction];
            break;
        case 3:
            [self sendButtonMsg:@"gal2l" WithOption:CalcTypeFunction];
            break;
        case 4:
            [self sendButtonMsg:@"UKgal2l" WithOption:CalcTypeFunction];
            break;

        case 5:
            [self sendButtonMsg:@"gill2l" WithOption:CalcTypeFunction];
            break;
        case 6:
            [self sendButtonMsg:@"USdryPk2l" WithOption:CalcTypeFunction];
            break;
        case 7:
            [self sendButtonMsg:@"pt2l" WithOption:CalcTypeFunction];
            break;
        case 8:
            [self sendButtonMsg:@"UKpt2l" WithOption:CalcTypeFunction];
            break;
        case 9:
            [self sendButtonMsg:@"USdryPt2l" WithOption:CalcTypeFunction];
            break;
        case 10:
            [self sendButtonMsg:@"qt2l" WithOption:CalcTypeFunction];
            break;
        case 11:
            [self sendButtonMsg:@"UKqt2l" WithOption:CalcTypeFunction];
            break;
        case 12:
            [self sendButtonMsg:@"USdryQt2l" WithOption:CalcTypeFunction];
            break;
        case 13:
            [self sendButtonMsg:@"ml2fldr" WithOption:CalcTypeFunction];
            break;
        case 14:
            [self sendButtonMsg:@"l2floz" WithOption:CalcTypeFunction];
            break;
        case 15:
            [self sendButtonMsg:@"l2UKfloz" WithOption:CalcTypeFunction];
            break;
        case 16:
            [self sendButtonMsg:@"l2gal" WithOption:CalcTypeFunction];
            break;
        case 17:
            [self sendButtonMsg:@"l2UKgal" WithOption:CalcTypeFunction];
            break;
        case 18:
            [self sendButtonMsg:@"l2gill" WithOption:CalcTypeFunction];
            break;
        case 19:
            [self sendButtonMsg:@"l2USdryPk" WithOption:CalcTypeFunction];
            break;
        case 20:
            [self sendButtonMsg:@"l2pt" WithOption:CalcTypeFunction];
            break;
        case 21:
            [self sendButtonMsg:@"l2UKpt" WithOption:CalcTypeFunction];
            break;
        case 22:
            [self sendButtonMsg:@"l2USdryPt" WithOption:CalcTypeFunction];
            break;
        case 23:
            [self sendButtonMsg:@"l2qt" WithOption:CalcTypeFunction];
            break;
        case 24:
            [self sendButtonMsg:@"l2UKqt" WithOption:CalcTypeFunction];
            break;
        case 25:
            [self sendButtonMsg:@"l2USdryQt" WithOption:CalcTypeFunction];
            break;


        default:
            break;
    }
    [self UpdateDisplay];
}

- (IBAction)btn_TempUnits:(id)sender {
    /*  
     
     [tempUnitsPop addItemsWithTitles:[NSArray arrayWithObjects:
     @"Celcius to Farenheit",
     @"Farenheit to Celcius",
     @"Celcius to Kelvin",
     @"Farenheit to Kelvin",
     @"Kelvin to Celcius",
     @"Kelvin to Farenheit", nil]];

     */
    NSInteger idx = [tempUnitsPop indexOfSelectedItem];
    
    switch (idx) {
        case 0:
            [self sendButtonMsg:@"c2f" WithOption:CalcTypeFunction];
            break;
        case 1:
            [self sendButtonMsg:@"f2c" WithOption:CalcTypeFunction];
            break;
        case 2:
            [self sendButtonMsg:@"c2k" WithOption:CalcTypeFunction];
            break;
        case 3:
            [self sendButtonMsg:@"f2k" WithOption:CalcTypeFunction];
            break;
        case 4:
            [self sendButtonMsg:@"k2c" WithOption:CalcTypeFunction];
            break;
        case 5:
            [self sendButtonMsg:@"k2f" WithOption:CalcTypeFunction];
            break;
        
        default:
            break;
    }
    [self UpdateDisplay];

}

- (IBAction)btn_WeightUnit:(id)sender {
    
        /*
         [weightUnitPop addItemsWithTitles:[NSArray arrayWithObjects:
         @"atomic mass unit (amu) to gram(g)",//0
         @"carat (metric) to gram (g)",//1
         @"cental to kilogram (kg)",//2
         @"dram (dr) to gram (g)",//3
         @"grain (gr) to gram (g)",//4
         @"hundredweight (UK) to kilogram (kg)",//5
         @"newton (earth) to kilogram (kg)",//6
         @"ounce (oz) to gram (g)",//7
         @"pennyweight (dwt) to gram (g)",//8
         @"pound (lb) to kilogram (kg)",//9
         @"quarter to kilogram (kg)",//10
         @"stone to kilogram (kg)",//11
         @"troy ounce to gram (g)",//12
         
         @"gram(g) to atomic mass unit (amu)",//13
         @"gram(g) to carat (metric)",//14
         @"kilogram (kg) to cental",//15
         @"gram(g) to dram (dr)",//16
         @"gram(g) to grain (gr)",//17
         @"kilogram (kg) to hundredweight (UK)",//18
         @"kilogram (kg) to newton (earth)",//19
         @"gram(g) to ounce (oz)",//20
         @"gram(g) to pennyweight (dwt)",//21
         @"kilogram (kg) to pound (lb)",//22
         @"kilogram (kg) to quarter",//23
         @"kilogram (kg) to stone",//24
         @"gram(g) to troy ounce",//25
         nil]];

     
     
     */
    NSInteger idx = [weightUnitPop indexOfSelectedItem];
    
    switch (idx) {
        case 0:
            [self sendButtonMsg:@"amu2g" WithOption:CalcTypeFunction];
            break;
        case 1:
            [self sendButtonMsg:@"carat2g" WithOption:CalcTypeFunction];
            break;
        case 2:
            [self sendButtonMsg:@"cental2kg" WithOption:CalcTypeFunction];
            break;
        case 3:
            [self sendButtonMsg:@"dram2g" WithOption:CalcTypeFunction];
            break;
        case 4:
            [self sendButtonMsg:@"grain2g" WithOption:CalcTypeFunction];
            break;
        case 5:
            [self sendButtonMsg:@"hundredwt2kg" WithOption:CalcTypeFunction];
            break;

            
        case 6:
            [self sendButtonMsg:@"N2kg" WithOption:CalcTypeFunction];
            break;
        case 7:
            [self sendButtonMsg:@"oz2g" WithOption:CalcTypeFunction];
            break;
        case 8:
            [self sendButtonMsg:@"dwt2g" WithOption:CalcTypeFunction];
            break;
        case 9:
            [self sendButtonMsg:@"lb2kg" WithOption:CalcTypeFunction];
            break;
        case 10:
            [self sendButtonMsg:@"quarter2kg" WithOption:CalcTypeFunction];
            break;
        case 11:
            [self sendButtonMsg:@"stone2kg" WithOption:CalcTypeFunction];
            break;
        case 12:
            [self sendButtonMsg:@"troyOz2g" WithOption:CalcTypeFunction];
            break;
        case 13:
            [self sendButtonMsg:@"g2amu" WithOption:CalcTypeFunction];
            break;
        case 14:
            [self sendButtonMsg:@"g2carat" WithOption:CalcTypeFunction];
            break;
        case 15:
            [self sendButtonMsg:@"kg2cental" WithOption:CalcTypeFunction];
            break;
        case 16:
            [self sendButtonMsg:@"g2dram" WithOption:CalcTypeFunction];
            break;
        case 17:
            [self sendButtonMsg:@"g2grain" WithOption:CalcTypeFunction];
            break;
        case 18:
            [self sendButtonMsg:@"kg2hundredwt" WithOption:CalcTypeFunction];
            break;
        case 19:
            [self sendButtonMsg:@"kg2N" WithOption:CalcTypeFunction];
            break;
        case 20:
            [self sendButtonMsg:@"g2oz" WithOption:CalcTypeFunction];
            break;
        case 21:
            [self sendButtonMsg:@"g2dwt" WithOption:CalcTypeFunction];
            break;
        case 22:
            [self sendButtonMsg:@"kg2lb" WithOption:CalcTypeFunction];
            break;
        case 23:
            [self sendButtonMsg:@"kg2quarter" WithOption:CalcTypeFunction];
            break;
        case 24:
            [self sendButtonMsg:@"kg2stone" WithOption:CalcTypeFunction];
            break;
        case 25:
            [self sendButtonMsg:@"g2troyoz" WithOption:CalcTypeFunction];
            break;
                 
            
        default:
            break;
    }
    [self UpdateDisplay];
    
    
    
}


- (IBAction)next:(id)sender {
    if (![calc doingMultiParEntry]) {
        NSInteger cnt = [self closingsBracketsLeft];
        if (cnt) [self sendButtonMsg:@")" WithOption:CalcTypeRightParenthesis];
        else [self sendButtonMsg:@";" WithOption:CalcTypeMultiParameterFunctionNext];
    } else [self sendButtonMsg:@";" WithOption:CalcTypeMultiParameterFunctionNext]; 
    [self UpdateDisplay];
    // if (! [calc doingMultiParEntry]) [hlpDrawer close];
}



- (IBAction)btn_go_annuity:(id)sender {
    NSInteger idx = [popup_annuity indexOfSelectedItem];
    
    switch (idx) {
        case 0:
            [self sendButtonMsg:@"PaymentAnnuityLoan" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 1:
            [self sendButtonMsg:@"YearAnnuityLoan" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 2:
            [self sendButtonMsg:@"InterestRateAnnuityLoan" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 3:
            [self sendButtonMsg:@"BalanceAnnuityLoan" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;

        case 4:
            [self sendButtonMsg:@"PaymentBallonLoan" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
            
        case 5:
            [self sendButtonMsg:@"annuityLoanValue" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
            
            
            
        default:
            break;
    }
    [self UpdateDisplay];
    
}

- (IBAction)btn_000:(id)sender {
    [self sendButtonMsg:@"000" WithOption:CalcTypeNumber];
    [self UpdateDisplay];
}


- (IBAction)btn_interest:(id)sender {
    
    NSInteger idx = [popup_interest indexOfSelectedItem];
    
    switch (idx) {
        case 0:
            [self sendButtonMsg:@"FutureValueOfDeposit" WithOption:CalcTypeMultiParameterFunctionStart]; 
            break;
        case 1:
            [self sendButtonMsg:@"InterestPVFV" WithOption:CalcTypeMultiParameterFunctionStart];
            break;
        case 2:
            [self sendButtonMsg:@"YearsToFutureValue" WithOption:CalcTypeMultiParameterFunctionStart]; 
            break;
        case 3:
            [self sendButtonMsg:@"PresentValue" WithOption:CalcTypeMultiParameterFunctionStart];
            break;
        case 4:
            [self sendButtonMsg:@"CompoundInterest" WithOption:CalcTypeMultiParameterFunctionStart];
            break;
            
        default:
            break;
    }

    [self UpdateDisplay];

}

- (IBAction)btn_FVSavings:(id)sender {
    
    NSInteger idx = [popup_savings indexOfSelectedItem];
    
    switch (idx) {
        case 0:
            [self sendButtonMsg:@"FutureValueOfSavings" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
        case 1:
            [self sendButtonMsg:@"PaymentSavings" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
    /*    case 1:
            [self sendButtonMsg:@"InterestNeededForSavings" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break; */
        case 2:
            [self sendButtonMsg:@"SavingsYearsToTarget" WithOption:CalcTypeMultiParameterFunctionStart]; // multi parameter functions = 10.
            break;
      
    
        default:
            break;
    }

    [self UpdateDisplay];
}

- (void) todoBeforeSave {
    // Save changes in the application's managed object context before the application terminates.
    roll.printRollText =[NSMutableString stringWithString:[printroll_view string]];
    currentFormula.string =calc.formula;
    currententry.string = calc.entry;
    ValueStore *vx = [memoryValues objectForKey:@"current_x"];
    vx.string = [NSString stringWithFormat:@"%.10lg", calc.mem_x];
    ValueStore *vy = [memoryValues objectForKey:@"current_y"];
    vy.string = [NSString stringWithFormat:@"%.10lg", calc.mem_y];
    ValueStore *vz = [memoryValues objectForKey:@"current_z"];
    vz.string = [NSString stringWithFormat:@"%.10lg", calc.mem_z];
    ValueStore *va = [memoryValues objectForKey:@"current_a"];
    va.string = [NSString stringWithFormat:@"%.10lg", calc.mem_a];
    ValueStore *vb = [memoryValues objectForKey:@"current_b"];
    vb.string = [NSString stringWithFormat:@"%.10lg", calc.mem_b];
    ValueStore *vc = [memoryValues objectForKey:@"current_c"];
    vc.string = [NSString stringWithFormat:@"%.10lg", calc.mem_c];
    ValueStore *vd = [memoryValues objectForKey:@"current_d"];
    vd.string = [NSString stringWithFormat:@"%.10lg", calc.mem_d];
    ValueStore *vr = [memoryValues objectForKey:@"current_r"];
    vr.string = [NSString stringWithFormat:@"%.10lg", calc.mem_r];
    ValueStore *vh = [memoryValues objectForKey:@"current_h"];
    vh.string = [NSString stringWithFormat:@"%.10lg", calc.mem_h];
    ValueStore *vw = [memoryValues objectForKey:@"current_w"];
    vw.string = [NSString stringWithFormat:@"%.10lg", calc.mem_w];
    ValueStore *vm = [memoryValues objectForKey:@"current_m"];
    vm.string = [NSString stringWithFormat:@"%.10lg", calc.memory];
    
    ValueStore *lx = [variableLabels objectForKey:@"label_x"];
    lx.string = [NSString stringWithString:calc.cLabel_x];
    ValueStore *ly = [variableLabels objectForKey:@"label_y"];
    ly.string = [NSString stringWithString:calc.cLabel_y];
    ValueStore *lz = [variableLabels objectForKey:@"label_z"];
    lz.string = [NSString stringWithString:calc.cLabel_z];
    ValueStore *la = [variableLabels objectForKey:@"label_a"];
    la.string = [NSString stringWithString:calc.cLabel_a];
    ValueStore *lb = [variableLabels objectForKey:@"label_b"];
    lb.string = [NSString stringWithString:calc.cLabel_b];
    ValueStore *lc = [variableLabels objectForKey:@"label_c"];
    lc.string = [NSString stringWithString:calc.cLabel_c];
    ValueStore *ld = [variableLabels objectForKey:@"label_d"];
    ld.string = [NSString stringWithString:calc.cLabel_d];
    ValueStore *lr = [variableLabels objectForKey:@"label_r"];
    lr.string = [NSString stringWithString:calc.cLabel_r];
    ValueStore *lh = [variableLabels objectForKey:@"label_h"];
    lh.string = [NSString stringWithString:calc.cLabel_h];
    ValueStore *lw = [variableLabels objectForKey:@"label_w"];
    lw.string = [NSString stringWithString:calc.cLabel_w];


}


- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    [self todoBeforeSave];
    if (standardUserDefaults) {
        [standardUserDefaults synchronize];
    }
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

- (IBAction)undo:(id)sender {

    
}




- (IBAction)paste:(id)sender {
    NSInteger cnt; 
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classArray = [NSArray arrayWithObject:[NSString class]];
    NSDictionary *options = [NSDictionary dictionary];
    
    BOOL ok = [pasteboard canReadObjectForClasses:classArray options:options];
    if (ok) {
        NSArray *objectsToPaste = [pasteboard readObjectsForClasses:classArray options:options];
        cnt = [objectsToPaste count];
        if (cnt) {
            NSString *text = [objectsToPaste objectAtIndex:0];
            if (text) {
                [self sendButtonMsg:text WithOption:CalcTypeArbitaryText];
                [ self UpdateDisplay]; 
            }
        }
    }
}
- (IBAction)btn_clearPrintRoll:(id)sender {
    //[PrintRollText setString:@""];
    [ self.printroll_view  setString:@""];
    [ self sendToPrintRoll:@"- Printroll cleared -\n"]; 
}

- (IBAction)btn_SavePrintroll:(id)sender {
}

- (IBAction)btn_hidePrintRoll:(id)sender {
    [_printroll_window orderOut:sender];
}

- (IBAction)btn_roll:(id)sender {
    
    [_printroll_window makeKeyAndOrderFront:sender];
    [_printroll_window setTitle:@"FormulaCalculator printroll"];
    
}
- (IBAction)btnVarDraver:(id)sender {
    if ([var_drawer state] == NSDrawerOpenState) {
        [var_drawer close];
    } else if ([var_drawer state] == NSDrawerClosedState) {
        [var_drawer openOnEdge:NSMinXEdge]; // NSMaxXEdge = right edge.
    }
}
- (IBAction)CalcPreferences:(id)sender {
    // preference_window
    if (_window.contentView == _preference_window) {
        _window.contentView = StoredMainView;
        [self updateConstPopup]; 
    } else {
        StoredMainView = _window.contentView; 
        _window.contentView = _preference_window;
        
    }
    
    NSMutableString *url = [NSMutableString stringWithString:[[self applicationFilesDirectory]description]];
    [url appendString:@"FormulaCalculatorXML.storedata"];
    [url replaceCharactersInRange:[url rangeOfString:@"%20"] withString:@" "];
    [url replaceCharactersInRange:[url rangeOfString:@"file://localhost"] withString:@""];

    [StoreFileLocation setStringValue:url];
    
    
    
}
@end
