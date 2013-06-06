//
//  BookModel.m
//  Recite
//
//  Created by Roy on 6/3/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "BookModel.h"
#import "HttpClient.h"

static NSMutableArray *instances;

__attribute__((constructor))
static void initializeInstances()
{
    instances = [[NSMutableArray alloc] init];
}

@implementation BookModel

@synthesize bid;

@synthesize title;

@synthesize description;

@synthesize level;

@synthesize size;

+ (BookModel *)bookForBid:(int)bid
{
    BookModel *book = [BookModel bookFromCache:bid];
    
    if (!book)
    {
        HttpClient *client = [HttpClient singleInstance];
        NSDictionary *dict = [client call:[NSString stringWithFormat:@"book/%i", bid]];

        if (client.code)
        {
            return nil;
        }

        book = [[BookModel alloc] init];
        [book initContent:dict];

        [instances addObject:book];
    }

    return book;
}

+ (BookModel *)bookFromCache:(int)bid
{
    BookModel *book;

    for (int i = 0; i < instances.count; i++)
    {
        book = [instances objectAtIndex:i];
        
        if (book.bid == bid) return book;
    }
    
    return nil;
}

+ (NSArray *)booksForPage:(int)page
{
    NSDictionary *dict;
    BookModel *book;
    HttpClient *client = [HttpClient singleInstance];
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i", page], @"page", nil];
    NSArray *books = (NSArray *)[client call:@"book/list" post:nil query:query];

    if (client.code)
    {
        return nil;
    }
    
    [instances removeAllObjects];

    for (int i = 0; i < books.count; i++)
    {
        dict = [books objectAtIndex:i];
        book = [[BookModel alloc] init];
        [book initContent:dict];
        [instances addObject:book];
    }

    return [NSArray arrayWithArray:instances];
}

+ (BOOL)purchase:(int)bid
{
    HttpClient *client = [HttpClient singleInstance];
    [client call:[NSString stringWithFormat:@"book/%i/purchase", bid]];

    return !client.code;
}

+ (NSArray *)purchasedBooks:(int)uid
{
    return nil;
}

- (void)initContent:(NSDictionary *)dict
{
    self.bid = [[dict objectForKey:@"id"] intValue];
    self.title = [dict objectForKey:@"title"];
    self.description = [dict objectForKey:@"description"];
    self.level = [[dict objectForKey:@"level"] intValue];
    self.size = [[dict objectForKey:@"size"] intValue];
}

@end
