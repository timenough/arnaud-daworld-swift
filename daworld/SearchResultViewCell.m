
#import "SearchResultViewCell.h"

@implementation SearchResultViewCell

@synthesize lblCheval,
    lblChevalInfosDispo,
    imgChevalView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor  blackColor];
        
        // Initialization code
        CGRect rect;
        
        //Picto du Cheval
        rect                                    = CGRectMake(1,1,33,39);
        imgChevalView                           = [[UIImageView alloc] initWithFrame:rect];
        [self.contentView addSubview:imgChevalView];
        
        //Cheval libelle
        rect                                    = CGRectMake(48,5,255,30);
        lblCheval                               = [[UILabel alloc] initWithFrame:rect];
        lblCheval.font                          = [UIFont fontWithName:@"Helvetica" size:12.0f];
        lblCheval.font                          = [UIFont boldSystemFontOfSize:12.0f];
        lblCheval.backgroundColor               = [UIColor clearColor];
        lblCheval.textColor                     = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1];
        lblCheval.lineBreakMode                 = UILineBreakModeWordWrap;
        lblCheval.numberOfLines                 = 0;
        [self.contentView addSubview:lblCheval];
        
        //Cheval infos
        /*
        rect                                     = CGRectMake(28,30,255,20);
        lblChevalInfosDispo                      = [[UILabel alloc] initWithFrame:rect];
        lblChevalInfosDispo.font                 = [UIFont fontWithName:@"Helvetica" size:11.5f];
        lblChevalInfosDispo.font                 = [UIFont italicSystemFontOfSize:11.5f];
        lblChevalInfosDispo.backgroundColor      = [UIColor clearColor];
        lblChevalInfosDispo.textColor            = [UIColor colorWithRed:59.0/255 green:39.0/255 blue:16.0/255 alpha:0.5];
        [self.contentView addSubview:lblChevalInfosDispo];
        */
        
    }
    return self;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];
    
}

@end
