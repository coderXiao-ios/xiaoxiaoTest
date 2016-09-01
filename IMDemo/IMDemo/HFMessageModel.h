//
//  XXMessageModel.h
//  IMDemo
//
//  Created by 潇潇 on 16/8/19.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK.h>
#import "HFAttchment.h"
typedef NS_ENUM(NSInteger,HFMessageDisplayMode){
    /**
     *  直播间消息
     */
    HFBroadcastMessage,
    /**
     *  用户进直播间提醒（高等级）
     */
    HFUserIntoLivRoom,
    /**
     *  送礼物
     */
    HFSendPresent,
    /**
     *  等级提升
     */
    HfGradePromotion,
    /**
     *  关注主播
     */
    HFAttentionAnchor,
    /**
     *  分享
     */
    HFUserShare,
    /**
     *  用户离开
     */
    HFUserLeave,
    /**
     *  用户进入
     */
    HFUserEnter,
    /**
     *  拉黑
     */
    HFPullBlack,
    /**
     *  弹幕
     */
    HFBarrage,
    /**
     *  踢出
     */
    HFKickOut,
    /**
     *  禁言
     */
    HFAddMute,
    /**
     *  点击屏幕
     */
    HFClickScreen
};

@interface HFMessageModel : NSObject
/**
 *  消息数据
 */
@property (nonatomic, strong) NIMMessage *message;
@property (nonatomic, strong) NIMMessageChatroomExtension *messageEtx;
@property (nonatomic, copy) NSString *contentText;
@property (nonatomic, retain) UIColor *rankBgColor;
@property (nonatomic, retain) UIColor *rankBoraderColor;
@property (nonatomic, copy) NSString *rankImg;
@property (nonatomic, copy) NSString *rankType;
@property (nonatomic, strong)HFAttchment *attachment;
@property (nonatomic,copy) NSString *level;//等级
@property (nonatomic,copy) NSString *name;//名字
@property (nonatomic,copy) NSString *type;//消息类型
@property (nonatomic,copy) NSString *content;//消息主体
@property (nonatomic,copy) NSString *gcount;//礼物个数
@property (nonatomic,copy) NSString *giftInfo;//礼物类型
@property (nonatomic,copy) NSString *superGiftInfo;//礼物类型
@property (nonatomic,copy) NSString *avator;//用户头像
@property (nonatomic, strong) NIMChatroomMember *member;
@property(nonatomic, assign)HFMessageDisplayMode messageDisplayMode;
@property (nonatomic, assign)BOOL isNormal;//yes:普通的会话文本，no：自定义的会话和通知

/**
 *  NIMMessage封装成XXMessageModel的方法
 *
 *  @param  message 消息体
 *
 *  @return XXMessageModel实例
 */
- (instancetype)initWithMessage:(NIMMessage*)message;

- (instancetype) initWithEventType:(NIMChatroomNotificationContent *)content ;
- (instancetype) initWithCumtomeAttachment:(NIMMessage *)attachment;
@end
