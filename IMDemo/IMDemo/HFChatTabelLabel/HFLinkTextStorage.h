//
//  HFLinkTextStorage.h
//  IMDemo
//
//  Created by 潇潇 on 16/9/29.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "HFTextStorge.h"

@interface HFLinkTextStorage : HFTextStorge
// textColor        链接颜色 如未设置就是TYAttributedLabel的linkColor
// TYAttributedLabel的 highlightedLinkBackgroundColor  高亮背景颜色
// underLineStyle   下划线样式（无，单 双） 默认单
// modifier         下划线样式 （点 线）默认线

@property (nonatomic, strong) id        linkData;    // 链接携带的数据

@end
