//
//  SettingController.m
//  Recite
//
//  Created by Roy on 5/31/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "SettingController.h"
#import "UserModel.h"

@interface SettingController ()

@end

@implementation SettingController

@synthesize email = _email;

@synthesize name = _name;

- (void)initContent
{
    [super initContent];
    

    CGRect rect;
    CGRect frame = self.parentViewController.contentFrame;
    float width = 280, height = 36;
    float screeWidth = frame.size.width;
    
    rect = CGRectMake(frame.origin.x + (screeWidth - width) / 2, 50, width, height);
    _name = [[UILabel alloc] initWithFrame:rect];
    [_name setTextAlignment:NSTextAlignmentCenter];
    [_name setBackgroundColor:[UIColor brownColor]];
    [self.view addSubview:_name];
    
    rect = CGRectMake(frame.origin.x + (screeWidth - width) / 2, 120, width, height);
    _email = [[UILabel alloc] initWithFrame:rect];
    [_email setBackgroundColor:[UIColor brownColor]];
    [_email setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_email];
    
    rect = CGRectMake(frame.origin.x + (screeWidth - width) / 2, 250, width, height);
    UIButton *signout = [[UIButton alloc] initWithFrame:rect];
    [signout setTitle:@"退出" forState:UIControlStateNormal];
    [signout setBackgroundColor:[UIColor redColor]];
    [signout addTarget:self action:@selector(signout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UserModel *user = [UserModel currentUser];
    _name.text = user.name;
    _email.text = user.email;
}

- (IBAction)signout:(UIButton *)sender
{
    [UserModel signout];
    [UserModel currentUser];
    [self.parentViewController showAuthView];
}

@end
