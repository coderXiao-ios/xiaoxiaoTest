//
//  HFMessageConfig.m
//  IMDemo
//
//  Created by 潇潇 on 16/8/30.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "HFMessageConfig.h"
#import <CommonCrypto/CommonDigest.h>
static NSString *encryptionKey = @"hfMD5…";

@implementation HFMessageConfig
- (NSMutableDictionary *) creatCustomeExpressions {
    NSMutableDictionary *expressionsDic = [NSMutableDictionary dictionary];
//    NSArray *expressionArry = @[];
    for (int i = 0 ; i<23; i++) {
        NSString *expressionStr ;
        if (i < 10) {
            expressionStr = [NSString stringWithFormat:@"keyboard_a_0%d",i];
        }else{
            expressionStr = [NSString stringWithFormat:@"keyboard_a_%d",i];
        }
        NSString *md5Str = [self md5EncryptWithString:expressionStr];
        
        [expressionsDic setObject:expressionStr forKey:md5Str ];
    }
    return expressionsDic ;
}
- (NSString *)md5EncryptWithString:(NSString *)string{
    return [self md5:[NSString stringWithFormat:@"%@%@", encryptionKey, string]];
}
- (NSString *)md5:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return result;
}

@end
