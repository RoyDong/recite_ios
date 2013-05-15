//
//  SignupController.m
//  Recite
//
//  Created by Roy on 5/13/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "SignupController.h"
#import "HttpClient.h"
#import "ViewConstant.h"

@interface SignupController ()
{
    HttpClient *client;
}

@property (nonatomic, strong) IBOutlet UITextField *email;

@property (nonatomic, strong) IBOutlet UITextField *passwd;

- (IBAction)back:(id)sender;

@end

@implementation SignupController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        client = [HttpClient singleInstance];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.email.placeholder = @"Enter your email";
    self.passwd.placeholder = @"Enter your password";

}


- (IBAction)submit:(UIButton *)sender
{
    NSDictionary *account = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.email.text, @"email",
                             self.passwd.text, @"password", nil];
    
    [client call:@"user/signup" post:account];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"msg"
                          message:@"ok"
                          delegate:self
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil, nil];

    if(client.code == 0)
    {
        [self.root render:0 animated:NO];
    }
    else
    {
        [alert setMessage:client.message];
        [alert show];
    }
}

- (IBAction)back:(id)sender
{
    [self.root render:0 animated:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.email resignFirstResponder];
    [self.passwd resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
