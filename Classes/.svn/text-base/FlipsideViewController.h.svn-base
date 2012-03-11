//
//  FlipsideViewController.h
//  iCensor
//
//  Created by Faisal Saeed on 8/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController {
	id <FlipsideViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done;
- (IBAction)infoBtnClicked;
- (IBAction)itouchballClicked;
- (IBAction)tellmystoryClicked;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

