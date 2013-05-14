//
//  SigninController.m
//  Recite
//
//  Created by Roy on 5/13/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "SigninController.h"
#import "HttpClient.h"

@interface SigninController ()
{
    HttpClient *client;
}

@property (nonatomic, strong) IBOutlet UITextField *email;

@property (nonatomic, strong) IBOutlet UITextField *passwd;

- (IBAction)submit:(UIButton *)sender;

- (IBAction)back:(id)sender;

@end

@implementation SigninController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        client = [HttpClient singleInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)submit:(UIButton *)sender
{
    NSDictionary *account = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.email.text, @"email",
                             self.passwd.text, @"password", nil];
    
    [client call:@"login_check" post:account];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"msg"
                          message:@"ok"
                          delegate:self
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil, nil];
    
    if(client.code == 0)
    {
        [self.back dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [alert setMessage:client.message];
        [alert show];
    }
}

- (IBAction)back:(id)sender
{
    [self.back dismissViewControllerAnimated:YES completion:nil];
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
