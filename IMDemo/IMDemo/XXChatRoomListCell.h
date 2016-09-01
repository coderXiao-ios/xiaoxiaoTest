//
//  XXChatRoomListCell.h
//  IMDemo
//
//  Created by 潇潇 on 16/8/18.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFMessageModel.h"
#import "TYAttributedLabel.h"
@interface XXChatRoomListCell :UITableViewCell<TYAttributedLabelDelegate>
@property(nonatomic, strong)TYAttributedLabel *contentLabel;
@property(nonatomic, strong)HFMessageModel *cellModel;
@end
