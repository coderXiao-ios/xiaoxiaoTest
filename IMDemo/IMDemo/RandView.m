//
//  RandView.m
//  RankView
//
//  Created by 李鹏 on 16/8/29.
//  Copyright © 2016年 DJ. All rights reserved.
//

#import "RandView.h"
#import "UIColor+Category.h"
@interface RandView ()

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, retain)NSArray *ImgArry ;

@end
@implementation RandView

- (instancetype)initWithFrame:(CGRect)frame Rand:(int )randStr
{
    if (self = [super initWithFrame: frame]) {
        CGRect rect = frame;
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, rect.size.height - 4, rect.size.height - 4)];
        [self addSubview:self.image];
        self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.height + 4, 2,rect.size.width - rect.size.height - 4 - 2 , rect.size.height - 4)];
        self.rankLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.rankLabel];
          _ImgArry = [NSArray arrayWithObjects:@"icon_xingxing",@"icon_yueliang",@"icon_taiyang",@"icon_yuanxing",@"icon_jiangzhang",@"icon_jiangpai1",@"icon_jiangpai2",@"icon_jiangbei",@"icon_wangguan1",@"icon_wangguan2",nil];
        [self.image setImage:[self image:randStr]];
        self.rankLabel.text = [self labelTest:randStr];
        self.backgroundColor = [self randBackgroundColor:randStr];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews]; // 注意，一定不要忘记调用父类的layoutSubviews方法！
    //TODO:xiaoxiao Fix
    self.layer.cornerRadius = 2 ;
    self.layer.masksToBounds = YES ;
}

- (UIImage *)image:(int)randStr
{
   
    UIImage *image = [UIImage imageNamed:_ImgArry[((randStr - 1) / 20)]];
    return image;
}
- (NSString *)labelTest:(int)randStr
{
//    return [NSString stringWithFormat:@"%d", ((randStr  - (randStr/20)*20)%5)];
    return [NSString stringWithFormat:@"%d", (randStr/5 + 1)*5 ];
}
- (UIColor *)randBackgroundColor:(int)randStr{
    NSMutableArray *colorArr = [[NSMutableArray alloc] initWithObjects:@"00AAF6",@"08C5BB",@"9F54FD",@"FF2C8A", nil];
    
    NSString *colorStr = [colorArr objectAtIndex:((randStr  - ((randStr - 1)/20)*20  - 1)/5)];
    return [UIColor colorWithHexString:colorStr];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
