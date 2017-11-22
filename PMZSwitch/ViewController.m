//
//  ViewController.m
//  PMZSwitch
//
//  Created by Li Guangming on 2017/11/21.
//  Copyright © 2017年 Li Guangming. All rights reserved.
//

#import "ViewController.h"
#import "PMZSwitch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.90 blue:0.83 alpha:1.00];
    PMZSwitch *s = [[PMZSwitch alloc] initWithFrame:CGRectMake(100, 200, 200, 100)];
    [self.view addSubview:s];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
