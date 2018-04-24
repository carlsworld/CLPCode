//
//  LZBrowserItem.h
//  _test_
//
//  Created by Carlson Lee on 2018/3/28.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LZBrowserItemDelegate;
@interface LZBrowserItem : UIView

@property (nonatomic, weak) id<LZBrowserItemDelegate> delegate;

@property (nonatomic, strong) id itemData;

@property (nonatomic, strong) UIScrollView* scroll;

@end

@protocol LZBrowserItemDelegate <NSObject>
//开始滑动
- (void)photoBrowserDragBeganWithItem:(LZBrowserItem* )item;
//拖拽坐标变化
- (void)photoBrowserDragItem:(LZBrowserItem* )item withPoint:(CGPoint)p1 locationPoint:(CGPoint)p2;
//结束拖拽
- (void)photoBrowserDragEndWithItem:(LZBrowserItem* )item isDecelerate:(BOOL)decelerate;
//结束滑动
- (void)photoBrowserDecelerateWithItem:(LZBrowserItem* )item;

- (void)photoBrowserSingleTapWithItem:(LZBrowserItem* )item;

@end
