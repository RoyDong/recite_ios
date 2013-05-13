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

- (IBAction)sign:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[HttpClient singleInstance] call:@"security/status"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)sign:(UIButton *)sender
{
    NSString *title = sender.titleLabel.text;
    
    if ([title isEqualToString:@"Sign up"]) {
        SignupController *signup = [[SignupController alloc] init];
        signup.back = self;
        [self presentViewController:signup animated:YES completion:nil];
    }
    else
    {
        SigninController *signin = [[SigninController alloc] init];
        signin.back = self;
        [self presentViewController:signin animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
