//
//  LZBrowserItem.h
//  _test_
//
//  Created by Carlson Lee on 2018/3/28.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPSystemMacro.h"

@protocol CLPBrowserItemDelegate;
@interface CLPBrowserItem : UIView

@property (nonatomic, weak) id<CLPBrowserItemDelegate> delegate;

@property (nonatomic, strong) id itemData;

@property (nonatomic, strong) UIScrollView* scroll;

@end

@protocol CLPBrowserItemDelegate <NSObject>
//开始滑动
- (void)photoBrowserDragBeganWithItem:(CLPBrowserItem* )item;
//拖拽坐标变化
- (void)photoBrowserDragItem:(CLPBrowserItem* )item withPoint:(CGPoint)p1 locationPoint:(CGPoint)p2;
//结束拖拽
- (void)photoBrowserDragEndWithItem:(CLPBrowserItem* )item isDecelerate:(BOOL)decelerate;
//结束滑动
- (void)photoBrowserDecelerateWithItem:(CLPBrowserItem* )item;

- (void)photoBrowserSingleTapWithItem:(CLPBrowserItem* )item;

@end
