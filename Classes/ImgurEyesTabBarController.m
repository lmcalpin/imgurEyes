//
//  ImgurEyesTabBarController.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurEyesTabBarController.h"


@implementation ImgurEyesTabBarController
- (void)viewDidLoad {
	[self setTabURLs:[NSArray arrayWithObjects:
					  @"imgur://gallery",
					  @"imgur://upload",
					  @"imgur://history",
					  nil]];
}
@end
