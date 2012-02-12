//
//  UploadHistory.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UploadHistory.h"

#import "SqliteDatabase.h"

static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *insert_statement = nil;

@implementation UploadHistory

@synthesize primaryKey;
@synthesize image_hash;
@synthesize delete_hash;
@synthesize original_image;
@synthesize large_thumbnail;
@synthesize small_thumbnail;
@synthesize imgur_page;
@synthesize delete_page;
@synthesize upload_date;

+ (NSInteger)insertToDatabase:(sqlite3*)database withData:(NSDictionary*)response {
	NSString* image_hash = [response objectForKey:@"image_hash"];
	NSString* delete_hash = [response objectForKey:@"delete_hash"];
	NSString* original_image = [response objectForKey:@"original_image"];
	NSString* large_thumbnail = [response objectForKey:@"large_thumbnail"];
	NSString* small_thumbnail = [response objectForKey:@"small_thumbnail"];
	NSString* imgur_page = [response objectForKey:@"imgur_page"];
	NSString* delete_page = [response objectForKey:@"delete_page"];
	NSDate* today = [NSDate date];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString* upload_date = [formatter stringFromDate:today];

	if (insert_statement == nil) {
		static char *sql = "INSERT INTO history(imgur_page, delete_hash, image_hash, original_image, large_thumbnail, small_thumbnail, delete_page, upload_date) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
		if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare insert statement: '%s'.", sqlite3_errmsg(database));
		} 
	}
	sqlite3_bind_text(insert_statement, 1, [imgur_page UTF8String], -1, SQLITE_STATIC);
	sqlite3_bind_text(insert_statement, 2, [delete_hash UTF8String], -1, SQLITE_STATIC);
	sqlite3_bind_text(insert_statement, 3, [image_hash UTF8String], -1, SQLITE_STATIC);
	sqlite3_bind_text(insert_statement, 4, [original_image UTF8String], -1, SQLITE_STATIC);
	sqlite3_bind_text(insert_statement, 5, [large_thumbnail UTF8String], -1, SQLITE_STATIC);
	sqlite3_bind_text(insert_statement, 6, [small_thumbnail UTF8String], -1, SQLITE_STATIC);
	sqlite3_bind_text(insert_statement, 7, [delete_page UTF8String], -1, SQLITE_STATIC);
	sqlite3_bind_text(insert_statement, 8, [upload_date UTF8String], -1, SQLITE_STATIC);

	int result = sqlite3_step(insert_statement);
	sqlite3_reset(insert_statement);
	if (result != SQLITE_ERROR) {
		NSInteger primaryKey = sqlite3_last_insert_rowid(database);
		NSLog(@"Inserted new history entry with primaryKey=%d and url=%@", primaryKey, imgur_page);
		[[SqliteDatabase databaseHolder] refreshHistory];
		return primaryKey; 
	}
	NSAssert1(0, @"Error inserting row: '%s'", sqlite3_errmsg(database));
	return -1;
}

- (NSString*)stringOrNilFromColumn:(NSInteger)column forStatement:(sqlite3_stmt*)statement {
	char *columnValue = (char*)sqlite3_column_text(statement, column);
	if (columnValue == NULL)
		return nil;
	return [NSString stringWithUTF8String:columnValue];
}

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3*)database {
	if (self = [super init]) {
		primaryKey = pk;
		if (init_statement == nil) {
			const char *sql = "SELECT image_hash, delete_hash, original_image, large_thumbnail, small_thumbnail, delete_page, imgur_page, upload_date FROM history WHERE id=?";
			if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
				NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
			}
		}
		sqlite3_bind_int(init_statement, 1, primaryKey);
		if (sqlite3_step(init_statement) == SQLITE_ROW) {
			self.image_hash = [self stringOrNilFromColumn:0 forStatement:init_statement];
			self.delete_hash = [self stringOrNilFromColumn:1 forStatement:init_statement];
			self.original_image = [self stringOrNilFromColumn:2 forStatement:init_statement];
			self.large_thumbnail = [self stringOrNilFromColumn:3 forStatement:init_statement];
			self.small_thumbnail = [self stringOrNilFromColumn:4 forStatement:init_statement];
			self.delete_page = [self stringOrNilFromColumn:5 forStatement:init_statement];
			self.imgur_page = [self stringOrNilFromColumn:6 forStatement:init_statement];
			self.upload_date = [self stringOrNilFromColumn:7 forStatement:init_statement];
		}
		sqlite3_reset(init_statement);
	}
	return self;
}


@end
