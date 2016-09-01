//
//  ExpressionPageView.m
//  ZYKeyBoardViewTest
//
//  Created by ZhaoYAN on 16/8/21.
//  Copyright © 2016年 ZhaoYan. All rights reserved.
//

#import "ExpressionPageView.h"
#import "ExpressionView.h"
@interface ExpressionPageView ()
@property (nonatomic, weak) UIButton *delBtn;
@end
@implementation ExpressionPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    UIButton *delBtn = [[UIButton alloc] init];
    [delBtn setImage:[UIImage imageNamed:@"ico_shanchu"]
            forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delBtn];
     self.delBtn = delBtn;
}
#pragma mark - 删除表情
- (void)deleteClick:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ExpressionDeleteNotification object:nil];
}
- (void)btnClick:(UIButton *)btn
{
    ExpressionView *exp = (ExpressionView *)btn.superview;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[ExpressionSelectKey] = exp.model;
    [[NSNotificationCenter defaultCenter] postNotificationName:ExpressionSelectNotification object:nil userInfo:userInfo];
}
- (void)setExpressionArray:(NSArray *)ExpressionArray
{
    _ExpressionArray = ExpressionArray;
//    for (UIView *sub in self.subviews) {
//        if (sub == self.delBtn) {
//            continue;
//        }
//        [sub removeFromSuperview];
//    }
    NSLog(@"ciyeshumu %ld",ExpressionArray.count);
    NSUInteger count = ExpressionArray.count;
    for (int i = 0; i<count; i++) {
        ExpressionView *exp = [ExpressionView expressionView];
        exp.model = ExpressionArray[i];
        [exp.clickBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:exp];
    }
    //[self setNeedsLayout];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger  EmoMaxRows  = 2;
    NSInteger  EmoMaxCols  = [HelpKeyBoard helpEmoMaxCols];

    // 左右边距
    CGFloat inset = [HelpKeyBoard helpWithHeight:23]; //ProportionHeight(23);
    //中间间距
    CGFloat IntervalW = 32;
    //上下间距
    CGFloat IntervalH = [HelpKeyBoard helpWithHeight:10];//ProportionHeight(10);
    NSUInteger count = self.ExpressionArray.count;
    NSLog(@"%ld", count);
    CGFloat expW = (self.frame.size.width - 2 * inset - IntervalW *(EmoMaxCols - 1)) / EmoMaxCols;
    CGFloat expH = (self.frame.size.height - IntervalH * 2) / EmoMaxRows;
    for (int i = 0; i<count; i++) {
        ExpressionView *exp = self.subviews[i + 1];
        exp.frame = CGRectMake(inset +(expW + IntervalW)*(i%EmoMaxCols), IntervalH + (IntervalH + expH)*(i/EmoMaxCols), expW, expH);
    }
    
    self.delBtn.frame = CGRectMake(self.frame.size.width - inset - expW, self.frame.size.height - expH, expW, expH);
    
}

@end
