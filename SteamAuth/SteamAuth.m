//
//  SteamAuth.m
//  SteamAuth
//
//  Created by Michael Ho on 2015-01-02.
//  Copyright (c) 2015 michaelchum. All rights reserved.
//

#import "SteamAuth.h"

@interface SteamAuth ()

@property (nonatomic, strong) UIWebView *steamMobileLoginView;
@property (nonatomic, strong) NSString *apiKey; // e.g. Monk3y

@end

@implementation SteamAuth

static NSString * const STEAM_MOBILE_LOGIN_URL = @"https://steamcommunity.com/mobilelogin";
static NSInteger const STEAMID64_IDENTIFIER = 76561197960265728;
static NSString * const VANITY_URL_XML_PREFIX = @"https://steamcommunity.com/id/";
static NSString * const VANITY_URL_XML_SUFFIX = @"/?xml=1";

- (instancetype)initWithKey:(NSString *)key {
    if (self = [super init]) {
        self.steamID64 = nil;
        self.steamID = nil;
        self.vanityID = nil;
        self.apiKey = key;
    }
    return self;
}

+ (instancetype)sessionWithKey:(NSString *)key {
    SteamAuth *steamAuth = [[self alloc] initWithKey:key];
    
    return steamAuth;
}

- (void)promptLoginWebView {
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    self.steamMobileLoginView = [[UIWebView alloc] initWithFrame:rootViewController.view.bounds];
    self.steamMobileLoginView.delegate = self;
    [self.steamMobileLoginView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:STEAM_MOBILE_LOGIN_URL]]];
    
    [rootViewController.view addSubview:self.steamMobileLoginView];
    
}

- (NSString *)promptLoginRetrieveSteamID {
    
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

// SteamID conversion using the official formula
// https://developer.valvesoftware.com/wiki/SteamID
// Steam Community ID = SteamID64 = W = Z*2+V+Y
// Steam ID = SteamID = STEAM_X:Y:Z

// Steam ID => Steam Community ID
// STEAM_0:1:65633249 => 76561198091532227
+ (NSString *)convertSteamIDToSteamID64:(NSString *)steamID {
    
    NSString *steamID64 = nil;
    
    NSArray *components = [steamID componentsSeparatedByString:@":"];
    NSInteger z = [components[2] intValue];
    NSInteger y = [components[1] intValue];
    NSInteger v = STEAMID64_IDENTIFIER;
    
    steamID64 = [NSString stringWithFormat:@"%ld", z * 2 + v + y];
    
    return steamID64;
}

// Steam Community ID => Steam ID
// 76561198091532227 => STEAM_0:1:65633249
+ (NSString *)convertSteamID64ToSteamID:(NSString *)steamID64  {
    
    NSMutableString *steamID = [@"STEAM_0" mutableCopy];
    
    NSInteger w = [steamID64 longLongValue];
    NSInteger v = STEAMID64_IDENTIFIER;
    NSInteger y = w % (long)2;
    
    NSInteger sid = w - y - v;
    sid = sid / 2;
    
    [steamID appendString:@":"];
    [steamID appendString:[NSString stringWithFormat:@"%ld", y]];
    [steamID appendString:@":"];
    [steamID appendString:[NSString stringWithFormat:@"%ld", sid]];
    
    return steamID;
}

+ (NSString *)convertVanityIDToSteamID64:(NSString *)vanityID {
    
    NSString *steamID64 = nil;
    
    // Gather vanity url
    NSMutableString *vanityAddress = [VANITY_URL_XML_PREFIX mutableCopy];
    [vanityAddress appendString:vanityID];
    [vanityAddress appendString:VANITY_URL_XML_SUFFIX];
    NSURL *vanityURL = [NSURL URLWithString:vanityAddress];
    NSURLRequest *vanityRequest = [NSURLRequest requestWithURL:vanityURL];
    
    // Initialize URL session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration  defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:nil];
    
    
    return steamID64;
}

@end

