//
//  PopVcViewController.m
//  IMDemo
//
//  Created by 潇潇 on 16/9/28.
//  Copyright © 2016年 潇潇. All rights reserved.
//

#import "PopVcViewController.h"

@interface PopVcViewController ()

@end

@implementation PopVcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) swipPop{
//    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:@ action:<#(nullable SEL)#>]
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
