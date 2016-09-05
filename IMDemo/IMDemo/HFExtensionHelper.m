//
//  NSString+HFKitExtension.m
//  IMDemo
//
//  Created by 潇潇 on 16/9/5.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "HFExtensionHelper.h"
#import <objc/runtime.h>

@implementation NSString (HFKitExtension)
static char HFKitStringJsonDictionaryAddress;
- (NSDictionary *)IMkit_jsonDict
{
    NSDictionary *dict = [objc_getAssociatedObject(self, &HFKitStringJsonDictionaryAddress) copy];
    if (dict == nil)    //解析过一次后就缓存解析结果，避免多次解析
    {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:nil];
        if (![dict isKindOfClass:[NSDictionary class]])
        {
            dict = [NSDictionary dictionary];
        }
        objc_setAssociatedObject(self,&HFKitStringJsonDictionaryAddress,dict,OBJC_ASSOCIATION_COPY);
    }
    return dict;
    
}
@end

@implementation NSDictionary (HFKitExtension)
- (NSString *)IMkit_jsonString
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0
                                                     error:nil];
    return data ? [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding] : nil;
}
@end