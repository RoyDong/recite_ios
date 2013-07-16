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

const int Timeout = 30;


@implementation TcpClient
{
    int sockeId;
    struct sockaddr_in socketParams;
    NSThread *thread;
    NSMutableArray *callbacks;
    int calltimes[MaxCall];
}


@synthesize host = _host;

@synthesize ip = _ip;

@synthesize port = _port;

@synthesize message = _message;

@synthesize status = _status;


- (void)close
{
    close(sockeId);
    callbacks = [NSMutableArray arrayWithCapacity:MaxCall];
    
    for (int i = 0; i < MaxCall; i++)
    {
        callbacks[i] = NULL;
        calltimes[i] = 0;
    }
    
    _status = 0;
    NSLog(@"%@", _message);
}

- (void)open:(NSString *)host port:(int)port
{
    [self close];

    _host = host;
    _port = port;

    sockeId = socket(AF_INET, SOCK_STREAM, 0);

    if (sockeId == -1)
    {
        _message = @"failed to create socket";
        [self close];
        return;
    }

    struct hostent *hostEnt = gethostbyname([_host UTF8String]);

    if (hostEnt == NULL)
    {
        _message = @"could not get host info";
        [self close];
        return;
    }

    socketParams.sin_family = AF_INET;
    bcopy(hostEnt->h_addr_list[0], &socketParams.sin_addr, hostEnt->h_length);
    socketParams.sin_port = htons(_port);
    
    thread = [[NSThread alloc] initWithTarget:self
                                     selector:@selector(connect)
                                       object:Nil];
    [thread start];
}

- (void)connect
{
    int ret = connect(sockeId, (struct sockaddr *)&socketParams, sizeof(socketParams));
    
    if (ret == -1)
    {
        _message = [NSString stringWithFormat:@"connect to %@:%i failed", _host, _port];
        [self close];
        return;
    }
    
    NSMutableData *data = [[NSMutableData alloc] init];
    _status = 1;

    while (1)
    {
        const char *buffer[1024];
        int length = sizeof(buffer);
        int result = recv(sockeId, &buffer, length, 0);
        
        if (result > 0)
        {
            [data appendBytes:buffer length:result];
            NSLog(@"%@ %i", data, result);
        }
        else
        {
            _message = @"server closed";
            [self close];
            break;
        }
    }
}

- (BOOL)send:(NSString *)command data:(NSString *)data callback:(void (^)(void))callback
{
    int cid;
    int t = (int)time(NULL);
    
    for (cid = 0; cid < MaxCall; cid++)
    {
        if (calltimes[cid] == 0)
        {
            callbacks[cid] = callback;
            calltimes[cid] = t;
            break;
        }
    }
    
    if (cid >= MaxCall)
    {
        _message = @"too many calls";
        return NO;
    }
    
    const char *commandBuffer = [command UTF8String];
    const char *dataBuffer = [data UTF8String];
    int commandLength = strlen(commandBuffer);
    int dataLength = strlen(dataBuffer);
    int length = 13 + commandLength + dataLength;

    char buffer[length];
    buffer[0] = cid;
    bcopy((void *)&t, buffer + 1, 4);
    bcopy((void *)&commandLength, buffer + 5, 4);
    bcopy((void *)&dataLength, buffer + 9, 4);
    bcopy(commandBuffer, buffer + 13, commandLength);
    bcopy(dataBuffer, buffer + 13 + commandLength, dataLength);

    return send(sockeId, buffer, length, AF_INET) == length;
}

- (void)networkError
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
    }];
}

@end
