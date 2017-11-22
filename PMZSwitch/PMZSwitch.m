//
//  PMZSwitch.m
//  PMZSwitch
//
//  Created by Li Guangming on 2017/11/22.
//  Copyright © 2017年 Li Guangming. All rights reserved.
//

#import "PMZSwitch.h"
#import "PMZISwitchAnimatedThumb.h"

@interface PMZSwitch ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) PMZISwitchAnimatedThumb *thumbView;
@property (nonatomic, assign) CGPoint startTrackingPoint;
@property (nonatomic, assign) CGRect startThumbFrame;
@property (nonatomic, assign) BOOL switchValue;
@property (nonatomic, assign) BOOL ignoreTap;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation PMZSwitch

- (void)setOn:(BOOL)on
{
    self.switchValue = on;
    [self setOn:on animated:NO];
}

- (BOOL)on
{
    return self.switchValue;
}

- (UIColor *)thumbTintColor
{
    return self.thumbView.thumbTintColor;
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    self.thumbView.thumbTintColor = thumbTintColor;
}

- (UIColor *)onThumbTintColor
{
    return self.thumbView.onThumbTintColor;
}

- (void)setOnThumbTintColor:(UIColor *)onThumbTintColor
{
    self.thumbView.onThumbTintColor = onThumbTintColor;
}

- (UIColor *)shadowColor
{
    return self.thumbView.shadowColor;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    self.thumbView.shadowColor = shadowColor;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 50, 30)];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (CGFloat)maxThumbOffset
{
    CGFloat borderMargin = 15;
    return self.bounds.size.width - self.thumbView.frame.size.width - borderMargin * 2;
}

- (CGRect)originalThumbRect
{
    CGFloat borderMargin = 15;
    CGRect squareRect = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
    return CGRectInset(squareRect, borderMargin, borderMargin);
}

- (void)setup
{
    self.startTrackingPoint = CGPointZero;
    self.startThumbFrame = CGRectZero;
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = UIColor.whiteColor;
    self.backgroundView.layer.cornerRadius = self.frame.size.height * 0.5;
    self.backgroundView.userInteractionEnabled = NO;
    self.backgroundView.clipsToBounds = YES;
    [self addSubview:self.backgroundView];
    
    self.thumbView = [[PMZISwitchAnimatedThumb alloc] initWithFrame:self.originalThumbRect];
    [self addSubview:self.thumbView];
    
    self.on = NO;
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.ignoreTap) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.thumbView toggle:YES];
        [self setOn:!self.switchValue animated:YES];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    self.startTrackingPoint = [touch locationInView:self];
    self.startThumbFrame = self.thumbView.frame;
    [self.thumbView startTracking];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    self.ignoreTap = YES;
    
    // Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    CGFloat thumbMinPosition = self.originalThumbRect.origin.x;
    CGFloat thumbMaxPosition = self.originalThumbRect.origin.x + self.maxThumbOffset;
    CGFloat touchXOffset = lastPoint.x - self.startTrackingPoint.x;
    
    CGRect desiredFrame = CGRectOffset(self.startThumbFrame, touchXOffset, 0);
    desiredFrame.origin.x = MIN(MAX(desiredFrame.origin.x, thumbMinPosition), thumbMaxPosition);
    self.thumbView.frame = desiredFrame;
    
    if (self.switchValue) { // left <- right
        self.thumbView.animationProgress = (thumbMaxPosition - desiredFrame.origin.x) / self.maxThumbOffset;
    }
    else { // left -> right
        self.thumbView.animationProgress = (desiredFrame.origin.x - thumbMinPosition) / self.maxThumbOffset;
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    
    if (self.thumbView.center.x > CGRectGetMidX(self.bounds)) {
        [self setOn:YES animated:YES];
    }
    else {
        [self setOn:NO animated:YES];
    }
    
    self.ignoreTap = NO;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [super cancelTrackingWithEvent:event];
    
    if (!self.ignoreTap) {
        return;
    }
    
    if (self.switchValue) {
        [self showOn:YES];
    }
    else {
        [self showOff:YES];
    }
    
    self.ignoreTap = NO;
}

- (void)setOn:(BOOL)isOn animated:(BOOL)animated
{
    if (_switchValue == isOn) {
        return;
    }
    
    _switchValue = isOn;

    if (isOn) {
        [self showOn:animated];
    }
    else {
        [self showOff:animated];
    }
}

- (BOOL)isOn
{
    return self.switchValue;
}

- (void)showOn:(BOOL)animated
{
    [self.thumbView endTracking:YES];
    CGFloat animationDuration = 0.3;
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.thumbView.frame = CGRectOffset(self.originalThumbRect, self.maxThumbOffset, 0);
                     }
                     completion:nil];
}

- (void)showOff:(BOOL)animated
{
    [self.thumbView endTracking:NO];
    CGFloat animationDuration = 0.3;
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.thumbView.frame = self.originalThumbRect;
                     }
                     completion:nil];
}
@end
