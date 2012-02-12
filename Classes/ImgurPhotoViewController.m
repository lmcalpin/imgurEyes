//
//  ImgurPhotoViewController.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurPhotoViewController.h"
#import "ImgurSource.h"
#import "ImgurImage.h"

@implementation ImgurPhotoViewController

- (id)initWithIndex:(int)index {
	ImgurFeedModel* feedModel = [ImgurFeedModel feed];
	ImgurImage* photo = [feedModel.images objectAtIndex:index];
	if (self = [self initWithPhoto:photo]) {
		NSLog(@"Initializing photoviewer for index %d; new center image is %d", index, [self centerPhotoIndex]);
		self.title = @"Photos";
	}
	return self;
}

- (void)viewDidLoad {
	ImgurFeedModel* feedModel = [ImgurFeedModel feed];
	self.photoSource = [[ImgurSource alloc]
						initWithTitle:@"Imgur"
						photos:feedModel.images];
}
	
@end
