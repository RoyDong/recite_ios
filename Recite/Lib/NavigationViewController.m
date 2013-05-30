//
//  NavigatorViewController.m
//  Recite
//
//  Created by Roy on 5/30/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()
{
    NSMutableArray *tabs;
}

@end

@implementation NavigationViewController

@synthesize duration = _duration;

@synthesize animationOptions = _animationOptions;

@synthesize activeIndex = _activeIndex;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _duration = 0;
        _animationOptions = UIViewAnimationOptionTransitionNone;
        _activeIndex = -1;
    }
    
    return self;
}

- (void)initTabs:(NSArray *)titles classes:(NSArray *)classes images:(NSArray *)images rect:(CGRect)rect
{
    if (titles.count == classes.count && titles.count == images.count)
    {
        UIViewController *controller;
        UIButton *button;
        CGRect buttonRect;
        float width = rect.size.width / titles.count;
        float height = rect.size.height;
        float x = rect.origin.x;
        float y = rect.origin.y;
            
        for (int i = 0; i < titles.count; i++)
        {
            controller = [[[classes objectAtIndex:i] alloc] init];
            [self addChildViewController:controller];
            
            buttonRect = CGRectMake(x + width * i, y, width, height);
            button = [[UIButton alloc] initWithFrame:buttonRect];
            [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];

            [self.view addSubview:button];
        }
    }
}

- (void)active:(NSInteger)index
{
    if (index == _activeIndex) return;
    
    UIViewController *controller = [self.childViewControllers objectAtIndex:index];
    UIViewController *currentController = [self.childViewControllers objectAtIndex:_activeIndex];
    
    [self transitionFromViewController:currentController
                            toViewController:controller
                            duration:_duration
                            options:_animationOptions
                            animations:^{}
                            completion:^(BOOL finished){
                                if (finished)
                                {
                                    _activeIndex = index;
                                }
                            }];
}


@end
