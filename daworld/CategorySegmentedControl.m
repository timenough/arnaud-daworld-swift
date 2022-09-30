
#import "CategorySegmentedControl.h"

@implementation CategorySegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setSegmentedControlStyle:UISegmentedControlStylePlain];
        
        
        UIImage *segment = [[UIImage imageNamed:@"bg_tablecell_section_menu.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [[UISegmentedControl appearance] setBackgroundImage:segment forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UISegmentedControl appearance] setDividerImage:segment forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        
        
        [[UISegmentedControl appearance] setBackgroundColor:[UIColor colorWithRed:23.0/255 green:21.0/255 blue:17.0/255 alpha:1]];
        
        [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont boldSystemFontOfSize:13.0f],UITextAttributeFont,
                                      [UIColor whiteColor], UITextAttributeTextColor,
                                      [UIColor blackColor], UITextAttributeTextShadowColor,
                                      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                      nil] forState:UIControlStateNormal];
        
        UIImage *segmentSelected = [[UIImage imageNamed:@"bg_segmented_control_category.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        UIImage *segmentUnselected = [[UIImage imageNamed:@"bg_segmented_control_category_off.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

        
        [[UISegmentedControl appearance] setBackgroundImage:segmentSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [[UISegmentedControl appearance] setDividerImage:segmentSelected forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UISegmentedControl appearance] setDividerImage:segmentUnselected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
       
        
        
        [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont boldSystemFontOfSize:13.0f],UITextAttributeFont,
                                      [UIColor whiteColor], UITextAttributeTextColor,
                                      [UIColor blackColor], UITextAttributeTextShadowColor,
                                      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                      nil] forState:UIControlStateSelected];
       
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
