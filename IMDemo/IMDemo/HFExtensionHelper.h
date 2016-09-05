//
//  NSString+HFKitExtension.h
//  IMDemo
//
//  Created by 潇潇 on 16/9/5.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HFKitExtension)
- (NSDictionary *)IMkit_jsonDict;
@end
@interface NSDictionary (HFKitExtension)
- (NSString *)IMkit_jsonString;
@end