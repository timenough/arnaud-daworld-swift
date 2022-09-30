
#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import "MenuSelect.h"

@implementation MenuSelect

@synthesize pickerViewText, pickerViewToolBar, MenuSelectArrow, MenuSelectStartValue, MenuSelectCurrentText,MenuSelectCurrentValue, herited_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate           = self;
    }
    
    ////// TEXTE
    self.contentHorizontalAlignment                 = UIControlContentHorizontalAlignmentCenter;
    self.contentVerticalAlignment                   = UIControlContentVerticalAlignmentCenter;
    self.textAlignment                              = NSTextAlignmentCenter;
    self.layer.cornerRadius                         = 12;
    self.layer.masksToBounds                        = YES;
    self.textColor                                  = [UIColor whiteColor];
    self.font                                       = [UIFont fontWithName:@"Helvetica" size:15.0f];
    self.font                                       = [UIFont boldSystemFontOfSize:15.0f];
    
    ////// FLECHE
    MenuSelectArrow                                 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_develop_list.png"]];
    
    [self setRightView:MenuSelectArrow];
    [self setRightViewMode:UITextFieldViewModeAlways];

    return self;
}

/* PERMET DE SUPPRIMER LE CURSEUR DU TEXTFIELD */
- (CGRect) caretRectForPosition:(UITextPosition *)position {
    return CGRectZero;
}

/* PERMET DE REPOSITION L'IMAGE DE LA FLECHE DU TEXTFIELD */
- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rightBounds = [super rightViewRectForBounds:bounds];
    rightBounds.origin.x -= 11;
    return rightBounds;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    NSLog(@"ON COMMENCE A EDITER (Picker Déclenché)");
    [self showSelectList:aTextField];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return NO;
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [MenuSelectDataArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [MenuSelectDataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.text                           = [MenuSelectDataArray objectAtIndex:row];
    MenuSelectCurrentText               = self.text;
    MenuSelectCurrentValue              = row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    pickerViewText                          = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 37)];
    
    if (component == 0) {
        pickerViewText.font                 = [UIFont fontWithName:@"Helvetica" size:16.0f];
        pickerViewText.font                 = [UIFont boldSystemFontOfSize:16.0f];
        pickerViewText.backgroundColor      = [UIColor clearColor];
        pickerViewText.textColor            = [UIColor colorWithRed:31.0/255 green:28.0/255 blue:24.0/255 alpha:1];
        pickerViewText.textAlignment        = UITextAlignmentCenter;
        pickerViewText.lineBreakMode        = UILineBreakModeWordWrap;
        pickerViewText.text                 = [NSString stringWithFormat:@"%@",[MenuSelectDataArray objectAtIndex:row]];
        //label.text                        = [NSString stringWithFormat:@"- %@ -",[MenuSelectDataArray objectAtIndex:row]];
    }
    return pickerViewText;
}

- (NSInteger)selectedRowInComponent:(NSInteger)component{
    return 2;
}

#pragma mark - Actions

-(void)setSelectListData:(NSMutableArray*)data
{
    MenuSelectDataArray                 = data;
}

-(void)setDefaultValue:(int)itemid
{
    self.text                       = [MenuSelectDataArray objectAtIndex:itemid];
    MenuSelectCurrentText           = [MenuSelectDataArray objectAtIndex:itemid];
    MenuSelectStartValue            = itemid;
    MenuSelectCurrentValue          = itemid;
}

- (void)showSelectList:(id)sender
{
    //[UIView animateWithDuration:.2f delay:0 options: UIViewAnimationOptionCurveLinear
    //                 animations:^{
    //                     MenuSelectArrow.transform = CGAffineTransformMakeRotation( 180 * M_PI  / 180);
    //                 }
    //                 completion:nil];
    
    ///////////
    /////////// LE PICKERVIEW
    ///////////
    pickerView                                      = [[UIPickerView alloc] init];
    pickerView.showsSelectionIndicator              = YES;
    pickerView.dataSource                           = self;
    pickerView.delegate                             = self;
    
    ///////////
    /////////// LA TOOLBAR DU PICKERVIEW
    ///////////
    pickerViewToolBar                               = [[UIToolbar alloc] init];
    pickerViewToolBar.barStyle                      = UIBarStyleDefault;
    pickerViewToolBar.translucent                   = YES;
    [pickerViewToolBar sizeToFit];
    
        ///////////
        /////////// LES BOUTONS DE LA TOOLBAR DU PICKERVIEW
        ///////////
        UIBarButtonItem *cancelButton               = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                    target:self
                                                                    action:@selector(hideSelectList:)];
        UIBarButtonItem *spaceBetweenButtons        = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                    target:nil
                                                                    action:nil];
        UIBarButtonItem *doneButton                 = [[UIBarButtonItem alloc] initWithTitle:@"Valider"
                                                                    style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                                      action:@selector(applyItemSelectedList)];
        [pickerViewToolBar setItems:[NSArray arrayWithObjects:cancelButton,spaceBetweenButtons,doneButton,nil]];
    
    ///////////
    /////////// APPLICATION DU TOUT + STYLE
    ///////////
    self.inputView                                  = pickerView;
    self.inputAccessoryView                         = pickerViewToolBar;
    ////// RAPPEL DU DERNIER ELEMENT SELECTIONNE
    [pickerView selectRow:MenuSelectCurrentValue inComponent:0 animated:NO];
}

-(void)hideSelectList:(id)sender
{
    //[UIView animateWithDuration:.2f delay:0 options: UIViewAnimationOptionCurveLinear
    //                 animations:^{
    //                     MenuSelectArrow.transform = CGAffineTransformMakeRotation( 0 * M_PI  / -180);
    //                 }
    //                 completion:nil];
    
    ///////////
    /////////// on initialise à la StartValue (Cancel)
    ///////////
    self.text                                       = [MenuSelectDataArray objectAtIndex:MenuSelectStartValue];
    MenuSelectCurrentValue                          = MenuSelectStartValue;
    [self resignFirstResponder];
    
    //[self applyItemSelectedList];
}

-(void)applyItemSelectedList
{
    [self resignFirstResponder];
    ///////////
    /////////// on reload la tableView parente (Valider)
    ///////////
    [self.herited_delegate consequenceOnTableView:MenuSelectCurrentValue];
}

@end
