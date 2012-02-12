//
//  ImgurImage.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurImage.h"
#import <Three20/Three20.h>

@implementation ImgurImage

@synthesize caption = _caption;
@synthesize created = _created;
@synthesize imageId = _imageId;
@synthesize imageUrl = _imageUrl;
@synthesize largeThumbUrl = _largeThumbUrl;
@synthesize smallThumbUrl = _smallThumbUrl;
@synthesize source = _source;
@synthesize pageUrl = _pageUrl;
@synthesize index = _index;
@synthesize size = _size;
@synthesize photoSource = _photoSource;

- (void)dealloc {
	TT_RELEASE_SAFELY(_caption);
	TT_RELEASE_SAFELY(_created);
	TT_RELEASE_SAFELY(_imageId);
	TT_RELEASE_SAFELY(_imageUrl);
	TT_RELEASE_SAFELY(_largeThumbUrl);
	TT_RELEASE_SAFELY(_smallThumbUrl);
	TT_RELEASE_SAFELY(_source);
	TT_RELEASE_SAFELY(_pageUrl);
	[super dealloc];
}

- (NSString*)URLForVersion:(TTPhotoVersion)version {
	switch (version) {
		case TTPhotoVersionLarge:
			return _imageUrl;
		case TTPhotoVersionMedium:
			return _imageUrl;
		case TTPhotoVersionSmall:
			return _imageUrl;
		case TTPhotoVersionThumbnail:
			return _largeThumbUrl;
		default:
			return nil;
	}
}

- (NSComparisonResult)compareByDate:(ImgurImage*)otherObject {
	return [self.created compare:otherObject.created];
}

@end
