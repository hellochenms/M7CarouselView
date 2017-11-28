//
//  CarouselViewController.m
//  M7CarouselView
//
//  Created by Chen,Meisong on 2017/11/28.
//  Copyright © 2017年 chenmeisong. All rights reserved.
//

#import "CarouselViewController.h"
#import <M7CarouselView/M7Carousel.h>
#import "CarouselItem.h"

@interface CarouselViewController ()<M7CarouselViewDatasource>
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) M7CarouselView *carouselView;
@property (nonatomic) NSArray *datas;
@end

@implementation CarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.carouselView];
    [self.carouselView start];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    double width = CGRectGetWidth(self.view.bounds);
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(width, CGRectGetHeight(self.view.bounds) * 2);
    self.carouselView.frame = CGRectMake(20, 20, width - 20 * 2, 200);
}

#pragma mark - M7CarouselViewDatasource
- (NSInteger)numberOfItemsInCarouselView:(M7CarouselView *)carouselView {
    return [self.datas count];
}

- (M7CarouselItem *)carouselView:(M7CarouselView *)carouselView itemAtIndex:(NSInteger )index {
    CarouselItem *item = [CarouselItem new];
    NSArray *data = [self.datas objectAtIndex:index];
    [item configWithData:data];
    
    return item;
}

- (NSTimeInterval)rotatePeriodInCarouselView:(M7CarouselView *)carouselView {
    return 2.6;
}

- (NSTimeInterval)transitionDurationInCarouselView:(M7CarouselView *)carouselView {
    return 1;
}

#pragma mark - Getter
- (UIScrollView *)scrollView {
    if(!_scrollView){
        _scrollView = [UIScrollView new];
    }
    
    return _scrollView;
}

- (M7CarouselView *)carouselView {
    if(!_carouselView){
        _carouselView = [M7CarouselView new];
        _carouselView.datasource = self;
    }
    
    return _carouselView;
}

- (NSArray *)datas {
    if(!_datas){
        _datas = @[@[[UIColor redColor], @"star", @"^helloworldhelloworldhelloworld$"],
                   @[[UIColor greenColor], @"share", @"^你好世界你好世界你好世界你好世界你好世界$"],
                   @[[UIColor blueColor], @"comment", @"^helloworld你好世界helloworld你好世界$"],
                   ];
    }
    
    return _datas;
}

@end
