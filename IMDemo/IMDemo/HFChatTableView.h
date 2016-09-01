//
//  HFChatTableView.h
//  IMDemo
//
//  Created by 肖萧 on 16/8/23.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXChatRoomListCell.h"
@protocol HFChatTableViewDelegate <NSObject>
- (void) showTipNewMessage:(NSInteger) lastCountMsg;
- (void) hiddenTipNewMessage;
@end

@interface HFChatTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, retain)NSMutableArray *contentDataArry;
@property(nonatomic, assign)CGFloat cellsHeigth;
@property(nonatomic, assign)BOOL isAuto;
@property(nonatomic, assign)NSInteger lastMsgCount;
@property(nonatomic, weak)id<HFChatTableViewDelegate> hfDelegate ;

@end
