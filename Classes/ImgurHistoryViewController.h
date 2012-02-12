//
//  ImgurHistoryViewController.h
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import <sqlite3.h>

@interface ImgurHistoryViewController : TTTableViewController {
}

@property(nonatomic,retain) NSArray* history;

@end
