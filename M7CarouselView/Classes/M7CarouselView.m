//
//  M7CarouselView.m
//  M7CarouselView
//
//  Created by Chen,Meisong on 2017/11/28.
//

#import "M7CarouselView.h"
#import "M7CarouselItem.h"

static double const kRotatePeriod = 3.0;
static double const kTransitionDuration = 1.0;

@interface M7CarouselView()
@property (nonatomic) UIView *imagesContainer;
@property (nonatomic) dispatch_block_t block;
@property (nonatomic) NSTimer *timer;
@end

@implementation M7CarouselView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imagesContainer];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imagesContainer.frame = self.bounds;
    [[self.imagesContainer subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.frame = self.imagesContainer.bounds;
    }];
}

#pragma mark - Public
- (void)reloadData {
    NSArray<UIView *> *subviews = [self.imagesContainer subviews];
    [subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item removeFromSuperview];
    }];
    
    if (!self.datasource
        || ![self.datasource respondsToSelector:@selector(numberOfItemsInCarouselView:)]
        || ![self.datasource respondsToSelector:@selector(carouselView:itemAtIndex:)]) {
        return;
    }
    
    NSInteger itemCount = [self.datasource numberOfItemsInCarouselView:self];
    NSMutableArray<M7CarouselItem *> *items = [NSMutableArray array];
    for (NSInteger i = 0; i < itemCount; i++) {
        M7CarouselItem *item = [self.datasource carouselView:self itemAtIndex:i];
        [items addObject:item];
    }
    // 为了让index为0的数据显示在最前面，逆序后添加到父view
    NSArray *reverseItems = [[items reverseObjectEnumerator] allObjects];
    [reverseItems enumerateObjectsUsingBlock:^(M7CarouselItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.imagesContainer addSubview:item];
    }];
}

- (void)start {
    [self stop];
    
    if (!self.datasource
        || ![self.datasource respondsToSelector:@selector(numberOfItemsInCarouselView:)]) {
        return;
    }
    
    NSArray<M7CarouselItem *> *subviews = [self.imagesContainer subviews];
    NSInteger itemCount = [subviews count];
    
    if (itemCount < 1) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    self.block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
        M7CarouselItem *nextVisibleView = [[weakSelf.imagesContainer subviews] lastObject];
        [weakSelf animateWithVisibleItem:nil nextVisibleItem:nextVisibleView];
    });
    dispatch_async(dispatch_get_main_queue(), self.block);
    
    if (itemCount < 2) {
        return;
    }
    
    double rotatePeriod = kRotatePeriod;
    if (self.datasource &&
        [self.datasource respondsToSelector:@selector(rotatePeriodInCarouselView:)]) {
        rotatePeriod = [self.datasource rotatePeriodInCarouselView:self];
        if (rotatePeriod <= 0) {
            rotatePeriod = kRotatePeriod;
        }
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:rotatePeriod
                                                 repeats:YES
                                                   block:^(NSTimer * _Nonnull timer) {
                                                       NSArray<M7CarouselItem *> *subviews = [self.imagesContainer subviews];
                                                       NSInteger itemCount = [subviews count];
                                                       M7CarouselItem *visibleView = [subviews objectAtIndex:itemCount - 1];
                                                       M7CarouselItem *nextVisibleView = [subviews objectAtIndex:itemCount - 2];
                                                       [weakSelf animateWithVisibleItem:visibleView nextVisibleItem:nextVisibleView];
                                                   }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stop {
    if (self.block) {
        dispatch_block_cancel(self.block);
    }
    [self.timer invalidate];
}

#pragma mark - Setter/Getter
- (void)setDatasource:(id<M7CarouselViewDatasource>)datasource {
    _datasource = datasource;
    [self reloadData];
}

- (UIView *)imagesContainer {
    if(!_imagesContainer){
        _imagesContainer = [[UIView alloc] init];
        _imagesContainer.clipsToBounds = YES;
    }
    
    return _imagesContainer;
}

#pragma mark - Tools
- (void)animateWithVisibleItem:(M7CarouselItem *)visibleItem nextVisibleItem:(M7CarouselItem *)nextVisibleItem {
    double transitionDuration = kTransitionDuration;
    if (self.datasource &&
        [self.datasource respondsToSelector:@selector(transitionDurationInCarouselView:)]) {
        transitionDuration = [self.datasource transitionDurationInCarouselView:self];
        if (transitionDuration <= 0) {
            transitionDuration = kTransitionDuration;
        }
    }
    [visibleItem exitWithDuration:transitionDuration];
    [nextVisibleItem enterWithDuration:transitionDuration];
}

#pragma mark - Life Cycle
- (void)dealloc {
    [self stop];
}

@end
