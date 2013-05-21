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
{
    NSInteger currentViewTag;
}

- (IBAction)switchTab:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect rect = self.view.bounds;
    CGRect subRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - 100);
    
    SignupController *signup = [[SignupController alloc] init];
    SettingController *setting = [[SettingController alloc] init];

    signup.view.frame = subRect;
    setting.view.frame = subRect;

    [self addChildViewController:signup];
    [self addChildViewController:setting];

    [self.view addSubview:signup.view];
}

- (IBAction)switchTab:(UIButton *)sender
{
    if (sender.tag == currentViewTag) return;

    UIViewController *currentView = [self.childViewControllers objectAtIndex:currentViewTag];
    UIViewController *newView = [self.childViewControllers objectAtIndex:sender.tag];
    
    [self transitionFromViewController:currentView
                    toViewController:newView
                    duration:2
                    options:UIViewAnimationOptionAutoreverse
                    animations:^{}
                    completion:^(BOOL finished){
                        if (finished)
                        {
                            currentViewTag = sender.tag;
                        }
                    }];
}

@end
