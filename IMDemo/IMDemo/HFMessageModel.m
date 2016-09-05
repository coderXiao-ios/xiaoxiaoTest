//
//  XXMessageModel.m
//  IMDemo
//
//  Created by 潇潇 on 16/8/19.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "HFMessageModel.h"

@implementation HFMessageModel
//@synthesize contentSize        = _contentSize;
@synthesize message  = _message;
@synthesize attachment   = _attachment;
@synthesize messageDisplayMode = _messageDisplayMode;

- (instancetype)initWithMessage:(NIMMessage*)message
{
    if (self = [self init])
    {
        _message = message;
        _messageEtx = (NIMMessageChatroomExtension *)_message.messageExt ;
        _rankImg = @"Star";
        _rankType = @"明星";
        _rankBgColor = [UIColor greenColor];
        _rankBoraderColor = [UIColor yellowColor] ;
        if ([_message.text isEqualToString:@""]||!_message.text) {
            self.isNormal = NO;
            NSString *textStr = [NSString stringWithFormat:@"自定义消息%@",_message.from];
           _contentText = textStr;
        }else{
            self.isNormal = YES ;
            _contentText = [NSString stringWithFormat:@"[rankImg_%@]%@%@",_rankImg,self.message.from,self.message.text];
        }
    }
    return self;
}

- (NSString*)description{
    return self.message.text;
}
- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[HFMessageModel class]])
    {
        return NO;
    }else
    {
        HFMessageModel *model = object;
        return [self.message isEqual:model.message];
    }
}
- (instancetype) initWithEventType:(NIMChatroomNotificationContent *)content {
    self = [super init];
    self.isNormal = NO ;
    if (self) {
        self.member = [[NIMChatroomMember alloc] init];
        switch (content.eventType) {
            case NIMChatroomEventTypeExit:
                /*离开直播间*/
                self.messageDisplayMode = HFUserLeave ;
                self.member.userId = content.targets[0].userId ;
                self.member.roomNickname = content.targets[0].nick;
                self.contentText = [NSString stringWithFormat:@"%@离开了",self.member.userId];
                break;
            case NIMChatroomEventTypeEnter:
                /*进入直播间*/
                self.messageDisplayMode = HFUserEnter ;
                self.member.userId = content.targets[0].userId ;
                self.member.roomNickname = content.targets[0].nick;
                self.contentText = [NSString stringWithFormat:@"%@来了",self.member.userId];
                break;
            case NIMChatroomEventTypeAddMuteTemporarily:
            case NIMChatroomEventTypeAddMute:
                /*禁言*/
                self.messageDisplayMode = HFAddMute ;
                self.member.userId = content.targets[0].userId ;
                self.member.roomNickname = content.targets[0].nick;
                self.contentText = [NSString stringWithFormat:@"%@被禁言",self.member.userId];
                break;
            case NIMChatroomEventTypeKicked:
                /*踢出*/
                self.messageDisplayMode = HFAddMute ;
                self.member.userId = content.targets[0].userId ;
                self.member.roomNickname = content.targets[0].nick;
                self.contentText = [NSString stringWithFormat:@"%@被踢出",self.member.userId];
                break;
            case NIMChatroomEventTypeAddBlack:
                /*拉黑*/
                self.messageDisplayMode = HFPullBlack ;
                self.member.userId = content.targets[0].userId ;
                self.member.roomNickname = content.targets[0].nick;
                self.contentText = [NSString stringWithFormat:@"%@被拉黑",self.member.userId];
                break;
            default:
                break;
        }
    }
    return self ;
}
- (instancetype) initWithCumtomeAttachment:(NIMMessage *)message{
    if (self = [self init])
    {
        self.message = message;
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        HFAttchment *attachment  = (HFAttchment *)object.attachment;
        self.attachment = attachment ;
        self.isNormal = NO ;
        switch ([attachment.type integerValue]) {
            case 100:
                self.messageDisplayMode = HFBarrage ;
                self.contentText = [NSString stringWithFormat:@"%@发送了弹幕(弹幕内容：%@)",attachment.userInfo.name,attachment.content];
                break;
            case 101:
                self.messageDisplayMode = HFUserShare ;
                self.contentText = [NSString stringWithFormat:@"%@分享了主播，分享才够味!\t\n主播心里特别美！\t\n主播就要上热门啦！\t\n分享才是真的爱！\t\n捧红主播的节奏\t\n宝宝受宠若惊",attachment.userInfo.name];
                break;
            case 102:
                self.messageDisplayMode = HFAttentionAnchor ;
                self.contentText = [NSString stringWithFormat:@"%@关注了主播",attachment.userInfo.name];
                break;
            case 103:
                self.messageDisplayMode = HFClickScreen ;
                self.contentText = [NSString stringWithFormat:@"%@点击了泡泡",attachment.userInfo.name];
                break;
            case 104:
                self.messageDisplayMode = HFSendPresent ;
                self.contentText = [NSString stringWithFormat:@"直播消息：%@：我送了1个……礼物",attachment.userInfo.name];
                break;
            case 105:
                self.messageDisplayMode = HFSendPresent ;
                self.contentText = [NSString stringWithFormat:@"%@送超级礼物了",attachment.userInfo.name];
                break;
            case 106:
                self.messageDisplayMode = HFSendPresent ;
                self.contentText = [NSString stringWithFormat:@"直播消息：一声巨响华丽登场，%@进入直播间",attachment.userInfo.name];
                break;
            case 107:
                self.messageDisplayMode = HFSendPresent ;
                self.contentText = [NSString stringWithFormat:@"%@已升级至%@级，送礼物升级更快喲",attachment.userInfo.name,attachment.userInfo.level];
                break;
            default:
                break;
        }
    }
    return self;

}
@end
