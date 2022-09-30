//
//  HTMLViewController.m
//  iphone-zoneturf
//
//  Created by Gwladys Vassort on 15/11/13.
//  Copyright (c) 2013 Moneyweb. All rights reserved.
//

#import "HTMLViewController.h"

@interface HTMLViewController ()

@end

@implementation HTMLViewController

@synthesize htmlText, mWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) loadHTML:(NSString *)templateHTML{
    NSError *error;
    
	self.htmlText=[NSString stringWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:templateHTML] encoding:NSUTF8StringEncoding error:&error];
    
}

@end




