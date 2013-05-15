//
//  BaseViewController.m
//  Recite
//
//  Created by Roy on 5/15/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)alert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]
                         initWithTitle:title
                         message:message
                         delegate:self
                         cancelButtonTitle:@"ok"
                         otherButtonTitles:nil, nil];
    
    [alert show];
}

@end
