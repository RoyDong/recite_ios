//
//  ViewController.m
//  Recite
//
//  Created by Roy on 5/13/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "ViewController.h"
#import "SignupController.h"
#import "SettingController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    float screenWidth = self.view.frame.size.width;
    float screenHeight = self.view.frame.size.height;
    float navHeight = 30.0;
    float navWidth = 250.0;
    CGRect navRect = CGRectMake((screenWidth - navWidth ) / 2, screenHeight - navHeight, navWidth, navHeight);
    
    [self initTabs:[NSArray arrayWithObjects:@"注册", @"登录", nil]
           classes:[NSArray arrayWithObjects:[SignupController class],[SettingController class], nil]
            images:[NSArray arrayWithObjects:@"1", @"2", nil]
              rect:navRect];
}


@end
