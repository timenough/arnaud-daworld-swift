
#import <UIKit/UIKit.h>

///////////
//////////////////
///// PROTOCOLE DELEGATE :
///// La(les) méthode qu'il contient doit être implementée et définie par le controlleur parent
///// car il va inclure ce fichier "MenuSelect.h" dans son .h
///// ensuite quand il instanciera le MenuSelect dans son .m
///// MenuSelect pour appeler ces méthodes, dont il aura hérité
//////////////////
@protocol UITextFieldAffectTableViewDelegate <NSObject>

-(void)consequenceOnTableView:(int)selectedValue;

@end
//////////////////
///////////

@interface MenuSelect : UITextField <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    UIPickerView *pickerView;
    UILabel *pickerViewText;
    UIToolbar *pickerViewToolBar;
    NSMutableArray *MenuSelectDataArray;
    UIImageView *MenuSelectArrow;
    int MenuSelectStartValue;
    int MenuSelectCurrentValue;
    
    id<UITextFieldAffectTableViewDelegate> herited_delegate;
}

-(void) setSelectListData:(NSMutableArray*)data;
-(void) setDefaultValue:(int)itemid;

@property (retain, nonatomic) UILabel *pickerViewText;
@property (retain, nonatomic) UIToolbar* pickerViewToolBar;
@property (retain, nonatomic) NSString* MenuSelectCurrentText;
@property (retain, nonatomic) UIImageView *MenuSelectArrow;
@property (nonatomic) int MenuSelectStartValue;
@property (nonatomic) int MenuSelectCurrentValue;

@property (retain, nonatomic) id<UITextFieldAffectTableViewDelegate> herited_delegate;

@end
