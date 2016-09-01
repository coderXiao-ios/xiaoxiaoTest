//
//  GGKeychain.h
//  UUIDDemo
//
//  Created by PC-LiuChunhui on 15/7/15.
//  Copyright (c) 2015年 PC-LiuChunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGKeychain : NSObject
+ (void)saveKeychain:(NSString *)service data:(id)data;
+ (id)loadKeychain:(NSString *)service;
+ (void)deleteKeychain:(NSString *)service;
@end