//
//  SteamAuth.m
//  SteamAuth
//
//  Created by Michael Ho on 2015-01-02.
//  Copyright (c) 2015 michaelchum. All rights reserved.
//

#import "SteamAuth.h"

@interface SteamAuth ()

@property (nonatomic, strong) NSString *steamID;

@end

@implementation SteamAuth

static NSString * const STEAM_MOBILE_LOGIN_URL = @"https://steamcommunity.com/mobilelogin";

- (instancetype)init
{
    if (self = [super init]) {
        self.steamID = nil;
    }
    return self;
}

- (void)promptLoginWebView {
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIWebView *steamMobileLoginView = [[UIWebView alloc] initWithFrame:rootViewController.view.bounds];
    
    [steamMobileLoginView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:STEAM_MOBILE_LOGIN_URL]]];
    [rootViewController.view addSubview:steamMobileLoginView];
    
}

+ (NSString *)promptLoginRetrieveSteamID {
    
    SteamAuth *steamAuth = [[SteamAuth alloc] init];
    
    [steamAuth promptLoginWebView];
    
    return steamAuth.steamID;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType
{

    return YES;
}

@end

