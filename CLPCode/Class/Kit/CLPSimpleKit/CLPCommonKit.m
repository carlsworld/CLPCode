//
//  CLPCommonKit.m
//  LZCode
//
//  Created by Carlson Lee on 2018/4/24.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//  快速创建视图

#import "CLPCommonKit.h"

@implementation CLPCommonKit

/**
 * 字体名称
 */
NSString* fontName(FONT_TYPE tp){
    switch (tp) {
        case FONT_TYPE_REGULAR:{
            return @"PingFangSC-Regular";
        }
            break;
        case FONT_TYPE_MEDIUM:{
            return @"PingFangSC-Medium";
        }
            break;
        case FONT_TYPE_LIGHT:{
            return @"PingFangSC-Light";
        }
            break;
        default:
            break;
    }
}

/**
 * 字体
 */
UIFont* CLPFont(CGFloat size, FONT_TYPE tp){
    UIFont* font = [UIFont fontWithName:fontName(tp) size:size*kScaleX];
    if(!font){
        font = [UIFont systemFontOfSize:size*kScaleX];
    }
    return font;
}

/**
 *文字+英文/数字混合计算会有误差
 */
CGSize CLPSize(NSString* str, UIFont* font, CGSize size){
    if(!str || !str.length)return CGSizeZero;
    if(!font)font = CLPFont(16, FONT_TYPE_REGULAR);
    if(!size.width || !size.height){
        return [str sizeWithAttributes:@{NSFontAttributeName:font}];
    }
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

/**
 *  初始化label
 */
id CLP_NEW_LABEL(UIColor* _bg_color_, UIColor* _text_color_, UIFont* _font_, NSTextAlignment _type_, NSInteger _lines_, id _superView_){
    UILabel* _object_name_ = [[UILabel alloc]init];
    [_object_name_ setBackgroundColor:_bg_color_?_bg_color_:[UIColor clearColor]];
    [_object_name_ setTextColor:_text_color_];
    [_object_name_ setFont:_font_];
    [_object_name_ setTextAlignment:_type_];
    [_object_name_ setNumberOfLines:_lines_];
    if(_superView_)[_superView_ addSubview:_object_name_];
    return _object_name_;
}

@end
