//
//  CustomExpressionView.m
//  ZYKeyBoardViewTest
//
//  Created by saga_ios on 16/8/20.
//  Copyright © 2016年 ZhaoYan. All rights reserved.
//

#import "CustomExpressionView.h"

@interface CustomExpressionView()<UIScrollViewDelegate>

@property(nonatomic,weak)UIScrollView * scrollView;
@property(nonatomic,weak)UIPageControl * pageControl;

@end

@implementation CustomExpressionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self CreateSubViews];
    }
    return self;
}
- (void)dealloc
{
    
}
#pragma mark - 创建subview
-(void)CreateSubViews
{
    UIScrollView * scroll = [[UIScrollView alloc]init];
    scroll.delegate = self;
    scroll.pagingEnabled = YES;
    scroll.bounces = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    [self addSubview:scroll];
    self.scrollView = scroll;
    
    UIPageControl * pageC = [[UIPageControl alloc]init];
    pageC.hidesForSinglePage = YES;
    pageC.userInteractionEnabled = NO;
    pageC.currentPageIndicatorTintColor = [UIColor blackColor];
    pageC.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:pageC];
    self.pageControl = pageC;
}
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    NSInteger  EmoPageSize = [HelpKeyBoard helpEmoPageSize];
    for (UIView *sub in self.scrollView.subviews) {
        [sub removeFromSuperview];
    }
    NSInteger count = (emotions.count+EmoPageSize-1) / EmoPageSize;
    self.pageControl.numberOfPages = count;
    for (int i = 0; i < count; i ++) {
        ExpressionPageView * pageview = [[ExpressionPageView  alloc]init];
        //计算这一页的表情范围
        NSRange range;
        range.location = i * EmoPageSize;
        //left: 剩余的表情个数(可以截取的)
        NSUInteger left = emotions.count - range.location;
        if (left > EmoPageSize) {
            //这一页足够了
            range.length = EmoPageSize;
        }else{
            range.length = left;
        }
        //设置这一页的表情
        pageview.ExpressionArray = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageview];
        
    }
    [self setNeedsLayout];

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 25);
    //scrollview
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.pageControl.frame.origin.y);
    //设置scrollview 内部每一页的尺寸
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i < count;  i++ ) {
        //pageview
        ExpressionPageView *pageview = self.scrollView.subviews[i];
        pageview.frame = CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        
    }
    //设置scrollview 的 contentSize
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.frame.size.width, 0);

}
#pragma mark - scrollviewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNo = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}

@end
