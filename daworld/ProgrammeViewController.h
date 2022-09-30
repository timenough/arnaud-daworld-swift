
#import "FrontViewController.h"

@interface ProgrammeViewController : FrontViewController
    <UITableViewDataSource, UITableViewDelegate>
{
    
    NSString *reunionDate;
    int reunionSelected;
    BOOL isScrolling;
    
}

@property (strong, nonatomic) NSString *reunionDate;
@property (nonatomic) int reunionSelected;
@property (nonatomic) BOOL isScrolling;

@end
