//
//  XXChatRoomVC.m
//  IMDemo
//
//  Created by 潇潇 on 16/8/18.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "XXChatRoomVC.h"
#import "HFChatRoomMannager.h"
#import "FloatKeyBoardView.h"
#import "HFChatTableView.h"
#import "HFMessageModel.h"
#import <NIMSDK.h>
#import "CustomMessageView.h"
#import "HFAttchment.h"
#import "HFMessageConfig.h"
#import "UIButton+HFAdd.h"
#define NIMMyAccount1   @"test3"
#define BaseURL @"http://192.168.1.11:8080/web/chat/setMemberRole"
#define HFAttachmentLevel @"level"
#define HFAttachmentName @"name"
#define HFAttachmentType @"Type"
#define HFAttachmentConetent @"content"
#define HFAttachmentAvator @"avator"
#define HFAttachmentGiftInfo @"giftInfo"
#define HFAttachmentGcount @"gcount"
@interface XXChatRoomVC ()<FloatKeyBoardViewDelegate,HFChatRoomMannagerProgressDelegate,HFChatRoomMannagerDelegate,HFMemberMannagerDelgate,HFChatTableViewDelegate,CustomeMessageViewDeleagte,NIMSystemNotificationManagerDelegate,NIMSystemNotificationManager>
{
    BOOL _isRefreshing;
}
@property (nonatomic,strong)    NSMutableArray  *notifications;
@property (nonatomic,strong) NIMChatroom *chatroom;
@property (nonatomic, strong)FloatKeyBoardView *keyView;
@property (nonatomic, strong)HFChatTableView *chatTableView;
@property (nonatomic, strong)NSMutableArray *modelsArry ;
@property (nonatomic, strong)UILabel *m_newMsgTipLbs;
@property (nonatomic, strong)UIButton *m_newMsgTipBtn;
@property (nonatomic, assign)BOOL hiddenTipLb;
@property (nonatomic, assign)NSInteger lastMsgCount;
@property (nonatomic, strong)CustomMessageView *customeView ;
@property (nonatomic,strong) NSMutableDictionary *myInfo;
@property (nonatomic,strong) UIView *bgView;
@end

@implementation XXChatRoomVC
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"走了dealloc");
}
- (instancetype)initWithChatroom:(NIMChatroom *)chatroom
{
    self = [super init];
    if (self) {
        _chatroom = chatroom;
        
    }
    return self;
}
- (NSMutableArray *) textsArry{
    if (_modelsArry == nil) {
        _modelsArry = [NSMutableArray array];
    }
    return _modelsArry;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
       _hiddenTipLb = YES ;

    [HFChatRoomMannager sharedInstance].chatManngerDg = self;
    [HFChatRoomMannager sharedInstance].chatMemberManngerDg = self;
    [HFChatRoomMannager sharedInstance].chatProgressManngerDg = self;

    if (_modelsArry == nil) {
        _modelsArry = [NSMutableArray array];
    }
    
    _customeView = [[CustomMessageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    [self.view addSubview:_customeView];
    _customeView.delegate = self ;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"HFExpressionDic"]) {
        HFMessageConfig *config = [[HFMessageConfig alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:[config creatCustomeExpressions] forKey:@"HFExpressionDic"];
    }
    [self configView];
}
- (void) configView{
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor grayColor];
    FloatKeyBoardView *keyView = [[FloatKeyBoardView alloc] initWithFrame:CGRectMake(0, kWinSize.height, kWinSize.width, 40)];
    keyView.delegate = self;
    [self.view addSubview:keyView];
    self.keyView = keyView;
    
    _chatTableView = [[HFChatTableView alloc] initWithFrame:CGRectMake(10, 100, 200, 200) style:UITableViewStylePlain];
    [self.view addSubview:_chatTableView];
    _chatTableView.hfDelegate = self ;
    
    UIButton *inputBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    inputBtn.frame = CGRectMake(200, 100, 50, 30);
    [inputBtn setTitle:@"输入" forState:UIControlStateNormal];
    [inputBtn addTarget:self action:@selector(intputAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputBtn];
    
    UIButton *textBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    textBtn.frame = CGRectMake(250, 150, 120, 30);
    [textBtn setTitle:@"自定义消息" forState:UIControlStateNormal];
    [textBtn addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textBtn];
    
    _m_newMsgTipBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    _m_newMsgTipBtn.frame =  CGRectMake(10, 300, 200, 30);
    _m_newMsgTipBtn.backgroundColor = [UIColor yellowColor];
    _m_newMsgTipBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [_m_newMsgTipBtn setTitle:@"" forState:UIControlStateNormal];
    [_m_newMsgTipBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_m_newMsgTipBtn addTarget:self action:@selector(tapTipAction) forControlEvents:UIControlEventTouchUpInside];
    [_m_newMsgTipBtn setHidden:YES];
    [self.view addSubview:_m_newMsgTipBtn];
    
}
#pragma mark FloatKeyBoardViewDelegate
- (void)FloatKeyBoardViewTextView:(UITextView *)textView InputSting:(NSString *)inputSting didIsBarrage:(BOOL)isBarrage{
    NSLog(@"是否开启了弹幕 ： %@",isBarrage?@"是":@"不是");
    if (isBarrage) {
        NIMChatroomMember *me = [[HFChatRoomMannager sharedInstance] myInfo:_chatroom.roomId];
        NSMutableDictionary *attachmentDic = [NSMutableDictionary dictionary];
        [attachmentDic setObject:me.userId forKey:HFAttachmentName];
        [attachmentDic setObject:@"10" forKey:HFAttachmentLevel];
        [attachmentDic setObject:@"100" forKey:HFAttachmentType];
        [attachmentDic setObject:@"" forKey:HFAttachmentGiftInfo];
        [attachmentDic setObject:[NSString stringWithFormat:@"%@",inputSting] forKey:HFAttachmentConetent];
        [attachmentDic setObject:@"" forKey:HFAttachmentGcount];
        [attachmentDic setObject:@"" forKey:HFAttachmentAvator];
        [[HFChatRoomMannager sharedInstance] sendCustomMessage:attachmentDic withRoomId:_chatroom.roomId];
        return ;
    }
    if (inputSting != nil) {
        NIMMessage *message = [[NIMMessage alloc] init];
        message.text = inputSting ;
        NIMChatroomMember *member = [[HFChatRoomMannager sharedInstance] myInfo:self.chatroom.roomId];
        message.remoteExt = @{@"type":@(member.type)};
        [[HFChatRoomMannager sharedInstance] sendMessage:message withRoomId:_chatroom.roomId];
    }

}

- (void) testAction{
_customeView.transform = CGAffineTransformMakeTranslation( 0, -200);
}

- (void) intputAction{
    [self.keyView.textView becomeFirstResponder];
}
- (void)willSendMessageHF:(NIMMessage *)message{
    NSLog(@"发送消息：%@！",message.text);

}
- (void)sendMessageHF:(NIMMessage *)message didCompleteWithError:(NSError *)error{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@/%@",path,[[NIMSDK sharedSDK] currentLogFilepath]];
    NSLog(@"%@",str);
    if (error == nil) {
        NSLog(@"发送成功！");
        self.keyView.textView.text = nil;
        if (message.session.sessionType == NIMSessionTypeChatroom
            && message.messageType == NIMMessageTypeNotification)
        {
            NIMNotificationObject *object = message.messageObject;
            if (![object.content isKindOfClass:[NIMUnsupportedNotificationContent class]]) {
                [self dealMessage:message];
            }
        }else if (message.session.sessionType == NIMSessionTypeChatroom
                  && message.messageType == NIMMessageTypeCustom){
            
            HFMessageModel *model = [[HFMessageModel alloc] initWithCumtomeAttachment:message];
            [_modelsArry addObject:model];
        }else{
            HFMessageModel *model = [[HFMessageModel alloc] initWithMessage:message];
            [_modelsArry addObject:model];
        }

        [self refreshTableView:_modelsArry];
    }
    
}
- (void)dealMessage:(NIMMessage *)message
{
    NIMNotificationObject *object = message.messageObject;
    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
    HFMessageModel *model = [[HFMessageModel alloc] initWithEventType:content];
    model.message = message;
    
    [_modelsArry addObject:model];
    BOOL containsMe = NO;
    for (NIMChatroomNotificationMember *member in content.targets) {
        if ([member.userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            containsMe = YES;
            break;
        }
    }
    if (containsMe) {
        NIMChatroomMember *member = self.myInfo[message.session.sessionId];
        switch (content.eventType) {
            case NIMChatroomEventTypeAddManager:
                member.type = NIMChatroomMemberTypeManager;
                break;
            case NIMChatroomEventTypeRemoveManager:
            case NIMChatroomEventTypeAddCommon:
                member.type = NIMChatroomMemberTypeNormal;
                break;
            case NIMChatroomEventTypeAddMute:
                member.type = NIMChatroomMemberTypeLimit;
                member.isMuted = YES;
                break;
            case NIMChatroomEventTypeRemoveMute:
                member.type = NIMChatroomMemberTypeGuest;
                member.isMuted = NO;
                break;
            case NIMChatroomEventTypeRemoveCommon:
                member.type = NIMChatroomMemberTypeGuest;
                break;
           
            case NIMChatroomEventTypeAddBlack:
                member.type = NIMChatroomMemberTypeLimit;
                break;
            case NIMChatroomEventTypeAddMuteTemporarily:
                member.type = NIMChatroomMemberTypeLimit;
                member.isTempMuted = YES ;
                break;
            case NIMChatroomEventTypeRemoveBlack:
                member.type = NIMChatroomMemberTypeGuest;
                member.isInBlackList = YES ;
                break;
            case NIMChatroomEventTypeRemoveMuteTemporarily:
                member.type = NIMChatroomMemberTypeGuest;
                member.isTempMuted = NO ;
                break;
            default:
                break;
        }
    }
}

- (void)onRecvMessagesHF:(NSArray<NIMMessage *> *)messages{
    for (NIMMessage *msg in messages) {
        if (msg.session.sessionType == NIMSessionTypeChatroom
            && msg.messageType == NIMMessageTypeNotification)
        {
            NIMNotificationObject *object = msg.messageObject;
            if (![object.content isKindOfClass:[NIMUnsupportedNotificationContent class]]) {
                [self dealMessage:msg];
            }
        }else if (msg.session.sessionType == NIMSessionTypeChatroom
                  && msg.messageType == NIMMessageTypeCustom){

            HFMessageModel *model = [[HFMessageModel alloc] initWithCumtomeAttachment:msg];
            [_modelsArry addObject:model];
        }else{
            HFMessageModel *model = [[HFMessageModel alloc] initWithMessage:msg];
            [_modelsArry addObject:model];
        }
    }
   
    [self refreshTableView:_modelsArry];
    NSLog(@"接收消息：%ld,%@,%@",messages.count,messages[0].from,messages[0].text);

}
- (void) refreshTableView:(NSMutableArray *) dataArry{
    NSString *tipStr;
    if (_hiddenTipLb) {
        tipStr = @"";
    }else{
        tipStr = [NSString stringWithFormat:@"%ld条新弹幕",_modelsArry.count - _lastMsgCount];
    }
    [self setUpTipMessageShowOrHidden:_hiddenTipLb withText:tipStr];

    if (_chatTableView.contentDataArry != nil) {
        _chatTableView.contentDataArry = nil;
    }
    _chatTableView.contentDataArry = [NSMutableArray arrayWithArray:dataArry];
    _chatTableView.cellsHeigth = 0 ;
    _chatTableView.scrollEnabled = YES ;
    [_chatTableView reloadData];
}
- (void)hiddenTipNewMessage{
    _hiddenTipLb = YES ;
    _lastMsgCount = 0 ;
    _chatTableView.isAuto = YES ;
}
- (void)showTipNewMessage:(NSInteger)lastCountMsg{
    _lastMsgCount = lastCountMsg ;
    _hiddenTipLb = NO ;
    _chatTableView.isAuto = NO ;
}
- (void) setUpTipMessageShowOrHidden:(BOOL)isShown withText:(NSString *)text{
    [_m_newMsgTipBtn setHidden:isShown];
//    [_m_newMsgTipBtn setTitle:text forState:UIControlStateNormal];
    [_m_newMsgTipBtn customselfTitle:text withImg:@"icon_genduoliuyan_normal" andMaxSize:CGSizeMake(self.view.frame.size.width, 100)];

}
- (void)tapTipAction{
    NSLog(@"点击消息提示label");
    _hiddenTipLb = YES ;
    _chatTableView.isAuto = YES ;
    [self refreshTableView:_modelsArry];
}
- (void)customeMessageAction:(NSInteger)type{
    _customeView.transform = CGAffineTransformIdentity;
    NIMChatroomMember *me = [[HFChatRoomMannager sharedInstance] myInfo:_chatroom.roomId];
    switch (type) {
        case 100:
            [[HFChatRoomMannager sharedInstance] exitChatroomHF:_chatroom.roomId completion:^(NSError * _Nullable error) {
                
            }];
            break;
        case 101:{
            NIMChatroomMemberUpdateRequest *request = [[NIMChatroomMemberUpdateRequest alloc] init];
            request.roomId = _chatroom.roomId;
            request.userId = @"test5";
            request.enable = NO ;
            [[HFChatRoomMannager sharedInstance]  updateMemberBlackHF:request completion:^(NSError * _Nullable error) {
                
            }];
        }
          break;
        case 102:
        {
            NIMChatroomMemberUpdateRequest *request = [[NIMChatroomMemberUpdateRequest alloc] init];
            request.roomId = _chatroom.roomId;
            request.userId = @"test5";
            request.enable = NO ;
            [[HFChatRoomMannager sharedInstance] updateMemberMuteHF:request completion:^(NSError * _Nullable error) {
                
            }];
        }
            break;
        case 103:
        {
            NSMutableDictionary *attachmentDic = [NSMutableDictionary dictionary];
            [attachmentDic setObject:me.userId forKey:HFAttachmentName];
            [attachmentDic setObject:@"10" forKey:HFAttachmentLevel];
            [attachmentDic setObject:@"100" forKey:HFAttachmentType];
            [attachmentDic setObject:@"" forKey:HFAttachmentGiftInfo];
            [attachmentDic setObject:@"发送了一条弹幕" forKey:HFAttachmentConetent];
            [attachmentDic setObject:@"" forKey:HFAttachmentGcount];
            [attachmentDic setObject:@"" forKey:HFAttachmentAvator];
            [[HFChatRoomMannager sharedInstance] sendCustomMessage:attachmentDic withRoomId:_chatroom.roomId];
        }
            break;
        case 104:
        {
            NSMutableDictionary *attachmentDic = [NSMutableDictionary dictionary];
            [attachmentDic setObject:me.userId forKey:HFAttachmentName];
            [attachmentDic setObject:@"10" forKey:HFAttachmentLevel];
            [attachmentDic setObject:@"101" forKey:HFAttachmentType];
            [attachmentDic setObject:@"" forKey:HFAttachmentGiftInfo];
            [attachmentDic setObject:[NSString stringWithFormat:@"%@分享了%@主播",NIMMyAccount1,_chatroom.creator] forKey:HFAttachmentConetent];
            [attachmentDic setObject:@"" forKey:HFAttachmentGcount];
            [attachmentDic setObject:@"" forKey:HFAttachmentAvator];
            [[HFChatRoomMannager sharedInstance] sendCustomMessage:attachmentDic withRoomId:_chatroom.roomId];
        }
            break;
        case 105:
        {
            NSMutableDictionary *attachmentDic = [NSMutableDictionary dictionary];
            [attachmentDic setObject:me.userId forKey:HFAttachmentName];
            [attachmentDic setObject:@"10" forKey:HFAttachmentLevel];
            [attachmentDic setObject:@"102" forKey:HFAttachmentType];
            [attachmentDic setObject:@"" forKey:HFAttachmentGiftInfo];
            [attachmentDic setObject:[NSString stringWithFormat:@"%@关注了%@主播",NIMMyAccount1,_chatroom.creator] forKey:HFAttachmentConetent];
            [attachmentDic setObject:@"" forKey:HFAttachmentGcount];
            [attachmentDic setObject:@"" forKey:HFAttachmentAvator];
            [[HFChatRoomMannager sharedInstance] sendCustomMessage:attachmentDic withRoomId:_chatroom.roomId];
        }
            break;
        case 106:
        {
            NSMutableDictionary *attachmentDic = [NSMutableDictionary dictionary];
            [attachmentDic setObject:me.userId forKey:HFAttachmentName];
            [attachmentDic setObject:@"10" forKey:HFAttachmentLevel];
            [attachmentDic setObject:@"103" forKey:HFAttachmentType];
            [attachmentDic setObject:@"" forKey:HFAttachmentGiftInfo];
            [attachmentDic setObject:[NSString stringWithFormat:@"%@点击了泡泡",NIMMyAccount1] forKey:HFAttachmentConetent];
            [attachmentDic setObject:@"" forKey:HFAttachmentGcount];
            [attachmentDic setObject:@"" forKey:HFAttachmentAvator];
            [[HFChatRoomMannager sharedInstance] sendCustomMessage:attachmentDic withRoomId:_chatroom.roomId];
        }
            break;
        case 107:
        {
            NSMutableDictionary *attachmentDic = [NSMutableDictionary dictionary];
            [attachmentDic setObject:me.userId forKey:HFAttachmentName];
            [attachmentDic setObject:@"10" forKey:HFAttachmentLevel];
            [attachmentDic setObject:@"104" forKey:HFAttachmentType];
            [attachmentDic setObject:@"" forKey:HFAttachmentGiftInfo];
            [attachmentDic setObject:[NSString stringWithFormat:@"%@给%@主播送了礼物",NIMMyAccount1,_chatroom.creator] forKey:HFAttachmentConetent];
            [attachmentDic setObject:@"" forKey:HFAttachmentGcount];
            [attachmentDic setObject:@"" forKey:HFAttachmentAvator];
            [[HFChatRoomMannager sharedInstance] sendCustomMessage:attachmentDic withRoomId:_chatroom.roomId];
        }
            break;
 
        default:
            break;
    }
}
@end
