//
//  ViewController.m
//  SYToastTool
//
//  Created by 孙宇 on 16/12/22.
//  Copyright © 2016年 孙宇. All rights reserved.
//

#import "ViewController.h"
#import "SYToast.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [SYToast manager].isActivity = NO;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(onButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)onButtonClick
{
//    [[SYToast manager]show];
//    [[SYToast manager]showWithText:@"加载中..."];
    [[SYToast manager]successWithText:@"成功"];
//    [[SYToast manager]successWithImage:nil text:@"下载成功"];
//    [[SYToast manager]failureWithText:@"失败"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
