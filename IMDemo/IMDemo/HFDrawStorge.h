//
//  HFDrawStorge.h
//  IMDemo
//
//  Created by 潇潇 on 16/9/29.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTextStorageProtocol.h"

@interface HFDrawStorge : NSObject<TYDrawStorageProtocol>
@property (nonatomic, assign)   NSInteger       tag;            // 标识
@property (nonatomic, assign)   NSRange         range;          // 文本范围
@property (nonatomic, assign)   NSRange         realRange;
@property (nonatomic, assign)   UIEdgeInsets    margin;         // 图片四周间距
@property (nonatomic, assign)   CGSize          size;           // 绘画物大小
@property (nonatomic, assign)   TYDrawAlignment drawAlignment;  // 对齐方式

/**
 *  获取绘画区域上行高度(默认实现)
 */
- (CGFloat)getDrawRunAscentHeight;

/**
 *  获取绘画区域下行高度 默认实现为0（一般不需要改写）
 */
- (CGFloat)getDrawRunDescentHeight;

/**
 *  获取绘画区域宽度（默认实现）
 */
- (CGFloat)getDrawRunWidth;

/**
 *  释放内存 （一般不需要 已注释 需要在打开）
 */
//- (void)DrawRunDealloc;

@end
