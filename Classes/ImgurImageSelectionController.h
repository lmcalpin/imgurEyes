//
//  ImgurImageSelectionController.h
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@interface ImgurImageSelectionController : TTViewController<UIImagePickerControllerDelegate> {
	UIButton* choosePhotoButton;
	UIButton* takePhotoButton;

}

@property(nonatomic,retain) IBOutlet UIButton* choosePhotoButton;
@property(nonatomic,retain) IBOutlet UIButton* takePhotoButton;

-(IBAction) choosePhotoFromPhotosAlbum;
-(IBAction) takePhoto;

@end
