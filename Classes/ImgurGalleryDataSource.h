//
//  ImgurGalleryDataSource.h
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "ImgurFeedModel.h"

@interface ImgurGalleryDataSource : TTListDataSource {
	ImgurFeedModel* _feedModel;
}

@end

