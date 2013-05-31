//
//  ViewController.m
//  Recite
//
//  Created by Roy on 5/13/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "ViewController.h"
#import "AuthController.h"
#import "LessonController.h"
#import "BookshelfController.h"
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
    
    if (!self.tabInitialized)
    {
        self.duration = 0.5;
        self.animationOptions = UIViewAnimationOptionTransitionCrossDissolve;
        
        float screenWidth = self.view.frame.size.width;
        float screenHeight = self.view.frame.size.height;
        float navHeight = 40.0;
        float navWidth = 200.0;
        CGRect navRect = CGRectMake((screenWidth - navWidth ) / 2, screenHeight - navHeight, navWidth, navHeight);
        
        [self initTabs:[NSArray arrayWithObjects:@"Lesson", @"Bookshelf", @"Setting", nil]
               classes:[NSArray arrayWithObjects:[LessonController class], [BookshelfController class], [SettingController class], nil]
                images:[NSArray arrayWithObjects:@"1", @"2", @"3", nil]
                  rect:navRect];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UserModel currentUser] ? (self.contentDisplayed = YES) : [self showAuthView];
}

- (void)showAuthView
{
    AuthController *controller = [[AuthController alloc] init];
    controller.parent = self;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
