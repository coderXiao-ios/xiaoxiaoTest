//
//  ExpressionView.m
//  ZYKeyBoardViewTest
//
//  Created by saga_ios on 16/8/20.
//  Copyright © 2016年 ZhaoYan. All rights reserved.
//

#import "ExpressionView.h"

@implementation ExpressionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

 + (instancetype)expressionView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ExpressionView" owner:nil options:nil] lastObject];
}
-(void)setModel:(ExpressionModel *)model
{
    _model = model;
    self.expressionImageView.image = [UIImage imageNamed:model.image];
    self.titleLabel.text = model.title;
}
@end
