//
//  CustomMessageView.h
//  IMDemo
//
//  Created by 潇潇 on 16/8/25.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomeMessageViewDeleagte<NSObject>
- (void) customeMessageAction:(NSInteger)type;
@end
@interface CustomMessageView : UIView
@property(nonatomic, weak)id<CustomeMessageViewDeleagte> delegate;
@end
