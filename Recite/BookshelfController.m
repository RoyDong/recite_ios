//
//  BookshelfController.m
//  Recite
//
//  Created by Roy on 5/31/13.
//  Copyright (c) 2013 Roy. All rights reserved.
//

#import "BookshelfController.h"
#import "BookModel.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.delegate = self;

    NSArray *books = [BookModel booksForPage:1];
    BookModel *book;
    UIButton *button;

    CGRect rect;
    CGRect frame = self.view.frame;
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
        
        x = ox + i % 3 * (labelWidth + padWidth);
        y = oy + ((int)(i / 3)) * (labelHeight + padHeight);

        rect = CGRectMake(x, y, labelWidth, labelHeight);
        button = [[UIButton alloc] initWithFrame:rect];
        [button setTitle:book.title forState:UIControlStateNormal];
        button.backgroundColor = [UIColor greenColor];
        h += labelHeight + padHeight;
        
        [scrollView addSubview:button];
    }
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, h);
    [self.view addSubview: scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
