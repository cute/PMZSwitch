//
//  PMZISwitchAnimatedThumb.m
//  PMZSwitch
//
//  Created by Li Guangming on 2017/11/21.
//  Copyright © 2017年 Li Guangming. All rights reserved.
//

#import "PMZISwitchAnimatedThumb.h"

@interface PMZISwitchAnimatedThumb ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *thumbSignView1;
@property (nonatomic, strong) UIView *thumbSignView2;
@property (nonatomic, strong) CAAnimationGroup *animationGroup1;
@property (nonatomic, strong) CAAnimationGroup *animationGroup2;
@property (nonatomic, strong) CAAnimationGroup *thumbAnimationGroup;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) BOOL isTracking;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat thumbSignWidth;
@end

@implementation PMZISwitchAnimatedThumb

- (void)setAnimationProgress:(CGFloat)animationProgress
{
    if (animationProgress > 1) {
        animationProgress = 1;
    }
    
    if (animationProgress < 0) {
        animationProgress = 0;
    }
    
    self.thumbSignView1.layer.timeOffset = self.animationDuration * animationProgress;
    self.thumbSignView2.layer.timeOffset = self.animationDuration * animationProgress;
    self.backgroundView.layer.timeOffset = self.animationDuration * animationProgress;
    
    _animationProgress = animationProgress;
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    if (self.isOn) {
        self.backgroundView.backgroundColor = thumbTintColor;
    }
    else {
        self.backgroundView.backgroundColor = _thumbTintColor;
    }
    
    _thumbTintColor = thumbTintColor;
}

- (void)setOnThumbTintColor:(UIColor *)onThumbTintColor
{
    if (self.isOn) {
        self.backgroundView.backgroundColor = onThumbTintColor;
    }
    else {
        self.backgroundView.backgroundColor = _onThumbTintColor;
    }
    
    _onThumbTintColor = onThumbTintColor;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    self.backgroundView.layer.shadowColor = shadowColor.CGColor;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect squareRect = CGRectMake(0, 0, 50, 30);
    CGFloat borderMargin = 15.0;
    CGRect initialFrame = CGRectIsEmpty(frame) ? CGRectInset(squareRect, borderMargin, borderMargin) : frame;
    self = [super initWithFrame:initialFrame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _thumbTintColor = [UIColor colorWithRed:0.95 green:0.90 blue:0.83 alpha:1.00];
    _onThumbTintColor = [UIColor colorWithRed:0.50 green:0.54 blue:0.96 alpha:1.00];
    _shadowColor = [UIColor grayColor];
    
    self.animationDuration = 0.3;
    self.thumbSignWidth = 5.0;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView = backgroundView;
    backgroundView.backgroundColor = _thumbTintColor;
    backgroundView.layer.cornerRadius = self.frame.size.height * 0.5;
    backgroundView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:backgroundView.layer.cornerRadius].CGPath;
    backgroundView.layer.shadowRadius = 4.0;
    backgroundView.layer.shadowOpacity = 0;
    backgroundView.layer.shadowColor = self.shadowColor.CGColor;
    backgroundView.layer.shadowOffset = CGSizeMake(0, 7);
    backgroundView.layer.masksToBounds = NO;
    [self addSubview:backgroundView];
    
    self.userInteractionEnabled = NO;
    [self setupSignViews];
}

- (void)toggle:(BOOL)animated
{
    [self resetAnimations];
    
    self.isTracking = NO;
    self.isOn = !self.isOn;
    
    self.thumbSignView1.layer.speed = animated ? 1 : 0;
    self.thumbSignView2.layer.speed = animated ? 1 : 0;
    self.backgroundView.layer.speed = animated ? 1 : 0;
    
    [self.thumbSignView1.layer addAnimation:self.animationGroup1 forKey:@"tickAnimation"];
    [self.thumbSignView2.layer addAnimation:self.animationGroup2 forKey:@"tickAnimation"];
    [self.backgroundView.layer addAnimation:self.thumbAnimationGroup forKey:@"thumbAnimation"];
}

- (void)startTracking
{
    if (self.isTracking) {
        return;
    }
    
    [self resetAnimations];
    self.isTracking = YES;
    
    self.thumbSignView1.layer.speed = 0;
    self.thumbSignView2.layer.speed = 0;
    self.backgroundView.layer.speed = 0;
    
    [self.thumbSignView1.layer addAnimation:self.animationGroup1 forKey:@"tickAnimation"];
    [self.thumbSignView2.layer addAnimation:self.animationGroup2 forKey:@"tickAnimation"];
    [self.backgroundView.layer addAnimation:self.thumbAnimationGroup forKey:@"thumbAnimation"];
}

- (void)endTracking:(BOOL)isOn
{
    self.isOn = isOn;
    
    if (!self.isTracking) {
        return;
    }
    
    self.isTracking = NO;
    
    self.thumbSignView1.layer.timeOffset = self.animationDuration;
    self.thumbSignView2.layer.timeOffset = self.animationDuration;
    self.backgroundView.layer.timeOffset = self.animationDuration;
}

- (void)setupSignViews
{
    self.thumbSignView1 = [self createThumbSignView];
    self.thumbSignView1.transform = CGAffineTransformMakeRotation(M_PI_4);
    [self addSubview:self.thumbSignView1];
    
    self.thumbSignView2 = [self createThumbSignView];
    self.thumbSignView2.transform = CGAffineTransformMakeRotation(-M_PI_4);
    [self addSubview:self.thumbSignView2];
}

- (UIView *)createThumbSignView
{
    CGFloat thumbSignHeight = self.bounds.size.height / 2 - self.thumbSignWidth;
    CGRect frame = CGRectMake(self.bounds.size.width / 2 - 4,
                              self.bounds.size.height / 2 - thumbSignHeight / 2,
                              self.thumbSignWidth, thumbSignHeight);
    UIView *thumbSignView = [[UIView alloc] initWithFrame:frame];
    thumbSignView.layer.cornerRadius = self.thumbSignWidth / 2;
    thumbSignView.backgroundColor = [UIColor whiteColor];
    return thumbSignView;
}

- (void)resetAnimations
{
    [self.thumbSignView1.layer removeAllAnimations];
    [self.thumbSignView2.layer removeAllAnimations];
    [self.backgroundView.layer removeAllAnimations];
    
    self.thumbSignView1.layer.timeOffset = 0;
    self.thumbSignView2.layer.timeOffset = 0;
    self.backgroundView.layer.timeOffset = 0;
    
    CGFloat thumbSignHeight = self.bounds.size.height / 2 - self.thumbSignWidth;
    CGPoint position1 = CGPointMake(self.thumbSignView1.center.x + 6, self.thumbSignView1.center.y + 2);
    CGPoint position2 = CGPointMake(self.thumbSignView2.center.x - (thumbSignHeight / 2.0 - 3.0),
                                    self.thumbSignView2.center.y + thumbSignHeight / 4.5);

    CABasicAnimation *rotationAnimation1 = [self baseAnimation:@"transform.rotation"
                                                     fromValue:@(M_PI_4)
                                                       toValue:@(-M_PI + M_PI_4)];
    
    CABasicAnimation *scaleAnimation1 = [self baseAnimation:@"bounds.size.height"
                                                  fromValue:@(thumbSignHeight)
                                                    toValue:@(thumbSignHeight + 7)];

    CABasicAnimation *moveAnimation1 = [self baseAnimation:@"position"
                                                 fromValue:[NSValue valueWithCGPoint:self.thumbSignView1.center]
                                                   toValue:[NSValue valueWithCGPoint:position1]];
    
    self.animationGroup1 = [CAAnimationGroup new];
    self.animationGroup1.duration = self.animationDuration;
    self.animationGroup1.animations = @[ rotationAnimation1, scaleAnimation1, moveAnimation1 ];
    self.animationGroup1.removedOnCompletion = NO;
    self.animationGroup1.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *rotationAnimation2 = [self baseAnimation:@"transform.rotation"
                                                     fromValue:@(-M_PI_4)
                                                       toValue:@(-M_PI - M_PI_4)];
    
    CABasicAnimation *scaleAnimation2 = [self baseAnimation:@"bounds.size.height"
                                                  fromValue:@(thumbSignHeight)
                                                    toValue:@(thumbSignHeight / 2 + 6)];

    CABasicAnimation *moveAnimation2 = [self baseAnimation:@"position"
                                                 fromValue:[NSValue valueWithCGPoint:self.thumbSignView2.center]
                                                   toValue:[NSValue valueWithCGPoint:position2]];
    
    self.animationGroup2 = [CAAnimationGroup new];
    self.animationGroup2.duration = self.animationDuration;
    self.animationGroup2.animations = @[ rotationAnimation2, scaleAnimation2, moveAnimation2 ];
    self.animationGroup2.removedOnCompletion = NO;
    self.animationGroup2.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *shadowOpacityAnimation = [self baseAnimation:@"shadowOpacity"
                                                         fromValue:@(0)
                                                           toValue:@(0.5)];
    
    CABasicAnimation *bgColorAnimation = [self baseAnimation:@"backgroundColor"
                                                   fromValue:(id)self.thumbTintColor.CGColor
                                                     toValue:(id)self.onThumbTintColor.CGColor];
    
    self.thumbAnimationGroup = [CAAnimationGroup new];
    self.thumbAnimationGroup.duration = self.animationDuration;
    self.thumbAnimationGroup.animations = @[ shadowOpacityAnimation, bgColorAnimation ];
    self.thumbAnimationGroup.removedOnCompletion = NO;
    self.thumbAnimationGroup.fillMode = kCAFillModeForwards;
}

- (CABasicAnimation *)baseAnimation:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = self.animationDuration;
    animation.fromValue = self.isOn ? toValue : fromValue;
    animation.toValue = self.isOn ? fromValue : toValue;
    return animation;
}

@end
