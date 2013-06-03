//
//  BookModel.h
//  Recite
//
//  Created by Roy on 6/3/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject

@property (nonatomic) int bid;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *description;

@property (nonatomic) int level;

@property (nonatomic) int size;

+ (BookModel *)bookForBid:(int)bid;

+ (NSArray *)booksForPage:(int)page;

+ (NSArray *)purchased:(int)uid;


@end
