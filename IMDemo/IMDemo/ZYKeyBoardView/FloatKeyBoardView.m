//
//  FloatKeyBoardView.m
//  ZYKeyBoardViewTest
//
//  Created by saga_ios on 16/8/20.
//  Copyright © 2016年 ZhaoYan. All rights reserved.
//

#import "FloatKeyBoardView.h"
#import "CustomExpressionView.h"
#import "ExpressionModel.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"

#define KeyBoardInterval 5 //上下间距
#define AroundKeyBoardInterval 10 //左右间距
@interface FloatKeyBoardView()<UITextViewDelegate>

@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, strong) UIButton *sendBtn;//发送按钮
@property (nonatomic, strong) UIButton *chooseBtn;//切换键盘
@property (nonatomic, strong) UIButton *barrageBtn;//弹幕开关
@property (nonatomic, strong) UIView *inputBackgroundView;//输入框背景
@property (nonatomic, strong) CustomExpressionView *customEView;//自制表情
@property (nonatomic, assign) BOOL isChooseKeyBoard;//是否在切换键盘

@property (nonatomic, strong) NSMutableArray *expressionData;
@end
@implementation FloatKeyBoardView

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor grayColor];
        _isChooseKeyBoard = NO;
        [self initTextView:frame];
        [self registeredNotification];
    }
    return self;
}
-(void)initTextView:(CGRect)frame
{
    _barrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_barrageBtn setImage:[UIImage imageNamed:@"btn_guanbidanmu_press"] forState:UIControlStateNormal];
    [_barrageBtn setImage:[UIImage imageNamed:@"btn_kaiqdanmui_press"] forState:UIControlStateSelected];
    [_barrageBtn addTarget:self action:@selector(barrageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _inputBackgroundView = [[UIView alloc] init];
    _inputBackgroundView.backgroundColor = [UIColor whiteColor];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setImage:[UIImage imageNamed:@"btn_fasong_press"] forState:UIControlStateNormal];
    [_sendBtn setImage:[UIImage imageNamed:@"btn_fasong_unpress"] forState:UIControlStateSelected];
    [_sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _textView = [[CJPlaceHolderTextView alloc] init];
    _textView.placeHolder = @"和主播说点什么";
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    inputAccessoryView.userInteractionEnabled = NO;
    _textView.inputAccessoryView = inputAccessoryView;
    
    _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chooseBtn setImage:[UIImage imageNamed:@"ico_biaoqing40"] forState:UIControlStateNormal];
    [_chooseBtn addTarget:self action:@selector(chooseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_barrageBtn];
    [self addSubview:_sendBtn];
    [self addSubview:_inputBackgroundView];
    [_inputBackgroundView addSubview:_textView];
    [_inputBackgroundView addSubview:_chooseBtn];
    
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
//TODO:xiaoxiao Fix

- (void)getDataFromPlist{
    //沙盒获取路径
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString *filePatch = [path stringByAppendingPathComponent:@"expreaaion.plist"];//没有会自动创建
    NSLog(@"file patch%@",filePatch);
    NSMutableDictionary *sandBoxDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePatch];
    if (sandBoxDataDic==nil) {
        sandBoxDataDic = [NSMutableDictionary new];
        sandBoxDataDic[@"test"] = @"test";
        [sandBoxDataDic writeToFile:filePatch atomically:YES];
    }
    NSLog(@"sandBox %@",sandBoxDataDic);//直接打印数据
    
    
    //工程自身的plist
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"PropertyListTest" ofType:@"plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSLog(@"nsbundle %@",dataDic);//直接打印数据
    
}
- (void)writeDataToPlist{
    //这里使用位于沙盒的plist（程序会自动新建的那一个）
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString *filePatch = [path stringByAppendingPathComponent:@"expreaaion.plist"];
    NSMutableDictionary *sandBoxDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePatch];
    NSLog(@"old sandBox is %@",sandBoxDataDic);
    sandBoxDataDic = nil;
    [sandBoxDataDic writeToFile:filePatch atomically:YES];
    sandBoxDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePatch];
    NSLog(@"new sandBox is %@",sandBoxDataDic);
    
    
    //这里使用的是位于工程自身的plist（手动新建的那一个）
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"expreaaion" ofType:@"plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    
    //开始修改及写入
    NSNumber *number = @10;
    dataDic[@"1"] = number;//修改
    NSNumber *boolNumber = [NSNumber numberWithBool:YES];//bool值只能通过nsnumber修改
    dataDic[@"3"] = boolNumber;
    [dataDic writeToFile:plistPath atomically:YES];
    
    //重新获取数据 看是否有变动（虚拟机上会有变动，但是真机上不会）
    NSMutableDictionary *newDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSLog(@"new %@",newDataDic);//打印新数据
}

#pragma mark 注册通知
- (void)registeredNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expressionDidDelete) name:ExpressionDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expressionDidSelect:) name:ExpressionSelectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height ;
    NSLog(@"jianpangao %lf", deltaY);
    self.keyBoardHeight=deltaY;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        CGRect frame = self.frame;
        frame.size.width = kWinSize.width;
        frame.origin.y = kWinSize.height - deltaY - self.frame.size.height + 40;
        self.frame = frame;
        //self.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    } completion:^(BOOL finished) {
        _isChooseKeyBoard = NO;
    }];
}

-(void)keyboardHide:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    NSTimeInterval KeyboardDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSTimeInterval duration = (KeyboardDuration/self.keyBoardHeight)*40.0f + KeyboardDuration;
    NSLog(@"key%lf,dur%lf",KeyboardDuration,duration);
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.frame;
        frame.origin.y = frame.origin.y + deltaY ;
        self.frame = frame;

        //self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        if (!_isChooseKeyBoard) {
            //[self removeFromSuperview];
        }

    }];
    
}
//删除表情
- (void)expressionDidDelete
{
    [self.textView deleteBackward];
}
//选择表情
- (void)expressionDidSelect:(NSNotification *)note
{
    _textView.placeHolderLabel.hidden = YES;
    ExpressionModel *seleModel = note.userInfo[ExpressionSelectKey];
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    emojiTextAttachment.emojiTag = seleModel.image;
    emojiTextAttachment.image = [UIImage imageNamed:seleModel.image];
    emojiTextAttachment.emojiSize = CGSizeMake(20,20);
    [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                          atIndex:_textView.selectedRange.location];
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);
    
}
//横竖屏
- (void)doRotateAction:(NSNotification *)notification {
    
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown || [UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait) {
         _customEView.emotions = self.expressionData;
    }else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight) {
         _customEView.emotions = self.expressionData;
    }

    //刷新
   // _customEView.emotions = self.expressionData;
}
#pragma mark 布局 UI
- (void)layoutSubviews {
    
     [super layoutSubviews];
    
    CGFloat childHeight = self.frame.size.height - KeyBoardInterval * 2;
    _barrageBtn.frame = CGRectMake(AroundKeyBoardInterval, KeyBoardInterval, 45, childHeight);
    _sendBtn.frame = CGRectMake(self.frame.size.width - AroundKeyBoardInterval - 60, KeyBoardInterval, 60, childHeight);
    
    
    CGFloat inputBgWith = self.frame.size.width - (AroundKeyBoardInterval + _barrageBtn.frame.size.width + KeyBoardInterval) - (KeyBoardInterval + _sendBtn.frame.size.width + AroundKeyBoardInterval);
    _inputBackgroundView.frame = CGRectMake(AroundKeyBoardInterval + _barrageBtn.frame.size.width + KeyBoardInterval, KeyBoardInterval, inputBgWith, childHeight);
    
    
    _chooseBtn.frame = CGRectMake(_inputBackgroundView.frame.size.width - KeyBoardInterval - 20, KeyBoardInterval, 20, 20);
    _textView.frame = CGRectMake(0, 0, _inputBackgroundView.frame.size.width - (KeyBoardInterval + 20), childHeight);
    
    //_customEView.frame = CGRectMake(0,  0, kWinSize.width, [HelpKeyBoard helpWithHeight:160]);
}
#pragma mark 按钮响应
//弹幕
- (void)barrageBtnClicked:(UIButton *)button
{
    button.selected = !button.selected;
    _textView.placeHolder = button.selected?@"开启弹幕,1饭票/条":@"和主播说点什么";
}
//发送
- (void)sendBtnClicked:(UIButton *)button
{
    NSString *inputStr = [NSString stringWithFormat:@"%@", [_textView.textStorage getPlainStringMD5]];
    NSLog(@"wang %@",inputStr);
    if ([_delegate respondsToSelector:@selector(FloatKeyBoardViewTextView:InputSting:didIsBarrage:)]) {
        [_delegate FloatKeyBoardViewTextView:_textView InputSting:inputStr didIsBarrage:_barrageBtn.selected];
        
    }
}
//切换键盘
- (void)chooseBtnClicked:(UIButton *)button
{
   // button.selected = !button.isSelected;
    _isChooseKeyBoard = YES;
    if (self.textView.inputView == nil) {
        // 切换为自定义的表情键盘
        _customEView.frame = CGRectMake(0,  0, kWinSize.width, [HelpKeyBoard helpWithHeight:160]);
        self.textView.inputView = self.customEView;
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
@end
