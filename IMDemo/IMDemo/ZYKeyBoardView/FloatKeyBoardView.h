//
//  FloatKeyBoardView.h
//  ZYKeyBoardViewTest
//
//  Created by saga_ios on 16/8/20.
//  Copyright © 2016年 ZhaoYan. All rights reserved.
//


//CJPlaceHolderTextView.h 这个类不用再倒进项目，项目里有
#import <UIKit/UIKit.h>
#import "CJPlaceHolderTextView.h"
#define kWinSize [UIScreen mainScreen].bounds.size
@class FloatKeyBoardView;
@protocol FloatKeyBoardViewDelegate <NSObject>

@optional
//isBarrage 为是否开启了弹幕
-(void)FloatKeyBoardViewTextView:(UITextView *)textView InputSting:(NSString *)inputSting didIsBarrage:(BOOL)isBarrage;

@end

@interface FloatKeyBoardView : UIView
@property (nonatomic, strong) CJPlaceHolderTextView *textView;
@property(nonatomic,weak)id<FloatKeyBoardViewDelegate>delegate;
@end
