//
//  MainViewController.m
//  iCensor
//
//  Created by Faisal Saeed on 8/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MainView.h"
#import "CensorImagePreviewHandler.h"
#import "iCensorAppDelegate.h"


@implementation MainViewController

@synthesize m_pShowToolBar;
@synthesize m_pOptionToolBar;
@synthesize m_pCensorToolBar;
@synthesize m_pSaveButton;
@synthesize m_pImageView;
@synthesize m_pAddCensorButton;
@synthesize m_pDeleteCensorButton;
@synthesize	m_iCensorImageIndex;
@synthesize m_pTitleLabel;
@synthesize m_pAdMobView;

+ (UIImage *)captureView:(UIView *)view 
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
	
    return newImage;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (CGFloat)distanceBetweenTwoPoints: (CGPoint)fromPoint toPoint: (CGPoint)toPoint{
	
	float x = toPoint.x - fromPoint.x;
	float y = toPoint.y - fromPoint.y;
	return sqrt(x * x + y * y);
	
}

- (void)touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event{
	
	NSSet *allTouches = [event allTouches];
	
	switch ([allTouches count])
	{
		case 1: 
		{
			UITouch *pTouch = [allTouches anyObject];
			
			if(m_pSelectedImageView == nil)
				return;	
			
			CGPoint pTouchPt = [pTouch locationInView:[self view]];	
			float x = pTouchPt.x - firstTouch.x;
			float y = pTouchPt.y - firstTouch.y;
			
			firstTouch = pTouchPt;
			
			CGPoint pCenter = CGPointMake(m_pSelectedImageView.center.x + x, m_pSelectedImageView.center.y + y);
			[m_pSelectedImageView setCenter:pCenter];
			//[m_pSelectionFrameImageView setCenter:pCenter];
		} 
			break;
		case 2: 
		{
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
			UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
			m_pSelectedImageView.transform = CGAffineTransformWithTouches(m_pSelectedImageView.transform, touch1, touch2);
			//The image is being zoomed in or out.
			/*
			
			
			//Calculate the distance between the two fingers.
	
			
			finalDistance = [self distanceBetweenTwoPoints:[touch1 locationInView:[self view]]
												   toPoint:[touch2 locationInView:[self view]]];
			
			CGSize pSize = [m_pSelectedImageView frame].size;
			CGPoint pCenter = m_pSelectedImageView.center;
			CGRect pFinalRect;
			//Check if zoom in or zoom out.
			
			
			
			if(initialDistance > finalDistance) 
			{
				pSize = CGSizeMake(pSize.width - 2, pSize.height - 2);
				NSLog(@"Zoom Out");
				
			}
			else 
			{
				pSize = CGSizeMake(pSize.width + 2, pSize.height + 2);
				NSLog(@"Zoom In");
			}
			pFinalRect = CGRectMake( 0, 0, pSize.width, pSize.height);
			
			
			
			//[m_pSelectedImageView setTransform:transform];
			[m_pSelectedImageView setFrame:pFinalRect];
			[m_pSelectedImageView setCenter:pCenter];
			
			//[m_pSelectionFrameImageView setFrame:[m_pSelectedImageView frame]];
			initialDistance = finalDistance;
			 */
		} break;
	}	
}

- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event{
	NSSet *allTouches = [event allTouches];
	switch ([allTouches count]) 
	{
		case 1: { //Single touch
			
			//Get the first touch.
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			
			switch ([touch tapCount])
			{
				case 1: //Single Tap.
				{
					if([m_pCensorImagesArray count] == 0)
					{
					//	[m_pSelectionFrameImageView setHidden:TRUE];
						[m_pDeleteCensorButton setEnabled:FALSE];
						return;
					}
					
					firstTouch = [touch locationInView:[self view]];
					m_pSelectedImageView = nil;
					
					for(int i=[m_pCensorImagesArray count]-1; i>=0; i--)
					{
						UIImageView* pImageView = [m_pCensorImagesArray objectAtIndex:i];
						if(CGRectContainsPoint([pImageView frame], firstTouch))
						{
							m_pSelectedImageView = pImageView;
							//[m_pSelectionFrameImageView setFrame:[m_pSelectedImageView frame]];
							//[self.view bringSubviewToFront:m_pSelectionFrameImageView];
							//[m_pSelectionFrameImageView setHidden:FALSE];
							[m_pDeleteCensorButton setEnabled:TRUE];
							break;
						}
					}
					
					if(m_pSelectedImageView)
						[self touchesMoved:touches withEvent:event];
					else
					{
						//[m_pSelectionFrameImageView setHidden:TRUE];
						[m_pDeleteCensorButton setEnabled:FALSE];
					}
				} 
				break;
					
				case 2: 
				{//Double tap.
					
				} break;
			}
		}
			break;
		case 2: 
		{ //Double Touch

			//Track the initial distance between two fingers.
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
			UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
			
			initialDistance = [self distanceBetweenTwoPoints:[touch1 locationInView:[self view]]
													 toPoint:[touch2 locationInView:[self view]]];
			
		}
			break;
		default:
			break;
	}
	
	
}

- (IBAction) deleteCensorBtnClicked
{
	if(m_pSelectedImageView != nil)
	{		
		[m_pSelectedImageView removeFromSuperview];
		[m_pCensorImagesArray removeObject:m_pSelectedImageView];
		[m_pSelectedImageView release];	
		m_pSelectedImageView = nil;
		
		if([m_pCensorImagesArray count] == 0)
		{
			[m_pDeleteCensorButton setEnabled:FALSE];
			[m_pSaveButton setEnabled:FALSE];
			//[m_pSelectionFrameImageView setHidden:TRUE];
		}
		else
		{
			UIImageView* pImageView  = [m_pCensorImagesArray objectAtIndex:[m_pCensorImagesArray count]-1];
			m_pSelectedImageView = pImageView;
			//[m_pSelectionFrameImageView setFrame:[m_pSelectedImageView frame]];
		}
	}
}


- (IBAction) addCensorBtnClicked
{

	if(m_pImageViewSelectorController == nil)
	{
		m_pImageViewSelectorController = [[ImageViewSelector alloc] initWithNibName:@"ImageViewSelector" bundle:[NSBundle mainBundle]];
		bIsCensored = TRUE;
	}
	m_pImageViewSelectorController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:m_pImageViewSelectorController animated:YES];
}

- (IBAction) showOptionToolbar
{
//	[m_pShowToolBar setFrame:CGRectMake(-160, 436, [m_pShowToolBar frame].size.width, [m_pShowToolBar frame].size.height)];
	[m_pOptionToolBar setFrame:CGRectMake(0, 436, [m_pOptionToolBar frame].size.width, [m_pOptionToolBar frame].size.height)];
	[m_pCensorToolBar setFrame:CGRectMake(0, 0, [m_pCensorToolBar frame].size.width, [m_pCensorToolBar frame].size.height)];
	[m_pTitleLabel setFrame:CGRectMake(0, 0, [m_pCensorToolBar frame].size.width, [m_pCensorToolBar frame].size.height)];
}

- (IBAction) hideOptionToolbar
{
//	[m_pShowToolBar setFrame:CGRectMake(0, 436, [m_pShowToolBar frame].size.width, [m_pShowToolBar frame].size.height)];
	[m_pOptionToolBar setFrame:CGRectMake(0, 500, [m_pOptionToolBar frame].size.width, [m_pOptionToolBar frame].size.height)];
	[m_pCensorToolBar setFrame:CGRectMake(0, -160, [m_pCensorToolBar frame].size.width, [m_pCensorToolBar frame].size.height)];
	[m_pTitleLabel setFrame:CGRectMake(0, -160, [m_pCensorToolBar frame].size.width, [m_pCensorToolBar frame].size.height)];
}

- (void) hideAllControls
{
	[self	 hideOptionToolbar];
	[m_pShowToolBar setFrame:CGRectMake(-160, 436, [m_pShowToolBar frame].size.width, [m_pShowToolBar frame].size.height)];
}

- (void) showAllControls
{
	if(m_bShowingToolBars)
		[self showOptionToolbar];
	else
		[self hideOptionToolbar];	
}

- (IBAction) takeSnapshotFromCamera
{
	[m_pImagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
	[self presentModalViewController:m_pImagePickerController animated:YES];
}

- (IBAction) loadImageFromLibrary
{
	[m_pImagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	[self presentModalViewController:m_pImagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	[m_pImageView setImage:image];
	
	if([m_pCensorImagesArray count] > 0)
	{
		for(int i=0; i<[m_pCensorImagesArray count]; i++)
		{
			UIImageView *pImageView = [m_pCensorImagesArray objectAtIndex:i];
			[pImageView removeFromSuperview];
		}
		[m_pCensorImagesArray removeAllObjects];
		[m_pDeleteCensorButton setEnabled:FALSE];
		[m_pSaveButton setEnabled:FALSE];
	}
	[self dismissModalViewControllerAnimated:TRUE];
	[m_pAddCensorButton setEnabled:TRUE];
}


- (IBAction) performAction
{
	if([m_pCensorImagesArray count] == 0)
	{
		UIAlertView* pAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select at least one censor by using the iCensored button below" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[pAlertView show];
		[pAlertView release];
		return;
	}
	[self hideAllControls];
	[m_pAdMobView setHidden:YES];
	//[m_pSelectionFrameImageView setHidden:YES];
	m_pFinalImage = [MainViewController captureView:self.view];
	[m_pAdMobView setHidden:NO];
	//[m_pSelectionFrameImageView setHidden:NO];
	[self showAllControls];	
	
	CensorImagePreviewHandler *pCensorPreview = [[CensorImagePreviewHandler alloc] initWithNibName:@"CensorImagePreviewHandler" 
																							bundle:[NSBundle mainBundle]];
	[pCensorPreview setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[pCensorPreview setM_pFinalImage:m_pFinalImage];

	[self presentModalViewController:pCensorPreview animated:YES];
	[pCensorPreview release];
}

- (void) viewWillAppear:(BOOL) bAnimated
{
	[super viewWillAppear:bAnimated];	

	if(bIsCensored == TRUE)
	{
		m_iCensorImageIndex = [m_pImageViewSelectorController m_iSelectedIndex];
		if(m_iCensorImageIndex != -1)
		{
			if(m_pImageViewSelectorController.m_iSelectedCategory == CAT_FACIAL)
			{
				NSString *pImagePath = [NSString stringWithFormat:@"%@%d%@",IMAGE_NAME_FACIAL,m_iCensorImageIndex+1,IMAGE_NAME_PRO_STRING];
				CGImageRef pImgRef = [m_pImageViewSelectorController resizeImage:[UIImage imageNamed:pImagePath]];
				UIImageView *pImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:pImgRef]];
				[pImageView setCenter:CGPointMake(160,240)];
				[m_pCensorImagesArray addObject:pImageView];
				[self.view addSubview:pImageView];
				m_pSelectedImageView = pImageView;
				CGImageRelease(pImgRef);
			
			}
			else if(m_pImageViewSelectorController.m_iSelectedCategory == CAT_GEOMETRIC)
			{
				NSString *pImagePath = [NSString stringWithFormat:@"%@%d%@",IMAGE_NAME_GEOMETRIC,m_iCensorImageIndex+1,IMAGE_NAME_PRO_STRING];
				CGImageRef pImgRef = [m_pImageViewSelectorController resizeImage:[UIImage imageNamed:pImagePath]];
				UIImageView *pImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:pImgRef]];
				[pImageView setCenter:CGPointMake(160,240)];
				[m_pCensorImagesArray addObject:pImageView];
				[self.view addSubview:pImageView];
				m_pSelectedImageView = pImageView;
				CGImageRelease(pImgRef);
			}
			else if(m_pImageViewSelectorController.m_iSelectedCategory == CAT_MOSAIC)
			{
				NSString *pImagePath = [NSString stringWithFormat:@"%@%d%@",IMAGE_NAME_MOSAIC,m_iCensorImageIndex+1,IMAGE_NAME_PRO_STRING];
				CGImageRef pImgRef = [m_pImageViewSelectorController resizeImage:[UIImage imageNamed:pImagePath]];
				UIImageView *pImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:pImgRef]];
				[pImageView setCenter:CGPointMake(160,240)];
				[m_pCensorImagesArray addObject:pImageView];
				[self.view addSubview:pImageView];
				m_pSelectedImageView = pImageView;
				CGImageRelease(pImgRef);
			}
			else if(m_pImageViewSelectorController.m_iSelectedCategory == CAT_OTHERS)
			{
				NSString *pImagePath = [NSString stringWithFormat:@"%@%d%@",IMAGE_NAME_OTHERS,m_iCensorImageIndex+1,IMAGE_NAME_PRO_STRING];
				CGImageRef pImgRef = [m_pImageViewSelectorController resizeImage:[UIImage imageNamed:pImagePath]];
				UIImageView *pImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:pImgRef]];
				[pImageView setCenter:CGPointMake(160,240)];
				[m_pCensorImagesArray addObject:pImageView];
				[self.view addSubview:pImageView];
				m_pSelectedImageView = pImageView;
				CGImageRelease(pImgRef);
			}
			else
			{
				NSString *pImagePath = [NSString stringWithFormat:@"%@%d%@",IMAGE_NAME_FACIAL,m_iCensorImageIndex+1,IMAGE_NAME_PRO_STRING];
				CGImageRef pImgRef = [m_pImageViewSelectorController resizeImage:[UIImage imageNamed:pImagePath]];
				UIImageView *pImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:pImgRef]];
				[pImageView setCenter:CGPointMake(160,240)];
				[m_pCensorImagesArray addObject:pImageView];
				[self.view addSubview:pImageView];
				m_pSelectedImageView = pImageView;
				CGImageRelease(pImgRef);
			}
			bIsCensored = FALSE;
		}
		else 
		{
			NSString *pImagePath = [NSString stringWithFormat:@"%@%d%@",IMAGE_NAME_FACIAL,m_iCensorImageIndex+1,IMAGE_NAME_PRO_STRING];
			CGImageRef pImgRef = [m_pImageViewSelectorController resizeImage:[UIImage imageNamed:pImagePath]];
			UIImageView *pImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:pImgRef]];
			[pImageView setCenter:CGPointMake(160,240)];
			
			[m_pCensorImagesArray addObject:pImageView];
			[self.view addSubview:pImageView];
			m_pSelectedImageView = pImageView;
			CGImageRelease(pImgRef);
		}
		bIsCensored = FALSE;
		[m_pImageViewSelectorController release];
		m_pImageViewSelectorController = nil;
		
		if([m_pCensorImagesArray count] > 0)
		{
			[m_pDeleteCensorButton setEnabled:TRUE];
			[m_pSaveButton setEnabled:TRUE];	
		}
		else
		{
			[m_pDeleteCensorButton setEnabled:FALSE];
			[m_pSaveButton setEnabled:FALSE];	
		}
	}
	[self showOptionToolbar];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
			m_iCensorImageIndex = -1;
    }
    return self;
}

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	m_pFinalImage = nil;
	m_pCensorImagesArray = [[NSMutableArray alloc] init];	
	
	m_pImagePickerController = [[UIImagePickerController alloc] init];
	[m_pImagePickerController setDelegate:self];
	[m_pImagePickerController setWantsFullScreenLayout:TRUE];
	[m_pImagePickerController setAllowsImageEditing:TRUE];
	m_bShowingToolBars = TRUE;

	m_pImageViewSelectorController = nil;
	bIsCensored = FALSE;
	//m_pSelectionFrameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boxSelection.png"]];
	//[self.view addSubview:m_pSelectionFrameImageView];
	//[m_pSelectionFrameImageView setHidden:TRUE];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
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


- (void)dealloc 
{
    [super dealloc];
	
	if([m_pCensorImagesArray count] > 0)
	{
		for(int	i=0; i< [m_pCensorImagesArray count]; i++)
		{
			[[m_pCensorImagesArray objectAtIndex:i] removeFromSuperview];
		}
	
		[m_pCensorImagesArray removeAllObjects];
	}
	[m_pCensorImagesArray release];
	m_pCensorImagesArray = nil;
}

CGFloat distanceBetweenPoints(CGPoint firstPoint, CGPoint secondPoint) {
	CGFloat distance;
	
	//Square difference in x
	CGFloat xDifferenceSquared = pow(firstPoint.x - secondPoint.x, 2);
	// NSLog(@"xDifferenceSquared: %f", xDifferenceSquared);
	
	// Square difference in y
	CGFloat yDifferenceSquared = pow(firstPoint.y - secondPoint.y, 2);
	// NSLog(@"yDifferenceSquared: %f", yDifferenceSquared);
	
	// Add and take Square root
	distance = sqrt(xDifferenceSquared + yDifferenceSquared);
	// NSLog(@"Distance: %f", distance);
	return distance;
	
}
 

CGPoint vectorBetweenPoints(CGPoint firstPoint, CGPoint secondPoint) {
	// NSLog(@"Point One: %f, %f", firstPoint.x, firstPoint.y);
	// NSLog(@"Point Two: %f, %f", secondPoint.x, secondPoint.y);
	
	CGFloat xDifference = firstPoint.x - secondPoint.x;
	CGFloat yDifference = firstPoint.y - secondPoint.y;
	
	CGPoint result = CGPointMake(xDifference, yDifference);
	
	return result;
}


CGAffineTransform CGAffineTransformWithTouches(CGAffineTransform oldTransform,
											   UITouch *firstTouch,
											   UITouch *secondTouch) 
{
	
	CGPoint firstTouchLocation = [firstTouch locationInView:nil];
	CGPoint firstTouchPreviousLocaion = [firstTouch previousLocationInView:nil];
	CGPoint secondTouchLocation = [secondTouch locationInView:nil];
	CGPoint secondTouchPreviousLocaion = [secondTouch previousLocationInView:nil];
	
	CGAffineTransform newTransform;
	
	// Calculate new scale and rotation
	
	// Get distance between points
	CGFloat currentDistance = distanceBetweenPoints(firstTouchLocation,
													secondTouchLocation);
	
	CGFloat previousDistance = distanceBetweenPoints(firstTouchPreviousLocaion,
													 secondTouchPreviousLocaion);
	
	// Figure new scale
	
	CGFloat distanceRatio = currentDistance / previousDistance;
	// NSLog(@"DifferenceRatio: %f, %f", distanceRatio.x, distanceRatio.y);
	
	// Combine with current transform
	newTransform = CGAffineTransformScale(oldTransform, distanceRatio, distanceRatio);
	
	
	// Now figure new rotation
	
	// Get previous angle
	CGPoint previousDifference = vectorBetweenPoints(firstTouchPreviousLocaion, secondTouchPreviousLocaion);
	CGFloat xDifferencePrevious = previousDifference.x;
	
	// Use acos to get angle to avoid issue with the denominator being 0
	CGFloat previousRotation = acos(xDifferencePrevious / previousDistance); // adjacent over hypotenuse
	if (previousDifference.y < 0) {
		// account for acos of angles in quadrants III and IV
		previousRotation *= -1;
	}
	// NSLog(@"previousRotation: %f", previousRotation);
	
	// Get current angle
	CGPoint currentDifference = vectorBetweenPoints(firstTouchLocation, secondTouchLocation);
	CGFloat xDifferenceCurrent = currentDifference.x;
	
	// Use acos to get angle to avoid issue with the denominator being 0
	CGFloat currentRotation = acos(xDifferenceCurrent / currentDistance); // adjacent over hypotenuse
	if (currentDifference.y < 0) {
		// account for acos of angles in quadrants III and IV
		currentRotation *= -1;
	}
	// NSLog(@"currentRotation: %f", currentRotation);
	
	CGFloat newAngle = currentRotation - previousRotation;
	
	// Combine with current transform
	newTransform = CGAffineTransformRotate(newTransform, newAngle);
	
	// Return result
	return newTransform;
}
 
/*
-(UIImage*) resizeImage:(UIImage*)originalImage
{
	//NSAutoreleasePool* pPool = [[NSAutoreleasePool alloc] init];
	// calculate scale based on the larger of the original width and height
	float originalWidth = originalImage.size.width;
	float originalHeight = originalImage.size.height;
	float percentage;
	if (originalWidth > originalHeight)
		percentage = SAMPLE_IMAGE_WIDTH / originalWidth;
	else
		percentage = SAMPLE_IMAGE_HEIGHT / originalHeight;
	
	float newWidth = originalWidth * percentage;
	float newHeight = originalHeight * percentage;
	
	
	CGRect headshotRect = CGRectMake(0.0f, 0.0f, SAMPLE_IMAGE_WIDTH, SAMPLE_IMAGE_HEIGHT);
	
	CGRect scaledImageRect = CGRectMake((SAMPLE_IMAGE_WIDTH - newWidth) / 2.0f,     // centered on x
										(SAMPLE_IMAGE_HEIGHT - newHeight) / 2.0f,    // centered on y
										newWidth,
										newHeight);
	
	CGContextRef context = MyCreateBitmapContext(SAMPLE_IMAGE_WIDTH, SAMPLE_IMAGE_HEIGHT);
	
	// Draw a black background
	CGContextSaveGState(context);
	CGContextSetRGBFillColor (context, 0.0f, 0.0f, 0.0f, 0.0f);     // change fill to black
	CGContextFillRect(context, headshotRect);                       // draw a rectangle for the background
	CGContextRestoreGState(context);
	
	// draw the original image scaled
	CGContextDrawImage(context, scaledImageRect, originalImage.CGImage);
	
	// get the data back out
	CGImageRef myRef = CGBitmapContextCreateImage (context);
	free(CGBitmapContextGetData(context));
	CGContextRelease(context);
	//[pPool release];
	// return a new UIImage
	UIImage* pRetImage = [UIImage imageWithCGImage:myRef];
	CGImageRelease(myRef);
	return pRetImage;
}
*/
- (IBAction) showLoading
{
	iCensorAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate showActivityWithText:@"Loading..."];
	[NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(addCensorBtnClicked) userInfo:nil repeats:NO];
	
}
@end
