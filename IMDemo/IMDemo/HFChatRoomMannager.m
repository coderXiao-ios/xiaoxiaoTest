//
//  XXChatRoomMannager.m
//  IMDemo
//
//  Created by 潇潇 on 16/8/18.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "HFChatRoomMannager.h"
#define HFAttachmentLevel @"level"
#define HFAttachmentName @"name"
#define HFAttachmentType @"Type"
#define HFAttachmentConetent @"content"
#define HFAttachmentAvator @"avator"
#define HFAttachmentGiftInfo @"giftInfo"
#define HFAttachmentGcount @"gcount"

@interface HFChatRoomMannager()
@property (nonatomic,strong) NSMutableDictionary *myInfo;

@end
@implementation HFChatRoomMannager
XXSingletonM
- (instancetype)init{
    self = [super init];
    if (self) {
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        _myInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)dealloc
{
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}

#pragma mark 个人数据处理
- (void)cacheMyInfo:(NIMChatroomMember *)info roomId:(NSString *)roomId
{
    [_myInfo setObject:info forKey:roomId];
}
- (NIMChatroomMember *)myInfo:(NSString *)roomId
{
    NIMChatroomMember *member = _myInfo[roomId];
    return member;
}


#pragma mark 消息类
- (void)sendMessage:(NIMMessage *)message withRoomId:(NSString *)roomId{
    NIMSession *session = [NIMSession session:roomId type:NIMSessionTypeChatroom];
    [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:session error:nil];
}
- (void)sendCustomMessage:(NSDictionary *)attachmentDic  withRoomId:(NSString *)roomId{
//    //构造自定义内容
    HFAttchment *attachment = [[HFAttchment alloc] init];
    attachment.name = attachmentDic[HFAttachmentName];
    attachment.level = attachmentDic[HFAttachmentLevel];
    attachment.type = attachmentDic[HFAttachmentType];
    attachment.avator = attachmentDic[HFAttachmentAvator];
    attachment.content = attachmentDic[HFAttachmentConetent];
    attachment.gcount = attachmentDic[HFAttachmentGcount];
    attachment.giftInfo = attachmentDic[HFAttachmentGiftInfo];

    //构造自定义MessageObject
    NIMCustomObject *object = [[NIMCustomObject alloc] init];
    object.attachment = attachment;
    
    //构造自定义消息
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = object;
    
    NIMSession *session = [NIMSession session:roomId type:NIMSessionTypeChatroom];
    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}


#pragma mark - XXChatRoomMannagerDelegate 消息收发接口
- (void) willSendMessage:(NIMMessage *)message{
    [self.chatProgressManngerDg willSendMessageHF:(NIMMessage *)message];
}
- (void) sendMessage:(NIMMessage *)message progress:(CGFloat)progress{
    [self.chatProgressManngerDg sendMessageHF:(NIMMessage *)message progress:progress];
}
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error{
    [self.chatProgressManngerDg sendMessageHF:(NIMMessage *)message didCompleteWithError:error];
}
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    [self.chatProgressManngerDg onRecvMessagesHF:(NSArray<NIMMessage *> *)messages];
}
- (void)onRecvMessageReceipt:(NIMMessageReceipt *)receipt{
    [self.chatProgressManngerDg onRecvMessageReceiptHF:receipt];
}


#pragma mark 聊天室操作
- (void)enterChatroomHF:(NIMChatroomEnterRequest *)request completion:(NIMChatroomEnterHandler)completion{
    [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:completion];
}
//离开聊天室
- (void)exitChatroomHF:(NSString *)roomId completion:(NIMChatroomHandler)completion{
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:roomId completion:completion];
}
//获取聊天室成员
- (void)fetchChatroomMembers:(NIMChatroomMemberRequest *)request completion:(NIMChatroomMembersHandler)completion{
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembers:request completion:completion];
}
//获取聊天室信息
- (void)fetchChatroomInfoHF:(NSString *)roomId completion:(NIMChatroomInfoHandler)completion{
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomInfo:roomId completion:completion];
}
/**
 *  标记为聊天室管理员
 */
- (void)markMemberManagerHF:(NIMChatroomMemberUpdateRequest *)request
               completion:(nullable NIMChatroomHandler)completion{
    [[NIMSDK sharedSDK].chatroomManager markMemberManager:request completion:completion];
}

/**
 *  标记为聊天室普通成员
 */
- (void)markNormalMemberHF:(NIMChatroomMemberUpdateRequest *)request
              completion:(nullable NIMChatroomHandler)completion{
    [[NIMSDK sharedSDK].chatroomManager markNormalMember:request completion:completion];
}
/**
 *  更新用户聊天室黑名单状态
 */
- (void)updateMemberBlackHF:(NIMChatroomMemberUpdateRequest *)request
               completion:(nullable NIMChatroomHandler)completion{
    [[NIMSDK sharedSDK].chatroomManager updateMemberBlack:request completion:completion];
}


/**
 *  更新用户聊天室静言状态
 */

- (void)updateMemberMuteHF:(NIMChatroomMemberUpdateRequest *)request
              completion:(nullable NIMChatroomHandler)completion{
    [[NIMSDK sharedSDK].chatroomManager updateMemberMute:request completion:completion];;
}
/**
 *  更新用户聊天室临时禁言状态
 */
- (void)updateMemberTempMuteHF:(NIMChatroomMemberUpdateRequest *)request
                    duration:(unsigned long long)duration
                  completion:(nullable NIMChatroomHandler)completion{
    [[NIMSDK sharedSDK].chatroomManager updateMemberTempMute:request duration:duration completion:completion];
}
/**
 *  将特定成员踢出聊天室
 */
- (void)kickMember:(NIMChatroomMemberKickRequest *)request
        completion:(nullable NIMChatroomHandler)completion{
    [[NIMSDK sharedSDK].chatroomManager kickMember:request completion:completion];
 }
#pragma mark 代理相关设置
/**
 *  添加通知对象
 *
 *  @param delegate 通知对象
 */
- (void)addDelegateHF:(id<NIMChatroomManagerDelegate>)delegate{
    [[NIMSDK sharedSDK].chatroomManager addDelegate:delegate];
}

/**
 *  移除通知对象
 *
 *  @param delegate 通知对象
 */
- (void)removeDelegate:(id<NIMChatroomManagerDelegate>)delegate{
    
}

@end
