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
    NSError *error;
    NSURL *url = [self createUrlWithApi:api query:query];

    [request setURL:url];
    [request setHTTPMethod:@"POST"];

    if(post)
    {
        NSData *postData = [[self buildHttpFormData:post]
                            dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [request setHTTPBody:postData];        
    }
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    

    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies])
    {
        //NSLog(@"%@", cookie);
    }
    
    NSString *content =[NSString stringWithCString:[response bytes]
                                          encoding:NSUTF8StringEncoding];

    NSLog(@"%@", content);

    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
    if([error code])
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
    NSString *part;
    NSString *key;
    NSString *value;
    
    for(key in parameters)
    {
        value = [parameters objectForKey:key];
        part = [NSString stringWithFormat:@"%@=%@", key, value];
        [parts addObject:part];
    }
         
    return [parts componentsJoinedByString:@"&"];
}

@end
