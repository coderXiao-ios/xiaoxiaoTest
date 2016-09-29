//
//  XXChatRoomMannager.h
//  IMDemo
//
//  Created by 潇潇 on 16/8/18.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "xx_ConfigHeader.h"
#import "XXChatRoomMode.h"
#import "HFAttchment.h"
#pragma mark 消息进度代理
@protocol HFChatRoomMannagerProgressDelegate <NSObject>
@optional
/**
 *  发送消息
 *
 *  @param message 消息
 *  @param roomId 房间号
 */
- (void) willSendMessageHF:(nullable NIMMessage *)message;
/**
 *  发送消息进度回调
 *
 *  @param message  当前发送的消息
 *  @param progress 进度
 */
- (void)sendMessageHF:(nullable NIMMessage *)message
           progress:(CGFloat)progress;
/**
 *  发送消息完成回调
 *
 *  @param message 当前发送的消息
 *  @param error   失败原因,如果发送成功则error为nil
 */
- (void)sendMessageHF:(nullable NIMMessage *)message
didCompleteWithError:(nullable NSError *)error;
/**
 *  收到消息回调
 *
 *  @param messages 消息列表,内部为NIMMessage
 */
- (void)onRecvMessagesHF:(nullable NSArray<NIMMessage *> *)messages;
/**
 *  收到消息回执
 *
 *  @param receipt 消息回执
 *  @discussion 当上层收到此消息时所有的存储和 model 层业务都已经更新，只需要更新 UI 即可。如果对端发送的已读回执时间戳比当前端存储的最后时间戳还小，这个已读回执将被忽略。
 */
- (void)onRecvMessageReceiptHF:(nullable NIMMessageReceipt *)receipt;
@end


#pragma mark 聊天室代理
@protocol HFChatRoomMannagerDelegate <NSObject>
@optional

/**
 *  查询服务器保存的聊天室消息记录
 *
 *  @param roomId  聊天室ID
 *  @param option  查询选项
 *  @param result   完成回调
 */
- (void)fetchMessageHistoryHF:(nullable NSString *)roomId
                     option:(nullable NIMHistoryMessageSearchOption *)option
                     result:(nullable NIMFetchChatroomHistoryBlock)result;

@end

#pragma mark 会话层代理
@protocol HFSessionMannagerDelgate <NSObject>

@end
#pragma mark 成员代理
@protocol HFMemberMannagerDelgate <NSObject>
@optional

@end

@interface HFChatRoomMannager : NSObject<NIMChatManagerDelegate,NIMChatroomManager,NIMChatroomManagerDelegate>
XXSingletonH
@property(nonatomic, weak,nullable)id<HFChatRoomMannagerProgressDelegate> chatProgressManngerDg;
@property(nonatomic, weak,nullable)id<HFChatRoomMannagerDelegate> chatManngerDg;
@property(nonatomic, weak,nullable)id<HFSessionMannagerDelgate> chatSessionMannagerDg;;
@property(nonatomic, weak,nullable)id<HFMemberMannagerDelgate> chatMemberManngerDg;
- (void)cacheMyInfo:(nullable NIMChatroomMember *)info roomId:(nullable NSString *)roomId;
- (nullable NIMChatroomMember *)myInfo:(nullable NSString *)roomId;

#pragma mark 聊天室操作

#pragma mark 消息发送处理
/**
 *  发送消息
 *
 *  @param message 消息
 *  @param roomId 房间号
 */
- (void)sendMessage:(nullable NIMMessage *)message withRoomId:(nullable NSString *)roomId;
/**
 *  发送自定义消息
 *
 *  @param attachment 自定义消息
 *  @param roomId 房间号
 */
- (void)sendCustomMessage:(nullable NSDictionary *)attachmentDic  withRoomId:(nullable NSString *)roomId;
#pragma mark 聊天室操作
/**
 *  调用这个方法进入聊天室
 *  @param request  聊天室参数
 *  @param message 消息
 */
- (void)enterChatroomHF:(nullable NIMChatroomEnterRequest *)request completion:(nullable NIMChatroomEnterHandler)completion;
/**
 *  离开聊天室
 *
 *  @param roomId     聊天室ID
 *  @param completion 离开聊天室的回调
 */
- (void)exitChatroomHF:(nullable NSString *)roomId
            completion:(nullable NIMChatroomHandler)completion;

/**
 *  获取聊天室信息
 *
 *  @param roomId     聊天室ID
 *  @param completion 获取聊天室信息的回调
 *  @discussion 只有已进入聊天室才能够获取对应的聊天室信息
 */
- (void)fetchChatroomInfoHF:(nullable NSString *)roomId
                 completion:(nullable NIMChatroomInfoHandler)completion;
/**
 *  获取聊天室成员
 *
 *  @param request    获取成员请求
 *  @param completion 请求完成回调
 */
- (void)fetchChatroomMembersHF:(nullable NIMChatroomMemberRequest  *)request
                    completion:(nullable NIMChatroomMembersHandler)completion;

/**
 *  根据用户ID获取聊天室成员信息
 *
 *  @param request    获取成员请求
 *  @param completion 请求完成回调
 */
- (void)fetchChatroomMembersByIdsHF:(nullable NIMChatroomMembersByIdsRequest *)request
                         completion:(nullable NIMChatroomMembersHandler)completion;

/**
 *  标记为聊天室管理员
 *
 *  @param request    更新请求
 *  @param completion 请求回调
 */
- (void)markMemberManagerHF:(nullable NIMChatroomMemberUpdateRequest *)request
                 completion:(nullable NIMChatroomHandler)completion;
/**
 *  标记为聊天室普通成员
 *
 *  @param request    更新请求
 *  @param completion 请求回调
 */
- (void)markNormalMemberHF:(nullable NIMChatroomMemberUpdateRequest *)request
                completion:(nullable NIMChatroomHandler)completion;
/**
 *  更新用户聊天室黑名单状态
 *
 *  @param request    更新请求
 *  @param completion 请求回调
 */
- (void)updateMemberBlackHF:(nullable NIMChatroomMemberUpdateRequest *)request
                 completion:(nullable NIMChatroomHandler)completion;
/**
 *  更新用户聊天室静言状态
 *
 *  @param request    更新请求
 *  @param completion 请求回调
 */
- (void)updateMemberMuteHF:(nullable NIMChatroomMemberUpdateRequest *)request
                completion:(nullable NIMChatroomHandler)completion;
/**
 *  更新用户聊天室临时禁言状态
 *
 *  @param request    更新请求
 *  @param duration   临时禁言时长，单位为妙
 *  @param completion 请求回调
 */
- (void)updateMemberTempMuteHF:(nullable NIMChatroomMemberUpdateRequest *)request
                      duration:(unsigned long long)duration
                    completion:(nullable NIMChatroomHandler)completion;
/**
 *  将特定成员踢出聊天室
 *
 *  @param request    踢出请求
 *  @param completion 请求回调
 */
- (void)kickMemberHF:(nullable NIMChatroomMemberKickRequest *)request
          completion:(nullable NIMChatroomHandler)completion;
/**
 *  添加通知对象
 *
 *  @param delegate 通知对象
 */
- (void)addDelegateHF:(nullable id<NIMChatroomManagerDelegate>)delegate;
/**
 *  移除通知对象
 *
 *  @param delegate 通知对象
 */
- (void)removeDelegateHF:(nullable id<NIMChatroomManagerDelegate>)delegate;
@end
