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
    NSLog(@"%@ - %@", [self getJavaScript], [_webView stringByEvaluatingJavaScriptFromString:[self getJavaScript]]);
    NSLog(@"@");
    //[self testJavaScript];
}

- (void) testJavaScript {
    JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // enable error logging
    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"WEB JS: %@", value);
    }];
    
    
    // add function for processing form submission
    NSString *addContactText =
    @" \
    var audios = document.getElementsByTagName('audio'); \
    for (var i = 0; i < audios.length; i++) { \
        audios[i].addEventListener('volumechange', function() { \
            var fakeUrl = 'Applize://action/turnvolume/' + audios[i].volume; \
            document.location.href = fakeUrl; \
        });  \
    }";
 
    NSLog(@"%@", [context evaluateScript:addContactText]);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@",request.URL.absoluteString);
    NSString *urlString = request.URL.absoluteString;
    if ([urlString containsString:@"AAA"]) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)prefersStatusBarHidden{
    if (DISABLE_STATUS_BAR) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) shouldAutorotate {
    return SHOULDAUTOROTATE;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return SHOULDAUTOROTATE;
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
    if (SHOW_LOADING_SPIN) {
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
    if (SHOW_LOADING_SPIN) {
        [self stopProgressIndicator];
    }
}

- (NSString *)getJavaScript {
    NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"binding" ofType:@"js"];
    NSString *txtContent = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
    return txtContent;
}

@end
