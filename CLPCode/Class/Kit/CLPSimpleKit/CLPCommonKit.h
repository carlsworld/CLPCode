//
//  CLPCommonKit.h
//  LZCode
//
//  Created by Carlson Lee on 2018/4/24.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//  快速创建视图

#import <Foundation/Foundation.h>
#import "CLPHeader.h"

typedef NS_ENUM(NSInteger, FONT_TYPE){
    FONT_TYPE_REGULAR, //常规
    FONT_TYPE_MEDIUM,//粗体
    FONT_TYPE_LIGHT, //细体
};
@interface CLPCommonKit : NSObject


/**
 back font
 */
UIFont* CLPFont(CGFloat size, FONT_TYPE tp);

/**
 back str size
 */
CGSize CLPSize(NSString* str, UIFont* font, CGSize size);

/**
 new label
 */
id CLP_NEW_LABEL(UIColor* _bg_color_, UIColor* _text_color_, UIFont* _font_, NSTextAlignment _type_, NSInteger _lines_, id _superView_);

@end
