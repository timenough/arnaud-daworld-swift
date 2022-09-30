
#import "ProgrammeViewCell.h"

@implementation ProgrammeViewCell

@synthesize lblCourse,
    lblCourseInfosDispo,
    imgCourseView,
    imgQuinteView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // Initialization code
        CGRect rect;
        
        
        //Picto Status de la course
        rect                                    = CGRectMake(7,9,12,12);
        imgCourseView                           = [[UIImageView alloc] initWithFrame:rect];
        imgCourseView.backgroundColor           = [UIColor clearColor];
        [self.contentView addSubview:imgCourseView];
        
        //Course libelle
        rect                                    = CGRectMake(28,4,255,30);
        lblCourse                               = [[UILabel alloc] initWithFrame:rect];
        lblCourse.font                          = [UIFont fontWithName:@"Helvetica" size:12.0f];
        lblCourse.font                          = [UIFont boldSystemFontOfSize:12.0f];
        lblCourse.backgroundColor               = [UIColor clearColor];
        lblCourse.textColor                     = [UIColor colorWithRed:31.0/255 green:28.0/255 blue:24.0/255 alpha:1];
        lblCourse.lineBreakMode                 = UILineBreakModeWordWrap;
        lblCourse.numberOfLines                 = 0;
        [self.contentView addSubview:lblCourse];
        
        //Course infos
        rect                                     = CGRectMake(28,30,255,20);
        lblCourseInfosDispo                      = [[UILabel alloc] initWithFrame:rect];
        lblCourseInfosDispo.font                 = [UIFont fontWithName:@"Helvetica" size:11.5f];
        lblCourseInfosDispo.font                 = [UIFont italicSystemFontOfSize:11.5f];
        lblCourseInfosDispo.backgroundColor      = [UIColor clearColor];
        lblCourseInfosDispo.textColor            = [UIColor colorWithRed:59.0/255 green:39.0/255 blue:16.0/255 alpha:0.5];
        [self.contentView addSubview:lblCourseInfosDispo];
        
        //Picto Quinté
        rect                                    = CGRectMake(275,9,39,15);
        imgQuinteView                           = [[UIImageView alloc] initWithFrame:rect];
        [self.contentView addSubview:imgQuinteView];
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
