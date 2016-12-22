//
//  SYToast.h
//  SYMusicPlayer
//
//  Created by 孙宇 on 16/12/22.
//  Copyright © 2016年 孙宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SYToast : NSObject


/**
 设置加载视图是否使用 UIActivityIndicatorView 控件，默认YES
 设置为NO时是使用图片旋转动画
 */
@property (nonatomic, assign) BOOL isActivity;


/**
 背景色（默认透明）
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 前景色（默认黑色）
 */
@property (nonatomic, strong) UIColor *foregroundColor;

/**
 文字颜色（默认白色）
 */
@property (nonatomic, strong) UIColor *toastTextColor;

/**
 文字字体（默认系统字体，字号17）
 */
@property (nonatomic, strong) UIFont *toastTextFont;

@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, assign) NSTimeInterval duration;

+ (instancetype)manager;

- (void)show;
- (void)showWithText:(NSString *)text;

- (void)successWithText:(NSString *)text;
- (void)successWithImage:(UIImage *)image text:(NSString *)text;

- (void)failureWithText:(NSString *)text;
- (void)failureWithImage:(UIImage *)image text:(NSString *)text;

- (void)hidden;
- (void)hiddenDelay:(CGFloat)delay;

@end
