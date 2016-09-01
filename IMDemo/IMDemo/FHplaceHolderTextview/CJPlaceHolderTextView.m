//
//  CJPlaceHolderTextView.m
//  CJCOMMON
//
//  Created by user on 15/12/3.
//
//

#import "CJPlaceHolderTextView.h"
#import "CJInputControl.h"
@interface CJPlaceHolderTextView ()

@end
@implementation CJPlaceHolderTextView
#pragma mark - 初始化方法
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // 添加占位框
    UILabel *placeL = [[UILabel alloc] init];
    // 设置默认占位文字颜色
    placeL.textColor = RGB(200, 200, 200, 1);
    // 设置多行显示
    placeL.numberOfLines = 0;
    placeL.backgroundColor = [UIColor clearColor];
    
    [self addSubview:placeL];
    self.placeHolderLabel = placeL;
    // 设置可拉伸
    self.alwaysBounceVertical = YES;
    // 设置默认字体
    self.font = [UIFont systemFontOfSize:14];
    
    // 设置监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置占位框frame
    CGFloat labelX = 5; 
    CGFloat labelY = 8;
    CGFloat labelW = self.frame.size.width;
    CGSize placeHolderSize = [self.placeHolderLabel.text boundingRectWithSize:CGSizeMake(labelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeHolderLabel.font} context:nil].size;
    // 设置占位框frame
    self.placeHolderLabel.frame = CGRectMake(labelX, labelY, labelW, placeHolderSize.height);
}

#pragma mark - 通知监听
- (void)textDidChange {
    self.placeHolderLabel.hidden = self.hasText;
    [CJInputControl textViewDidChange:self limit:self.fontcount];
}

#pragma mark - 公共方法
/**
 *  设置文字，防止代码输入监听不到
 */
- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self textDidChange];
}
/**
 *  设置textView字体
 */
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeHolderLabel.font = font;
    // 重新设定占位框frame
    [self setNeedsLayout];
}
/**
 *  设置占位文字
 *
 *  @param placeHolder 占位文字
 */
- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = [placeHolder copy];
    // 设置占位文字
    self.placeHolderLabel.text = _placeHolder;
    // 重新设定占位框frame
    [self setNeedsLayout];
}
/**
 *  设置占位文字颜色
 *
 *  @param placeHolderColor 占位文字颜色
 */
- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor = placeHolderColor;
    self.placeHolderLabel.textColor = placeHolderColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    if (cornerRadius) {
        self.layer.cornerRadius = cornerRadius;
    }
}

@end
