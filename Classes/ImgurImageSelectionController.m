//
//  ImgurImageSelectionController.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurImageSelectionController.h"
#import "ImgurUploadViewController.h"
#import <Three20/Three20.h>
#import "SqliteDatabase.h"

@implementation ImgurImageSelectionController

@synthesize choosePhotoButton = choosePhotoButton;
@synthesize takePhotoButton = takePhotoButton;

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
	NSLog(@"Loading ImgurImageSelectionController file");
	if (self = [super init]) {
		self.title = @"Upload";
		self.tabBarItem.image = [UIImage imageNamed:@"86-camera.png"];
		NSArray* objs = [[NSBundle mainBundle] loadNibNamed:@"ImgurImageSelectionController" owner:self options:nil];
		if (objs == nil) {
			NSLog(@"Failed to load nib file");
		}
	}
	return self;
}

/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
}

- (IBAction) choosePhotoFromPhotosAlbum {
	NSLog(@"Choose photo...");
	UIImagePickerController* picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	[self presentModalViewController:picker animated:YES];
}

- (IBAction) takePhoto {
	NSLog(@"Take photo...");
	UIImagePickerController* picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
	[picker dismissModalViewControllerAnimated:NO];
	
	UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	ImgurUploadViewController* uploadViewController = [[ImgurUploadViewController alloc] initWithImage:image];
	[self.navigationController pushViewController:uploadViewController animated:YES];
//	[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"imgur://upload/confirm"]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}


@end
