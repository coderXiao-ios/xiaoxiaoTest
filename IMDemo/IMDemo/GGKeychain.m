//
//  GGKeychain.m
//  UUIDDemo
//
//  Created by PC-LiuChunhui on 15/7/15.
//  Copyright (c) 2015年 PC-LiuChunhui. All rights reserved.
//

#import "GGKeychain.h"

@implementation GGKeychain
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)CFBridgingRelease(kSecClassGenericPassword),(id)CFBridgingRelease(kSecClass),
            service, (id)CFBridgingRelease(kSecAttrService),
            service, (id)CFBridgingRelease(kSecAttrAccount),
            (id)CFBridgingRelease(kSecAttrAccessibleAfterFirstUnlock),(id)CFBridgingRelease(kSecAttrAccessible),
            nil];
}

+ (void)saveKeychain:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)CFBridgingRetain(keychainQuery));
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)CFBridgingRelease(kSecValueData)];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)CFBridgingRetain(keychainQuery), NULL);
    CFBridgingRelease((__bridge CFTypeRef)(keychainQuery));
//    CFDictionaryrele(keychainQuery);
}

+ (id)loadKeychain:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)CFBridgingRelease(kCFBooleanTrue) forKey:(id)CFBridgingRelease(kSecReturnData)];
    [keychainQuery setObject:(id)CFBridgingRelease(kSecMatchLimitOne) forKey:(id)CFBridgingRelease(kSecMatchLimit)];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)CFBridgingRetain(keychainQuery), (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)CFBridgingRelease(keyData)];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}

+ (void)deleteKeychain:(NSString *)service{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)CFBridgingRetain(keychainQuery));
    CFBridgingRelease((__bridge CFTypeRef)(keychainQuery));
}
@end
