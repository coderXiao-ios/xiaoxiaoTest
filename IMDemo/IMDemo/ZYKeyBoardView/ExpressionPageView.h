//
//  ExpressionPageView.h
//  ZYKeyBoardViewTest
//
//  Created by ZhaoYAN on 16/8/21.
//  Copyright © 2016年 ZhaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpKeyBoard.h"

// 表情选中的通知
static NSString * const ExpressionSelectNotification = @"ExpressionDidSelectNotification";
static NSString * const ExpressionSelectKey = @"ExpressionSelectKey";
// 删除文字的通知
static NSString * const ExpressionDeleteNotification = @"ExpressionDidDeleteNotification";

@interface ExpressionPageView : UIView

@property (nonatomic, strong) NSArray *ExpressionArray;

@end
