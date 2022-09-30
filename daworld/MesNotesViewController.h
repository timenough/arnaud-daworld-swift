
#import "FrontViewController.h"

@interface MesNotesViewController : FrontViewController
    <UIScrollViewDelegate>
{
    
	IBOutlet UIScrollView *scrollView;
	
	NSMutableArray *documentTitles;
	UILabel *pageOneDoc;
	UILabel *pageTwoDoc;
	UILabel *pageThreeDoc;
	int prevIndex;
	int currIndex;
	int nextIndex;
    
}

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *documentTitles;
@property (nonatomic, retain) UILabel *pageOneDoc;
@property (nonatomic, retain) UILabel *pageTwoDoc;
@property (nonatomic, retain) UILabel *pageThreeDoc;
@property (nonatomic) int prevIndex;
@property (nonatomic) int currIndex;
@property (nonatomic) int nextIndex;

- (void)loadPageWithId:(int)index onPage:(int)page;

@end
