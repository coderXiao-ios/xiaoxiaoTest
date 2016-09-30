//
//  HFImageStorge.h
//  IMDemo
//
//  Created by 潇潇 on 16/9/29.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "HFDrawStorge.h"
typedef enum : NSUInteger {
    TYImageAlignmentCenter,  // 图片居中
    TYImageAlignmentLeft,    // 图片左对齐
    TYImageAlignmentRight,   // 图片右对齐
    TYImageAlignmentFill     // 图片拉伸填充
} TYImageAlignment;

@interface HFImageStorge : HFDrawStorge<TYViewStorageProtocol>
@property (nonatomic, strong) UIImage   *image;

@property (nonatomic, strong) NSString  *imageName;

@property (nonatomic, strong) NSURL     *imageURL;

@property (nonatomic, strong) NSString  *placeholdImageName;

@property (nonatomic, assign) TYImageAlignment imageAlignment; // default center

@property (nonatomic, assign) BOOL cacheImageOnMemory; // default NO ,if YES can improve performance，but increase memory
@end
