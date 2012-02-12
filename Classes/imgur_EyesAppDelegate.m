//
//  imgur_EyesAppDelegate.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "imgur_EyesAppDelegate.h"
#import <Three20/Three20.h>
#import "ImgurGalleryTableViewController.h"
#import "ImgurGalleryThumbsViewController.h"
#import "ImgurEyesTabBarController.h"
#import "ImgurPhotoViewController.h"
#import "ImgurWebController.h"
#import "ImgurUploadViewController.h"
#import "ImgurImageSelectionController.h"
#import "ImgurHistoryViewController.h"
#import "ImgurStyleSheet.h"

@implementation imgur_EyesAppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [[TTURLRequestQueue mainQueue] setMaxContentLength:0];
	[[TTURLCache sharedCache] setMaxPixelCount:10*320*480]; // approx 10 images
	[TTStyleSheet setGlobalStyleSheet:[[[ImgurStyleSheet alloc] init] autorelease]];
	 
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeNone;
	navigator.window = [[[UIWindow alloc] initWithFrame:TTScreenBounds()] autorelease];
	
	ImgurFeedModel* feedModel = [ImgurFeedModel feed];
	[feedModel load:TTURLRequestCachePolicyDisk more:YES];

	TTURLMap* map = navigator.URLMap;
	[map from:@"*" toViewController:[ImgurWebController class]];
	[map from:@"imgur://tabbar" toSharedViewController: [ImgurEyesTabBarController class]];
	[map from:@"imgur://gallery" toSharedViewController: [ImgurGalleryTableViewController class]];
	[map from:@"imgur://thumbs" toSharedViewController: [ImgurGalleryThumbsViewController class]];
	[map from:@"imgur://upload" toViewController: [ImgurImageSelectionController class]];
	[map from:@"imgur://history" toSharedViewController: [ImgurHistoryViewController class]];
	[map from:@"imgur://photo/(initWithIndex:)" toSharedViewController: [ImgurPhotoViewController class]];

	if (![navigator restoreViewControllers]) {
		[navigator openURLAction:[TTURLAction actionWithURLPath:@"imgur://tabbar"]];
        NSLog(@"loading tabbar");
    } else {
        NSLog(@"did not restore view controllers");

    }

	return YES;
}

- (void)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application tab is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [super dealloc];
}


@end
