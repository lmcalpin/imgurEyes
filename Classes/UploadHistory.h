//
//  UploadHistory.h
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

/*
CREATE TABLE history(id INTEGER PRIMARY KEY, image_hash VARCHAR(35), delete_hash VARCHAR(35), 
original_image VARCHAR(65), large_thumbnail VARCHAR(65), small_thumbnail VARCHAR(65), 
imgur_page VARCHAR(65), delete_page VARCHAR(65), upload_date VARCHAR(65)); 
*/

@interface UploadHistory : NSObject {
	NSInteger primaryKey;
	NSString* image_hash;
	NSString* delete_hash;
	NSString* original_image;
	NSString* large_thumbnail;
	NSString* small_thumbnail;
	NSString* imgur_page;
	NSString* delete_page;
	NSString* upload_date;
}

@property(assign,nonatomic,readonly) NSInteger primaryKey;
@property(nonatomic,retain) NSString* image_hash;
@property(nonatomic,retain) NSString* delete_hash;
@property(nonatomic,retain) NSString* original_image;
@property(nonatomic,retain) NSString* large_thumbnail;
@property(nonatomic,retain) NSString* small_thumbnail;
@property(nonatomic,retain) NSString* imgur_page;
@property(nonatomic,retain) NSString* delete_page;
@property(nonatomic,retain) NSString* upload_date;

- (id)initWithPrimaryKey:(NSInteger)id database:(sqlite3*)db;

+ (NSInteger)insertToDatabase:(sqlite3*)database withData:(NSDictionary*)response;

@end
