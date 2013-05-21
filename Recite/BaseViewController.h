//
//  BaseViewController.h
//  Recite
//
//  Created by Roy on 5/15/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    NSArray *controllers;
}

@property (nonatomic, readonly) NSUInteger number;

- (void)alert:(NSString *)title message:(NSString *)message;

@end
