//
//  ImgurGalleryDataSource.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurGalleryDataSource.h"
#import "ImgurFeedModel.h"
#import "ImgurImage.h"

@implementation ImgurGalleryDataSource

- (id)init {
	if (self = [super init]) {
		_feedModel = [ImgurFeedModel feed];
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_feedModel);
	[super dealloc];
}

- (id<TTModel>)model {
	return _feedModel;
}

- (void)tableViewDidLoadModel:(UITableView *)tableView {
	NSMutableArray* items = [[NSMutableArray alloc] init];
	for (ImgurImage* image in _feedModel.images) {
		//NSString* viewerUrl = [[NSString alloc] initWithFormat:@"imgur://photo/%d", image.index];
		//NSLog(@"Loading image %@ from %@, created %@, imageurl %@, url %@", image.caption, image.source, image.created, image.largeThumbUrl, image.imageUrl);
		[items addObject:[TTTableMessageItem itemWithTitle: image.caption
												   caption: nil
													  text: image.source
												 timestamp: image.created
											   imageURL: image.largeThumbUrl
													   URL: image.imageUrl]];
	}
	if (_feedModel.hasMore) {
		[items addObject:[TTTableMoreButton itemWithText:@"Load more..."]];
	}
	self.items = items;
	TT_RELEASE_SAFELY(items);
	NSLog(@"Done loading table view!");
}

- (NSString*)titleForEmpty {
	return NSLocalizedString(@"No images found.", @"Imgur feed returned no results.");
}

- (NSString*)subtitleForError:(NSError*)error {
	return NSLocalizedString(@"Error loading images from Imgur.", @"");
}

@end
