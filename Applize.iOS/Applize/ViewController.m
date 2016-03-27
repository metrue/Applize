//
//  ViewController.m
//  Applize
//
//  Created by huangmh on 12/26/15.
//  Copyright © 2015 minghe. All rights reserved.
//

#import "ViewController.h"
#import "Config.h"
#import <AVFoundation/AVFoundation.h>
@import JavaScriptCore;
@import Foundation;

@interface ViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *loadingSpin;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	if (ENABLE_AUDIO_IN_BACKGROUND) {
		[self enableAudioInBackground];
	}

	[self injectNotificationWebhook];
	[self injectConsoleWebhook];
	[self loadWebSite];
}

- (void) loadWebSite {
	_webView = [[UIWebView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];

	NSString *urlString = URL_OF_YOUR_WEBSITE;
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

	[_webView setScalesPageToFit:YES];
	[_webView loadRequest:urlRequest];
	[_webView setDelegate:self];
	[self.view addSubview:_webView];
}

- (void) enableAudioInBackground {
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	BOOL ok;
	NSError *setCategoryError = nil;
	ok = [audioSession setCategory:AVAudioSessionCategoryPlayback
	      error:&setCategoryError];
	if (!ok) {
		NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
	}
}

- (void)startProgressIndicator {
	_loadingSpin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_loadingSpin.center = self.view.center;
	[self.view addSubview:_loadingSpin];
	[_loadingSpin startAnimating];
}

- (void)stopProgressIndicator {
	[_loadingSpin stopAnimating];
	[_loadingSpin removeFromSuperview];
}

- (void) injectNotificationWebhook {
	JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

	// enable error logging
	[context setExceptionHandler:^(JSContext *context, JSValue *value) {
	   NSLog(@"Web JavaScript Exception: %@", value);
	 }];
	[context evaluateScript:[self loadJavaScriptCodeFromFileName:@"notification"]];
}

- (void) injectConsoleWebhook {
	JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
	[context setExceptionHandler:^(JSContext *context, JSValue *value) {
	   NSLog(@"Web JavaScript Exception: %@", value);
	 }];

	[context evaluateScript:[self loadJavaScriptCodeFromFileName:@"console"]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSDictionary *actionInfo = [self getActionFrom:request];
	if ([actionInfo[@"action"] containsString:@"CONSOLE/LOG"]) {
		NSLog(@"LOG: %@", actionInfo[@"data"]);

		return NO;
	} else if ([actionInfo[@"action"] containsString:@"CONSOLE/INFO"]) {
		NSLog(@"INFO: %@", actionInfo[@"data"]);

		return NO;
	}else if ([actionInfo[@"action"] containsString:@"CONSOLE/ERROR"]) {
		NSLog(@"ERROR: %@", actionInfo[@"data"]);

		return NO;
	}else if ([actionInfo[@"action"] containsString:@"CONSOLE/WARN"]) {
		NSLog(@"WARN: %@", actionInfo[@"data"]);

		return NO;
	} else if ([actionInfo[@"action"] containsString:@"CONSOLE/DEBUG"]) {
		NSLog(@"DEBUG: %@", actionInfo[@"data"]);

		return NO;
    } else if ([actionInfo[@"action"] containsString:@"NOTIFICATION"]) {
        //TODO
        // Should handle the title and body sepertate
        [self showNotificationWithTitle:actionInfo[@"data"] body:@""];
        return NO;
	} else {
		return YES;
	}
}

- (void)showNotificationWithTitle:(NSString *)title body:(NSString *)body {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
	                                      message:body
	                                      preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
	                           style:UIAlertActionStyleDefault
	                           handler:^(UIAlertAction *action) {
	                             [alertController dismissViewControllerAnimated:YES completion:nil];
														 }];
	[alertController addAction:actionOk];
	[self presentViewController:alertController animated:YES completion:nil];
   
    // auto dissmise Alert view after 3s
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 3.0);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (NSDictionary *)getActionFrom:(NSURLRequest *)request {
	NSString *urlString = request.URL.absoluteString;
	NSArray *tmp = [urlString componentsSeparatedByString:@"//ACTION/"];
	if ([tmp count] == 2) {
		NSArray *info = [tmp[1] componentsSeparatedByString:@"/DATA/"];
		return @{
						 @"action": info[0],
						 @"data": info[1]
		};
	} else {
		return @{
						 @"action":@"NO",
						 @"data": @"NO"
		};
	}
}

- (BOOL)prefersStatusBarHidden {
	return ENABLE_STATUS_BAR;
}

- (BOOL) shouldAutorotate {
	return ENABLE_AUTO_ROTATE;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return ENABLE_AUTO_ROTATE;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	//return UIInterfaceOrientationPortrait;
	return UIInterfaceOrientationLandscapeRight;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
	if (ENABLE_LOADING_SPIN) {
		[self startProgressIndicator];
	}
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSString *errorString = [[NSString alloc] initWithFormat:@"Cannot loading your website: %@", [error localizedDescription]];
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Loading Error"
	                                      message:errorString
	                                      preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
	                           style:UIAlertActionStyleDefault
	                           handler:^(UIAlertAction *action) {
	                             [alertController dismissViewControllerAnimated:YES completion:nil];
														 }];
	[alertController addAction:actionOk];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
	if (ENABLE_LOADING_SPIN) {
		[self stopProgressIndicator];
	}
}

- (NSString *)loadJavaScriptCodeFromFileName:(NSString *)fileName {
	NSString *contentPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
	NSString *txtContent = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
	return txtContent;
}

@end
