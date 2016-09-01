//
//  ExpressionView.h
//  ZYKeyBoardViewTest
//
//  Created by saga_ios on 16/8/20.
//  Copyright © 2016年 ZhaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressionModel.h"

@interface ExpressionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *expressionImageView;

@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@property (nonatomic, strong)ExpressionModel *model;
+ (instancetype)expressionView;

@end
