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
