//
//  HFAttachmentDecoder.m
//  IMDemo
//
//  Created by 潇潇 on 16/8/25.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "HFAttachmentDecoder.h"
#import "HFAttchment.h"
@implementation HFAttachmentDecoder
- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content{
    //所有的自定义消息都会走这个解码方法，如有多种自定义消息请自行做好类型判断和版本兼容。这里仅演示最简单的情况。
    id<NIMCustomAttachment> attachment;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            HFAttchment *myAttachment = [[HFAttchment alloc] init];
            myAttachment.level = dict[@"level"];
            myAttachment.name = dict[@"name"];
            myAttachment.type = dict[@"type"];
            myAttachment.avator = dict[@"avator"];
            myAttachment.giftInfo = dict[@"giftInfo"];
            myAttachment.gcount = dict[@"gcount"];
            attachment = myAttachment ;
        }
    }
    return attachment;
}
@end
