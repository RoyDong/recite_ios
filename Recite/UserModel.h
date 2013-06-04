//
//  UserModel.h
//  Recite
//
//  Created by Roy on 5/15/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserModel : NSObject

@property (nonatomic) int uid;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *role;

+ (UserModel *)userForUid:(int)uid;

+ (UserModel *)currentUser;

+ (BOOL)signin:(NSString *)email passwd:(NSString *)passwd;

+ (void)signout;

@end
