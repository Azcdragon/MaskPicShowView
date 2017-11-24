//
//  ViewController.m
//  MaskPicShowView
//
//  Created by Mac mini on 2017/11/24.
//  Copyright © 2017年 Azcdragon. All rights reserved.
//

#import "ViewController.h"
#import "MaskPicShowView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(200, 200, 100, 100);
    [button setTitle:@"点击看大图" forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:@"1.jpg"] forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(touchUpAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}
- (void)touchUpAction{
    [MaskPicShowView maskPicShowImages:@[[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"4.jpg"],[UIImage imageNamed:@"5.jpg"]] seletedIndex:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
