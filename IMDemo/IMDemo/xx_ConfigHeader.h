//
//  xx_ConfigHeader.h
//  IMDemo
//
//  Created by 潇潇 on 16/8/19.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#ifndef xx_ConfigHeader_h
#define xx_ConfigHeader_h

//.h文件
#define XXSingletonH  + (nullable instancetype)sharedInstance;

//加上斜杠是为了让编辑器认为下一行代码也是宏的内容
//.m文件
#define XXSingletonM \
static id _instance;\
\
+ (nullable instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+ (instancetype)sharedInstance\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc]init];\
});\
return _instance;\
}\
\
- (id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}



#define HFMessageHistoryLimt 10
#define HFExpressionWidth 15
#define HFExpressionHeight 15
#define HFExpressionDic @"HFExpressionDic"
#endif /* xx_ConfigHeader_h */
