//
// Created by zorro on 15/3/7.
// Copyright (c) 2015 tutuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+EmojiExtension.h"
#import "EmojiTextAttachment.h"
#import "xx_ConfigHeader.h"
@implementation NSAttributedString (EmojiExtension)

- (NSString *)getPlainString {
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:[NSString stringWithFormat:@"[%@]",((EmojiTextAttachment *) value).emojiTag]];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1 + 2;
                      }
                  }];
    
    return plainString;
}
- (NSString *)getPlainStringMD5 {
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          NSDictionary *expressionDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"HFExpressionDic"];
                         NSString *expressionTitle = [NSString stringWithFormat:@"%@",((EmojiTextAttachment *) value).emojiTag];
                          NSString *expressionMD5Str = @"";
                          for (NSString *title in expressionDic) {
                              if ([expressionDic[title] isEqualToString:expressionTitle]) {
                                  expressionMD5Str = [NSString stringWithFormat:@"%@",title];
                              }
                          }
                          NSString *conversionStr = [NSString stringWithFormat:@"[%@,%.f,%.f]",expressionMD5Str,((EmojiTextAttachment *) value).emojiSize.width,((EmojiTextAttachment *) value).emojiSize.height] ;
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:conversionStr];
                          base += conversionStr.length - 1 ;
                      }
                  }];
    
    return plainString;
}

@end