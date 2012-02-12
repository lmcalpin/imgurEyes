//
//  EXImgur.h
//  ExportKit-Demo
//
//  Created by Shane Gianelli on 5/26/10.
//  Copyright 2010 SJ Development LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadManager.h"

// get your api key at imgur.com/register/api_anon
#define kImgurAPIKey @"GETYOUROWNAPIKEY"


@protocol EXImgurDelegate

- (void)imgurSuccesfullyPostedImage:(UIImage *)image withResponse:(NSDictionary *)response;
- (void)imgurFailedToPostImage:(UIImage *)image withError:(NSError *)error;

@optional
- (void)imgurImage:(UIImage *)image sentBytes:(NSInteger)bytes ofTotal:(NSInteger)total;

- (void)imgurImageDeletedSuccesfullyWithHash:(NSString *)hash;
- (void)imgurImageFailedToDeleteWithHash:(NSString *)hash;

@end

@interface EXImgur : NSObject {
@private
	id<EXImgurDelegate> delegate;
	UIImage *uploadingImage;
	NSString *deleteHash;
}

+ (void)uploadImageToImgur:(UIImage *)image withDelegate:(id)del;
+ (void)deleteImgurImageWithHash:(NSString *)hash withDelegate:(id)del;

@end
