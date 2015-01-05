//
//  ViewController.m
//  SteamAuth
//
//  Created by Michael Ho on 2015-01-02.
//  Copyright (c) 2015 michaelchum. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) SteamAuth *steamAuth;

@end

@implementation ViewController

- (IBAction)loginWithSteam:(id)sender {
    self.steamAuth = [SteamAuth sessionWithKey:@"YOUR_STEAM_API_KEY"];
    [self.steamAuth promptLoginRetrieveSteamID];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",[SteamAuth convertSteamIDToSteamID64:@"STEAM_0:1:65633249"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
