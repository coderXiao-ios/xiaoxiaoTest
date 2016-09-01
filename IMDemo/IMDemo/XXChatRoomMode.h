//
//  XXChatRoomMode.h
//  IMDemo
//
//  Created by 潇潇 on 16/8/19.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK.h>
@interface XXChatRoomMode : NSObject
/**
 *  账号
 */
@property(nonatomic, copy)NSString *userName;

/**
 *  后台提供的令牌
 */
@property(nonatomic, copy)NSString *token;
/**
 *  进入聊天室请求参数
 */
@property(nonatomic, copy)NIMChatroomEnterRequest *chatRoomRequestModel;

/**
 *  聊天室相关数据
 */
@property(nonatomic, copy)NIMChatroom *chatRoomModel;
/**
 *  聊天室成员数据
 */
@property(nonatomic, copy)NIMChatroomMember *chatRoomMemberModel;

@end
