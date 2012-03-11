//
//  iCensorAppDelegate.m
//  iCensor
//
//  Created by Faisal Saeed on 8/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "iCensorAppDelegate.h"
#import "MainViewController.h"

@implementation iCensorAppDelegate


@synthesize window;
@synthesize mainViewController;
@synthesize m_pActivity;
@synthesize m_bAlertShowing;

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	[[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	
//    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
	[aController release];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}
- (void) showActivityWithText:(NSString*)text
{
	if(m_pActivity == nil)
	{
		UIAlertView *tmpAlertView = [[UIAlertView alloc] initWithTitle: @""
															   message: nil
															  delegate: self
													 cancelButtonTitle: nil
													 otherButtonTitles: nil];
		
		UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityView.frame = CGRectMake(139.0f-18.0f, 50.0f, 37.0f, 37.0f);
		[tmpAlertView addSubview:activityView];
		[activityView startAnimating];
		[activityView release];
		
		self.m_pActivity = tmpAlertView;
		[tmpAlertView release];
	}
	
	self.m_pActivity.title = text;
	[self.m_pActivity show];
	
	m_bAlertShowing = YES;	
	
}
- (void) hideActivity{
	if (m_bAlertShowing == NO)
		return;
	
	[m_pActivity dismissWithClickedButtonIndex:99 animated:YES];
	m_bAlertShowing = NO;
}
@end
