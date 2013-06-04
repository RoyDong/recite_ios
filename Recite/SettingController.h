//
//  SettingController.h
//  Recite
//
//  Created by Roy on 5/31/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "ViewController.h"

@interface SettingController : NavigationViewController

@property (nonatomic, readonly) ViewController *parentViewController;

@property (nonatomic, strong) UILabel *name;

@property (nonatomic, strong) UILabel *email;

@end
