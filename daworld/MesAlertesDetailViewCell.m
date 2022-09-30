
#import "MesAlertesDetailViewCell.h"

@implementation MesAlertesDetailViewCell

@synthesize lblTitle,
    lblDescription,
    switchActiveButton,
    actionUrlParams,
    alertIDUrlParams,
    pushAlertIDUrlParams,
    type,
    mesAlertesViewController,
    indexPathCell,
    deleteButton;

//Initialise les cellules via le type passé en paramètre
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(NSString*)typeAlert
{
    
    self.type = typeAlert;
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect;
        
        //Alerte Name
        rect                                    = CGRectMake(10,4,200,30);
        lblTitle                               = [[UILabel alloc] initWithFrame:rect];
        lblTitle.font                          = [UIFont fontWithName:@"Helvetica" size:12.5f];
        lblTitle.font                          = [UIFont boldSystemFontOfSize:14.0f];
        lblTitle.backgroundColor               = [UIColor clearColor];
        lblTitle.textColor                     = [UIColor colorWithRed:31.0/255 green:28.0/255 blue:24.0/255 alpha:1];
        lblTitle.lineBreakMode                 = UILineBreakModeWordWrap;
        lblTitle.numberOfLines                 = 0;
        [self.contentView addSubview:lblTitle];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            
            if([self.type isEqualToString:@"notifications"]){
            }
            else if([self.type isEqualToString:@"quinte"]){
                switchActiveButton = [[UISwitch alloc] initWithFrame:CGRectMake(260,4,50,40)];
                [switchActiveButton addTarget:self action:@selector(switchActiveAlert:) forControlEvents: UIControlEventTouchUpInside];
            
                [self.contentView addSubview:switchActiveButton];
            }/*else{
                switchActiveButton = [[UISwitch alloc] initWithFrame:CGRectMake(260,4,50,40)];
                [switchActiveButton addTarget:self action:@selector(switchActiveAlert:) forControlEvents: UIControlEventTouchUpInside];
                
                [self.contentView addSubview:switchActiveButton];
            }*/
            
        }
        else{
            
            if([self.type isEqualToString:@"notifications"]){
            }
            else if([self.type isEqualToString:@"quinte"]){
                switchActiveButton = [[UISwitch alloc] initWithFrame:CGRectMake(236,6,50,40)];
                [switchActiveButton addTarget:self action:@selector(switchActiveAlert:) forControlEvents: UIControlEventTouchUpInside];
                
                [self.contentView addSubview:switchActiveButton];
            }/*else{
                switchActiveButton = [[UISwitch alloc] initWithFrame:CGRectMake(236,6,50,40)];
                [switchActiveButton addTarget:self action:@selector(switchActiveAlert:) forControlEvents: UIControlEventTouchUpInside];
                
                [self.contentView addSubview:switchActiveButton];
            }*/
            
        }
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    // HIDE THE SELECTED BG AFTER DELAY
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        [self backgroundView].alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self backgroundView].hidden = YES;
    }
     ];
    
}

#pragma mark - Actions
-(void) switchActiveAlert:(id) sender
{
    
    [self.mesAlertesViewController displayLoadingActivityPopup:nil isforView:nil];
    
    UISwitch *switchButton = (UISwitch *)sender;
    NSURL *url;
    
    if([self.type isEqualToString:@"quinte"]){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.daworld.co/json_mesalertes_detail_action.php?device_id=%@&source=iphone&alert_id=%@&action=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceID"], self.alertIDUrlParams, self.actionUrlParams]];
        
        self.actionUrlParams =([switchButton isOn])?  @"del" : @"add";
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.daworld.co/json_mesalertes_detail_action.php?device_id=%@&source=iphone&alert_id=%@&push_alert_id=%@&action=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceID"], self.alertIDUrlParams, self.pushAlertIDUrlParams, self.actionUrlParams]];
        NSLog(@"URL = %@",url);
        self.actionUrlParams = @"del";
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:10.0f];
    NSString *paramStr = [NSString stringWithFormat:@""];
    [request setHTTPBody:[NSData dataWithBytes:[paramStr UTF8String] length:[paramStr length]]];
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        @try {
            
            [self.mesAlertesViewController.activityIndicator stopAnimating];
            [self.mesAlertesViewController.activityIndicatorContainer removeFromSuperview];
            
            NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSString *responseMessage = [[Json objectForKey:@"message"] objectForKey:@"value"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerte" message:responseMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            
            /*
            if([self.type isEqualToString:@"partants"]){
                [self removeFromSuperview];
                [self.mesAlertesViewController.currentControllerTableViewContentArray removeObjectAtIndex:self.indexPathCell.row];
                [self.mesAlertesViewController.currentControllerTableView reloadData];
            }*/
                     
        }
        @catch (NSException *exception) {
            
            [self.mesAlertesViewController.activityIndicator stopAnimating];
            [self.mesAlertesViewController.activityIndicatorContainer removeFromSuperview];
            
            NSLog(@"Exception lors d'action sur les alertes");
        }
    });
   
}

@end
