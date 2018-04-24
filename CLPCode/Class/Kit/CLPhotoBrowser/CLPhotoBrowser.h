//
//  FCPhotoBrowser.h
//  FastCall
//
//  Created by Carlson Lee on 2018/1/22.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLPhotoBrowser : UIView


/**
 传入展示的模型数组

 例：@[@{@"link":@"", @"rect":@""}]
 
 @param items 模型数组
 @param index 展示第index模型
 */
+ (void)showItems:(NSArray* )items atIndex:(NSInteger)index;

@end
