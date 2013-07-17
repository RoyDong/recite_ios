//
//  SettingController.m
//  Recite
//
//  Created by Roy on 5/31/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "SettingController.h"
#import "UserModel.h"
#import "TcpClient.h"

@interface SettingController ()

@end

@implementation SettingController
{
    TcpClient *tcp;
}

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
    
    rect = CGRectMake(frame.origin.x + (screeWidth - width) / 2, 300, width, height);
    UIButton *testTcp = [[UIButton alloc] initWithFrame:rect];
    [testTcp setTitle:@"test tcp" forState:UIControlStateNormal];
    [testTcp setBackgroundColor:[UIColor redColor]];
    [testTcp addTarget:self action:@selector(testTcp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testTcp];
    
    tcp = [[TcpClient alloc] init:@"arch" port:3721];
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

- (IBAction)testTcp:(UIButton *)sender
{
    [tcp send:@"user.show" data:@"name=roy" callback:^(NSData *reply){
        NSString *s = [[NSString alloc] initWithData:reply encoding:NSUTF8StringEncoding];
        NSLog(@"%@ %i", s, 2);
    }];
}

@end
