//
//  AuthController.m
//  Recite
//
//  Created by Roy on 5/31/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "AuthController.h"

@interface AuthController ()

@end

@implementation AuthController

@synthesize email = _email;

@synthesize passwd = _passwd;

@synthesize button = _button;

@synthesize hint = _hint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _button = [[UIButton alloc] init];
//    float pageHeight = self.view.frame.size.height;
    float pageWidth = self.view.frame.size.width;
    float height = 36;
    float width = 280;
    
    _button.frame = CGRectMake((pageWidth - width) / 2, 250, width, height);
    [_button setTitle:@"Sign in" forState:UIControlStateNormal];
    [_button setBackgroundColor:[UIColor yellowColor]];
    [_button addTarget:self action:@selector(submitAccount:) forControlEvents:1];

    [self.view addSubview:_button];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitAccount:(UIButton *)sender
{
    if ([UserModel signin:self.email.text passwd:self.passwd.text])
    {
        self.parent.contentDisplayed = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_email resignFirstResponder];
    [_passwd resignFirstResponder];
}

@end