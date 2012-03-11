//
//  ImageViewSelector.m
//  iCensor
//
//  Created by Faisal Saeed on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ImageViewSelector.h"
#import "iCensorAppDelegate.h"

#define SAMPLE_IMAGE_WIDTH	100
#define SAMPLE_IMAGE_HEIGHT	100

@implementation ImageViewSelector

//@synthesize m_pSegmentControl;
@synthesize m_pTableView;
@synthesize m_iSelectedIndex;
@synthesize m_iSelectedCategory;
//@synthesize m_iSelectedSize;

CGContextRef MyCreateBitmapContext (int pixelsWide,
		int pixelsHigh)
{
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;

	
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);

	colorSpace = CGColorSpaceCreateDeviceRGB();
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Memory not allocated!");
		return NULL;
	}
	context = CGBitmapContextCreate (bitmapData,
			pixelsWide,
			pixelsHigh,
			8,
			bitmapBytesPerRow,
			colorSpace,
			kCGImageAlphaPremultipliedLast);
	if (context== NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
		return NULL;
	}
	CGColorSpaceRelease( colorSpace );
	return context;
}
//- (CGImageRef)resizeImage:(UIImage*)originalImage toWidth:(int)width andHeight:(int)height {
/*- (CGImageRef)resizeImage:(UIImage*) originalImage
{
	float originalWidth = originalImage.size.width;
	float originalHeight = originalImage.size.height;
	float percentage;
	if (originalWidth > originalHeight)
		percentage = SAMPLE_IMAGE_WIDTH / originalWidth;
	else
		percentage = SAMPLE_IMAGE_HEIGHT / originalHeight;
	
	float newWidth = originalWidth * percentage;
	float newHeight = originalHeight * percentage;
	
	// create context, keeping original image properties
	CGColorSpaceRef colorspace = CGImageGetColorSpace(originalImage.CGImage);
	
	CGContextRef context = CGBitmapContextCreate(NULL, newWidth, newHeight,
												 CGImageGetBitsPerComponent(originalImage.CGImage),
												 CGImageGetBytesPerRow(originalImage.CGImage),
												 colorspace,
												 CGImageGetAlphaInfo(originalImage.CGImage));
	CGColorSpaceRelease(colorspace);
	
	if(context == NULL)
		return nil;
	
	// draw image to context (resizing it)
	CGContextDrawImage(context, CGRectMake(0, 0, newWidth, newHeight), originalImage.CGImage);
	// extract resulting image from context
	CGImageRef imgRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	return imgRef;
}
 */

-(CGImageRef) resizeImage:(UIImage*)originalImage
{
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
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


	
	
	bitmapBytesPerRow   = (SAMPLE_IMAGE_WIDTH * 4);
	bitmapByteCount     = (bitmapBytesPerRow * SAMPLE_IMAGE_HEIGHT);
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Memory not allocated!");
		return NULL;
	}
	context = CGBitmapContextCreate (bitmapData,
									 SAMPLE_IMAGE_WIDTH,
									 SAMPLE_IMAGE_HEIGHT,
									 8,
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedLast);
	if (context== NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
		return NULL;
	}
	CGColorSpaceRelease( colorSpace );

	
	//CGContextRef context = MyCreateBitmapContext(SAMPLE_IMAGE_WIDTH, SAMPLE_IMAGE_HEIGHT);

	// Draw a black background
	CGContextSaveGState(context);
	CGContextSetRGBFillColor (context, 0.0f, 0.0f, 0.0f, 0.0f);     // change fill to black
	CGContextFillRect(context, headshotRect);                       // draw a rectangle for the background
	CGContextRestoreGState(context);

	// draw the original image scaled
	CGContextDrawImage(context, scaledImageRect, originalImage.CGImage);

	// get the data back out
	CGImageRef myRef = CGBitmapContextCreateImage (context);
	//void* pBitmap = CGBitmapContextGetData(context);
	//if(pBitmap != NULL)
	//	free(pBitmap);
	free(CGBitmapContextGetData(context));
	CGContextRelease(context);
	free(bitmapData);
	//free(context);
	
	return myRef;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
		//Custom initialization
		m_iSelectedIndex = -1;
	}
	return self;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [m_pImagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier%d",indexPath.row];

	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];

	UIImageView *pImageView = [[UIImageView alloc] initWithImage:[[m_pImagesArray objectAtIndex:indexPath.row] image]];

	[pImageView setCenter:CGPointMake(160,50)];
	[cell addSubview:pImageView];
	[pImageView release];

	//[[cell imageView] setImage:[[m_pImagesArray objectAtIndex:indexPath.row] image]]	;
	if(m_iSelectedIndex == indexPath.row)
		[cell setSelected:TRUE];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	m_iSelectedIndex = indexPath.row;
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction) goBack
{
	m_iSelectedIndex = -1;
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void) viewDidLoad
{
	NSAutoreleasePool* pPool = [[NSAutoreleasePool alloc] init];
	[super viewDidLoad];

	if(m_pImagesArray == nil)
		m_pImagesArray = [[NSMutableArray alloc] init];
	[m_pImagesArray removeAllObjects];
	for(int i= 1; i <= IMAGE_COUNT_OTHERS; i++)
	{
		NSString *pImageName = [NSString stringWithFormat:@"%@%d%@",IMAGE_NAME_OTHERS,i,IMAGE_NAME_PRO_STRING];
		UIImage *pImage = [UIImage imageNamed:pImageName];
		CGImageRef pImgRef = [self resizeImage:pImage];
		UIImageView *pImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:pImgRef]];
		[m_pImagesArray addObject:pImageView];
		CGImageRelease(pImgRef);
		[pImageView release];
		[pImage release];
	}

	m_iSelectedCategory = CAT_OTHERS;
	[pPool release];
	iCensorAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate hideActivity];
}


- (void) viewWillAppear:(BOOL) bAnimated
{
	[super viewWillAppear:bAnimated];
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
- (void)dealloc 
{
	if(m_pImagesArray != nil)
	{
		for(int i=0; i<[m_pImagesArray count]; i++)
			[[m_pImagesArray objectAtIndex:i] release];
	}

	[super dealloc];
	
}
- (void) reloadImages
{
	int iCount = 0;
	NSString* strImgName;
	if(m_iSelectedCategory == CAT_FACIAL)
	{
		iCount = IMAGE_COUNT_FACIAL;
		strImgName = IMAGE_NAME_FACIAL;
	}
	else if(m_iSelectedCategory == CAT_GEOMETRIC)
	{
		iCount = IMAGE_COUNT_GEO;
		strImgName = IMAGE_NAME_GEOMETRIC;
	}
	else if(m_iSelectedCategory == CAT_MOSAIC)
	{
		iCount = IMAGE_COUNT_MOSAIC;
		strImgName = IMAGE_NAME_MOSAIC;
	}
	else if(m_iSelectedCategory == CAT_OTHERS)
	{
		iCount = IMAGE_COUNT_OTHERS;
		strImgName = IMAGE_NAME_OTHERS;
	}
		
	[m_pImagesArray removeAllObjects];
	for(int i=1; i<= iCount; i++)
	{
		NSString *pImageName = [NSString stringWithFormat:@"%@%d%@",strImgName,i,IMAGE_NAME_PRO_STRING];
		UIImage *pImage = [UIImage imageNamed:pImageName];
		CGImageRef pImgRef = [self resizeImage:pImage];
		UIImageView *pImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:pImgRef]];
		[m_pImagesArray addObject:pImageView];
		CGImageRelease(pImgRef);
		[pImageView release];
		[pImage release];
	}
	
	iCensorAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate hideActivity];
	[m_pTableView reloadData];
}
-(IBAction) selectCategory1
{
	iCensorAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate showActivityWithText:@"Loading..."];
	m_iSelectedCategory = CAT_FACIAL;
	[NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(reloadImages) userInfo:nil repeats:NO];

}
-(IBAction) selectCategory2
{
	iCensorAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate showActivityWithText:@"Loading..."];
	m_iSelectedCategory = CAT_GEOMETRIC;
	[NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(reloadImages) userInfo:nil repeats:NO];
}
-(IBAction) selectCategory3
{
	iCensorAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate showActivityWithText:@"Loading..."];
	m_iSelectedCategory = CAT_MOSAIC;
	[NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(reloadImages) userInfo:nil repeats:NO];
}
-(IBAction) selectCategory4
{
	iCensorAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate showActivityWithText:@"Loading..."];
	m_iSelectedCategory = CAT_OTHERS;
	[NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(reloadImages) userInfo:nil repeats:NO];
}
-(IBAction) selectCategory5
{
	
}

@end
