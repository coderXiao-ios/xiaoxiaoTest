//
//  HFTextStorge.h
//  IMDemo
//
//  Created by 潇潇 on 16/9/29.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "TYTextStorageProtocol.h"
#import <Foundation/Foundation.h>

@interface HFTextStorge : NSObject<TYAppendTextStorageProtocol>
@property (nonatomic, assign)   NSInteger   tag;            // 标识
@property (nonatomic, assign)   NSRange     range;          //如果appendStorage, range只针对追加的文本
@property (nonatomic, assign)   NSRange     realRange;      // label文本中实际位置,因为某些文本被替换，会导致位置偏移
@property (nonatomic, strong)   NSString    *text;          // 只针对追加text文本
@property (nonatomic, strong)   UIColor     *textColor;     // 文本颜色
@property (nonatomic, strong)   UIFont      *font;          // 字体

@property (nonatomic, assign)   CTUnderlineStyle underLineStyle;// 下划线样式（单 双）（默认没有）
@property (nonatomic, assign)   CTUnderlineStyleModifiers modifier;// 下划线样式 （点 线）（默认线）


@end
