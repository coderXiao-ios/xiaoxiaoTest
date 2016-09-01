//
//  CJInputControl.m
//  CJCOMMON
//
//  Created by yuqy on 14-10-17.
//  Copyright (c) 2014年 YYT. All rights reserved.
//

#import "CJInputControl.h"

@implementation CJInputControl
+ (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText limit:(long)limit
{
    if (limit > 0 && searchBar.text.length > limit)
    {
        searchBar.text = [searchBar.text substringToIndex:limit];
    }
}

+ (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text limit:(long)limit
{
//    if (limit > 0 && text.length != 0)
//    {
//        NSInteger existedLength = searchBar.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = text.length;
//        if (existedLength - selectedLength + replaceLength > limit)
//        {
//            return NO;
//        }
//    }

    return YES;
}

+ (void)textViewDidChange:(UITextView*)textView limit:(long)limit
{
    if (limit > 0 && textView.markedTextRange == nil && textView.text.length > limit)
    {
        textView.text = [textView.text substringToIndex:limit];
    }
}

+ (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text limit:(long)limit
{
//    if (limit > 0 && text.length != 0)
//    {
//        NSInteger existedLength = textView.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = text.length;
//        if (existedLength - selectedLength + replaceLength > limit)
//        {
//            return NO;
//        }
//    }
    
    return YES;
}

+ (void)textFieldDidChange:(UITextField *)textField limit:(long)limit
{
    if (limit > 0 && textField.markedTextRange == nil && textField.text.length > limit)
    {
        textField.text = [textField.text substringToIndex:limit];
    }
}

+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limit:(long)limit
{
//    if (limit > 0 && string.length != 0)
//    {
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > limit)
//        {
//            return NO;
//        }
//    }
    
    return YES;
}
@end
