//
//  SecondKeyBoardView.h
//  ZYKeyBoardViewTest
//
//  Created by ZhaoYAN on 16/8/22.
//  Copyright © 2016年 ZhaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
//二级键盘主要用于评论和写状态
@interface SecondKeyBoardView : UIView
@property (nonatomic, weak) UITextView *textView;//引用外部的textView

@end
