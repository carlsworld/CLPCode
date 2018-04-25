//
//  FCPhotoBrowserCell.m
//  FastCall
//
//  Created by Carlson Lee on 2018/1/22.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//

#import "CLPhotoBrowserCell.h"

@implementation CLPhotoBrowserCell

- (void)setItemData:(id)itemData
{
    _itemData = itemData;
    self.browserItem.itemData = _itemData;
}

#pragma mark - Getter

- (CLPBrowserItem *)browserItem
{
    if(!_browserItem){
        _browserItem = [[CLPBrowserItem alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:_browserItem];
    }
    return _browserItem;
}

@end
