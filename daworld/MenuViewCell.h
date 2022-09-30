
#import <UIKit/UIKit.h>

#define MENU_SECTION 0
#define MENU_REUNION 1
#define MENU_QUINTE 2
#define MENU_BASIC 3

#define SECTION_CLOSE 0
#define SECTION_OPEN 1

@interface MenuViewCell : UITableViewCell
{
    UILabel *lblReunion;
    UILabel *lblReunionHour;
    UILabel *lblBadgeValue;
    UIImageView *imgReunionView;
    UIImageView *imgQuinteView;
    NSString *reunionDate;
    NSArray *raceInfoTabStatus;
    NSString *raceName;
    NSString *raceContexte;
    NSString *raceArrivee;
    int reunionNumber;
    int type;
    int status;
    int subSectionNumber;
    BOOL subSectionStatus;
    int raceTabSelected;
    int raceId;
    BOOL isClicable;
}

@property (strong, nonatomic) UILabel *lblReunion;
@property (strong, nonatomic) UILabel *lblReunionHour;
@property (strong, nonatomic) UILabel *lblBadgeValue;
@property (strong, nonatomic) UIImageView *imgReunionView;
@property (strong, nonatomic) UIImageView *imgQuinteView;
@property (strong, nonatomic) NSString *reunionDate;
@property (strong, nonatomic) NSArray *raceInfoTabStatus;
@property (strong, nonatomic) NSString *raceName;
@property (strong, nonatomic) NSString *raceContexte;
@property (strong, nonatomic) NSString *raceArrivee;
@property (nonatomic) int reunionNumber;
@property (nonatomic) int type;
@property (nonatomic) int status;
@property (nonatomic) int raceId;
@property (nonatomic) int subSectionNumber;
@property (nonatomic) int raceTabSelected;
@property (nonatomic) BOOL subSectionStatus;
@property (nonatomic) BOOL isClicable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(int)typeStatus;

@end
