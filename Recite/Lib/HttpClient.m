//
//  HttpClient.m
//  three
//
//  Created by Roy on 5/7/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "HttpClient.h"
#import <Foundation/Foundation.h>

@interface HttpClient()

@end

static HttpClient *singleInstance;

@implementation HttpClient

+ (HttpClient *)singleInstance
{
    if(!singleInstance)
    {
        singleInstance = [[HttpClient alloc] init];
    }
    
    return singleInstance;
}

- (HttpClient *)init
{
    self = [super init];
    
    if(self)
    {
        _host = @"http://roy.recite.dev.xq.lab/";
        request = [[NSMutableURLRequest alloc] init];
        [request setValue:@"json" forHTTPHeaderField:@"Response-Format"];
    }
    
    return self;
}

@synthesize host = _host;
@synthesize message = _message;
@synthesize code = _code;

- (NSURL *)createUrlWithApi:(NSString *)api
{
    return [NSURL URLWithString:[self.host stringByAppendingString: api]];
}

- (NSURL *)createUrlWithApi:(NSString *)api query:(NSDictionary *)query
{
    NSString *url = [self.host stringByAppendingString: api];

    if(query)
    {
        NSString *httpQuery = [self buildHttpFormData:query];
        url = [url stringByAppendingFormat:@"?%@", httpQuery];
    }

    return [NSURL URLWithString: url];
}

- (NSDictionary *)call:(NSString *)api
{
    return [self call:api post:nil query:nil];
}

- (NSDictionary *)call:(NSString *)api post:(NSDictionary *)post
{
    return [self call:api post:post query:nil];
}

- (NSDictionary *)call:(NSString *)api post:(NSDictionary *)post query:(NSDictionary *)query
{
    currentApi = api;
    NSError *error;
    NSURL *url = [self createUrlWithApi:api query:query];

    [request setURL:url];
    [request setHTTPMethod:@"POST"];

    if(post)
    {
        NSData *postData = [[self buildHttpFormData:post] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [request setHTTPBody:postData];        
    }
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];

    NSString *content = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@", content);

    if(error.code)
    {
        _message = @"Server error";
        _code = 1;

        return nil;
    }
    
    _message = [result objectForKey:@"message"];
    _code = [[result objectForKey:@"code"] intValue];

    return [result objectForKey:@"data"];
}

- (NSString *)buildHttpFormData:(NSDictionary *)parameters
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    NSString *key;
    NSString *value;
    
    for(key in parameters)
    {
        value = [parameters objectForKey:key];
        [parts addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
         
    return [parts componentsJoinedByString:@"&"];
}

- (NSString *)cookieForKey:(NSString *)key
{
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    for(NSHTTPCookie *cookie in [cookieStore cookies])
    {
        if ([cookie.name isEqualToString:key]) return cookie.value;
    }

    return nil;
}

@end
