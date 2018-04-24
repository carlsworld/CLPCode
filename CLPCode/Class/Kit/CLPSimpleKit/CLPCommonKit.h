//
//  CLPCommonKit.h
//  LZCode
//
//  Created by Carlson Lee on 2018/4/24.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//  快速创建视图

#import <Foundation/Foundation.h>

@interface CLPCommonKit : NSObject

/**
 new label
 */
id CLP_NEW_LABEL(UIColor* _bg_color_, UIColor* _text_color_, UIFont* _font_, NSTextAlignment _type_, NSInteger _lines_, id _superView_);

@end
