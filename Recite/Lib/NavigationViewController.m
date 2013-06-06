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
    NSArray *controllers;
    int indexes[10];
}

@end

@implementation NavigationViewController

@synthesize duration = _duration;

@synthesize animationOptions = _animationOptions;

@synthesize activeIndex = _activeIndex;

@synthesize contentNeedDisplay = _contentNeedDisplay;

@synthesize tabInitialized = _tabInitialized;

@synthesize contentFrame = _contentFrame;


- (void)initContent
{
    
}

- (void)initTabs:(NSArray *)titles classes:(NSArray *)classes images:(NSArray *)images rect:(CGRect)rect
{
    if (!_tabInitialized && titles.count == classes.count &&
        titles.count == images.count && classes.count <= sizeof(indexes))
    {
        UIButton *button;
        CGRect buttonRect;
        float width = rect.size.width / titles.count;
        float height = rect.size.height;
        float x = rect.origin.x;
        float y = rect.origin.y;
        _contentFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - rect.size.height);
        controllers = classes;
 
        for (int i = 0; i < classes.count; i++)
        {
            buttonRect = CGRectMake(x + width * i, y, width, height);
            button = [[UIButton alloc] initWithFrame:buttonRect];
            button.tag = i;
            [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [self.view addSubview:button];
            indexes[i] = classes.count;

            if (_activeIndex == i && _contentNeedDisplay)
                [self.view addSubview:[[self childController:_activeIndex] view]];
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
    if (index == _activeIndex || index < 0 || index >= controllers.count) return;

    if (_contentNeedDisplay)
    {
        NavigationViewController *currentController = [self childController:_activeIndex];
        NavigationViewController *controller = [self childController:index];
        
        [self transitionFromViewController:currentController
                          toViewController:controller
                                  duration:_duration
                                   options:_animationOptions
                                animations:nil
                                completion:nil];
        _activeIndex = index;
    }
    else
    {
        _activeIndex = index;
        self.contentNeedDisplay = YES;
    }
}

- (NavigationViewController *)childController:(int)index
{
    if (indexes[index] < controllers.count)
        return [self.childViewControllers objectAtIndex:indexes[index]];

    NavigationViewController *controller = [[[controllers objectAtIndex:index] alloc] init];
    indexes[index] = self.childViewControllers.count;
    [self addChildViewController:controller];
    controller.view.frame = _contentFrame;
    [controller initContent];

    return controller;
}

- (void)setContentNeedDisplay:(BOOL)needDisplay
{
    if (needDisplay == _contentNeedDisplay) return;

    NavigationViewController *controller = [self childController:_activeIndex];
    needDisplay ? [self.view addSubview:controller.view] : [controller removeFromParentViewController];
    _contentNeedDisplay = needDisplay;
}

- (void)popMessage:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:text
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"ok"
                                         otherButtonTitles:nil, nil];

    [alert show];
}

@end
