//
//  FCPhotoBrowserCell.m
//  FastCall
//
//  Created by Carlson Lee on 2018/1/22.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//

#import "LZPhotoBrowserCell.h"

@implementation LZPhotoBrowserCell

- (void)setItemData:(id)itemData
{
    _itemData = itemData;
    self.browserItem.itemData = _itemData;
}

#pragma mark - Getter

- (LZBrowserItem *)browserItem
{
    if(!_browserItem){
        _browserItem = [[LZBrowserItem alloc]init];
        [self.contentView addSubview:_browserItem];
        
        [_browserItem mas_makeConstraints:^(MASConstraintMaker *make) {
           	make.edges.mas_equalTo(self.contentView);
        }];
    }
    return _browserItem;
}


@end
