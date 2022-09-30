//
//  HTMLViewController.h
//  iphone-zoneturf
//
//  Created by Gwladys Vassort on 15/11/13.
//  Copyright (c) 2013 Moneyweb. All rights reserved.
//

#import "FrontViewController.h"

@interface HTMLViewController : FrontViewController
{
	NSString* htmlText;
	IBOutlet UIWebView* mWebView;
}

@property (nonatomic,retain) NSString* htmlText;
@property (nonatomic, retain) IBOutlet UIWebView* mWebView;

-(void)loadHTML:(NSString *)templateHTML;


@end

