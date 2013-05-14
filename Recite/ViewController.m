//
//  ViewController.m
//  Recite
//
//  Created by Roy on 5/13/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "ViewController.h"
#import "HttpClient.h"
#import "SignupController.h"
#import "SigninController.h"

@interface ViewController ()

- (IBAction)signup:(UIButton *)sender;

- (IBAction)signin:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *role = [[[HttpClient singleInstance] call:@"user/status"] description];
    
    if([role isEqualToString:@"user"])
    {
        
    }
}

- (IBAction)signup:(UIButton *)sender
{
    SignupController *signup = [[SignupController alloc] init];
    signup.back = self;
    [self presentViewController:signup animated:YES completion:nil];

}

- (IBAction)signin:(UIButton *)sender
{
    SigninController *signin = [[SigninController alloc] init];
    signin.back = self;
    [self presentViewController:signin animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
