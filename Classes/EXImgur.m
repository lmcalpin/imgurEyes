//
//  EXImgur.m
//  ExportKit-Demo
//
//  Created by Shane Gianelli on 5/26/10.
//  Copyright 2010 SJ Development LLC. All rights reserved.
//

#import "EXImgur.h"


@interface EXImgur (private)

- (id)initWithDelegate:(id)del;
- (void)uploadImage:(UIImage *)img;

@end

@implementation EXImgur

+ (void)uploadImageToImgur:(UIImage *)image withDelegate:(id)del {
	EXImgur *uploader = [[EXImgur alloc] initWithDelegate:del];
	[uploader performSelectorInBackground:@selector(uploadImage:) withObject:image];
}

- (id)initWithDelegate:(id)del {
	if (self = [super init]) {
		delegate = del;
		deleteHash = nil;
	}
	
	return self;
}

- (void)uploadImage:(UIImage *)img {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if ([UIImagePNGRepresentation(img) length] > 10 * 1024 * 1024) {
		if (delegate)
			[delegate imgurFailedToPostImage:img withError:[NSError errorWithDomain:@"Image greater than 10MB" code:0 userInfo:nil]];
		
		return;
	}
	
	uploadingImage = img;
	
	if (img == nil) {
		if (delegate)
			[delegate imgurFailedToPostImage:uploadingImage withError:[NSError errorWithDomain:@"No Image" code:100 userInfo:nil]];
		
		[pool drain];
		return;
	}
	
	NSURL *url = [NSURL URLWithString:@"http://imgur.com/api/upload"];
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
	
	[postRequest setHTTPMethod:@"POST"];
	
	NSString *stringBoundary = @"sweetjesusifyourapikeyorimageisequaltothisthenimsosorrybutyoucanalwayschangeme";	
	NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	
	[postRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
		
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"key\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[kImgurAPIKey dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"dummy.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Type: image/png\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSData *imageData = UIImagePNGRepresentation(img);
	
	[postBody appendData:imageData];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];	
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postRequest setHTTPBody:postBody];
	
	NSArray *keys = [NSArray arrayWithObjects:@"image_hash",
					 @"original_image", 
					 @"delete_hash",
					 @"large_thumbnail",
					 @"small_thumbnail",
					 @"imgur_page",
					 @"delete_page",
					 @"rsp",nil];
	
	UploadManager *man = [[UploadManager alloc] initWithParserKeys:keys andDelegate:self];
	[man performSelectorOnMainThread:@selector(beginConnectionWithRequest:) withObject:postRequest waitUntilDone:NO];
	
	[pool drain];
}

+ (void)deleteImgurImageWithHash:(NSString *)hash withDelegate:(id)del {
	EXImgur *deleter = [[EXImgur alloc] initWithDelegate:del];	
	[deleter performSelectorInBackground:@selector(deleteHash:) withObject:hash];
}
- (void)deleteHash:(NSString *)hash {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	deleteHash = hash;
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *connectionResponse = nil;
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://imgur.com/api/delete/%@",hash]]];
	[urlRequest setHTTPMethod:@"POST"];
	
	connectionResponse = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	if (error != nil) {
		NSLog(@"ERROR: %@",[error localizedDescription]);
	}
	
	if (connectionResponse)
		[UploadManager parseXMLFileWithData:connectionResponse andKeys:[NSArray arrayWithObjects:@"error_msg",@"error_code",@"message",nil] withDelegate:self];
	
	[pool drain];
}

- (void)uploadCompleted:(UploadManager *)manager {
	[self release];
	self = nil;
}
- (void)uploadFailed:(UploadManager *)manager withError:(NSError *)err {
	if (delegate)
		[delegate imgurFailedToPostImage:uploadingImage withError:err];
	
	[self release];
	self = nil;
}
- (void)upload:(UploadManager *)manager receivedBytes:(NSInteger)bytes ofTotal:(NSInteger)total {
	if ([(NSObject *)delegate respondsToSelector:@selector(imgurImage:sentBytes:ofTotal:)])
		[delegate imgurImage:uploadingImage sentBytes:bytes ofTotal:total];
}
- (void)upload:(UploadManager *)manager receivedResponse:(NSDictionary *)response {
	NSLog(@"resp: %@",response);
	if (delegate && [response objectForKey:@"imgur_page"])
		[delegate imgurSuccesfullyPostedImage:uploadingImage withResponse:response];
//		[delegate imgurSuccesfullyPostedImage:uploadingImage withURL:[response objectForKey:@"imgur_page"] andDeleteHash:[response objectForKey:@"delete_hash"]];
	else if (delegate && [response objectForKey:@"message"])
		if ([(NSObject *)delegate respondsToSelector:@selector(imgurImageDeletedSuccesfullyWithHash:)])
			[delegate imgurImageDeletedSuccesfullyWithHash:deleteHash];
	else if (delegate && [response objectForKey:@"error_msg"] && deleteHash)
		if ([(NSObject *)delegate respondsToSelector:@selector(imgurImageFailedToDeleteWithHash:)])
			[delegate imgurImageFailedToDeleteWithHash:deleteHash];
	
	deleteHash = nil;
}
- (NSData *)upload:(UploadManager *)manager receivedData:(NSData *)data {
	return data;
}

- (void)dealloc {
	[super dealloc];
	
	[uploadingImage release];
	[deleteHash release];
}

@end
