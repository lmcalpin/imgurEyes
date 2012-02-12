    //
//  ImgurGalleryViewController.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurGalleryTableViewController.h"
#import "ImgurGalleryDataSource.h"

@implementation ImgurGalleryTableViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
	NSLog(@"init gallerytableviewController");
	if (self = [super init]) {
		self.title = @"Gallery";
		self.variableHeightRows = YES;
		self.tabBarItem.image = [UIImage imageNamed:@"33-cabinet.png"];
	}
	return self;
}
		
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	UINavigationController* navController = self.navigationController;
	navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	NSLog(@"Gallery view appearing");
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
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

- (void) createModel {
	self.dataSource = [[[ImgurGalleryDataSource alloc]
									init] autorelease];
}
		
- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}
		
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

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Selected object at index path %@", indexPath);
	[super didSelectObject:object atIndexPath:indexPath];
}

- (void)dealloc {
    [super dealloc];
}


@end
