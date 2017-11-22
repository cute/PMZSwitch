//
//  PMZSwitch.h
//  PMZSwitch
//
//  Created by Li Guangming on 2017/11/22.
//  Copyright © 2017年 Li Guangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMZSwitch : UIControl<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL on;
@property (nonatomic, strong) UIColor *thumbTintColor;
@property (nonatomic, strong) UIColor *onThumbTintColor;
@property (nonatomic, strong) UIColor *shadowColor;

- (void)setOn:(BOOL)isOn animated:(BOOL) animated;
- (BOOL)isOn;

@end
