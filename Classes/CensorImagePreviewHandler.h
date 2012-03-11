//
//  CensorImagePreviewHandler.h
//  iCensor
//
//  Created by Faisal Saeed on 8/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FBConnect/FBConnect.h"
#define FACEBOOK_API_KEY		@"5d6be52dd5f0aa859578cb1bda24eea1"
#define FACEBOOK_API_SECRET		@"c90d67b24b93f2c9b475db5f591dc9d0"
@interface CensorImagePreviewHandler : UIViewController <MFMailComposeViewControllerDelegate, FBRequestDelegate, FBSessionDelegate, FBDialogDelegate>
{
	UIImageView	*		m_pPreviewImageView;
	UIImage		*		m_pFinalImage;
	FBSession*			m_pFBSession;
	FBLoginDialog*		m_pFBLoginDialog;
	FBPermissionDialog* m_pFBPermDialog;
	FBRequest*			m_pFBRequest;
}

@property (nonatomic, retain) IBOutlet UIImageView	*	m_pPreviewImageView;
@property (nonatomic, retain) UIImage	*	m_pFinalImage;

- (IBAction) sendEmail;
- (IBAction) donePreviewClicked;
- (IBAction) saveToPhotoAlbum;
- (IBAction) sendFacebook;
- (void)session:(FBSession*)session didLogin:(FBUID)uid;
- (void)request:(FBRequest*)request didLoad:(id)result;
- (void)uploadPhoto:(UIImage *)uploadImage;


@end
