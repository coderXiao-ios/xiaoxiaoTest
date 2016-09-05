//
//  UIButton+HFAdd.m
//  IMDemo
//
//  Created by 潇潇 on 16/9/5.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "UIButton+HFAdd.h"

@implementation UIButton (HFAdd)
- (void) customselfTitle:(NSString *)str withImg:(NSString *)imgName andMaxSize:(CGSize)maxSize{
    UIImage *img = [UIImage imageNamed:imgName];
    [self setImage:img forState:UIControlStateNormal];
    [self setTitle:str forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:13] ;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
    CGSize textSize = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    CGFloat height = textSize.height;
    if (textSize.height < img.size.height) {
        height = img.size.height;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, textSize.width + img.size.width + 10, height);
    self.backgroundColor = [UIColor lightGrayColor];
    self.alpha = 0.3 ;
    self.titleLabel.backgroundColor = self.backgroundColor;
    self.imageView.backgroundColor = self.backgroundColor;
    //在使用一次titleLabel和imageView后才能正确获取titleSize
    CGSize titleSize = self.titleLabel.bounds.size;
    CGSize imageSize = self.imageView.bounds.size;
    CGFloat interval = 1.0;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval);
}
@end
