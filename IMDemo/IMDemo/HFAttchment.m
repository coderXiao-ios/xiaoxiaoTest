//
//  HFAttchment.m
//  IMDemo
//
//  Created by 潇潇 on 16/8/25.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "HFAttchment.h"
@implementation HFAttchment
@synthesize giftInfo = _giftInfo;
@synthesize type = _type;
@synthesize content = _content;

@synthesize gcount = _gcount;

- (instancetype) init{
    if ([super init]) {
        
    }
    return self ;
}
- (NSString *)encodeAttachment{
    NSDictionary *dict =@{@"userInfo":self.userInfo,@"type":self.type,@"content":self.content,@"gcount":self.gcount,@"giftInfo":self.giftInfo};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *encodeString = @"";
    if (data) {
        encodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return encodeString;
}

@end
