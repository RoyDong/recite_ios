//
//  ViewController.h
//  Recite
//
//  Created by Roy on 5/13/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "NavigationViewController.h"
#import "UserModel.h"

@interface ViewController : NavigationViewController

@property (nonatomic, strong) UserModel *user;

- (void)showAuthView;

@end
