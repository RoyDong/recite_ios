//
//  BookshelfController.m
//  Recite
//
//  Created by Roy on 5/31/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "BookshelfController.h"
#import "BookModel.h"
#import "HttpClient.h"

@interface BookshelfController ()

@end

@implementation BookshelfController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initContent
{
    [super initContent];
    
    CGRect frame = self.parentViewController.contentFrame;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.delegate = self;
    
    NSArray *books = [BookModel booksForPage:1];
    BookModel *book;
    UIButton *button;
    
    CGRect rect;
    float width = frame.size.width - 50;
    float ox = frame.origin.x + 25;
    float oy = frame.origin.y + 25;
    float x, y, h = 50;
    float padWidth = 10, padHeight = 20;
    float labelWidth = (width + padWidth) / 3 - padWidth;
    float labelHeight = 50;
    
    for (int i = 0; i < books.count; i++)
    {
        book = [books objectAtIndex:i];

        h += labelHeight + padHeight;
        x = ox + i % 3 * (labelWidth + padWidth);
        y = oy + ((int)(i / 3)) * (labelHeight + padHeight);
        rect = CGRectMake(x, y, labelWidth, labelHeight);

        button = [[UIButton alloc] initWithFrame:rect];
        [button setTitle:book.title forState:UIControlStateNormal];
        button.backgroundColor = [UIColor greenColor];
        button.tag = book.bid;
        [button addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];

        [scrollView addSubview:button];
    }

    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, h);
    [self.view addSubview: scrollView];
}

- (IBAction)purchase:(UIButton *)sender
{
    [BookModel purchase:sender.tag];
    [self popMessage:[[HttpClient singleInstance] message]];
}

@end
