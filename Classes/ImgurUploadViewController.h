//
//  ImgurUploadViewController.h
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "EXImgur.h"

@interface ImgurUploadViewController : TTViewController<EXImgurDelegate> {
	UIImage *image;
	UIImageView *imageViewer;
	UIButton *uploadPhotoButton;
	UIProgressView *progressView;
}

@property(nonatomic,retain) IBOutlet UIImageView *imageViewer;
@property(nonatomic,retain) IBOutlet UIButton *uploadPhotoButton;

-(IBAction) uploadPhoto;

@end
