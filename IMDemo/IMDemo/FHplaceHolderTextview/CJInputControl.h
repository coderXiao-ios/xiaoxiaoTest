//
//  CJInputControl.h
//  CJCOMMON
//
//  Created by yuqy on 14-10-17.
//  Copyright (c) 2014年 YYT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJInputControl : NSObject

+ (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText limit:(long)limit;

+ (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text limit:(long)limit;

+ (void)textViewDidChange:(UITextView*)textView limit:(long)limit;

+ (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text limit:(long)limit;

+ (void)textFieldDidChange:(UITextField *)textField limit:(long)limit;

+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limit:(long)limit;

@end
