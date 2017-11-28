//
//  CarouselItem.m
//  M7CarouselView_Example
//
//  Created by Chen,Meisong on 2017/11/28.
//  Copyright © 2017年 chenmeisong. All rights reserved.
//

#import "CarouselItem.h"

static double const kScaleSeconds = 2.4;
static double const kScaleFactor = 1.5;

@interface CarouselItem()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) dispatch_block_t exitTask;
@end

@implementation CarouselItem
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    double width = CGRectGetWidth(self.bounds);
    double height = CGRectGetHeight(self.bounds);
    
    if (CGAffineTransformEqualToTransform(self.imageView.transform, CGAffineTransformIdentity)) {
        self.imageView.frame = self.bounds;
    }
    self.titleLabel.frame = CGRectMake(20, height - 10 - 20, width - 20 * 2, 20);
}

#pragma mark - Public
- (void)configWithData:(NSArray *)data {
    self.imageView.backgroundColor = data[0];
    self.imageView.image = [UIImage imageNamed:data[1]];
    self.titleLabel.text = data[2];
}

#pragma mark - Override
- (void)enterWithDuration:(NSTimeInterval)seconds {
    [[self superview] bringSubviewToFront:self];
    [UIView animateWithDuration:seconds
                     animations:^{
                         self.alpha = 1;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:kScaleSeconds
                                          animations:^{
                                              self.imageView.transform = CGAffineTransformMakeScale(kScaleFactor, kScaleFactor);
                                          }];
                     }];
}

- (void)exitWithDuration:(NSTimeInterval)seconds {
    __weak typeof(self) weakSelf = self;
    self.exitTask = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
        [[weakSelf superview] sendSubviewToBack:weakSelf];
        weakSelf.alpha = 0;
        weakSelf.imageView.transform = CGAffineTransformIdentity;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), self.exitTask);
}

#pragma mark - Getter
- (UILabel *)titleLabel {
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
    }
    
    return _titleLabel;
}

- (UIImageView *)imageView {
    if(!_imageView){
        _imageView = [UIImageView new];
    }
    
    return _imageView;
}

#pragma mark - Life Cycle
- (void)dealloc {
    if (self.exitTask) {
        dispatch_block_cancel(self.exitTask);
    }
}

@end
