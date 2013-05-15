//
//  UserModel.m
//  Recite
//
//  Created by Roy on 5/15/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "UserModel.h"

static NSMutableArray *instances;

static UserModel *current;

@implementation UserModel

@synthesize uid;

@synthesize email;

@synthesize username;

@synthesize role;

+ (UserModel *)userForUid:(int)uid
{
    UserModel *user = [UserModel userFromCache:uid];
    
    if (!user)
    {
        NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", uid], @"id", nil];
        NSDictionary *dict = [[HttpClient singleInstance] call:@"user/show" post:nil query:query];
        user = [[UserModel alloc] init];
        [user initContentWithDict:dict];
        
        [instances addObject:user];
    }

    return user;
}

+ (UserModel *)userFromCache:(int)uid
{
    UserModel *user;
    int count = [instances count];
    
    for (int i = 0; i < count; i++)
    {
        user = [instances objectAtIndex:uid];
        
        if (user.uid == uid) break;
    }
    
    return user;
}

+ (UserModel *)currentUser
{
    if (!current)
    {
        HttpClient *client = [HttpClient singleInstance];
        NSDictionary *dict = [client call:@"user/current"];
        
        if (client.code)
        {
            return nil;
        }
        
        current = [UserModel userFromCache:[[dict objectForKey:@"id"] intValue]];
        
        if (!current)
        {
            current = [[UserModel alloc] init];
            [current initContentWithDict:dict];
            [instances addObject:current];
        }
    }

    return current;
}

- (void)initContentWithDict:(NSDictionary *)dict
{
    self.uid = [[dict objectForKey:@"id"] intValue];
    self.email = [dict objectForKey:@"email"];
    self.username = [dict objectForKey:@"username"];
    self.role = [dict objectForKey:@"role"];
}

@end
