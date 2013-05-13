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

@property(nonatomic, readonly, strong) NSMutableURLRequest *request;

@end

static HttpClient *_singleInstance;

@implementation HttpClient

+ (HttpClient *)singleInstance
{
    if(!_singleInstance)
    {
        _singleInstance = [[HttpClient alloc] init];
    }
    
    return _singleInstance;
}

- (HttpClient *)init
{
    self = [super init];
    
    if(self){
        _host = @"http://roy.recite.dev.xq.lab/";
        _request = [[NSMutableURLRequest alloc] init];
        [_request setValue:@"json" forHTTPHeaderField:@"Response-Format"];
    }
    
    return self;
}

@synthesize host = _host;
@synthesize request = _request;
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

    [_request setURL:url];
    [_request setHTTPMethod:@"POST"];

    if(post)
    {
        NSData *postData = [[self buildHttpFormData:post]
                            dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [_request setHTTPBody:postData];        
    }
    
    NSData *response = [NSURLConnection sendSynchronousRequest:_request returningResponse:nil error:nil];
    

    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        //NSLog(@"%@", cookie);
    }
    
    NSString *content =[NSString stringWithCString:[response bytes]
                                          encoding:NSUTF8StringEncoding];

    NSLog(@"%@", content);

    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];

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
