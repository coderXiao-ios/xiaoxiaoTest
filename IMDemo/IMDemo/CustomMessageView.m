//
//  CustomMessageView.m
//  IMDemo
//
//  Created by 潇潇 on 16/8/25.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "CustomMessageView.h"
#define btnWidth 80
#define btnHeight 30

@implementation CustomMessageView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}
- (void) setUpView{
     NSArray *arry = @[@"离开",@"拉黑",@"禁言",@"弹幕",@"分享",@"关注",@"泡泡",@"送礼物",@"直播间消息",@"等级提升",@"进入"];
    for (int i = 0; i<arry.count ; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:arry[i] forState:UIControlStateNormal];
        CGFloat x = i%3 ;
        CGFloat y = i/3 ;
        [btn setFrame:CGRectMake(20 + x*(btnWidth +10) , 5 + y*(btnHeight + 5), btnWidth, btnHeight)];
        [self addSubview:btn];
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
}
- (void) btnAction:(UIButton *)btn{
    [self.delegate customeMessageAction:btn.tag];
}
@end
