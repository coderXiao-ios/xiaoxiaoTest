//
//  HFChatTableView.m
//  IMDemo
//
//  Created by 肖萧 on 16/8/23.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "HFChatTableView.h"
#import "XXChatRoomListCell.h"
#import "HFMessageModel.h"
#import "UIView+NTES.h"
#import "RegexKitLite.h"
#define RGB(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface HFChatTableView()<TYAttributedLabelDelegate>
{
    NSInteger coutIndex;
    BOOL _isEndScroll;
}
@end
@implementation HFChatTableView
@synthesize contentDataArry = _contentDataArry;
- (instancetype) initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.tableHeaderView = nil ;
        self.tableFooterView = nil ;
        self.sectionFooterHeight = 0;
        self.sectionFooterHeight = 0 ;
        self.separatorStyle = UITableViewCellSeparatorStyleNone ;
        self.showsVerticalScrollIndicator = NO ;
        self.backgroundColor = [UIColor orangeColor];
        if (_contentDataArry == nil) {
            _contentDataArry = [NSMutableArray array];
            _cellsHeigth = 0;
        }
        _isAuto = YES ;
        _isEndScroll = YES;
    }
    return self;
}
- (NSMutableArray *)contentDataArry{
    if (_contentDataArry == nil) {
        _contentDataArry = [NSMutableArray array];
    }
    return _contentDataArry;
}
- (void)setContentDataArry:(NSMutableArray *)contentDataArry{
    if (_contentDataArry != contentDataArry) {
        _contentDataArry = contentDataArry ;
        coutIndex = 0 ;
    }
}
- (TYTextContainer *) creatContainer:(HFMessageModel *)model{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = model.contentText;
    NSMutableArray *tmpArray = [NSMutableArray array];
    [model.contentText enumerateStringsMatchedByRegex:@"\\[(\\w+?),(\\d+?),(\\d+?)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        NSLog(@"____%@ _____%@", *capturedStrings, NSStringFromRange(*capturedRanges));
        if (captureCount > 3) {
            // 图片信息储存
            TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
            imageStorage.cacheImageOnMemory = YES;
            
            imageStorage.imageName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HFExpressionDic"]objectForKey:capturedStrings[1]];
            imageStorage.range = capturedRanges[0];
            imageStorage.size = CGSizeMake([capturedStrings[2]intValue], [capturedStrings[3]intValue]);
            
            [tmpArray addObject:imageStorage];
        }
    }];
    
    // 添加图片信息数组到label
    
    [textContainer addTextStorageArray:tmpArray];
    
    [textContainer addLinkWithLinkData:model.message.from linkColor:[UIColor lightGrayColor] underLineStyle:kCTUnderlineStyleNone range:[model.contentText rangeOfString:model.message.from]];
    TYTextStorage *textStorage = [[TYTextStorage alloc]init];
    
    textStorage.range = [model.contentText rangeOfString:model.message.from];
    textStorage.textColor = RGB(213, 0, 0, 1);
    textStorage.font = [UIFont systemFontOfSize:14];
    [textContainer addTextStorage:textStorage];
    textContainer.linesSpacing = 1;
    textContainer.textColor = [UIColor orangeColor];
    if (model.isNormal) {
        [textContainer addView:[self createRankView:model] range:[model.contentText rangeOfString:[NSString stringWithFormat:@"[rankImg_%@]",model.rankImg]]];
    }
    textContainer = [textContainer createTextContainerWithTextWidth:196];
    NSLog(@"textHeight:%.2f",textContainer.textHeight);
    return textContainer;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentDataArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identiy = @"chatRoomCell";
    XXChatRoomListCell *cell =(XXChatRoomListCell *) [tableView dequeueReusableCellWithIdentifier:identiy ];
    if (cell == nil) {
        cell = [[XXChatRoomListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identiy];
    }
    HFMessageModel *model = (HFMessageModel *)_contentDataArry[indexPath.row];
    cell.contentLabel.delegate = self;
    cell.contentLabel.textContainer = [self creatContainer:model];
    [self autoMoveCellToBottom:_isAuto];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    coutIndex++;
    NSLog(@"调用%ld次",coutIndex);
    HFMessageModel *model = _contentDataArry[indexPath.row];
    TYTextContainer *textContaner = [self creatContainer:model];
    return textContaner.textHeight + 4;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _isEndScroll = NO ;
    if (scrollView.contentOffset.y < 0) {
        scrollView.scrollEnabled  = NO ;
        _isAuto = NO ;
        
    }else if (scrollView.contentOffset.y > scrollView.contentSize.height- self.height){
        scrollView.scrollEnabled  = NO ;
        _isAuto = YES ;
    }else{
        _isAuto = NO ;
        scrollView.scrollEnabled  = YES ;
    }

    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isEndScroll = NO ;
    NSLog(@"BeginDragging y:%.2f\nheight:%.2f",scrollView.contentOffset.y,scrollView.contentSize.height) ;
    if (scrollView.contentOffset.y < 0) {
        scrollView.scrollEnabled  = NO ;
        _isAuto = NO ;
        
    }else if (scrollView.contentOffset.y > scrollView.contentSize.height- self.height){
        scrollView.scrollEnabled  = NO ;
        _isAuto = YES ;
    }else{
        _isAuto = NO ;
        scrollView.scrollEnabled  = YES ;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _isEndScroll = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _isEndScroll = YES ;
    [self setUpScrollView:scrollView];
}
- (void) setUpScrollView:(UIScrollView *)scrollView{
    NSLog(@"y:%.2f\nheight:%.2f",scrollView.contentOffset.y,scrollView.contentSize.height) ;
    scrollView.scrollEnabled  = YES ;
    HFMessageModel *model = (HFMessageModel *)_contentDataArry.lastObject;
    TYTextContainer *textContaner = [self creatContainer:model];
    CGFloat lastCellHeight =  textContaner.textHeight + 4 ;
    if (fabs(scrollView.contentOffset.y) < scrollView.contentSize.height- self.height -lastCellHeight) {
        _isAuto = NO ;
    }else{
        _isAuto = YES ;
    }

}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    _isEndScroll = YES ;
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _contentDataArry.count - 2) {
        _isAuto = YES ;
    }
}
- (void) autoMoveCellToBottom:(BOOL)isAuto{
    NSLog(@"BeginDragging y:%.2f\nheight:%.2f",self.contentOffset.y,self.contentSize.height) ;
    if (_isEndScroll) {
        if (isAuto) {
            _lastMsgCount = 0 ;
            [self.hfDelegate hiddenTipNewMessage];
            self.scrollEnabled = YES ;
            [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_contentDataArry.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            _isEndScroll = YES ;
        }else{
            if (_lastMsgCount == 0) {
                _lastMsgCount = _contentDataArry.count ;
            }
            [self.hfDelegate showTipNewMessage:_lastMsgCount];
            _isEndScroll = YES ;
        }

    }
}
- (TYAttributedLabel *)createRankView:(HFMessageModel *)model{
    TYAttributedLabel *label = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    label.backgroundColor = model.rankBgColor ;
    label.layer.cornerRadius = 3 ;
    label.layer.borderColor =model.rankBoraderColor.CGColor;
    label.layer.borderWidth = 1 ;
    label.layer.masksToBounds = YES ;
    NSString *textStr = [NSString stringWithFormat:@"%@%@",model.rankImg,model.rankType];
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = textStr;
    TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
    imageStorage.cacheImageOnMemory = YES;
    imageStorage.imageName = model.rankImg;
    imageStorage.range = NSMakeRange(0, model.rankImg.length);
    imageStorage.size = CGSizeMake(10, 10);
    imageStorage.imageAlignment = TYImageAlignmentLeft ;
    imageStorage.margin = UIEdgeInsetsMake(0, 2, 0, 0);
    [textContainer addTextStorage:imageStorage];
    TYTextStorage *textStorage = [[TYTextStorage alloc]init];
    textStorage.range = [textStr rangeOfString:model.rankType];
    textStorage.textColor = [UIColor whiteColor];
    textStorage.font = [UIFont systemFontOfSize:10];
    [textContainer addTextStorage:textStorage];
    label.textContainer = textContainer ;
    label.numberOfLines = 0;
    label.isWidthToFit = YES ;
    label.characterSpacing = 1 ;
    [label sizeToFit];
    
    return label;
}

@end
