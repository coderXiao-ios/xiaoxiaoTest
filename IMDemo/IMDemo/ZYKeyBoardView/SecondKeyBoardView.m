//
//  SecondKeyBoardView.m
//  ZYKeyBoardViewTest
//
//  Created by ZhaoYAN on 16/8/22.
//  Copyright © 2016年 ZhaoYan. All rights reserved.
//

#import "SecondKeyBoardView.h"
#import "CustomExpressionView.h"
#import "ExpressionModel.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"
@interface SecondKeyBoardView ()

@property (nonatomic, strong)UILabel *surplusLabel;//剩余字体
@property (nonatomic, strong) UIButton *chooseBtn;//切换键盘
@property (nonatomic, strong) CustomExpressionView *customEView;//自制表情
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSMutableArray *expressionData;
@end
@implementation SecondKeyBoardView


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
    _topView = [[UIView alloc] init];
    _bottomView = [[UIView alloc] init];
    _topView.backgroundColor = _bottomView.backgroundColor = [UIColor blackColor];
    [self addSubview:_topView];
    [self addSubview:_bottomView];
    
    _surplusLabel = [[UILabel alloc] init];
    _surplusLabel.text = @"还剩120字";
    [self addSubview:_surplusLabel];
    _surplusLabel.textColor = [UIColor blackColor];
    _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chooseBtn setImage:[UIImage imageNamed:@"ico_biaoqing40"] forState:UIControlStateNormal];
    [_chooseBtn addTarget:self action:@selector(chooseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_chooseBtn];
    
    _customEView = [[CustomExpressionView alloc] init];

    _customEView.emotions = self.expressionData;
    
}
-(NSMutableArray *)expressionData
{
    if (!_expressionData) {
        _expressionData = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"expreaaion.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dic in array) {
            ExpressionModel *model = [[ExpressionModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_expressionData addObject:model];
        }
    }
    return _expressionData;
}

//切换键盘
- (void)chooseBtnClicked:(UIButton *)button
{
    // button.selected = !button.isSelected;
    if (self.textView.inputView == nil) {
        // 切换为自定义的表情键盘
        _customEView.frame = CGRectMake(0,  0, [UIScreen mainScreen].bounds.size.width, [HelpKeyBoard helpWithHeight:160]);
        self.textView.inputView = _customEView;
    }else {
        // 切换为系统自带的键盘
        self.textView.inputView = nil;
    }
    // 退出键盘
    [self.textView endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 弹出键盘
        [self.textView becomeFirstResponder];
    });
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _topView.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    _bottomView.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    _surplusLabel.frame = CGRectMake(10, 0, self.frame.size.width/2, self.frame.size.height);
    _chooseBtn.frame = CGRectMake(self.frame.size.width - 34, 8, 24, 24);
}
@end
