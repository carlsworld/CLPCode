//
//  ViewController.m
//  LZCode
//
//  Created by Carlson Lee on 2018/4/24.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//

#import "ViewController.h"
#import "CLPhotoBrowser.h"

@interface ViewController ()
{
    NSMutableArray* _mArr;
}
@property (nonatomic, strong) UILabel* tipLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray* photos = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522800019482&di=3aafd314cc329e8cbbcf85d60ca200bc&imgtype=0&src=http%3A%2F%2Fu.thsi.cn%2Ffileupload%2Fdata%2FInput%2F2012%2F12%2F25%2F23166197e14cabce3ad99b27c223107c.jpg", @"http://kuaihu.xnsudai.com/album/28317/2de6f98e98d643f1afa65873a41f27e2.jpg", @"http://kuaihu.xnsudai.com/album/28317/ef1d0a4ec3794f59bffa2716c60b1be7.jpg", @"http://kuaihu.xnsudai.com/album/28317/04f444f2a50746fb84e71229a6251dd5.jpg"];
    _mArr = @[].mutableCopy;
    CGFloat f_w = (kScreen.width - 40*kScaleX)/3;
    for(int i=0; i<photos.count; i++){
        CGRect rect = CGRectMake(10*kScaleX+i%3*(f_w+10*kScaleX), 100+i/3*(f_w+10*kScaleX), f_w, f_w);
        UIImageView* imgView = [UIImageView new];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView sd_setImageWithURL:[NSURL URLWithString:photos[i]]];
        imgView.frame = rect;
        [self.view addSubview:imgView];
        [imgView.layer setMasksToBounds:YES];
        [imgView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [imgView.layer setBorderWidth:.5];
        imgView.userInteractionEnabled = YES;
        imgView.tag = i;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnSelect:)];
        [imgView addGestureRecognizer:tap];
        NSDictionary* mdic = @{@"link":photos[i], @"rect":@(rect)};
        [_mArr addObject:mdic];
    }
}

- (void)btnSelect:(UITapGestureRecognizer* )tap
{
    UIImageView* imgView = (UIImageView* )tap.view;
    [CLPhotoBrowser showItems:_mArr atIndex:imgView.tag];
}

- (UILabel *)tipLab
{
    if(!_tipLab){
        
    }
    return _tipLab;
}

@end
