
#import "MenuViewCell.h"

@implementation MenuViewCell

@synthesize lblReunion,
    imgReunionView,
    lblReunionHour,
    imgQuinteView,
    type,
    status,
    subSectionNumber,
    subSectionStatus,
    reunionDate,
    reunionNumber,
    raceId,
    raceTabSelected,
    isClicable,
    raceInfoTabStatus,
    lblBadgeValue,
    raceName,
    raceContexte,
    raceArrivee;

//Initialise les cellules via le type passé en paramètre
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(int)typeStatus
{
    
    self.type = typeStatus;
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view        = nil;
        UIImage *img        = nil;
        UIImageView *view2  = nil;
        CGRect rect;
        
        switch(self.type){
            case MENU_SECTION:
                
                view                            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
                view.backgroundColor            = [UIColor colorWithRed:79.0/255 green:71.0/255 blue:61.0/255 alpha:1];
                
                img                             = [UIImage imageNamed:@"bg_tablecell_section_menu.png"];
                view2                           = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
                view2.image                     = [img resizableImageWithCapInsets:UIEdgeInsetsMake(5,5,5,5)];
                [view addSubview:view2];

                
                //Section date
                rect                            = CGRectMake(8,0,150,20);
                lblReunion                      = [[UILabel alloc] initWithFrame:rect];
                lblReunion.font                 = [UIFont fontWithName:@"Helvetica" size:11.7f];
                lblReunion.font                 = [UIFont italicSystemFontOfSize:11.7f];
                lblReunion.backgroundColor      = [UIColor clearColor];
                lblReunion.textColor            = [UIColor whiteColor];
                [self.contentView addSubview:lblReunion];
                
                //Picto Quinté
                rect                            = CGRectMake(self.frame.size.width - 60,8,11,6);
                imgQuinteView                   = [[UIImageView alloc] initWithFrame:rect];
                [self.contentView addSubview:imgQuinteView];
                
                
                break;
                
            case MENU_REUNION:
     
                view                            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25)];
                view.backgroundColor            = [UIColor colorWithRed:55.0/255 green:50.0/255 blue:43.0/255 alpha:1];
                img                             = [UIImage imageNamed:@"bg_tablecell_reunion_menu.png"];
                view2                           = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25)];
                view2.image                     = [img resizableImageWithCapInsets:UIEdgeInsetsMake(5,5,5,5)];
                [view addSubview:view2];
                
                //Picto Status de la réunion
                rect                            = CGRectMake(7,9,12,12);
                imgReunionView                  = [[UIImageView alloc] initWithFrame:rect];
                [self.contentView addSubview:imgReunionView];
                
                //Réunion / Hyppodrome
                rect                            = CGRectMake(25,0,185,25);
                lblReunion                      = [[UILabel alloc] initWithFrame:rect];
                lblReunion.font                 = [UIFont fontWithName:@"HelveticaNeue" size:11.5f];
                lblReunion.font                 = [UIFont boldSystemFontOfSize:11.5f];
                lblReunion.backgroundColor      = [UIColor clearColor];
                lblReunion.textColor            = [UIColor whiteColor];
                //lblReunion.shadowColor          = [UIColor colorWithRed:76.0/255 green:69.0/255 blue:62.0/255 alpha:1];
                //lblReunion.shadowOffset         = CGSizeMake(-2.0f, -2.0f);
                [self.contentView addSubview:lblReunion];
                
                //Heure réunion
                rect                            = CGRectMake(187,0,50,25);
                lblReunionHour                  = [[UILabel alloc] initWithFrame:rect];
                lblReunionHour.font             = [UIFont fontWithName:@"Helvetica" size:11.5f];
                
                lblReunionHour.backgroundColor  = [UIColor clearColor];
                lblReunionHour.textColor        = [UIColor colorWithRed:224.0/255 green:207.0/255 blue:194.0/255 alpha:1];
                //lblReunionHour.shadowColor      = [UIColor colorWithRed:76.0/255 green:69.0/255 blue:62.0/255 alpha:1];
                //lblReunionHour.shadowOffset     = CGSizeMake(-2.0f, -2.0f);
                [self.contentView addSubview:lblReunionHour];
                
                //Picto Quinté
                rect                        = CGRectMake(229,5,39,15);
                imgQuinteView               = [[UIImageView alloc] initWithFrame:rect];
                [self.contentView addSubview:imgQuinteView];
                    
                break;
                
            case MENU_QUINTE:
                view                        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25)];
                img                         = [UIImage imageNamed:@"bg_tablecell_reunion_menu.png"];
                view2                       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25)];
                view2.image                 = [img resizableImageWithCapInsets:UIEdgeInsetsMake(5,5,5,5)];
                [view addSubview:view2];
                
                view.backgroundColor            = [UIColor colorWithRed:55.0/255 green:50.0/255 blue:43.0/255 alpha:1];
                //Picto Status de la course
                rect                        = CGRectMake(7,9,9,9);
                imgReunionView              = [[UIImageView alloc] initWithFrame:rect];
                [self.contentView addSubview:imgReunionView];
                
                //Partants / pronostics / rapports
                rect = CGRectMake(25,0,185,25);
                lblReunion                  = [[UILabel alloc] initWithFrame:rect];
                lblReunion.font             = [UIFont fontWithName:@"HelveticaNeue" size:11.5f];
                lblReunion.font             = [UIFont boldSystemFontOfSize:11.5f];
                lblReunion.backgroundColor  = [UIColor clearColor];
                lblReunion.textColor        = [UIColor whiteColor];
                //lblReunion.shadowColor      = [UIColor colorWithRed:76.0/255 green:69.0/255 blue:62.0/255 alpha:1];
                //lblReunion.shadowOffset        = CGSizeMake(-2.0f, -2.0f);
                [self.contentView addSubview:lblReunion];
                
                break;
            default:
                view                        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25)];
                img                         = [UIImage imageNamed:@"bg_tablecell_reunion_menu.png"];
                view2                       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25)];
                view2.image                 = [img resizableImageWithCapInsets:UIEdgeInsetsMake(5,5,5,5)];
                
                [view addSubview:view2];
                view.backgroundColor            = [UIColor colorWithRed:55.0/255 green:50.0/255 blue:43.0/255 alpha:1];
                //Libelle menu
                rect                        = CGRectMake(5,0,self.frame.size.width-5,25);
                lblReunion                  = [[UILabel alloc] initWithFrame:rect];
                lblReunion.font             = [UIFont fontWithName:@"HelveticaNeue" size:11.5f];
                lblReunion.font             = [UIFont boldSystemFontOfSize:11.5f];
                lblReunion.backgroundColor  = [UIColor clearColor];
                lblReunion.textColor        = [UIColor whiteColor];
                //lblReunion.shadowColor      = [UIColor colorWithRed:76.0/255 green:69.0/255 blue:62.0/255 alpha:1];
                //lblReunion.shadowOffset     = CGSizeMake(-2.0f, -2.0f);
                [self.contentView addSubview:lblReunion];
                
                // BADGE VALUE
                rect                                                    = CGRectMake(240.0,3,34,18);
                lblBadgeValue                                           = [[UILabel alloc] initWithFrame:rect];
                lblBadgeValue.textAlignment                              = NSTextAlignmentCenter;
                lblBadgeValue.layer.cornerRadius                         = 9;
                lblBadgeValue.layer.masksToBounds                        = YES;
                lblBadgeValue.textColor                                  = [UIColor whiteColor];
                lblBadgeValue.font                                       = [UIFont fontWithName:@"Helvetica" size:11.5f];
                lblBadgeValue.font                                       = [UIFont boldSystemFontOfSize:11.5f];
                lblBadgeValue.backgroundColor                            = [UIColor colorWithRed:101.0/255 green:89.0/255 blue:73.0/255 alpha:1];
                lblBadgeValue.hidden                                       = YES;
                [self.contentView addSubview:lblBadgeValue];
                
                break;
                
        }
        
        self.backgroundView = view;
        
    }
    return self;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   
   /*if(selected){
        UIView *view        = nil;
        
        view                            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        view.backgroundColor            = [UIColor colorWithRed:47.0/255 green:42.0/255 blue:37.0/255 alpha:1];
        
        self.backgroundView = view;
    }*/
    
     [super setSelected:selected animated:animated];
    
}

@end
