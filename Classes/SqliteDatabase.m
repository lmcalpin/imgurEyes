//
//  SqliteDatabase.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SqliteDatabase.h"
#import "UploadHistory.h"

static SqliteDatabase* databaseHolder;

@implementation SqliteDatabase

@synthesize database;
@synthesize history;

+ (SqliteDatabase*) databaseHolder {
	@synchronized(self) {
		if (databaseHolder == nil) {
			databaseHolder = [[SqliteDatabase alloc] init];
		}
	}
	return databaseHolder;			
}


+ (sqlite3*) database {
	return [SqliteDatabase databaseHolder].database;			
}

+ (NSArray*) history {
	return [SqliteDatabase databaseHolder].history;			
}


- (id) init {
	if (self = [super init]) {
		[self createEditableCopyOfDatabaseIfNeeded];
		[self refreshHistory];
	}
	return self;
}

- (void)createEditableCopyOfDatabaseIfNeeded {
	BOOL success;
	// see if our database exists
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"imgur.sqlite"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return;
	// no database on device; copy the default
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"imgur.sqlite"];
	NSLog(@"Looking for database at %@", defaultDBPath);
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) {
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (void)refreshHistory {
	NSMutableArray *historyArray = [[NSMutableArray alloc] init];
	self.history = historyArray;
	[historyArray release];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"imgur.sqlite"];
	if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		const char *sql = "SELECT id FROM history ORDER BY id DESC LIMIT 100";
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
			while (sqlite3_step(statement) == SQLITE_ROW) {
				int primaryKey = sqlite3_column_int(statement, 0);
				NSLog(@"Loaded UploadHistory object for %d", primaryKey);
				UploadHistory *obj = [[UploadHistory alloc] initWithPrimaryKey:primaryKey
																	  database:database];
				[history addObject:obj];
				[obj release];
			}
		}
		// release resources
		sqlite3_finalize(statement);
	} else {
		// couldn't open, but clean up anyway
		sqlite3_close(database);
		NSAssert1(0, @"Failed to open database with message '%@'.", sqlite3_errmsg(database));
	}
}


@end
