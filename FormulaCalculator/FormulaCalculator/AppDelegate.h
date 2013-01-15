//
//  AppDelegate.h
//  FormulaCalculator
//
//  Created by Ole Kristian Ek Hornnes on 10/19/12.
//  Copyright (c) 2012 Ole Kristian Ek Hornnes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Calculator.h"
#import "FunctionLibrary.h"
#import "PrintRoll.h"
#import "ValueStore.h"
#import "ConstCategories.h"
#import "Constants.h"
#import "RDTransformer.h"
#import "VTOneTokenTransformer.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate>
@property (unsafe_unretained) IBOutlet NSWindow *printroll_window;

@property (unsafe_unretained) IBOutlet NSTextView *printroll_view;
- (IBAction)btn_clearPrintRoll:(id)sender;
- (IBAction)btn_SavePrintroll:(id)sender;
- (IBAction)btn_hidePrintRoll:(id)sender;
- (IBAction)btn_roll:(id)sender;
@property (weak) IBOutlet NSView *preference_window;
@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *main_view;
@property NSView *StoredMainView; 
@property (weak) IBOutlet NSTableColumn *prefTableValueColumn;

@property PrintRoll *roll;
@property NSStatusBar *statusBar;
@property ValueStore *currentFormula;
@property ValueStore *currententry;
@property NSDictionary *memoryValues;
@property NSDictionary *variableLabels;
@property ValueStore *prefDP;
@property ValueStore *prefNumFormat;
@property BOOL derivativeEntry;

@property (weak) IBOutlet NSButton *factBtn;
    
@property (weak) IBOutlet NSTextField *topDisplay;
@property (weak) IBOutlet NSTextField *display;
@property (weak) IBOutlet NSTextField *topStatus;
@property NSInteger bracketsbeforeMultiPart;

@property (weak) IBOutlet NSPopUpButton *ConstCategoryPop;
@property (weak) IBOutlet NSPopUpButton *ConstantPop;

- (IBAction)changeConstCat:(id)sender;
- (IBAction)ChangeConstant:(id)sender;
- (IBAction)BtnConstantInsert:(id)sender;
//ConstCategoryPop, ConstantPop, ConstantsFromPop
@property NSMutableArray *ConstantsFromPop;
@property (weak) IBOutlet NSTextField *StoreFileLocation;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property NSUserDefaults *standardUserDefaults;  
@property Calculator *calc;
@property FunctionLibrary *functionLib; // borowing out this instance to calculators. 
@property BOOL shiftkey;
@property NSInteger currentFunctionLib; 
@property (weak) IBOutlet NSButton *sqrt_btn;
@property (weak) IBOutlet NSButton *ln_btn;
@property (weak) IBOutlet NSButton *log_btn;
@property (weak) IBOutlet NSButton *sin_btn;
@property (weak) IBOutlet NSButton *cos_btn;
@property (weak) IBOutlet NSButton *tan_btn;
@property (weak) IBOutlet NSButton *sinh_btn;
@property (weak) IBOutlet NSButton *cosh_btn;
@property (weak) IBOutlet NSButton *tanh_btn;

@property (weak) IBOutlet NSButton *in2cm_btn;
@property (weak) IBOutlet NSButton *cm2in_btn;

@property (assign) IBOutlet NSPanel *editww;
@property (weak) IBOutlet NSTextField *bottom_bar;

@property (weak) IBOutlet NSTextField *editTextField;
@property (weak) IBOutlet NSTextField *hlpTitle;
@property (weak) IBOutlet NSTextField *hlpInfo;
@property (weak) IBOutlet NSDrawer *hlpDrawer;
@property (weak) IBOutlet NSDrawer *var_drawer;
- (IBAction)btnVarDraver:(id)sender;
@property (weak) IBOutlet NSButtonCell *btnTabKey;
@property (weak) IBOutlet NSButton *shftKey;
@property (weak) IBOutlet NSButton *rightbracketkey;

@property (weak) IBOutlet NSPopUpButton *popup_annuity;
@property (weak) IBOutlet NSPopUpButton *popup_interest;
@property (weak) IBOutlet NSPopUpButton *popup_savings;
// variables
@property (weak) IBOutlet NSTextField *var_x;
@property (weak) IBOutlet NSTextField *var_y;
@property (weak) IBOutlet NSTextField *var_z;
@property (weak) IBOutlet NSTextField *var_a;
@property (weak) IBOutlet NSTextField *var_b;
@property (weak) IBOutlet NSTextField *var_c;
@property (weak) IBOutlet NSTextField *var_d;
@property (weak) IBOutlet NSTextField *var_r;
@property (weak) IBOutlet NSTextField *var_h;
@property (weak) IBOutlet NSTextField *var_w;

@property (weak) IBOutlet NSTextField *label_x;
@property (weak) IBOutlet NSTextField *label_y;
@property (weak) IBOutlet NSTextField *label_z;
@property (weak) IBOutlet NSTextField *label_a;
@property (weak) IBOutlet NSTextField *label_b;
@property (weak) IBOutlet NSTextField *label_c;
@property (weak) IBOutlet NSTextField *label_d;
@property (weak) IBOutlet NSTextField *label_r;
@property (weak) IBOutlet NSTextField *label_h;
@property (weak) IBOutlet NSTextField *label_w;
- (IBAction)CalcPreferences:(id)sender;
@property (weak) IBOutlet NSTextField *toolbar_textDisplay;

- (IBAction)btn_toolbar_log:(id)sender;

- (IBAction)edit_x:(id)sender;
- (IBAction)edit_y:(id)sender;
- (IBAction)edit_z:(id)sender;
- (IBAction)edit_a:(id)sender;
- (IBAction)edit_b:(id)sender;
- (IBAction)edit_c:(id)sender;
- (IBAction)edit_d:(id)sender;
- (IBAction)edit_r:(id)sender;
- (IBAction)edit_h:(id)sender;
- (IBAction)edit_w:(id)sender;

- (IBAction)change_label_x:(id)sender;
- (IBAction)change_label_y:(id)sender;
- (IBAction)change_label_z:(id)sender;
- (IBAction)change_label_a:(id)sender;
- (IBAction)change_label_b:(id)sender;
- (IBAction)change_label_c:(id)sender;
- (IBAction)change_label_d:(id)sender;
- (IBAction)change_label_r:(id)sender;
- (IBAction)change_label_h:(id)sender;
- (IBAction)change_label_w:(id)sender;
- (IBAction)clrLabels:(id)sender;


// variable buttons
- (IBAction)but_varx:(id)sender;
- (IBAction)but_vary:(id)sender;
- (IBAction)but_varz:(id)sender;
- (IBAction)but_vara:(id)sender;
- (IBAction)but_varb:(id)sender;
- (IBAction)but_varc:(id)sender;
- (IBAction)but_vard:(id)sender;
- (IBAction)but_varr:(id)sender;
- (IBAction)but_varh:(id)sender;
- (IBAction)but_varw:(id)sender;
// Title of variable buttons
@property (weak) IBOutlet NSButton *but_titx;
@property (weak) IBOutlet NSButton *but_tity;
@property (weak) IBOutlet NSButton *but_titz;
@property (weak) IBOutlet NSButton *but_tita;
@property (weak) IBOutlet NSButton *but_titb;
@property (weak) IBOutlet NSButton *but_titc;
@property (weak) IBOutlet NSButton *but_titd;
@property (weak) IBOutlet NSButton *but_titr;
@property (weak) IBOutlet NSButton *but_tith;
@property (weak) IBOutlet NSButton *but_titw;
// geometry

@property (weak) IBOutlet NSButton *tit_cylarea;

// buttons and outlets for geometry drawer
@property (weak) IBOutlet NSPopUpButton *pop_geo_gen;
@property (weak) IBOutlet NSPopUpButton *pop_geo_area;
@property (weak) IBOutlet NSPopUpButton *pop_geo_vol;
@property (weak) IBOutlet NSPopUpButton *pop_geo_circ;

- (IBAction)btn_go_gengeo:(id)sender;
- (IBAction)btn_go_geoArea:(id)sender;
- (IBAction)btn_go_geoVol:(id)sender;
- (IBAction)btn_go_geicirc:(id)sender;


@property (weak) IBOutlet NSButton *checkIncludeDoc;

@property NSUndoManager *unduManager; 

- (IBAction)HomeFormulaCalculator:(id)sender;
- (IBAction)DocumentationWiki:(id)sender;

- (IBAction)ClickDisplay:(id)sender;

@property (weak) IBOutlet NSPopUpButton *popup_functionLib;
- (IBAction)popup_selectFunction:(id)sender;

@property (weak) IBOutlet NSDrawer *drawer_Finance;
@property (weak) IBOutlet NSDrawer *drawer_convert;
@property (weak) IBOutlet NSDrawer *drawer_geometry;

- (IBAction)paste:(id)sender;
- (IBAction)undo:(id)sender;

- (void) sendButtonMsg:(NSString*)str WithOption:(CalcFunctionType)opt; 
- (IBAction)saveAction:(id)sender;
// Calculator buttons

- (IBAction)btnOne:(id)sender;
- (IBAction)btnTwo:(id)sender;
- (IBAction)btnThree:(id)sender;
- (IBAction)btnFour:(id)sender;
- (IBAction)btnFive:(id)sender;
- (IBAction)btnSix:(id)sender;
- (IBAction)btnSeven:(id)sender;
- (IBAction)btnEigth:(id)sender;
- (IBAction)btnNine:(id)sender;
- (IBAction)btnZero:(id)sender;
- (IBAction)btnComma:(id)sender;
- (IBAction)btnPlus:(id)sender;
- (IBAction)btnMinus:(id)sender;
- (IBAction)btnMultiply:(id)sender;
- (IBAction)btnDivide:(id)sender;
- (IBAction)btnEqual:(id)sender;
- (IBAction)btn_e:(id)sender;
- (IBAction)btn_pi:(id)sender;
- (IBAction)btnClear:(id)sender;
- (IBAction)btn_AllClear:(id)sender;
- (IBAction)btn_pow:(id)sender;
- (IBAction)btn_leftpar:(id)sender;
- (IBAction)btn_rightpar:(id)sender;
- (IBAction)btn_percent:(id)sender;
- (IBAction)btn_1x:(id)sender;
- (IBAction)btn_sqrt:(id)sender;
- (IBAction)btn_pow2:(id)sender;
- (IBAction)btn_pow3:(id)sender;
- (IBAction)btn_ln:(id)sender;
- (IBAction)btn_log10:(id)sender;
- (IBAction)btn_sin:(id)sender;
- (IBAction)btn_cos:(id)sender;
- (IBAction)btn_tan:(id)sender;
- (IBAction)btn_sinh:(id)sender;
- (IBAction)btn_cosh:(id)sender;
- (IBAction)btn_tanh:(id)sender;
- (IBAction)btn_fact:(id)sender;
- (IBAction)btn_shift:(id)sender;
- (IBAction)btn_chsign:(id)sender;
- (IBAction)btn_memplus:(id)sender;
- (IBAction)btn_memclear:(id)sender;
- (IBAction)btn_memminus:(id)sender;
- (IBAction)mem_save:(id)sender;
- (IBAction)btn_memrecall:(id)sender;
- (IBAction)btn_EE:(id)sender;
- (IBAction)in2cm:(id)sender;
- (IBAction)cm2in:(id)sender;
- (IBAction)btn_f2c:(id)sender;
- (IBAction)btn_c2f:(id)sender;

- (IBAction)btnLengthUnits:(id)sender;
- (IBAction)btnVolumeUnits:(id)sender;
- (IBAction)btn_TempUnits:(id)sender;
- (IBAction)btn_WeightUnit:(id)sender;

@property (weak) IBOutlet NSPopUpButton *lengthUnitPop;
@property (weak) IBOutlet NSPopUpButton *volumUnitsPop;
@property (weak) IBOutlet NSPopUpButton *tempUnitsPop;
@property (weak) IBOutlet NSPopUpButton *weightUnitPop;


- (IBAction)next:(id)sender;
- (IBAction)btn_go_annuity:(id)sender;
- (IBAction)btn_000:(id)sender;
- (IBAction)btn_interest:(id)sender;
- (IBAction)btn_FVSavings:(id)sender;



- (void) UpdateDisplay; 

@end
