//
//  HelpKeyBoard.m
//  ZYKeyBoardViewTest
//
//  Created by ZhaoYAN on 16/8/21.
//  Copyright © 2016年 ZhaoYan. All rights reserved.
//

#import "HelpKeyBoard.h"

@implementation HelpKeyBoard

//根据横竖屏判断每页最多的表情数目
+ (NSInteger)helpEmoPageSize
{
    NSInteger  EmoPageSize = 9;
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown || [UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait) {
        EmoPageSize = 9;
    }else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight) {
        EmoPageSize = 17;
    }
    return EmoPageSize;
}

//返回每行多少个
+ (NSInteger)helpEmoMaxCols
{
    NSInteger  EmoMaxCols  = 5;
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown || [UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait) {
        EmoMaxCols = 5;
    }else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight) {
        EmoMaxCols = 9;
    }
    return EmoMaxCols;
}
//横竖屏计算比例高
+ (CGFloat)helpWithHeight:(CGFloat)height
{
    CGSize  scrren = [UIScreen mainScreen].bounds.size;
    //默认高
    CGFloat proportionHeight = height * scrren.width/375;
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown || [UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait) {
        proportionHeight =  height * scrren.width/375;
    }else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight) {
        proportionHeight =  (height) * scrren.width/667;
    }
    return proportionHeight;
}


@end
