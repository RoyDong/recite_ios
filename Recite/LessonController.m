//
//  LessonController.m
//  Recite
//
//  Created by Roy on 5/31/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "LessonController.h"
#import "LessonModel.h"
#import "BookModel.h"
#import "UserModel.h"

@interface LessonController ()

@end

@implementation LessonController

- (void)initContent
{
    [super initContent];

    UserModel *user = [UserModel currentUser];
    [BookModel purchasedBooks:user.uid];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [LessonModel lessons];
}

@end