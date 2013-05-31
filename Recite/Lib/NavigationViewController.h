//
//  NavigatorViewController.h
//  Recite
//
//  Created by Roy on 5/30/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationViewController : UIViewController

@property (nonatomic) int duration;

@property (nonatomic) UIViewAnimationOptions animationOptions;

@property (nonatomic, readonly) NSInteger activeIndex;

@property (nonatomic) BOOL contentDisplayed;

@property (nonatomic, readonly) BOOL tabInitialized;

- (void)initTabs:(NSArray *)titles classes:(NSArray *)classes images:(NSArray *)images rect:(CGRect)rect;

- (IBAction)tap:(id)sender;

- (void)activeTab:(NSInteger)index;

@end
