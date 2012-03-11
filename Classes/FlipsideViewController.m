//
//  FlipsideViewController.m
//  iCensor
//
//  Created by Faisal Saeed on 8/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
}

- (IBAction)infoBtnClicked
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.vahzay.com"]];
}


- (IBAction)itouchballClicked
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=318336925"]];
}

- (IBAction)tellmystoryClicked
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=313855175&mt=8&s=143441"]];
}

- (IBAction)done {
	[self.delegate flipsideViewControllerDidFinish:self];	
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
