//
//  UploadManager.m
//  ExportKit-Demo
//
//  Created by Shane Gianelli on 5/23/10.
//  Copyright 2010 SJ Development LLC. All rights reserved.
//

#import "UploadManager.h"

#define kCacheDirectory(x) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:x]


@implementation UploadManager

@synthesize delegate;

- (id)initWithParserKeys:(NSArray *)keys andDelegate:(id)del {
	if (self = [super init]) {
		self.delegate = del;
		parseKeys = [keys copy];
	}
	
	return self;
}

- (void)beginConnectionWithRequest:(NSURLRequest *)req {
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	[connection start];
}

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data {
	//[data writeToFile:kCacheDirectory(@"response.txt") atomically:YES];
	NSLog(@"RESPONSE: %@",[NSString stringWithCString:[data bytes] length:[data length]]);
	
	[self parseXMLFileWithData:[delegate upload:self receivedData:data]];
}
- (void)connection:(NSURLConnection *)_connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	NSLog(@"bytes: %d",totalBytesWritten);
	[delegate upload:self receivedBytes:totalBytesWritten ofTotal:totalBytesExpectedToWrite];
}
- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error {
	[delegate uploadFailed:self withError:error];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
}


+ (void)parseXMLFileWithData:(NSData *)xml andKeys:(NSArray *)keys withDelegate:(id)del {
	UploadManager *man = [[[UploadManager alloc] initWithParserKeys:keys andDelegate:del] autorelease];
	[man parseXMLFileWithData:xml];
}
- (void)parseXMLFileWithData:(NSData *)xml {
	[connection release];
	
	parsedContent = [[NSMutableDictionary alloc] init];
	tempSubContent = [[NSMutableDictionary alloc] init];
	
	NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData:xml] autorelease];
	
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[xmlParser setDelegate:self];
	
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	[xmlParser setShouldResolveExternalEntities:NO];
	
	[xmlParser parse];
}
- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	[parsedContent release];
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{ 
	currentElement = [elementName copy];
	
	if ([attributeDict count] > 0 && [parseKeys containsObject:currentElement])
		[parsedContent setObject:attributeDict forKey:currentElement];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName { 
	[currentElement release];
	currentElement = nil;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([parseKeys containsObject:currentElement] && ![parsedContent objectForKey:currentElement])
		[parsedContent setObject:string forKey:currentElement];
	else if ([parseKeys containsObject:currentElement] && [parsedContent objectForKey:currentElement])
		[[parsedContent objectForKey:currentElement] setObject:string forKey:currentElement];
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {	
	if (currentElement)
		[currentElement release];
	
	[delegate upload:self receivedResponse:parsedContent];
	
	if (parsedContent)
		[parsedContent release];
}

	
@end
