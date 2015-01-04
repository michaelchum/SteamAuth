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
    self.steamAuth = [[SteamAuth alloc] init];
    [self.steamAuth promptLoginRetrieveSteamID64];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
