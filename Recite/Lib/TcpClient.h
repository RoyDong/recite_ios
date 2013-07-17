//
//  TcpClient.h
//  Recite
//
//  Created by Roy on 7/12/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TcpClient : NSObject

@property (nonatomic, readonly, strong) NSString *host;

@property (nonatomic, readonly, strong) NSString *ip;

@property (nonatomic, readonly, strong) NSString *message;

@property (nonatomic, readonly) int status;

@property (nonatomic, readonly) int port;

- (TcpClient *)init:(NSString *)host port:(int)port;

- (void)open;

- (BOOL)send:(NSString *)command data:(NSString *)data callback:(void (^)(NSData *reply))callback;

@end
