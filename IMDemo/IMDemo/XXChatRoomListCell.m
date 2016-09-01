//
//  XXChatRoomListCell.m
//  IMDemo
//
//  Created by 潇潇 on 16/8/18.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "XXChatRoomListCell.h"
#import "UIView+NIM.h"
#define colorParmeter(a) (a)/255.0

@implementation XXChatRoomListCell
@synthesize cellModel = _cellModel ;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat red = arc4random()%255;
        CGFloat green = arc4random()%255;
        CGFloat blun = arc4random()%255;
        self.contentView.backgroundColor = [UIColor colorWithRed:colorParmeter(red) green:colorParmeter(green) blue:colorParmeter(blun) alpha:1.0];
        self.contentLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(2, 2, 196, 0)]  ;
        [self addSubview:_contentLabel];
        self.contentLabel.highlightedLinkColor = [UIColor redColor];
        self.contentLabel.highlightedLinkBackgroundColor = [UIColor clearColor];
        self.contentLabel.delegate = self ;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setCellModel:(HFMessageModel *)cellModel{
    if (_cellModel != cellModel) {
        _cellModel = cellModel ;
    }
    [self setNeedsLayout];
}
- (HFMessageModel *)cellModel{
    if (_cellModel) {
        _cellModel = [[HFMessageModel alloc] init];
    }
    return _cellModel;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_contentLabel setFrameWithOrign:CGPointMake(2, 2) Width:196];
    
}
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    NSLog(@"点击用户名");
}
@end
