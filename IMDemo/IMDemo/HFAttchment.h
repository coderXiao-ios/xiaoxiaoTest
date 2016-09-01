//
//  HFAttchment.h
//  IMDemo
//
//  Created by 潇潇 on 16/8/25.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK.h>
@interface HFAttchment : NSObject<NIMCustomAttachment>
@property (nonatomic,copy) NSString *level;//等级
@property (nonatomic,copy) NSString *name;//名字
@property (nonatomic,copy) NSString *type;//消息类型100：弹幕、101：分享、102：关注、103：泡泡、104：送礼物、105：超级礼物、106：高级用户入场、107：等级提升
@property (nonatomic,copy) NSString *content;//消息主体
@property (nonatomic,copy) NSString *gcount;//礼物个数
@property (nonatomic,copy) NSString *giftInfo;//礼物类型
@property (nonatomic,copy) NSString *superGiftInfo;//礼物类型
@property (nonatomic,copy) NSString *avator;//用户头像

@end
