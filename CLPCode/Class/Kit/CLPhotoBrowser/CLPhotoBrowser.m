//
//  FCPhotoBrowser.m
//  FastCall
//
//  Created by Carlson Lee on 2018/1/22.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//

#import "CLPhotoBrowser.h"
#import "CLPhotoBrowserCell.h"
#import "CLPSystemMacro.h"

@interface CLPhotoBrowser ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLPBrowserItemDelegate>
{
    NSInteger _lastIndex;
    CGFloat _dragMax;
    CGFloat _progress;
    
    CGFloat _scaleX;
    CGFloat _scaleY;
    CGSize _originSize;
}

@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) UICollectionView* collection;
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) CLPBrowserItem *dragItem;

@end


#define DRAG_MAX 250.f
@implementation CLPhotoBrowser

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self p_configure];
    }
    return self;
}

+ (void)showItems:(NSArray* )items atIndex:(NSInteger)index
{
    CLPhotoBrowser* browser = [[CLPhotoBrowser alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    browser.items = items;
    browser.currentIndex = index;
    [browser showBrowser];
}

- (void)showBrowser
{
    if(!self.superview){
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self setAlpha:0];
        
        [UIView animateWithDuration:.25 animations:^{
            self.alpha = 1.0;
        }];
    }
   	[self.collection setContentSize:CGSizeMake(CGRectGetWidth(self.bounds)*_items.count, 0)];
	[self.collection setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*_currentIndex, 0)];
}

#pragma mark - # Private

- (void)p_configure
{
    [self p_addSubviews];
    [self p_layout];
}

- (void)p_addSubviews
{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.collection];
}

- (void)p_layout
{
    self.bgView.frame = self.bounds;
    self.collection.frame = self.bounds;
}

#pragma mark - # FCPhotoBrowserCellDelegate

- (void)photoBrowserSingleTapWithItem:(CLPBrowserItem *)item
{
    CGRect rect =  CGRectZero;
    id tem = self.items[item.tag];
    if([tem valueForKey:@"rect"] && [tem[@"rect"] isKindOfClass:[NSValue class]]){
        rect = [tem[@"rect"] CGRectValue];
    }
	if(rect.size.width){//如果当前item设置了frame，则创建一个item用于缩放
        [self photoBrowserDragBeganWithItem:item];
        [self.bgView setAlpha:0];
    }
	
    [UIView animateWithDuration:.25 animations:^{
        if(rect.size.width){
            self.dragItem.frame = rect;
        }else{
            [self.bgView setAlpha:0];
        }
    } completion:^(BOOL finished) {
        if(finished){
            [self removeFromSuperview];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat f_x = scrollView.contentOffset.x;
    _currentIndex = f_x/CGRectGetWidth(self.bounds);
    if(_currentIndex != _lastIndex && f_x == CGRectGetWidth(self.bounds)*_currentIndex){
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:_lastIndex inSection:0];
        CLPhotoBrowserCell* cell = (CLPhotoBrowserCell* )[self.collection cellForItemAtIndexPath:indexPath];
        cell.browserItem.scroll.zoomScale = 1.0;
        _lastIndex = _currentIndex;
    }
}

- (void)photoBrowserDragBeganWithItem:(CLPBrowserItem *)item
{
    if(!_dragItem){
        CLPBrowserItem* dragItem = [item copy];
        [self addSubview:dragItem];
        self.dragItem = dragItem;
        _dragMax = DRAG_MAX;
        _originSize = item.bounds.size;
        dragItem.frame = CGRectMake(0, 0, _originSize.width, _originSize.height);
    }
}

- (void)photoBrowserDragItem:(CLPBrowserItem *)item withPoint:(CGPoint)p1 locationPoint:(CGPoint)p2
{
    if(self.collection.alpha>.1){
        self.collection.alpha = 0;
    }
    if(_dragItem){
        _progress = p1.y/_dragMax;
        [self.bgView setAlpha:1-(_progress>1?1:(_progress<0?0:_progress))];
        CGFloat itemProgress = p1.y/_originSize.height;
        if(!_scaleX)_scaleX = p2.x/CGRectGetWidth(item.frame);
        if(!_scaleY)_scaleY = p2.y/CGRectGetHeight(item.frame);
        CGFloat scale_width = 0;
        CGFloat scale_height = 0;
        CGFloat maxScale = _dragMax/_originSize.height;
        if(itemProgress > 0){
            if(itemProgress>maxScale)itemProgress = maxScale;
            scale_width = _originSize.width*itemProgress;
            scale_height = _originSize.height*itemProgress;
            CGFloat item_width = _originSize.width-scale_width;
            CGFloat item_height = _originSize.height-scale_height;
            self.dragItem.frame = CGRectMake(scale_width*_scaleX+p1.x, scale_height*_scaleY+p1.y, item_width, item_height);
        }else{
            self.dragItem.frame = CGRectMake(scale_width*_scaleX+p1.x, 0, _originSize.width, _originSize.height);
        }
    }else{
        [self photoBrowserDragBeganWithItem:item];
    }
	
}

- (void)photoBrowserDragEndWithItem:(CLPBrowserItem *)item isDecelerate:(BOOL)decelerate
{
    if(_progress>1.0){//超过最大拖动
        CGRect rect =  CGRectZero;
        id tem = self.items[item.tag];
        if([tem valueForKey:@"rect"] && [tem[@"rect"] isKindOfClass:[NSValue class]]){
            rect = [tem[@"rect"] CGRectValue];
        }
        [UIView animateWithDuration:.25 animations:^{
            if(rect.size.width){
                self.dragItem.frame = rect;
            }else{
             	[self.dragItem setAlpha:0];
            }
        } completion:^(BOOL finished) {
            [self.dragItem removeFromSuperview];
            self.dragItem = nil;
            [self removeFromSuperview];
        }];
    }else{
        [UIView animateWithDuration:.25 animations:^{
            [self.bgView setAlpha:1.0];
            self.dragItem.frame = CGRectMake(0, 0, _originSize.width, _originSize.height);
        } completion:^(BOOL finished) {
            if(finished && !decelerate){
                [self photoBrowserDecelerateWithItem:item];
            }
        }];
    }
    _scaleX = 0;
    _scaleY = 0;
    _progress = 0;
}

- (void)photoBrowserDecelerateWithItem:(CLPBrowserItem *)item
{
    [self.dragItem removeFromSuperview];
    self.dragItem = nil;
    self.collection.scrollEnabled = YES;
    self.collection.alpha = 1.0;
    [self.bgView setBackgroundColor:[UIColor blackColor]];
}

#pragma mark - # UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = self.collection.frame.size;
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CLPhotoBrowserCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo_browser_cell" forIndexPath:indexPath];
    cell.itemData = _items[indexPath.row];
    cell.browserItem.delegate = self;
    cell.browserItem.tag = indexPath.row;
    return cell;
}

#pragma mark - # Getter

- (UIView *)bgView
{
    if(!_bgView){
        _bgView = [UIView new];
        [_bgView setBackgroundColor:[UIColor blackColor]];
    }
    return _bgView;
}

-(UICollectionView *)collection
{
    if(!_collection){
        UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.sectionInset = UIEdgeInsetsZero;
        flow.minimumLineSpacing = 30*kScaleX;
        flow.minimumInteritemSpacing = 30*kScaleX;
        _collection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        [_collection setBackgroundColor:[UIColor clearColor]];
        [_collection registerClass:[CLPhotoBrowserCell class] forCellWithReuseIdentifier:@"photo_browser_cell"];
        [_collection setPagingEnabled:YES];
 		
        [_collection setShowsVerticalScrollIndicator:NO];
        [_collection setShowsHorizontalScrollIndicator:NO];
        _collection.delegate = self;
        _collection.dataSource = self;
    }
    return _collection;
}

- (CLPBrowserItem *)dragItem
{
    if(!_dragItem){
        _dragItem = [[CLPBrowserItem alloc]init];
    }
    return _dragItem;
}

@end
