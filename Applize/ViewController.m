//
//  ViewController.m
//  Applize
//
//  Created by huangmh on 12/26/15.
//  Copyright © 2015 minghe. All rights reserved.
//

#import "ViewController.h"
#import "Config.h"

@interface ViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *loadingSpin;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    // set the url string to your website url
    NSString *urlString = URL_OF_YOUR_WEBSITE;
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [webView setScalesPageToFit:YES];
    
    [webView loadRequest:urlRequest];
    [webView setDelegate:self];
    [self.view addSubview:webView];
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

- (BOOL)prefersStatusBarHidden{
    if (DISABLE_STATUS_BAR) {
        return YES;
    } else {
        return NO;
    }
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

@end
