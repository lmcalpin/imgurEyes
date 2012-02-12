//
//  ImgurFeedModel.h
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface ImgurFeedModel : TTURLRequestModel {
	NSInteger currentPage;
	NSMutableArray* images;
	BOOL hasMore;
	BOOL isLoading;
}

@property(nonatomic,readonly) NSArray* images;
@property(nonatomic) BOOL hasMore;

- (id)initForPage:(NSInteger)page;

+ (ImgurFeedModel *)feed;

@end
