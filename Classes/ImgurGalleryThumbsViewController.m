//
//  ImgurGalleryThumbsViewController.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurGalleryThumbsViewController.h"
#import <Three20/Three20.h>
#import "ImgurFeedModel.h"
#import "ImgurImage.h"
#import "ImgurSource.h"

@implementation ImgurGalleryThumbsViewController

- (id)init {
	NSLog(@"init gallerythumbsController");
	if (self = [super init]) {
		self.title = @"Thumbs";
		self.hidesBottomBarWhenPushed = NO;
		//self.delegate = self;
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"Thumbs view appearing");
	UINavigationController* navController = self.navigationController;
	navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	[self setWantsFullScreenLayout:YES];
}

- (void)viewDidLoad {
	ImgurFeedModel* feedModel = [ImgurFeedModel feed];
	NSLog(@"ViewDidLoad called, loading %d images", [feedModel.images count]);
	self.photoSource = [[ImgurSource alloc]
						initWithTitle:@"Imgur"
						photos:feedModel.images];
}

- (void)thumbsViewController:(TTThumbsViewController*)controller didSelectPhoto:(id<TTPhoto>)photo {
	NSLog(@"Selected photo %d -> caption: %@", photo.index, photo.caption);
	ImgurFeedModel* feedModel = [ImgurFeedModel feed];
	ImgurImage* image = [feedModel.images objectAtIndex:photo.index];
	[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:image.imageUrl]];
}

- (BOOL)thumbsViewController:(TTThumbsViewController*)controller shouldNavigateToPhoto:(id<TTPhoto>)photo {
	return NO;
}


- (void)dealloc {
    [super dealloc];
}

@end
