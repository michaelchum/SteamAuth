//
//  SteamAuth.m
//  SteamAuth
//
//  Created by Michael Ho on 2015-01-02.
//  Copyright (c) 2015 michaelchum. All rights reserved.
//

#import "SteamAuth.h"

@interface SteamAuth ()

@property (nonatomic, strong) NSString *steamID; // e.g.
@property (nonatomic, strong) NSString *steamID64; // e.g. 76561198091532227
@property (nonatomic, strong) NSString *vanityID; // e.g.
@property (nonatomic, strong) UIWebView *steamMobileLoginView;

@end

@implementation SteamAuth

static NSString * const STEAM_MOBILE_LOGIN_URL = @"https://steamcommunity.com/mobilelogin";

- (instancetype)init
{
    if (self = [super init]) {
        self.steamID64 = nil;
        self.steamID = nil;
        self.vanityID = nil;
    }
    return self;
}

- (void)promptLoginWebView {
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    self.steamMobileLoginView = [[UIWebView alloc] initWithFrame:rootViewController.view.bounds];
    self.steamMobileLoginView.delegate = self;
    [self.steamMobileLoginView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:STEAM_MOBILE_LOGIN_URL]]];
    
    [rootViewController.view addSubview:self.steamMobileLoginView];
    
}

- (NSString *)promptLoginRetrieveSteamID64 {
    
    [self promptLoginWebView];
    
    return self.steamID64;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    
//    NSLog(@"%@",request.URL.absoluteString);
    
    // Parse URL for 64-bit steamID https://steamcommunity.com/profiles/<steamID64>/blotter
    if ([request.URL.absoluteString rangeOfString:@"https://steamcommunity.com/profiles/"].location != NSNotFound) {
        
        NSArray *urlComponents = [request.URL.absoluteString componentsSeparatedByString:@"/"];
        NSString *potentialID = urlComponents[4];
        
        // Check if potential steamID64 is valid (consists entirely of integers)
        self.steamID64 = potentialID;
        
        // Remove subview from rootViewController
        [self.steamMobileLoginView removeFromSuperview];
        self.steamMobileLoginView = nil;

        return NO;
        
    // Parse URL for VanityID https://steamcommunity.com/id/<vanityID>/blotter
    } else if ([request.URL.absoluteString rangeOfString:@"https://steamcommunity.com/id/"].location != NSNotFound) {
        
        NSArray *urlComponents = [request.URL.absoluteString componentsSeparatedByString:@"/"];
        NSString *potentialVanityID = urlComponents[4];
        
        // Convert VanityID to 64-bit steamID
        self.vanityID = potentialVanityID;

        // Remove subview from rootViewController
        [self.steamMobileLoginView removeFromSuperview];
        self.steamMobileLoginView = nil;
        
        return NO;
        
    }

    return YES;
}

+ (NSString *)convertTextTo64:(NSString *)steamID {
    NSString *steamID64 = nil;
    return steamID64;
}

+ (NSString *)convert64ToText:(NSString *)steamID64  {
    NSString *steamID = nil;
    return steamID;
}

+ (NSString *)convertVanityTo64 {
    NSString *steamID64;
    return steamID64;
}

@end

