//
//  UploadHistoryDataSource.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UploadHistoryDataSource.h"

#import "UploadHistory.h"

@implementation UploadHistoryDataSource

- (id)initWithHistory:(NSArray*)historyRecords {
	if (self = [super init]) {
		history = historyRecords;
	}
	return self;
	
}

- (void)tableViewDidLoadModel:(UITableView *)tableView {
	NSMutableArray* items = [[NSMutableArray alloc] init];
	for (UploadHistory* upload in history) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterFullStyle];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		NSDate* upload_date = [dateFormatter dateFromString:upload.upload_date];
		[items addObject:[TTTableMessageItem itemWithTitle: upload.image_hash
												   caption: nil
													  text: nil
												 timestamp: upload_date
												  imageURL: upload.large_thumbnail
													   URL: upload.imgur_page]];
	}
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

- (NSString*)titleForEmpty {
	return NSLocalizedString(@"No history found.", @"You have not uploaded any photos using this iPhone application yet.");
}

- (NSString*)subtitleForError:(NSError*)error {
	return NSLocalizedString(@"Error loading upload history.", @"");
}

@end
