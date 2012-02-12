//
//  ImgurUploadViewController.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurUploadViewController.h"
#import "ExImgur.h"
#import <Three20/Three20.h>
#import "UploadHistory.h"
#import "SqliteDatabase.h"

@implementation ImgurUploadViewController

@synthesize imageViewer = imageViewer;
@synthesize uploadPhotoButton = uploadPhotoButton;

- (id)initWithImage:(UIImage*)setImage {
	if (self = [super init]) {
		self.title = @"Upload";
		NSLog(@"setting image %@", setImage);
		image = setImage;
		[image retain];
		NSArray* objs = [[NSBundle mainBundle] loadNibNamed:@"ImgurUploadViewController" owner:self options:nil];
		if (objs == nil) {
			NSLog(@"Failed to load nib file");
		}
		if (image != nil) {
			NSLog(@"putting image %@ in %@", image, imageViewer);
			imageViewer.image = image;
			imageViewer.contentMode = UIViewContentModeScaleAspectFit;
		}
	}
	return self;
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
	[image release];
}

- (IBAction) uploadPhoto {
	NSLog(@"Uploading Photo");
	progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	[progressView setFrame:CGRectMake(60.0f, 222.0f, 200.0f, 20.0f)];
	[progressView setProgress:0.0f];
	[self.view addSubview:progressView];
	[EXImgur uploadImageToImgur:image withDelegate:self];
}

- (void)imgurSuccesfullyPostedImage:(UIImage *)image withResponse:(NSDictionary *)response {
	[progressView release];
	[self.navigationController popViewControllerAnimated:NO];
	NSInteger primaryKey = [UploadHistory insertToDatabase:[SqliteDatabase database] withData:response]; 
	NSLog(@"Successful upload: created row %d", primaryKey);
	[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"imgur://upload"]];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload succeeded" message:@"Your photo is now on imgur." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)imgurFailedToPostImage:(UIImage *)image withError:(NSError *)error {
	[progressView release];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload failed" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)imgurImage:(UIImage *)image sentBytes:(NSInteger)bytes ofTotal:(NSInteger)total {
	float progress = ((float)bytes / (float)total);
	[progressView setProgress:progress];
}

@end
