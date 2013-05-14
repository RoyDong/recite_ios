//
//  HttpClient.h
//  three
//
//  Created by Roy on 5/7/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpClient : NSObject
{
    NSMutableURLRequest *request;
}

@property (nonatomic, readonly, strong) NSString *host;

@property (nonatomic, readonly, strong) NSString *message;

@property (nonatomic, readonly) int code;

+ (HttpClient *)singleInstance;

- (NSDictionary *)call:(NSString *)api;

- (NSDictionary *)call:(NSString *)api post:(NSDictionary *)post;

- (NSDictionary *)call:(NSString *)api post:(NSDictionary *)post query:(NSDictionary *)query;

@end
