//
//  SteamAuth.h
//  SteamAuth
//
//  Created by Michael Ho on 2015-01-02.
//  Copyright (c) 2015 michaelchum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SteamAuth : NSObject <UIWebViewDelegate, NSURLSessionDelegate>

@property (nonatomic, strong) NSString *steamID; // e.g. STEAM_0:1:65633249
@property (nonatomic, strong) NSString *steamID64; // e.g. 76561198091532227
@property (nonatomic, strong) NSString *vanityID; // e.g. Monk3y

+ (instancetype)sessionWithKey:(NSString *)key;

- (NSString *)promptLoginRetrieveSteamID;

// Steam ID => Steam Community ID
// STEAM_0:1:65633249 => 76561198091532227
+ (NSString *)convertSteamIDToSteamID64:(NSString *)steamID;

// Steam Community ID => Steam ID
// 76561198091532227 => STEAM_0:1:65633249
+ (NSString *)convertSteamID64ToSteamID:(NSString *)steamID64;

// Steam Vanity ID => Steam Community ID
// Monk3y => 76561198091532227
+ (NSString *)convertVanityIDToSteamID64:(NSString *)vanityID;

@end