//
//  ImageViewSelector.h
//  iCensor
//
//  Created by Faisal Saeed on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect/FBConnect.h"

#define IMAGE_NAME_OTHERS		@"Others/others"
#define IMAGE_NAME_FACIAL		@"Facial/fac"
#define	IMAGE_NAME_MOSAIC		@"Mosaic/mos"
#define IMAGE_NAME_GEOMETRIC	@"Geometric/geom"
#define IMAGE_NAME_PRO_STRING	@".png"
#define IMAGE_COUNT				15
#define IMAGE_COUNT_FACIAL		30
#define IMAGE_COUNT_MOSAIC		17
#define IMAGE_COUNT_OTHERS		25
#define IMAGE_COUNT_GEO			26


enum CATEGORIES
{
	CAT_FACIAL = 1,
	CAT_GEOMETRIC = 2,
	CAT_MOSAIC = 3,
	CAT_OTHERS = 4
};
@interface ImageViewSelector : UIViewController <UINavigationControllerDelegate, 
												UITableViewDelegate, UITableViewDataSource>
{
	NSInteger		m_iSelectedIndex;
//	NSInteger		m_iSelectedSize;
	
//	UISegmentedControl	*	m_pSegmentControl;
	NSMutableArray *	m_pImagesArray;
	//NSMutableArray*		m_pImagesArrayFacial;
	//NSMutableArray*		m_pImagesArrayMosaic;
	//NSMutableArray*		m_pImagesArrayGemoetric;
	//NSMutableArray*		m_pImagesArrayOthers;

	UITableView	*	m_pTableView;
	NSInteger		m_iSelectedCategory;
	UIAlertView *m_pPurchaseActivity;
	
}
@property (nonatomic) NSInteger m_iSelectedCategory;
@property (nonatomic, retain) IBOutlet UITableView *m_pTableView;
//@property (nonatomic) NSInteger	m_iSelectedSize;
@property (nonatomic) NSInteger m_iSelectedIndex;
//@property (nonatomic, retain) IBOutlet UISegmentedControl *m_pSegmentControl;

-(IBAction) goBack;
-(IBAction) selectCategory1;
-(IBAction) selectCategory2;
-(IBAction) selectCategory3;
-(IBAction) selectCategory4;
-(IBAction) selectCategory5;
-(CGImageRef) resizeImage:(UIImage*)originalImage;
//-(IBAction) segmentControlClicked;
@end
