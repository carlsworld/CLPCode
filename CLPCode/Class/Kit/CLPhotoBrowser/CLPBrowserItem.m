//
//  LZBrowserItem.m
//  _test_
//
//  Created by Carlson Lee on 2018/3/28.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//

#import "CLPBrowserItem.h"

@interface CLPBrowserItem ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) UIImageView* imgView;

@property (nonatomic,assign) BOOL doingPan;//正在拖拽
@property (nonatomic,assign) BOOL doingZoom;//正在缩放，此时不执行拖拽方法


/** 手势 */
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;//双击
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;//单击

@end

@implementation CLPBrowserItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self p_configure];
    }
    return self;
}

- (void)setItemData:(id)itemData
{
    _itemData = itemData;

    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_itemData[@"link"]]];
}

/**
 子类需要重写copy方法,自定义相关内容
 */
- (id)copy
{
    CLPBrowserItem* item = [[CLPBrowserItem alloc]initWithFrame:self.bounds];
    [item setItemData:_itemData];
    item.tag = self.tag;
    [item.scroll setScrollEnabled:NO];
    return item;
}

#pragma mark - Private

- (void)p_configure
{
    [self p_addSubviews];
    [self p_layout];
}

- (void)p_addSubviews
{
    [self addSubview:self.scroll];
    [self.scroll addSubview:self.bgView];
    [self.bgView addSubview:self.imgView];
}

- (void)p_layout
{
    self.scroll.frame = self.bounds;
    self.bgView.frame = self.scroll.bounds;
    self.imgView.frame = self.bgView.bounds;
    
    UIViewAutoresizing autoresizing = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.scroll.autoresizingMask = autoresizing;
    self.bgView.autoresizingMask = autoresizing;
    self.imgView.autoresizingMask = autoresizing;
}

#pragma mark - scrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.bgView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    self.doingZoom = YES;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    self.doingZoom = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!self.doingZoom){
        [self handlePanGes:scrollView.panGestureRecognizer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(self.doingZoom)return;
    if(!decelerate)self.doingPan = YES;
    if(_delegate && [_delegate respondsToSelector:@selector(photoBrowserDragEndWithItem:isDecelerate:)]){
        [_delegate photoBrowserDragEndWithItem:self isDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.doingPan = YES;
    if(_delegate && [_delegate respondsToSelector:@selector(photoBrowserDecelerateWithItem:)]){
        [_delegate photoBrowserDecelerateWithItem:self];
    }
}

#pragma mark - 拖动回调

- (void)handlePanGes:(UIPanGestureRecognizer* )pan
{
    if(self.scroll.zoomScale>1.0)return;
    if(pan.state == UIGestureRecognizerStateBegan){
        self.doingPan = YES;
        if(_delegate && [_delegate respondsToSelector:@selector(photoBrowserDragBeganWithItem:)]){
            [_delegate photoBrowserDragBeganWithItem:self];
        }
    }else if (pan.state == UIGestureRecognizerStateChanged){
        CGPoint o_p = [pan translationInView:self.scroll];
        CGPoint l_p = [pan locationInView:self];
        if(_delegate && [_delegate respondsToSelector:@selector(photoBrowserDragItem:withPoint:locationPoint:)]){
            [_delegate photoBrowserDragItem:self withPoint:o_p locationPoint:l_p];
        }
    }else if (pan.state == UIGestureRecognizerStatePossible || pan.state == UIGestureRecognizerStateEnded){
        
    }
}

#pragma mark - gestureAction

- (void)doSingleTap:(UITapGestureRecognizer *)recognizer
{
    if(_delegate && [_delegate respondsToSelector:@selector(photoBrowserSingleTapWithItem:)]){
        [_delegate photoBrowserSingleTapWithItem:self];
    }
}

- (void)doDoubleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scroll.zoomScale <= 1.0){
        CGFloat scaleX = touchPoint.x + self.scroll.contentOffset.x;
        CGFloat sacleY = touchPoint.y + self.scroll.contentOffset.y;
        [self.scroll zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    }else{
        [self.scroll setZoomScale:1.0 animated:YES]; //还原
    }
}

#pragma mark - Getter

- (UIScrollView *)scroll
{
    if(!_scroll){
        _scroll = [[UIScrollView alloc]init];
        _scroll.backgroundColor = [UIColor clearColor];//注意，背景是clearcolor
        _scroll.clipsToBounds = YES;
        _scroll.showsVerticalScrollIndicator = NO;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.minimumZoomScale = 1.0;
        _scroll.maximumZoomScale = 3.0;
        _scroll.zoomScale = 1.0;
        _scroll.delegate = self;
        _scroll.alwaysBounceVertical = YES;
        _scroll.alwaysBounceHorizontal = YES;
        _scroll.contentOffset = CGPointZero;
        _scroll.panGestureRecognizer.maximumNumberOfTouches = 1;
        _scroll.decelerationRate = 1.0;
        [_scroll addGestureRecognizer:self.singleTap];
        [_scroll addGestureRecognizer:self.doubleTap];
    }
    return _scroll;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap){
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired  =1;
    }
    return _doubleTap;
}

- (UITapGestureRecognizer *)singleTap
{
    if (!_singleTap){
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
        
    }
    return _singleTap;
}

- (UIView *)bgView
{
    if(!_bgView){
        _bgView = [UIView new];
        _bgView.userInteractionEnabled = NO;
    }
    return _bgView;
}

- (UIImageView *)imgView
{
    if(!_imgView){
        _imgView = [UIImageView new];
        [_imgView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _imgView;
}

@end
