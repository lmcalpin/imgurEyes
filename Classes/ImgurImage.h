//
//  ImgurImage.h
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface ImgurImage : NSObject<TTPhoto> {
	NSString* _caption;
	NSDate* _created;
	NSString* _imageId;
	NSString* _imageUrl;
	NSString* _smallThumbUrl;
	NSString* _largeThumbUrl;
	NSString* _source;
	NSString* _pageUrl;
	NSInteger _index;
	CGSize _size;
	id<TTPhotoSource> _photoSource;
}

@property(nonatomic,copy) NSString* caption;
@property(nonatomic,retain) NSDate* created;
@property(nonatomic,copy) NSString* imageId;
@property(nonatomic,copy) NSString* imageUrl;
@property(nonatomic,copy) NSString* smallThumbUrl;
@property(nonatomic,copy) NSString* largeThumbUrl;
@property(nonatomic,copy) NSString* source;
@property(nonatomic,copy) NSString* pageUrl;
@property(nonatomic,assign) id<TTPhotoSource> photoSource;
@property(nonatomic) CGSize size;
@property(nonatomic) NSInteger index;

@end
