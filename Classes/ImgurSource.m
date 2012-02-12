//
//  ImgurSource.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurSource.h"
#import <Three20/Three20.h>
#import "ImgurImage.h"

@implementation ImgurSource
@synthesize title = _title;
@synthesize photos = _photos;

- (id)initWithTitle:(NSString*)title photos:(NSArray*)photos {
	if ((self = [super init])) {
		self.title = title;
		self.photos = photos;
		for (int i = 0; i < _photos.count; ++i) {
			ImgurImage *photo = [_photos objectAtIndex:i];
			photo.photoSource = self;
			photo.index = i;
		}
	}
	return self;
}

- (void)dealloc {
	self.title = nil;
	self.photos = nil;
	[super dealloc];
}

- (BOOL)isLoading {
	return FALSE;
}

- (BOOL)isLoaded {
	return TRUE;
}

- (NSInteger)numberOfPhotos {
	return 100;
}

- (NSInteger)maxPhotoIndex {
	return _photos.count - 1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)index {
	if (index < _photos.count) {
		return [_photos objectAtIndex:index];
	} else {
		return nil;
	}
}

@end
