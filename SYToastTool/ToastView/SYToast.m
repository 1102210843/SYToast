//
//  SYToast.m
//  SYMusicPlayer
//
//  Created by 孙宇 on 16/12/22.
//  Copyright © 2016年 孙宇. All rights reserved.
//

#import "SYToast.h"

@interface SYToast ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *toastView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImage *toastImage;
@property (nonatomic, strong) UIImage *successImage;
@property (nonatomic, strong) UIImage *failureImage;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat rotation;

@end

@implementation SYToast

static SYToast *shared = nil;
+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.foregroundColor = [UIColor colorWithRed:49.f/255.f green:49.f/255.f blue:49.f/255.f alpha:0.6f];
        self.toastTextColor = [UIColor whiteColor];
        self.toastTextFont = [UIFont systemFontOfSize:17];
        self.toastImage = [UIImage imageNamed:@"recognize_circle_around_line"];
        self.successImage = [UIImage imageNamed:@"success"];
        self.failureImage = [UIImage imageNamed:@"error"];
        self.isActivity = YES;
    }
    return self;
}

- (void)show
{
    [self createDefaultWithText:nil];
}

- (void)showWithText:(NSString *)text
{
    [self createDefaultWithText:text];
}


- (void)successWithText:(NSString *)text
{
    [self createFeedbackWithImage:self.successImage text:text];
}
- (void)successWithImage:(UIImage *)image text:(NSString *)text
{
    [self createFeedbackWithImage:image text:text];
}

- (void)failureWithText:(NSString *)text
{
    [self createFeedbackWithImage:self.failureImage text:text];
}
- (void)failureWithImage:(UIImage *)image text:(NSString *)text
{
    [self createFeedbackWithImage:image text:text];
}

- (void)hidden
{
    [self.timer invalidate];
    self.timer = nil;
    [self.activityView removeFromSuperview];
    self.activityView = nil;
    [self.label removeFromSuperview];
    self.label = nil;
    [self.imageView stopAnimating];
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    [self.toastView removeFromSuperview];
    self.toastView = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}
- (void)hiddenDelay:(CGFloat)delay
{
    __weak typeof(self)weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself hidden];
    });
}




#pragma mark -- createUI
- (void)createDefault
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    self.backgroundView.frame = window.bounds;
    [window addSubview:self.backgroundView];
    
    [self.backgroundView addSubview:self.toastView];
    
    CGFloat width = self.backgroundView.bounds.size.width-200;
    self.toastView.frame = CGRectMake(0, 0, width, width/3.f*2.f);
    self.toastView.center = CGPointMake(self.backgroundView.bounds.size.width/2.f, self.backgroundView.bounds.size.height/2.f);
}

- (void)createDefaultWithText:(NSString *)text
{
    __weak typeof(self)weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself createDefault];
        [weakself createLabel:text];
        
        if (weakself.images.count > 0) {
            [weakself imagesAnimationStyle];
        }else{
            [weakself activityViewStyle];
        }
    });
}

- (void)createFeedbackWithImage:(UIImage *)image text:(NSString *)text
{
    __weak typeof(self)weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself createDefault];
        [weakself createLabel:text];
        [weakself createImage:image];
        [weakself hiddenDelay:1.5];
    });
}


- (void)createLabel:(NSString *)text
{
    if (text) {
        [self.toastView addSubview:self.label];
        self.label.text = text;
        [self.label sizeToFit];
        CGRect frame = self.label.frame;
        frame.size.width = self.toastView.bounds.size.width-10;
        self.label.frame = frame;
        self.label.center = CGPointMake(self.toastView.bounds.size.width/2.f, self.toastView.bounds.size.height-self.label.bounds.size.height/2.f-10);
    }
}

- (void)createImage:(UIImage *)image
{
    if (image) {
        [self.toastView addSubview:self.imageView];
        [self.imageView setImage:image];
        self.imageView.frame = CGRectMake(10, 10, CGRectGetWidth(self.toastView.bounds)-20, CGRectGetMidY(self.label.frame)-20);
    }else{
        CGFloat width = self.backgroundView.bounds.size.width-200;
        self.toastView.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.label.bounds)+10);
        self.toastView.center = CGPointMake(self.backgroundView.bounds.size.width/2.f, self.backgroundView.bounds.size.height/2.f);
        
        CGRect frame = self.label.frame;
        frame.origin.y = 5;
        self.label.frame = frame;
    }
}


- (void)imagesAnimationStyle
{
    [self.toastView addSubview:self.imageView];
    self.imageView.animationImages = self.images;
    self.imageView.animationDuration = self.duration;
    self.imageView.animationRepeatCount = NSIntegerMax;
    [self.imageView startAnimating];
    if (self.label.text){
        self.imageView.frame = CGRectMake(10, 10, CGRectGetWidth(self.toastView.bounds)-20, CGRectGetMidY(self.label.frame)-20);
    }else{
        self.imageView.frame = CGRectMake(10, 10, CGRectGetWidth(self.toastView.bounds)-20, CGRectGetHeight(self.toastView.bounds)-20);
    }
}

- (void)activityViewStyle
{
    if (self.isActivity) {
        [self.toastView addSubview:self.activityView];
        if (self.label.text){
            self.activityView.center = CGPointMake(CGRectGetWidth(self.toastView.bounds)/2.f, CGRectGetMidY(self.label.frame)/2.f);
        }else{
            self.activityView.center = CGPointMake(CGRectGetWidth(self.toastView.bounds)/2.f, CGRectGetHeight(self.toastView.bounds)/2.f);
        }
    }else{
        [self.toastView addSubview:self.imageView];
        [self.imageView setImage:self.toastImage];
        
        if (self.label.text){
            self.imageView.frame = CGRectMake(10, 10, CGRectGetWidth(self.toastView.bounds)-20, CGRectGetMidY(self.label.frame)-20);
        }else{
            self.toastView.backgroundColor = [UIColor clearColor];
            self.imageView.frame = CGRectMake(10, 10, CGRectGetWidth(self.toastView.bounds)-20, CGRectGetHeight(self.toastView.bounds)-20);
        }
        [self startAnimation];
    }
}


- (void)startAnimation
{
    self.rotation = 0;
    self.timer = [NSTimer timerWithTimeInterval:0.005 target:self selector:@selector(onTimerAnimatin) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)onTimerAnimatin
{
    self.rotation += M_PI / 180;
    if (self.rotation > M_PI*2) {
        self.rotation = 0;
    }
    self.imageView.transform = CGAffineTransformMakeRotation(self.rotation);
}



#pragma mark -- controls

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.backgroundColor = _backgroundColor;
    }
    return _backgroundView;
}

- (UIView *)toastView
{
    if (!_toastView) {
        _toastView = [[UIView alloc]init];
        _toastView.backgroundColor = self.foregroundColor;
        _toastView.layer.cornerRadius = 8;
        _toastView.layer.masksToBounds = YES;
    }
    return _toastView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = _toastTextFont;
        _label.textColor = _toastTextColor;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityView startAnimating];
    }
    return _activityView;
}




#pragma mark -- attribute

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
}

- (void)setForegroundColor:(UIColor *)foregroundColor
{
    _foregroundColor = foregroundColor;
}

- (void)setToastTextColor:(UIColor *)toastTextColor
{
    _toastTextColor = toastTextColor;
}

- (void)setToastTextFont:(UIFont *)toastTextFont
{
    _toastTextFont = toastTextFont;
}

@end
