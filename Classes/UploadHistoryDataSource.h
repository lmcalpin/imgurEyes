//
//  UploadHistoryDataSource.h
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface UploadHistoryDataSource : TTListDataSource {
	NSArray* history;
}

- (id)initWithHistory:(NSArray*)history;

@end
