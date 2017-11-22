//
//  PMZISwitchAnimatedThumb.h
//  PMZSwitch
//
//  Created by Li Guangming on 2017/11/21.
//  Copyright © 2017年 Li Guangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMZISwitchAnimatedThumb : UIView
@property (nonatomic, assign) CGFloat animationProgress;
@property (nonatomic, strong) UIColor *thumbTintColor;
@property (nonatomic, strong) UIColor *onThumbTintColor;
@property (nonatomic, strong) UIColor *shadowColor;

- (void)toggle:(BOOL)animated;
- (void)startTracking;
- (void)endTracking:(BOOL)isOn;

@end
