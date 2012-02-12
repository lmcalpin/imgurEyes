//
//  ImgurSource.h
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface ImgurSource : TTURLRequestModel<TTPhotoSource> {
	NSString* _title;
	NSMutableArray* _photos;
}

@property(nonatomic,copy) NSString* title;
@property(nonatomic,retain) NSArray *photos;

- (id)initWithTitle:(NSString*)title photos:(NSArray*)photos;

@end
