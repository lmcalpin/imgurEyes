//
//  ImgurFeedModel.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurFeedModel.h"
#import "ImgurImage.h"
#import <Three20/Three20.h>
#import "extThree20JSON/extThree20JSON.h"
#import "Utils.h"

static NSString* kGalleryFeedFormat = @"http://imgur.com/api/gallery.json?page=%d";
static ImgurFeedModel* feed;

@implementation ImgurFeedModel

@synthesize images = images;
@synthesize hasMore = hasMore;

+ (ImgurFeedModel*) feed {
	@synchronized(self) {
		if (feed == nil) {
			feed = [[ImgurFeedModel alloc] init];
		}
	}
	return feed;			
}

- (id)init {
	if (self = [super init]) {
		currentPage = 0;
		images = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(images);
	[super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	if (!self.isLoading) {
		isLoading = YES;
		if (more) {
			hasMore = (currentPage > 5) ? NO : YES;
			currentPage++;
		} else {
			currentPage = 1;
			[images removeAllObjects];
		}
		NSString* url = [NSString stringWithFormat:kGalleryFeedFormat, currentPage];
		NSLog(@"Loading data from: %@, more=%d", url, more);
		TTURLRequest* request = [TTURLRequest requestWithURL:url delegate:self];
		//request.cachePolicy = cachePolicy | TTURLRequestCachePolicyEtag;
		//request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE;
		TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
		request.response = response;
		TT_RELEASE_SAFELY(response);
		[request send];
	}
}
			  
- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
	NSDictionary* feed = response.rootObject;
	//NSLog(@"Found feed: %@", feed);
	TTDASSERT([[feed objectForKey:@"images"] isKindOfClass:[NSArray class]]);
	NSDictionary* entries = [feed objectForKey:@"images"];
	NSLog(@"Found %d entries", [entries count]);
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterFullStyle];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSMutableArray* newImages = [[NSMutableArray alloc] initWithCapacity:[entries count]];
	int index = [images count];
	for (NSString* key in entries) {		
//		NSLog(@"Creating image for %@ at index %d", key, index);
		NSDictionary* entry = [entries objectForKey:key];
		ImgurImage* image = [[ImgurImage alloc] init];
//		NSLog(@"Formatting entry of class %@: %@", [entry class], entry);
		NSString* strDate = [entry objectForKey:@"date_popular"];
		NSDate* date = [dateFormatter dateFromString:strDate];
		image.created = date;
//		NSLog(@"Formatting %@ as date %@", strDate, date);
		image.imageUrl = [entry objectForKey:@"original_image"];
//		NSLog(@"Formatting imageurl %@", image.imageUrl);
		image.pageUrl = [entry objectForKey:@"imgur_page"];
		image.imageId = [entry objectForKey:@"image_hash"];
		image.smallThumbUrl = [entry objectForKey:@"small_thumbnail"];
		image.largeThumbUrl = [entry objectForKey:@"large_thumbnail"];
		image.source = [entry objectForKey:@"source"];
		if (isEmpty(image.source))
			image.source = @"";
		image.caption = [entry objectForKey:@"message"];
		if (isEmpty(image.caption))
			image.caption = @"";
		image.index = index++;
//		NSLog(@"#%d, %@ from %@", image.index, image.caption, image.source);
		[newImages addObject:image];
	}
	NSArray* sortedArray = [newImages sortedArrayUsingSelector:@selector(compareByDate:)];
	sortedArray = [sortedArray reversedArray];
	[images addObjectsFromArray:sortedArray];
	NSLog(@"Returning %d images", [images count]);
	[super requestDidFinishLoad:request];
	isLoading = NO;
}

- (BOOL)isLoading {
	return isLoading;
}

@end
