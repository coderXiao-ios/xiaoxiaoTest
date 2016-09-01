//
//  ViewController.m
//  IMDemo
//
//  Created by 潇潇 on 16/8/16.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "ViewController.h"
#import <NIMSDK.h>
#import "NIMKit.h"
#import "TYAttributedLabel.h"
//#import "SessionViewController.h"
#import "XXChatRoomVC.h"
#import "HFMessageModel.h"
#import <M80AttributedLabel.h>
#import "RegexKitLite.h"
#import "HFChatRoomMannager.h"
#import "GGKeychain.h"
#define APPID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define RGB(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ViewController ()<UITextFieldDelegate,NIMChatroomManagerDelegate,TYAttributedLabelDelegate>
@property (nonatomic, weak) TYAttributedLabel *label1;

@end

@implementation ViewController
#define NIMMyAccount   @"hefan1"
#define NIMMyToken     @"123456"
#define NIMChatTarget  @"hefan2"

#define NIMMyAccount1   @"test3"
#define NIMMyToken1     @"45968a828dd50a533bd3d306c5906dd9"
#define NIMMyAccount2   @"test5"
#define NIMMyToken2     @"10f98f1598b0d3e445919d718f41bfd9"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*{"chatroom":{"roomid":3870254,"valid":true,"announcement":null,"name":"hefanchatroom","broadcasturl":null,"ext":"","creator":"xujie"},"code":200}*/
    UIButton *buton = [UIButton buttonWithType:UIButtonTypeSystem];
    buton.frame = CGRectMake(100, 100, 100, 50);
    buton.backgroundColor = [UIColor brownColor];
    [buton setTitle:@"demo" forState:UIControlStateNormal];
//    [buton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton];
    UIButton *buton2 = [UIButton buttonWithType:UIButtonTypeSystem];
    buton2.frame = CGRectMake(100, 200,100, 50);
    buton2.backgroundColor = [UIColor purpleColor];
    [buton2 setTitle:@"custom" forState:UIControlStateNormal];
    [buton2 addTarget:self action:@selector(entyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton2];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self addTextAttributedLabel1];
    [self addTextAttributedLabel2];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"HFUUID"] == nil) {
        [self keep_UUID];
    }
    NSLog(@"_____***HFUUID:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"HFUUID"]);
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"HFUUID"] ;
    NSLog(@"uuid:%@ 长度：%ld",uuid,(unsigned long)uuid.length);
}
- (void) entyAction{
    [[NIMSDK sharedSDK].loginManager login:NIMMyAccount2 token:NIMMyToken2 completion:^(NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"登录成功！") ;
            NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
            request.roomId = @"3953686" ;
//            request.roomId = @"3870254" ;
//            request.roomNickname = @"hefanchatroom" ;
            request.roomAvatar = @"" ;
            request.roomExt = @"10" ;
            request.roomNotifyExt = [NSString stringWithFormat:@"%@来了~",NIMMyAccount2] ;
            [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
                if (error == nil) {
                    [[HFChatRoomMannager sharedInstance] cacheMyInfo:me roomId:chatroom.roomId];
                    NSLog(@"ext:%@\nannouncement:%@",chatroom.ext,chatroom.announcement);
                    XXChatRoomVC *vc = [[XXChatRoomVC alloc] initWithChatroom:chatroom];
                    [self presentViewController:vc animated:YES completion:^{
                        
                    }];
//                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    NSLog(@"进入聊天室失败！");
                }
              
            }];
        }else{
            NSLog(@"%@",error);
            NSLog(@"登录失败！") ;
        }
    }];
}
#pragma mark 生成UUID
- (void)keep_UUID
{
    NSString *uuid = [GGKeychain loadKeychain:APPID];
    if (uuid == nil || uuid.length == 0) {
        NSLog(@"GEN  %@", [self gen_uuid]);
        [GGKeychain saveKeychain:APPID data:[self gen_uuid]];
    }
    uuid = [GGKeychain loadKeychain:APPID];
    NSLog(@"______HFUUID:%@", uuid);
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"HFUUID"];
}
- (NSString *) gen_uuid
{
    CFUUIDRef uuid_ref=CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref=CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid=[NSString stringWithString:CFBridgingRelease(uuid_string_ref)];
    //    CFRelease(uuid_string_ref);
    return uuid;
}

- (void)addTextAttributedLabel1
{
    TYAttributedLabel *label1 = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(0, 300, CGRectGetWidth(self.view.frame), 0)];
    label1.delegate = self;
    label1.highlightedLinkColor = [UIColor orangeColor];
    [self.view addSubview:label1];
    NSString *text = @"\t总有一天你将破蛹而出，成长得比人们期待的还要美丽。\n\t但这个过程会很痛，会很辛苦，有时候还会觉得灰心。\n\t面对着汹涌而来的现实，觉得自己渺小无力。\n\t但这，也是生命的一部分，做好现在你能做的，然后，一切都会好的。\n\t我们都将孤独地长大，不要害怕。";
    
    NSArray *textArray = [text componentsSeparatedByString:@"\n\t"];
    NSArray *colorArray = @[RGB(213, 0, 0, 1),RGB(0, 155, 0, 1),RGB(103, 0, 207, 1),RGB(209, 162, 74, 1),RGB(206, 39, 206, 1)];
    NSInteger index = 0;
    
    for (NSString *text in textArray) {
        
        if (index == 2) {
            // 追加链接信息
            [label1 appendLinkWithText:text linkFont:[UIFont systemFontOfSize:15+arc4random()%4] linkData:@"http://www.baidu.com"];
        }else {
            // 追加文本属性
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
            [attributedString addAttributeTextColor:colorArray[index%5]];
            [attributedString addAttributeFont:[UIFont systemFontOfSize:15+arc4random()%4]];
            [label1 appendTextAttributedString:attributedString];
        }
        [label1 appendText:@"\n\t"];
        index++;
    }
    
    [label1 appendLinkWithText:@"百度一下" linkFont:[UIFont systemFontOfSize:15+arc4random()%4] linkData:@"http://www.baidu.com"];
    
    [label1 sizeToFit];
}
- (void)addTextAttributedLabel2
{
    NSString *name = @"破蛹而出";
    NSString *titleimg = @"user_rank_100" ;
 
    NSString *textStr = [NSString stringWithFormat:@"[%@,20,20]总有一天你将%@，[ico_aini,25,25]成长得比人们期待的还要美丽。",titleimg,name];
    
    TYAttributedLabel *label1 = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(0, 300, CGRectGetWidth(self.view.frame), 0)];
    label1.delegate = self;
    label1.highlightedLinkColor = [UIColor redColor];
    [self.view addSubview:label1];
    label1.highlightedLinkBackgroundColor = [UIColor clearColor];
    
    // 属性文本生成器
    TYTextContainer *attStringCreater = [[TYTextContainer alloc]init];
    attStringCreater.text = textStr;
    NSMutableArray *tmpArray = [NSMutableArray array];
    [textStr enumerateStringsMatchedByRegex:@"\\[(\\w+?),(\\d+?),(\\d+?)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        NSLog(@"____%@ _____%@", *capturedStrings, NSStringFromRange(*capturedRanges));
        TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
        imageStorage.imageName = capturedStrings[1];
        imageStorage.range = capturedRanges[0];
        imageStorage.size = CGSizeMake([capturedStrings[2]intValue], [capturedStrings[3]intValue]);
        
        [tmpArray addObject:imageStorage];
    }];
    // 添加图片信息数组到label
    [attStringCreater addTextStorageArray:tmpArray];
    [attStringCreater addLinkWithLinkData:name linkColor:nil underLineStyle:kCTUnderlineStyleNone range:[textStr rangeOfString:name]];
    TYTextStorage *textStorage = [[TYTextStorage alloc]init];
    textStorage.range = [textStr rangeOfString:@"[ico_aini,25,25]成长得比人们期待的还要美丽。"];
    textStorage.textColor = RGB(213, 100, 0, 1);
    textStorage.font = [UIFont systemFontOfSize:16];
    [attStringCreater addTextStorage:textStorage];
    attStringCreater.textColor = [UIColor yellowColor];
    label1.textContainer = attStringCreater;
    [label1 sizeToFit];

}
#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    NSLog(@"textStorageClickedAtPoint");
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSRange rene = [attributedLabel.text rangeOfString:@"破蛹而出"] ;
        if (rene.location != NSNotFound) {
            NSLog(@"用户名片");
        }    }
}
@end
