//
//  CLPButton.h
//  CLPCode
//
//  Created by Carlson Lee on 2018/4/26.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CLPBTN_DIRECTOR){
    CLPBTN_DIRECTOR_HOC = 1,//水平
    CLPBTN_DIRECTOR_VER,//竖直
};

typedef NS_ENUM(NSInteger, CLPBTN_TYPE){
    CLPBTN_TYPE_T = 1,
    CLPBTN_TYPE_IT,//image+title
    CLPBTN_TYPE_TI,//title+image
};
@interface CLPButton : UIControl

/**
 按钮的布局类型, 默认图片+文字
 */
@property (nonatomic, assign) CLPBTN_TYPE type;
@property (nonatomic, assign) CLPBTN_DIRECTOR direction;

/**
 设置圆角, 默认0
 如果corner小于0, 则圆角为 高/2
 */
@property(nonatomic, assign) CGFloat corner;

/**
 图片大小
 如果设置CGSizeZero,则按原图大小
 */
@property(nonatomic, assign) CGSize imgSize;

@property(nonatomic, strong) UIColor* imgColor;

/**
 图片文字间距, 默认5
 */
@property(nonatomic, assign) CGFloat offset;

/**
 左 中 右
 */
@property(nonatomic, assign) NSTextAlignment alignment;

/**
 初始化方法.默认水平布局
 */
+ (CLPButton* )buttonWithType:(CLPBTN_TYPE)type;
/**
 按钮类型、
 */
+ (CLPButton* )buttonWithType:(CLPBTN_TYPE)type direction:(CLPBTN_DIRECTOR )dir;

- (void)setNormalImgStr:(NSString* )imgStr titleStrs:(NSString* )str, ...;
- (void)setSelectImgStr:(NSString* )imgStr titleStrs:(NSString* )str, ...;

@end
