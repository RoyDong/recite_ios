//
//  UserModel.m
//  Recite
//
//  Created by Roy on 5/15/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "UserModel.h"
#import "HttpClient.h"

static NSMutableArray *instances;

__attribute__((constructor))
static void initializeInstances()
{
    instances = [[NSMutableArray alloc] init];
}

static UserModel *current;

@implementation UserModel

@synthesize uid;

@synthesize email;

@synthesize name;


+ (UserModel *)userForUid:(int)uid
{
    UserModel *user = [UserModel userFromCache:uid];
    
    if (!user)
    {
        HttpClient *client = [HttpClient singleInstance];
        NSDictionary *dict = [client call:[NSString stringWithFormat:@"/user/%i", uid]];
        
        if (client.code)
        {
            return nil;
        }
        
        user = [[UserModel alloc] init];
        [user initContent:dict];
        
        [instances addObject:user];
    }

    return user;
}

+ (UserModel *)userFromCache:(int)uid
{
    UserModel *user;
    
    for (int i = 0; i < instances.count; i++)
    {
        user = [instances objectAtIndex:i];
        
        if (user.uid == uid) return user;
    }

    return nil;
}

+ (UserModel *)currentUser
{
    if (!current)
    {
        HttpClient *client = [HttpClient singleInstance];
        NSDictionary *dict = [client call:@"/user"];
        
        if (client.code)
        {
            return nil;
        }
        
        current = [UserModel userFromCache:[[dict objectForKey:@"id"] intValue]];
        
        if (!current)
        {
            current = [[UserModel alloc] init];
            [instances addObject:current];
        }
        
        [current initContent:dict];
    }

    return current;
}

+ (BOOL)signin:(NSString *)email passwd:(NSString *)passwd
{
    NSDictionary *account = [NSDictionary dictionaryWithObjectsAndKeys:
                             email, @"email",
                             passwd, @"passwd",
                             @"1", @"remember_me", nil];

    HttpClient *client = [HttpClient singleInstance];
    [client call:@"/signin" post:account];

    if (client.code == 13) [client call:@"/signup" post:account];

    return !client.code;
}

+ (void)signout
{
    [[HttpClient singleInstance] call:@"/signout"];
    current = nil;
}

- (void)initContent:(NSDictionary *)dict
{
    self.uid = [[dict objectForKey:@"id"] intValue];
    self.email = [dict objectForKey:@"email"];
    self.name = [dict objectForKey:@"name"];
}

@end
