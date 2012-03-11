//
//  CensorImagePreviewHandler.m
//  iCensor
//
//  Created by Faisal Saeed on 8/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CensorImagePreviewHandler.h"
#import "CP_Reachability.h"

@implementation CensorImagePreviewHandler

@synthesize m_pFinalImage;
@synthesize m_pPreviewImageView;

- (void) sendToFriend:(id)sender
{
	NSString *body = @"Please find attached a photo created via iCensored iPhone Application. I am sure you will find it amusing.<br><br>iCensored is a VahZay Application<br>Other application by <bold><a href=\"http://www.vahzay.com\">Vahzay®</a></bold><br><italic><a href=\"http://tellmystory.vahzay.com\">      Tell My Story</a><br><a href=\"http://itouchball.vahzay.com\">      iTouchBall</a></italic><br>";
	//[body writeToFile:@"/Users/sergey_styopkin/Documents/Projects/Darren/email.html" atomically:YES];
	MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
	[mailViewController setMailComposeDelegate:self];
	[mailViewController setSubject:NSLocalizedString(@"iCensored Photo from a friend's iPhone", @"")];
	[mailViewController setMessageBody:body isHTML:YES];
	
	if (m_pFinalImage) {
		[mailViewController addAttachmentData:UIImageJPEGRepresentation(m_pFinalImage, 1)
									 mimeType:@"image/jpeg"
									 fileName:@"image.jpg"];
	}
	
	[self presentModalViewController:mailViewController animated:YES];
	[mailViewController release];
}

- (IBAction) sendEmail
{
	if(m_pFinalImage)
	{
		[self sendToFriend:nil];
	}
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	
	if (result == MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"The e-mail could not be sent. This may be due to incomplete e-mail settings, Internet connection failure, or e-mail server failure. Please check your settings and try again."
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) donePreviewClicked
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (IBAction) saveToPhotoAlbum
{
	if(m_pFinalImage)
	{
		UIImageWriteToSavedPhotosAlbum(m_pFinalImage, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);  
	}
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {  
    NSString *message;  
    NSString *title;  
    if (!error) {  
        title = NSLocalizedString(@"Saving Image", @"");  
        message = NSLocalizedString(@"Image successfully saved.", @"");  
    } else {  
        title = NSLocalizedString(@"Saving Image", @"");  
        message = [error description];  
	}  
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title  
													message:message  
												   delegate:nil  
										  cancelButtonTitle:NSLocalizedString(@"OK", @"")  
										  otherButtonTitles:nil];  
	[alert show];  
	[alert release];  
	
}

- (void) viewWillAppear:(BOOL) bAnimated
{
	[super viewWillAppear:bAnimated];
	[m_pPreviewImageView setImage:m_pFinalImage];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

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
	[m_pFBSession.delegates removeObject: self];
	
    if(m_pFBSession != nil)
	{
		[m_pFBSession release];
		m_pFBSession = nil;
	}
	if(m_pFBLoginDialog != nil)
	{
		[m_pFBLoginDialog release];
		m_pFBLoginDialog = nil;
	}
	/*if(m_pFBRequest != nil)
	{
		[m_pFBRequest release];
		m_pFBRequest = nil;
	}*/
	if(m_pFBPermDialog != nil)
	{
		[m_pFBPermDialog release];
		m_pFBPermDialog = nil;
	}
	
	if(m_pFinalImage != nil)
	{
		[m_pFinalImage release];
		m_pFinalImage = nil;
	}
	if(m_pPreviewImageView != nil)
	{
		[m_pPreviewImageView release];
		m_pPreviewImageView = nil;
	}
	[super dealloc];
}

- (IBAction) sendFacebook
{
	if([[CP_Reachability sharedReachability] internetConnectionStatus] != NotReachable)
	{
		
	
		if(m_pFBSession == nil)
			m_pFBSession = [[FBSession sessionForApplication:FACEBOOK_API_KEY secret:FACEBOOK_API_SECRET delegate:self] retain];
		if([m_pFBSession resume] == NO)
		{
			if(m_pFBLoginDialog == nil)
				m_pFBLoginDialog = [[[FBLoginDialog alloc] initWithSession:m_pFBSession] retain]; 
			[m_pFBLoginDialog show];
		}
	}
	else
	{
		UIAlertView* pAlertView = [[UIAlertView alloc] initWithTitle:@"Internet Connection Problem" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[pAlertView show];
		[pAlertView release];
	}
	
}
- (void)session:(FBSession*)session didLogin:(FBUID)uid 
{
	if(m_pFBPermDialog == nil)
		m_pFBPermDialog = [[[FBPermissionDialog alloc] init] retain]; 
	m_pFBPermDialog.delegate = self; 
	
	m_pFBPermDialog.permission = @"publish_stream"; 
	[m_pFBPermDialog show];
}
- (void)request:(FBRequest*)request didLoad:(id)result
{
	NSLog(@"Upload photo request processed");
}
- (void)dialogDidSucceed:(FBDialog*)dialog 
{ 
	NSLog(@"Permission OK");
	[self uploadPhoto:m_pFinalImage];
	
}
- (void)dialogDidCancel:(FBDialog*)dialog 
{
	
}

- (void)uploadPhoto:(UIImage *)uploadImage 
{
	NSMutableDictionary *args = [[[NSMutableDictionary alloc] init] retain]; 
	[args setObject:uploadImage forKey:@"image"]; // 'images' is an array of 'UIImage' objects 
	//[args setObject:@"4865751097970555873" forKey:@"aid"];// 
	if(m_pFBRequest == nil)
		m_pFBRequest = [FBRequest requestWithDelegate:self]; 
	[m_pFBRequest call:@"photos.upload" params:args];	
	NSLog(@"uploading image is successful"); 
	UIAlertView* pAlertView = [[UIAlertView alloc] initWithTitle:@"Facebook Upload" message:@"Your iCensored photo has been uploaded to your Facebook profile" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[pAlertView show];
	[pAlertView release];
}

@end
