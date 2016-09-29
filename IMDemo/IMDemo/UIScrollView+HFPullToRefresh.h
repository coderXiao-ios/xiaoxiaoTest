//
//  UIScrollView+PullToRefresh.h
//  IMDemo
//
//  Created by 潇潇 on 16/9/7.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFPullToRefreshView;

@interface UIScrollView (HFPullToRefresh)

typedef NS_ENUM(NSUInteger, HFPullToRefreshPosition) {
    HFPullToRefreshPositionTop = 0,
    HFPullToRefreshPositionBottom,
};

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(HFPullToRefreshPosition)position;
- (void)triggerPullToRefresh;

@property (nonatomic, strong, readonly) HFPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;

@end

typedef NS_ENUM(NSUInteger, HFPullToRefreshState) {
    HFPullToRefreshStateStopped = 0,
    HFPullToRefreshStateTriggered,
    HFPullToRefreshStateLoading,
    HFPullToRefreshStateAll = 10
};

@interface HFPullToRefreshView : UIView

@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;
@property (nonatomic, strong, readwrite) UIColor *activityIndicatorViewColor;
@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property (nonatomic, readonly) HFPullToRefreshState state;
@property (nonatomic, readonly) HFPullToRefreshPosition position;

- (void)setTitle:(NSString *)title forState:(HFPullToRefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(HFPullToRefreshState)state;
- (void)setCustomView:(UIView *)view forState:(HFPullToRefreshState)state;

- (void)startAnimating;
- (void)stopAnimating;


@end
