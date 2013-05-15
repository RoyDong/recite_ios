//
//  ViewController.m
//  Recite
//
//  Created by Roy on 5/13/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "ViewController.h"
#import "SigninController.h"
#import "SignupController.h"
#import "SettingController.h"
#import "ViewConstant.h"
#import "UserModel.h"


@interface ViewController ()
{
    UserModel *user;
}

- (IBAction)signup:(UIButton *)sender;

- (IBAction)signin:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    user = [UserModel currentUser];
    
    if (user)
    {
        
    }
    else
    {
        SigninController *signin = [[SigninController alloc] init];
        signin.root = self;
        [self presentViewController:signin animated:YES completion:nil];
    }
}

- (void)render:(int)view animated:(BOOL)animated
{
    switch (view)
    {
        case VIEW_SETTING:
        {
            SettingController *setting = [[SettingController alloc] init];
            setting.root = self;
            [self presentViewController:setting animated:animated completion:nil];
        }
        break;
            
        case VIEW_SIGNUP:
        {
            SignupController *signup = [[SignupController alloc] init];
            signup.root = self;
            [self presentViewController:signup animated:animated completion:nil];
        }
        break;
        
        case VIEW_SIGNIN:
        {
            SigninController *signin = [[SigninController alloc] init];
            signin.root = self;
            [self presentViewController:signin animated:animated completion:nil];
        }
        break;
    }
}

- (IBAction)signup:(UIButton *)sender
{
    [self render:VIEW_SIGNUP animated:NO];
}

- (IBAction)signin:(UIButton *)sender
{
    [self render:VIEW_SIGNIN animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
