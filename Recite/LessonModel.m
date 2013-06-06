//
//  LessonModel.m
//  Recite
//
//  Created by Roy on 5/31/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "LessonModel.h"
#import "HttpClient.h"

@implementation LessonModel

+ (NSArray *)lessons
{
    NSDictionary *lessons = [[HttpClient singleInstance] call:@"course/lessons"];

    return nil;
}

@end
