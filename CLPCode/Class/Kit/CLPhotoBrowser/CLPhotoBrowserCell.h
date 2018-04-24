//
//  FCPhotoBrowserCell.h
//  FastCall
//
//  Created by Carlson Lee on 2018/1/22.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPBrowserItem.h"

@interface CLPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, strong) id itemData;

@property (nonatomic, strong) CLPBrowserItem* browserItem;


@end

