//
//  ImgurWebController.m
//  imgur Eyes
//
//  Created by Lawrence Mcalpin on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurWebController.h"
#import <Three20/Three20.h>

@implementation ImgurWebController

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[super webViewDidFinishLoad:webView];
	
	NSString *docWidthStr = [_webView stringByEvaluatingJavaScriptFromString:@"document.width"];
	int docWidth = [docWidthStr intValue];
	NSString *imgWidthStr = [_webView stringByEvaluatingJavaScriptFromString:@"document.images[0].width"];
	NSLog(@"Document is %@ px wide, Image is %@ px wide", docWidthStr, imgWidthStr);
	NSString *resizeJS = [NSString stringWithFormat:@"document.images[0].width = %d", docWidth];
	[_webView stringByEvaluatingJavaScriptFromString:resizeJS];
}

/*
- (void)openURL:(NSURL *)URL {
	super.view;
	_webView.scalesPageToFit = YES;
	_webView.multipleTouchEnabled = YES;
	NSLog(@"ImgurWebController is Loading: %@", URL);
	NSString *html = [NSString stringWithFormat:@"<html><head><style>img { margin-right: 10px; }</style></head><body><img src=\"%@\"/></body>", URL];
	NSLog(@"ImgurWebController is Loading: %@", html);
	NSLog(@"Web view: %@", _webView);
	[_webView loadHTMLString:html baseURL:[NSURL URLWithString:@""]];
}
 */

@end
