
#import <UIKit/UIKit.h>

@interface ActualiteViewCell : UITableViewCell
{
    
    UILabel *lblTitle;
    UILabel *lblDescription;
    UIImageView *imgPictureView;
    UIImage *imgPicture;

}

@property (strong, nonatomic) UILabel *lblTitle;
@property (strong, nonatomic) UILabel *lblDescription;
@property (strong, nonatomic) UIImageView *imgPictureView;
@property (strong, nonatomic) UIImage *imgPicture;

@end
