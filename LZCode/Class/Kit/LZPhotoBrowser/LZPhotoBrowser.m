//
//  FCPhotoBrowser.m
//  FastCall
//
//  Created by Carlson Lee on 2018/1/22.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//

#import "LZPhotoBrowser.h"
#import "LZPhotoBrowserCell.h"

@interface LZPhotoBrowser ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LZBrowserItemDelegate>
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

@property (nonatomic, strong) LZBrowserItem *dragItem;

@end


#define DRAG_MAX 250.f
@implementation LZPhotoBrowser

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self p_configure];
    }
    return self;
}

+ (void)showItems:(NSArray* )items atIndex:(NSInteger)index
{
    LZPhotoBrowser* browser = [[LZPhotoBrowser alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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
   	[self.collection setContentSize:CGSizeMake(kScreen.width*_items.count, 0)];
	[self.collection setContentOffset:CGPointMake(kScreen.width*_currentIndex, 0)];
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
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       	make.edges.mas_equalTo(self);
    }];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
       	make.edges.mas_equalTo(self);
    }];
}

#pragma mark - # FCPhotoBrowserCellDelegate

- (void)photoBrowserSingleTapWithItem:(LZBrowserItem *)item
{
    CGRect rect =  CGRectZero;
    id tem = self.items[_currentIndex];
    if([tem valueForKey:@"rect"] && [tem[@"rect"] isKindOfClass:[NSValue class]]){
        rect = [tem[@"rect"] CGRectValue];
    }
	if(rect.size.width){//如果当前item设置了frame，则创建一个item用于缩放
        [self photoBrowserDragBeganWithItem:item];
        [self layoutIfNeeded];
        [self.bgView setAlpha:0];
    }

    [UIView animateWithDuration:.25 animations:^{
        if(rect.size.width){
            [self.dragItem mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(rect.origin.y);
                make.left.mas_offset(rect.origin.x);
                make.width.mas_equalTo(rect.size.width);
                make.height.mas_equalTo(rect.size.height);
            }];
            [self layoutIfNeeded];
        }else{
            [_bgView setAlpha:0];
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
    _currentIndex = f_x/kScreen.width;
    if(_currentIndex != _lastIndex && f_x == kScreen.width*_currentIndex){
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:_lastIndex inSection:0];
        LZPhotoBrowserCell* cell = (LZPhotoBrowserCell* )[self.collection cellForItemAtIndexPath:indexPath];
        cell.browserItem.scroll.zoomScale = 1.0;
        _lastIndex = _currentIndex;
    }
}

- (void)photoBrowserDragBeganWithItem:(LZBrowserItem *)item
{
    if(!_dragItem){
        LZBrowserItem* dragItem = [item copy];
        [self addSubview:dragItem];
        self.dragItem = dragItem;
        _dragMax = DRAG_MAX;
        _originSize = item.bounds.size;
        [dragItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.mas_offset(0);
            make.width.mas_equalTo(_originSize.width);
            make.height.mas_equalTo(_originSize.height);
        }];
    }
}

- (void)photoBrowserDragItem:(LZBrowserItem *)item withPoint:(CGPoint)p1 locationPoint:(CGPoint)p2
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
            [self.dragItem mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(scale_height*_scaleY+p1.y);
                make.left.mas_offset(scale_width*_scaleX+p1.x);
                make.width.mas_equalTo(item_width);
                make.height.mas_equalTo(item_height);
            }];
        }else{
            [self.dragItem mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(0);
                make.left.mas_offset(scale_width*_scaleX+p1.x);
                make.width.mas_equalTo(_originSize.width);
                make.height.mas_equalTo(_originSize.height);
            }];
        }
    }else{
        [self photoBrowserDragBeganWithItem:item];
    }
	
}

- (void)photoBrowserDragEndWithItem:(LZBrowserItem *)item isDecelerate:(BOOL)decelerate
{
    if(_progress>1.0){//超过最大拖动
        CGRect rect =  CGRectZero;
        id tem = self.items[_currentIndex];
        if([tem valueForKey:@"rect"] && [tem[@"rect"] isKindOfClass:[NSValue class]]){
            rect = [tem[@"rect"] CGRectValue];
        }
        [UIView animateWithDuration:.25 animations:^{
            if(rect.size.width){
                [self.dragItem mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_offset(rect.origin.y);
                    make.left.mas_offset(rect.origin.x);
                    make.width.mas_equalTo(rect.size.width);
                    make.height.mas_equalTo(rect.size.height);
                }];
                [self layoutIfNeeded];
            }else{
             	[_dragItem setAlpha:0];
            }
        } completion:^(BOOL finished) {
            [_dragItem removeFromSuperview];
            _dragItem = nil;
            [self removeFromSuperview];
        }];
    }else{
        [UIView animateWithDuration:.25 animations:^{
            [self.bgView setAlpha:1.0];
            [self.dragItem mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(0);
                make.left.mas_offset(0);
                make.width.mas_equalTo(_originSize.width);
                make.height.mas_equalTo(_originSize.height);
            }];
            [self layoutIfNeeded];
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

- (void)photoBrowserDecelerateWithItem:(LZBrowserItem *)item
{
    [self.dragItem removeFromSuperview];
    self.dragItem = nil;
    self.collection.scrollEnabled = YES;
    self.collection.alpha = 1.0;
    [self.bgView setBackgroundColor:colorFromRGBA(0x000000, 1)];
}

#pragma mark - # UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collection.frame.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LZPhotoBrowserCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo_browser_cell" forIndexPath:indexPath];
    cell.itemData = _items[indexPath.row];
    cell.browserItem.delegate = self;
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
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        _collection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        [_collection setBackgroundColor:[UIColor clearColor]];
        [_collection registerClass:[LZPhotoBrowserCell class] forCellWithReuseIdentifier:@"photo_browser_cell"];
        [_collection setPagingEnabled:YES];
 		
        [_collection setShowsVerticalScrollIndicator:NO];
        [_collection setShowsHorizontalScrollIndicator:NO];
        _collection.delegate = self;
        _collection.dataSource = self;
    }
    return _collection;
}

- (LZBrowserItem *)dragItem
{
    if(!_dragItem){
        _dragItem = [[LZBrowserItem alloc]init];
    }
    return _dragItem;
}

@end
