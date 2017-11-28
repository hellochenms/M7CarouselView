//
//  M7CarouselView.h
//  M7CarouselView
//
//  Created by Chen,Meisong on 2017/11/28.
//

#import <UIKit/UIKit.h>
#import "M7CarouselItem.h"

@protocol M7CarouselViewDatasource;

@interface M7CarouselView : UIView
@property (nonatomic, weak, nullable) id<M7CarouselViewDatasource> datasource;
- (void)reloadData;
- (void)start;
- (void)stop;
@end

NS_ASSUME_NONNULL_BEGIN
@protocol M7CarouselViewDatasource<NSObject>
@required
- (NSInteger)numberOfItemsInCarouselView:(M7CarouselView *)carouselView;
- (__kindof M7CarouselItem *)carouselView:(M7CarouselView *)carouselView itemAtIndex:(NSInteger )index;
@optional
- (NSTimeInterval)rotatePeriodInCarouselView:(M7CarouselView *)carouselView;
- (NSTimeInterval)transitionDurationInCarouselView:(M7CarouselView *)carouselView;
@end
NS_ASSUME_NONNULL_END
