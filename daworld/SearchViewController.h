
#import <UIKit/UIKit.h>
#import "FrontViewController.h"
#import "FicheChevalViewController.h"

@interface SearchViewController : FrontViewController
    <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate>
{

    UISearchDisplayController *searchDisplayController;
    UISearchBar *searchBar;
    NSMutableArray *searchDatabase;
    NSArray *searchResults;
    
    FicheChevalViewController *ficheChevalViewController;

}

@property (strong, nonatomic) UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *searchDatabase;
@property (strong, nonatomic) NSArray *searchResults;

@property (strong,nonatomic) FicheChevalViewController *ficheChevalViewController;

- (void)sendJsonRequest_ASyncForAlert:(NSString *)JsonURI horseName:(NSString *)theHorseName;

@end
