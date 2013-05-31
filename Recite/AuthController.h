//
//  AuthController.h
//  Recite
//
//  Created by Roy on 5/31/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "ViewController.h"

@interface AuthController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *email;

@property (nonatomic, strong) IBOutlet UITextField *passwd;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) IBOutlet UILabel *hint;

@property (nonatomic, weak) ViewController *parent;

@end
