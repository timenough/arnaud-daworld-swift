
#import "ActualiteViewCell.h"

@implementation ActualiteViewCell

@synthesize lblTitle,
    lblDescription,
    imgPictureView,
    imgPicture;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        CGRect rect;
        
        
        //Picto Status de la course
        rect                                        = CGRectMake(6,6,100,68);
        imgPictureView                              = [[UIImageView alloc] initWithFrame:rect];
        [self.contentView addSubview:imgPictureView];
        
        //Article title
        rect                                        = CGRectMake(112,6,200,30);
        lblTitle                                    = [[UILabel alloc] initWithFrame:rect];
        lblTitle.font                               = [UIFont fontWithName:@"Helvetica" size:12.5f];
        lblTitle.font                               = [UIFont boldSystemFontOfSize:12.5f];
        lblTitle.backgroundColor                    = [UIColor clearColor];
        lblTitle.textColor                          = [UIColor colorWithRed:31.0/255 green:28.0/255 blue:24.0/255 alpha:1];
        lblTitle.lineBreakMode                      = UILineBreakModeWordWrap;
        lblTitle.numberOfLines                      = 0;
        [self.contentView addSubview:lblTitle];
        
        //Article summary
        rect                                = CGRectMake(112,35,200,40);
        lblDescription                      = [[UILabel alloc] initWithFrame:rect];
        lblDescription.font                 = [UIFont fontWithName:@"Helvetica" size:12.0f];
        lblDescription.backgroundColor      = [UIColor clearColor];
        lblDescription.textColor            = [UIColor colorWithRed:48.0/255 green:43.0/255 blue:37.0/255 alpha:0.5];
        lblDescription.lineBreakMode                 = UILineBreakModeWordWrap;
        lblDescription.numberOfLines                 = 2;
        [self.contentView addSubview:lblDescription];

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

@end
