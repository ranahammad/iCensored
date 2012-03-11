//
//  iCensorAppDelegate.h
//  iCensor
//
//  Created by Faisal Saeed on 8/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@class MainViewController;

@interface iCensorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
	UIAlertView *m_pActivity;
	BOOL m_bAlertShowing;
}
@property (nonatomic, retain) UIAlertView *m_pActivity;
@property (nonatomic) BOOL	m_bAlertShowing;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;
- (void) showActivityWithText:(NSString*)text;
- (void) hideActivity;
@end

