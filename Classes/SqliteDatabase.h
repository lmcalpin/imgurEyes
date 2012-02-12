//
//  SqliteDatabase.h
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqliteDatabase : NSObject {
	sqlite3 *database;
	NSMutableArray* history;
}

@property(nonatomic) sqlite3* database;
@property(nonatomic,retain) NSArray* history;

+ (sqlite3*)database;
+ (NSArray*)history;
+ (SqliteDatabase*)databaseHolder;

- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)refreshHistory;

@end
