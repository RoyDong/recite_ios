//
//  NavigatorViewController.m
//  Recite
//
//  Created by Roy on 5/30/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

@synthesize duration = _duration;

@synthesize animationOptions = _animationOptions;

@synthesize activeIndex = _activeIndex;

@synthesize contentDisplayed = _contentDisplayed;

@synthesize tabInitialized = _tabInitialized;

- (void)initTabs:(NSArray *)titles classes:(NSArray *)classes images:(NSArray *)images rect:(CGRect)rect
{
    if (!_tabInitialized && titles.count == classes.count && titles.count == images.count)
    {
        UIViewController *controller;
        UIButton *button;
        CGRect buttonRect;
        float width = rect.size.width / titles.count;
        float height = rect.size.height;
        float x = rect.origin.x;
        float y = rect.origin.y;
        CGRect viewRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - rect.size.height);

        for (int i = 0; i < titles.count; i++)
        {
            controller = [[[classes objectAtIndex:i] alloc] init];
            controller.view.frame = viewRect;
            [self addChildViewController:controller];

            buttonRect = CGRectMake(x + width * i, y, width, height);
            button = [[UIButton alloc] initWithFrame:buttonRect];
            button.tag = i;
            [button addTarget:self action:@selector(tap:) forControlEvents:1];
            [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [self.view addSubview:button];

            if (_activeIndex == i && _contentDisplayed) [self.view addSubview:controller.view];
        }
        
        _tabInitialized = YES;
    }
}

- (IBAction)tap:(UIButton *)sender
{
    [self activeTab:sender.tag];
}

- (void)activeTab:(NSInteger)index
{
    if (index == _activeIndex || index < 0 || index >= self.childViewControllers.count) return;

    if (_contentDisplayed)
    {
        UIViewController *currentController = [self.childViewControllers objectAtIndex:_activeIndex];
        UIViewController *controller = [self.childViewControllers objectAtIndex:index];
        
        [self transitionFromViewController:currentController
                            toViewController:controller
                            duration:_duration
                            options:_animationOptions
                            animations:nil
                            completion:^(BOOL finished){
                                if (finished)
                                {
                                    _activeIndex = index;
                                }
                            }];
    }
    else
    {
        _activeIndex = index;
        self.contentDisplayed = YES;
    }
}

- (void)setContentDisplayed:(BOOL)contentDisplayed
{
    if (contentDisplayed == _contentDisplayed) return;
    
    UIViewController *controller = [self.childViewControllers objectAtIndex:_activeIndex];
    
    if (contentDisplayed)
    {
        [self.view addSubview:controller.view];
    }
    else
    {
        [controller removeFromParentViewController];
    }

    _contentDisplayed = contentDisplayed;
}

@end
