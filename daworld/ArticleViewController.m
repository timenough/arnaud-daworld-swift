
#import "ArticleViewController.h"
#import "NSString+HTML.h"

@interface ArticleViewController ()

@end

@implementation ArticleViewController

@synthesize mItems,
    mItemIndex,
    mAllItems,
    scrollView,
    webViewArray,
    prevIndex,
    currIndex,
    nextIndex,
    nextButton,
    prevButton,
    socialSheet,
    itemsArrayToShare,
    itemsArrayToExclude,
    messagesSelonLeTypeDePartage;

- (void)viewWillAppear:(BOOL)animated
{
    
    if(pageType==2){
        
        UIButton *left_leftbuttoninstance = [UIButton buttonWithType:UIButtonTypeCustom];
        [left_leftbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_back_icon.png"] forState:UIControlStateNormal];
        [left_leftbuttoninstance addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
        left_leftbuttoninstance.frame = CGRectMake(0.0, 0.0, 24.0, 24.0);
        UIBarButtonItem *NewleftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_leftbuttoninstance];
        self.navigationItem.leftBarButtonItem = NewleftBarButtonItem;
        
        /* AVANT
        UIImage *backButtonImage = [UIImage imageNamed:@"button_back_icon.png"];
        UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissView:)];
        customItem.tintColor = [UIColor whiteColor];
        [self.navigationItem setLeftBarButtonItem: customItem];
        */

        UIButton *right_leftbuttoninstance = [UIButton buttonWithType:UIButtonTypeCustom];
        [right_leftbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_prev_icon.png"] forState:UIControlStateNormal];
        [right_leftbuttoninstance addTarget:self action:@selector(moveToPrevArticle:) forControlEvents:UIControlEventTouchUpInside];
        right_leftbuttoninstance.frame = CGRectMake(0.0, 0.0, 39.0, 24.0);
        
        UIButton *right_rightbuttoninstance = [UIButton buttonWithType:UIButtonTypeCustom];
        [right_rightbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_next_icon.png"] forState:UIControlStateNormal];
        [right_rightbuttoninstance addTarget:self action:@selector(moveToNextArticle:) forControlEvents:UIControlEventTouchUpInside];
        right_rightbuttoninstance.frame = CGRectMake(0.0, 0.0, 24.0, 24.0);
        
        /* AVANT
        UIImage *nextButtonImage = [UIImage imageNamed:@"button_next_icon.png"];
        UIImage *prevButtonImage = [UIImage imageNamed:@"button_prev_icon.png"];
        nextButton         = [[UIBarButtonItem alloc]
                                                 initWithImage:nextButtonImage style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(moveToNextArticle:)];
        
        prevButton          = [[UIBarButtonItem alloc]
                                                initWithImage:prevButtonImage style:UIBarButtonItemStylePlain
                                                target:self action:@selector(moveToPrevArticle:)];
         
        nextButton.tintColor = [UIColor whiteColor];
        prevButton.tintColor = [UIColor whiteColor];
         */
        
        prevButton          = [[UIBarButtonItem alloc] initWithCustomView:right_leftbuttoninstance];
        nextButton          = [[UIBarButtonItem alloc] initWithCustomView:right_rightbuttoninstance];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:nextButton,prevButton,nil];
        
    }
    
    [self enableArrows:mItemIndex];
    
    [super viewDidAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.topItem.title = self.pageTitle;
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    
    float startPositionY    = 0;
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if(sysVer >= 7.0f)
        startPositionY = 63.0f;

    self.pageType  = 2;
    
    [super viewDidLoad];
    
    [self loadAdsBanner:nil isforView:self.view withBackgroundColor:[UIColor blackColor] atPositionX:0 atPositionY:startPositionY];
    
    //////
    ////// WEBVIEW ARRAY
    //////
    webViewArray = [[NSMutableArray alloc] initWithCapacity:20];
    currIndex    = mItemIndex;
    
    //////
    ////// SCROLLVIEW > INIT
    //////
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,53.0f+startPositionY,self.view.frame.size.width,self.view.frame.size.height-53.0f-startPositionY)];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    //////
    ////// SCROLLVIEW > EACH WEBVIEW
    //////
    for(int i = 0; i<[mAllItems count];i++){
        
        CGRect webViewContainer;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            webViewContainer = CGRectMake(320*i,0,self.view.frame.size.width,self.view.frame.size.height-53.0f-startPositionY);
        }
        else{
            webViewContainer = CGRectMake(320*i,0,self.view.frame.size.width,self.view.frame.size.height-140.0f-startPositionY);
        }
        
        ArticleWebView *theWebView      = [[ArticleWebView alloc] initWithFrame:webViewContainer];
        theWebView.autoresizingMask     = ( UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth );
        theWebView.delegate             = self;
        theWebView.mItems               = [mAllItems objectAtIndex:i];
        theWebView.scrollView.backgroundColor = [UIColor colorWithRed:228.0/255 green:223.0/255 blue:216.0/255 alpha:1];
        [webViewArray addObject:theWebView];
        [theWebView loadHTML];
        
        [scrollView addSubview:theWebView];
    }
    
    //////
    ////// SCROLLVIEW > SLIDE EFFECT
    //////
    scrollView.scrollEnabled                        = NO;
    self.view.userInteractionEnabled                = YES;
    UISwipeGestureRecognizer *GesteVersLaGauche     = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiptToTheLeft:)];
    [GesteVersLaGauche setDirection:UISwipeGestureRecognizerDirectionLeft];
    [GesteVersLaGauche setDelegate:self];
    UISwipeGestureRecognizer *GesteVersLaDroite     = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiptToTheRight:)];
    [GesteVersLaDroite setDirection:UISwipeGestureRecognizerDirectionRight];
    [GesteVersLaDroite setDelegate:self];
    UITapGestureRecognizer *TapTape                 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapit)];
    [TapTape setNumberOfTapsRequired:1];
    [TapTape setDelegate:self];
    
    [self.view addGestureRecognizer:GesteVersLaDroite];
    [self.view addGestureRecognizer:GesteVersLaGauche];
    [self.view addGestureRecognizer:TapTape];
    
    //////
    ////// SCROLLVIEW > OTHER CONF
    //////
    [self.view addSubview:scrollView];
    scrollView.contentSize                  = CGSizeMake(320*20, self.view.frame.size.height-53.0f-startPositionY);
	[scrollView scrollRectToVisible:CGRectMake(320*mItemIndex,0,320,self.view.frame.size.height-53.0f-startPositionY) animated:NO];
    
    // Affichage de la Bannière pub
    [self displayAdsBanner:@"ArticleViewController"];
    
}

#pragma mark - GestureRecognizer

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    return YES;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    return YES;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    return NO;
    
}

#pragma mark - UIGestureRecognizer Delegate

-(void)swiptToTheLeft:(UISwipeGestureRecognizer *)recognizer
{
    
    [self moveToNextArticle:nil];
    
}

-(void)swiptToTheRight:(UISwipeGestureRecognizer *)recognizer
{
    
    [self moveToPrevArticle:nil];
    
}

#pragma methods

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    
    /*
	// Reset offset back to middle page
    currIndex = (round(scrollView.contentOffset.x / 320));
    NSLog(@"offset = %f",scrollView.contentOffset.x);
    [self enableArrows:currIndex];
	[scrollView scrollRectToVisible:CGRectMake(320*currIndex,0,320,416) animated:NO];
    */
    
}

- (void)moveToNextArticle:(id)sender
{
    
    currIndex = currIndex + 1;
    if(currIndex>=20)currIndex = 20;
    [self enableArrows:currIndex];

    [UIView animateWithDuration:.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{[scrollView scrollRectToVisible:CGRectMake(320*currIndex,0,320,416) animated:NO]; }
                     completion:NULL];
    
}

- (void)moveToPrevArticle:(id)sender
{
    
    currIndex = currIndex - 1;
    if(currIndex<0)currIndex = 0;
    [self enableArrows:currIndex];
    
    // AVANT
    //[scrollView scrollRectToVisible:CGRectMake(320*currIndex,0,320,416) animated:NO];
    
    [UIView animateWithDuration:.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{[scrollView scrollRectToVisible:CGRectMake(320*currIndex,0,320,416) animated:NO]; }
                     completion:NULL];
    
}

- (void)disabledWebViewScroll:(id)sender
{
    
    [[[[scrollView subviews] objectAtIndex:currIndex] scrollView] setScrollEnabled:NO];
    
}

- (void)enableWebViewScroll:(id)sender
{
    
    [[[[scrollView subviews] objectAtIndex:currIndex] scrollView] setScrollEnabled:NO];
    
}

- (void)enableArrows:(int)currentPage
{
    
    if(currentPage<=0){
        [prevButton setEnabled:NO];
    }
    else if(currentPage>=19){
        [nextButton setEnabled:NO];
    }
    else{
        [prevButton setEnabled:YES];
        [nextButton setEnabled:YES];
    }
    [[[[scrollView subviews] objectAtIndex:currIndex] scrollView] setContentOffset:CGPointMake(0, 0) animated:NO];
    
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(ArticleWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    /////////
    ///////// TEXTE REDUIT
    /////////
    if ( [request.mainDocumentURL.relativePath isEqualToString:@"/minus"] ) {
        //[[MoneyWebServices services] decrementFontSize];
        [webView loadHTML];
        return NO;
    }
    /////////
    ///////// TEXTE AGRANDIT
    /////////
    else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/plus"] ) {
        //[[MoneyWebServices services] incrementFontSize];
        [webView loadHTML];
        return NO;
    }
    /////////
    ///////// PARTAGE REASEAUX SOCIAUX
    /////////
    else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/share"] ) {
        [self sharePage:webView.mItems];
        [webView loadHTML];
        return NO;
    }
    /////////
    ///////// LIEN (ouverture dans Safari)
    /////////
    else{
        if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
            [[UIApplication sharedApplication] openURL:[request URL]];
            return NO;
        }
    }
    return YES;
    
}

#pragma mark - Actions

-(IBAction) dismissView:(id) sender
{
    
	[self.navigationController popViewControllerAnimated:YES];
    
}

-(void)sharePage:(NSDictionary*)itms
{
    
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    /// Préparation des Messages
    messagesSelonLeTypeDePartage                            = [[APActivityProvider alloc] init];
    messagesSelonLeTypeDePartage.customMailMessage          = [NSString stringWithFormat:@"<html><body>Retrouvez cet article sur Zone-Turf.fr en cliquant sur l'URL ci-dessous :<br//><a href='%@'>%@</a><br//><br//>Téléchargez l'appli Zone-Turf.fr sur <a href='%@'>iPhone</a></body></html>",[itms objectForKey:@"link"],[itms objectForKey:@"link"],[itms objectForKey:@"link"]];
    messagesSelonLeTypeDePartage.customTwitterMessage       = [NSString stringWithFormat:@"RT @Zone_Turf : \"%@\" %@",[itms objectForKey:@"title"],[NSURL URLWithString:[itms objectForKey:@"link"]]];
    messagesSelonLeTypeDePartage.customFacebookMessage      = [NSURL URLWithString:[itms objectForKey:@"link"]];
    messagesSelonLeTypeDePartage.customSMSMessage           = [NSString stringWithFormat:@"%@ %@",[itms objectForKey:@"title"],[itms objectForKey:@"link"]];
    
    /// Préparation du sheet
    itemsArrayToShare                                       = @[messagesSelonLeTypeDePartage];
    if(sysVer >= 7.0f){
        itemsArrayToExclude                                 = @[
                                                                UIActivityTypePostToWeibo,
                                                                UIActivityTypePostToVimeo,
                                                                UIActivityTypePostToTencentWeibo,
                                                                UIActivityTypeCopyToPasteboard,
                                                                UIActivityTypeAssignToContact,
                                                                UIActivityTypeSaveToCameraRoll,
                                                                UIActivityTypeAirDrop,
                                                                UIActivityTypePrint
                                                                ];
    }
    else{
        itemsArrayToExclude                                 = @[
                                                                UIActivityTypePostToWeibo,
                                                                UIActivityTypeCopyToPasteboard,
                                                                UIActivityTypePrint
                                                                ];
    }
    socialSheet                                             = [[UIActivityViewController alloc] initWithActivityItems:itemsArrayToShare applicationActivities:nil];
    socialSheet.excludedActivityTypes                       = itemsArrayToExclude;
    [socialSheet setValue:[NSString stringWithFormat:@"Zone-Turf.fr : %@",[itms objectForKey:@"title"]] forKey:@"subject"];
    [socialSheet setCompletionHandler:^(NSString *act, BOOL done){
        NSString *ServiceMsg = nil;
        if ( [act isEqualToString:UIActivityTypeMail] )           ServiceMsg = @"Votre mail a bien été envoyé";
        if ( [act isEqualToString:UIActivityTypePostToTwitter] )  ServiceMsg = @"Votre message a bien été posté sur Twitter";
        if ( [act isEqualToString:UIActivityTypePostToFacebook] ) ServiceMsg = @"Votre message a bien été posté sur Facebook";
        if ( [act isEqualToString:UIActivityTypeMessage] )        ServiceMsg = @"Votre SMS a bien été envoyé";
        if ( done )
        {
            UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:ServiceMsg message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [Alert show];
        }
    }];
    
    /// Déclenchement du sheet
    [self.navigationController presentViewController:socialSheet animated:YES completion:nil];
    
}

-(IBAction)changePage:(id)sender
{
    
    /*
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pagecontrol.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    */
    
}

@end

@implementation APActivityProvider

@synthesize customTwitterMessage,
    customFacebookMessage,
    customSMSMessage,
    customMailMessage;

- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
        return customTwitterMessage;
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
        return customFacebookMessage;
    if ( [activityType isEqualToString:UIActivityTypeMessage] )
        return customSMSMessage;
    if ( [activityType isEqualToString:UIActivityTypeMail] )
        return customMailMessage;
    return nil;
    
}

- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    
    return @"";
    
}

@end

