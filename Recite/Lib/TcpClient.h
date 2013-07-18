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

@property (nonatomic) int status;

@property (nonatomic, readonly) int port;

@property (nonatomic, strong) void (^noticeHandler)(NSData *notice);

+ (TcpClient *)singleInstance;

- (TcpClient *)initWithHost:(NSString *)host port:(int)port;

- (void)open;

- (NSString *)buildContent:(NSDictionary *)parameters;

- (BOOL)callWithTitle:(NSString *)title content:(NSString *)content callback:(void (^)(NSData *reply))callback;

@end
