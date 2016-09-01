//
//  CJPlaceHolderTextView.h
//  CJCOMMON
//
//  Created by user on 15/3/12.
//
//

#import <UIKit/UIKit.h>
#define RGB(r, g, b, a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface CJPlaceHolderTextView : UITextView
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, strong) UIColor *placeHolderColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) int fontcount;
@property (nonatomic, weak) id<UITextViewDelegate> delegate;

/** 占位框 */
@property (nonatomic, weak) UILabel *placeHolderLabel;
@end
