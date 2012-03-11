//
//  MainViewController.h
//  iCensor
//
//  Created by Faisal Saeed on 8/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FlipsideViewController.h"

#import "ImageViewSelector.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> 
{
	UIToolbar	*	m_pShowToolBar;
	UIToolbar	*	m_pOptionToolBar;
	UINavigationBar	*	m_pCensorToolBar;
	UILabel		*	m_pTitleLabel;
	UIView*			m_pAdMobView;
		
	BOOL			m_bShowingToolBars;
	UIImagePickerController	*	m_pImagePickerController;

	UIBarButtonItem	*	m_pAddCensorButton;
	UIBarButtonItem *	m_pDeleteCensorButton;
	UIBarButtonItem	*	m_pSaveButton;
	
	UIImageView	*	m_pImageView;
	
	NSMutableArray	*	m_pCensorImagesArray;
	UIImageView	*	m_pSelectedImageView;
	
	NSInteger		m_iCensorImageIndex;
	ImageViewSelector	*m_pImageViewSelectorController;

	//UIImageView	*	m_pSelectionFrameImageView;
	
	UIImage	*	m_pFinalImage;
	CGFloat		initialDistance;
	CGFloat		finalDistance;
	
	CGPoint		firstTouch;
	BOOL		bIsCensored;
}

@property (nonatomic, retain) IBOutlet UILabel *	m_pTitleLabel;
@property (nonatomic) NSInteger m_iCensorImageIndex;
@property (nonatomic, retain) IBOutlet UIBarButtonItem	* m_pAddCensorButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem	* m_pDeleteCensorButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem	* m_pSaveButton;
@property (nonatomic, retain) IBOutlet UIToolbar	*	m_pShowToolBar;
@property (nonatomic, retain) IBOutlet UIToolbar	*	m_pOptionToolBar;
@property (nonatomic, retain) IBOutlet UINavigationBar	*	m_pCensorToolBar;
@property (nonatomic, retain) IBOutlet UIView*			m_pAdMobView;
@property (nonatomic, retain) IBOutlet UIImageView	*	m_pImageView;

- (IBAction) deleteCensorBtnClicked;
- (IBAction) addCensorBtnClicked;
- (IBAction) showOptionToolbar;
- (IBAction) hideOptionToolbar;
- (IBAction) takeSnapshotFromCamera;
- (IBAction) loadImageFromLibrary;

- (IBAction) performAction;

- (IBAction) showInfo;
- (IBAction) showLoading;
//-(UIImage*) resizeImage:(UIImage*)originalImage;
CGAffineTransform CGAffineTransformWithTouches(CGAffineTransform oldTransform,
											   UITouch *firstTouch,
											   UITouch *secondTouch);

@end
