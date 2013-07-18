//
//  TcpClient.m
//  Recite
//
//  Created by Roy on 7/12/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "TcpClient.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netdb.h>



const int MaxCall = 10;

const int MaxSec = 30;

const int NoticeMid = 63;

@implementation TcpClient
{
    int sockeId;
    struct sockaddr_in socketParams;
    NSMutableArray *callbacks;
    int calltimes[MaxCall + 1];
    NSThread *thread;
}

@synthesize host = _host;

@synthesize ip = _ip;

@synthesize port = _port;

@synthesize message = _message;

@synthesize status = _status;

@synthesize noticeHandler = _noticeHandler;

static TcpClient *singleInstance;

+ (TcpClient *)singleInstance
{
    if(!singleInstance)
    {
        singleInstance = [[TcpClient alloc] initWithHost:@"arch" port:3721];
    }
    
    return singleInstance;
}

- (TcpClient *)initWithHost:(NSString *)host port:(int)port
{
    self = [super init];
    
    if (self)
    {
        _host = host;
        _port = port;
    }
    
    return self;
}

- (void)open
{
    callbacks = [NSMutableArray arrayWithCapacity:MaxCall];

    for (int i = 0; i < MaxCall; i++)
    {
        calltimes[i] = 0;
    }

    sockeId = socket(AF_INET, SOCK_STREAM, 0);

    if (sockeId == -1)
    {
        _message = @"failed to create socket";
        close(sockeId);
        return;
    }

    struct hostent *hostEnt = gethostbyname([_host UTF8String]);

    if (hostEnt == NULL)
    {
        _message = @"could not get host info";
        close(sockeId);
        return;
    }

    socketParams.sin_family = AF_INET;
    bcopy(hostEnt->h_addr_list[0], &socketParams.sin_addr, hostEnt->h_length);
    socketParams.sin_port = htons(_port);
    int ret = connect(sockeId, (struct sockaddr *)&socketParams, sizeof(socketParams));
    
    if (ret == -1)
    {
        _message = [NSString stringWithFormat:@"connect to %@:%i failed", _host, _port];
        close(sockeId);
        return;
    }

    _status = 1;
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(listen) object:Nil];
    [thread setName:@"t"];
    [thread start];
    NSLog(@"new thread");
}

- (void)listen
{
    while (_status)
    {
        char head[9];
        int result = recv(sockeId, head, 9, 0);

        if (result == 9)
        {
            int sentTime, length;
            int mid = head[0];
            bcopy(head + 1, (void *)&sentTime, 4);
            bcopy(head + 5, (void *)&length, 4);
            char buffer[length];
            result = recv(sockeId, buffer, length, 0);

            if (result == length)
            {
                NSData *data = [[NSData alloc] initWithBytes:buffer length:length];

                NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%i %i %@", mid, sentTime, s);

                if (mid == NoticeMid)
                {
                    if (_noticeHandler)
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{_noticeHandler(data);}];

                    continue;
                }

                if (mid >= 0 && mid < MaxCall)
                {
                    int callTime = calltimes[mid];
                    int t = (int)time(NULL);
                    void (^callback)(NSData *reply) = [callbacks objectAtIndex:mid];
                
                    if (callTime > 0 && t - callTime <= MaxSec && callback)
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{callback(data);}];

                    calltimes[mid] = 0;
                }

                continue;
            }
        }

        _status = 0;
    }

    _message = @"server closed";
    NSLog(@"server closed");
    close(sockeId);
    [NSThread exit];
}

- (void)setStatus:(int)status
{
    _status = status;
    if (_status == 0) [thread cancel];
}

- (BOOL)callWithTitle:(NSString *)title content:(NSString *)content callback:(void (^)(NSData *reply))callback
{
    if (!title || !content) return false;
    if (_status == 0) [self open];

    int mid;
    int t = (int)time(NULL);

    for (mid = 0; mid < MaxCall; mid++)
    {
        if (calltimes[mid] == 0 || t - calltimes[mid] > MaxSec)
        {
            [callbacks setObject:callback atIndexedSubscript:mid];
            calltimes[mid] = t;
            break;
        }
    }

    if (mid >= MaxCall)
    {
        _message = @"network is busy";
        NSLog(@"network is busy");
        return NO;
    }

    const char *titleBuf = [title UTF8String];
    const char *contentBuf = [content UTF8String];
    int titleLen = strlen(titleBuf);
    int contentLen = strlen(contentBuf);
    int length = 13 + titleLen + contentLen;

    char buffer[length];
    buffer[0] = mid;
    bcopy((void *)&t, buffer + 1, 4);
    bcopy((void *)&titleLen, buffer + 5, 4);
    bcopy((void *)&contentLen, buffer + 9, 4);
    bcopy(titleBuf, buffer + 13, titleLen);
    bcopy(contentBuf, buffer + 13 + titleLen, contentLen);

    return send(sockeId, buffer, length, AF_INET) == length;
}

- (NSString *)buildContent:(NSDictionary *)parameters
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    NSString *value;
    
    for(NSString *key in parameters)
    {
        value = [parameters objectForKey:key];
        [parts addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    
    return [parts componentsJoinedByString:@"&"];
}

@end