//
//  CLPButton.m
//  CLPCode
//
//  Created by Carlson Lee on 2018/4/26.
//  Copyright © 2018年 Carlson Lee. All rights reserved.
//

#import "CLPButton.h"
#import "CLPCommonKit.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CLPButton ()
{
    UIFont* _font;
    UIColor* _nColor;
    UIColor* _sColor;
    NSString* _nTitle;
    NSString* _nImgStr;
    NSString* _sTitle;
    NSString* _sImgStr;
}

@property (nonatomic, strong) UILabel* lmLab;
@property (nonatomic, strong) UIImageView* lmImgView;

@end

@implementation CLPButton

+ (CLPButton* )buttonWithType:(CLPBTN_TYPE)type
{
    return [self buttonWithType:type direction:CLPBTN_DIRECTOR_HOC];
}

+ (CLPButton* )buttonWithType:(CLPBTN_TYPE)type direction:(CLPBTN_DIRECTOR )dir
{
    CLPButton* btn = [[self alloc]init];
    btn.direction = dir;
    btn.type = type;
    btn.corner = 0;
    btn.offset = 5*kScaleX;
    btn.imgSize = CGSizeZero;
    btn.alignment = NSTextAlignmentCenter;
    [btn p_configure];
    return btn;
}

+ (instancetype)new
{
    return [self buttonWithType:CLPBTN_TYPE_IT];
}

- (void)setImgColor:(UIColor *)imgColor
{
    _imgColor = imgColor;
    [self.lmImgView setBackgroundColor:_imgColor];
}

- (void)setNormalImgStr:(NSString* )imgStr titleStrs:(NSString* )str, ...
{
    _nImgStr = imgStr;
    _nTitle = str;
    if(str){
        va_list argList;
        va_start(argList, str);
        id arg;
        while ((arg = va_arg(argList, id))) {
            if([arg isKindOfClass:[UIColor class]]){
                _nColor = arg;
            }else if ([arg isKindOfClass:[UIFont class]]){
                _font = arg;
            }
        }
        va_end(argList);
    }
    if(_nColor)[self.lmLab setTextColor:_nColor];
    if(_font)[self.lmLab setFont:_font];
    if(_nTitle)self.lmLab.text = _nTitle;
    
    if(_nImgStr){
        if([_nImgStr hasPrefix:@"http"]){
            WEAK_SELF
            [self.lmImgView sd_setImageWithURL:[NSURL URLWithString:_nImgStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if(!error){
                    if(!wSelf.imgSize.width || !wSelf.imgSize.height){
                        wSelf.imgSize = image.size;
                    }
                    [wSelf setNeedsLayout];
                }
            }];
        }else if(_nImgStr && _nImgStr.length){
            UIImage* image = CLP_IMG(_nImgStr);
            self.imgSize = image.size;
            self.lmImgView.image = image;
        }else{
            self.lmImgView.image = [UIImage new];
        }
    }
    
    [self setNeedsLayout];
}

- (void)setSelectImgStr:(NSString* )imgStr titleStrs:(NSString* )str, ...
{
    _sImgStr = imgStr;
    _sTitle = str;
    if(str){
        va_list argList;
        va_start(argList, str);
        id arg;
        while ((arg = va_arg(argList, id))) {
            if([arg isKindOfClass:[UIColor class]]){
                _sColor = arg;
            }else if ([arg isKindOfClass:[UIFont class]]){
                _font = arg;
            }
        }
        va_end(argList);
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    if(_sColor)[self.lmLab setTextColor:_sColor];
    if(_sTitle)self.lmLab.text = _sTitle;
    return YES;
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event
{
    if(_nColor)[self.lmLab setTextColor:_nColor];
    if(_nTitle)self.lmLab.text = _nTitle;
}

#pragma mark - Private

- (void)p_configure
{
    [self p_addSubviews];
    [self p_layout];
}

- (void)p_addSubviews
{
    [self addSubview:self.lmLab];
    [self addSubview:self.lmImgView];
}

- (void)p_layout
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat f_x = 0;
    CGFloat f_y = 0;
    CGSize strSize = CLPSize(_nTitle, _font, CGSizeZero);
    CGFloat f_gap = _offset;
    switch (_type) {
        case CLPBTN_TYPE_T:{
            self.lmLab.frame = CGRectMake((kBounds.width-strSize.width)/2, (kBounds.height-strSize.height)/2, strSize.width, strSize.height);
        }
            break;
        case CLPBTN_TYPE_IT:{
            if(_direction == CLPBTN_DIRECTOR_HOC){
                f_gap = (_imgSize.width&&strSize.width)?_offset:0;
                CGFloat f_w = _imgSize.width+strSize.width+f_gap;
                if(_alignment == NSTextAlignmentLeft){
                    f_x = 0;
                }else if (_alignment == NSTextAlignmentCenter){
                    f_x = (kBounds.width-f_w)/2;
                }else{
                    f_x = kBounds.width-f_w;
                }
                self.lmImgView.frame = CGRectMake(f_x, (kBounds.height-_imgSize.height)/2, _imgSize.width, _imgSize.height);
                self.lmLab.frame = CGRectMake(CGRectGetMaxX(self.lmImgView.frame)+f_gap, (kBounds.height-strSize.height)/2, strSize.width, strSize.height);
            }else{
                f_gap = (_imgSize.height&&strSize.height)?_offset:0;
                CGFloat f_h = _imgSize.height+strSize.height+f_gap;
                f_y = (kBounds.height-f_h)/2;
                self.lmImgView.frame = CGRectMake((kBounds.width-_imgSize.width)/2, f_y, _imgSize.width, _imgSize.height);
                self.lmLab.frame = CGRectMake((kBounds.width-strSize.width)/2, CGRectGetMaxY(self.lmImgView.frame)+f_gap, strSize.width, strSize.height);
            }
            if(_corner>0){
                self.lmImgView.layer.cornerRadius = _corner;
                [self.lmImgView.layer setMasksToBounds:YES];
            }else if (_corner<0){
                self.lmImgView.layer.cornerRadius = _imgSize.width/2.0;
                [self.lmImgView.layer setMasksToBounds:YES];
            }
        }
            break;
        case CLPBTN_TYPE_TI:{//title+image
            if(_direction == CLPBTN_DIRECTOR_HOC){
                f_gap = (_imgSize.width&&strSize.width)?_offset:0;
                CGFloat f_w = _imgSize.width+strSize.width+f_gap;
                if(_alignment == NSTextAlignmentLeft){
                    f_x = 0;
                }else if (_alignment == NSTextAlignmentCenter){
                    f_x = (kBounds.width-f_w)/2;
                }else{
                    f_x = kBounds.width-f_w;
                }
                self.lmLab.frame = CGRectMake(f_x, (kBounds.height-strSize.height)/2, strSize.width, strSize.height);
                self.lmImgView.frame = CGRectMake(CGRectGetMaxX(self.lmLab.frame)+f_gap, (kBounds.height-_imgSize.height)/2, _imgSize.width, _imgSize.height);
            }else{
                f_gap = (_imgSize.width&&strSize.width)?_offset:0;
                CGFloat f_h = _imgSize.height+strSize.height+f_gap;
                f_y = (kBounds.height-f_h)/2;
                self.lmLab.frame = CGRectMake((kBounds.width-strSize.width)/2, f_y, strSize.width, strSize.height);
                self.lmImgView.frame = CGRectMake((kBounds.width-_imgSize.width)/2, CGRectGetMaxY(self.lmLab.frame)+f_gap, _imgSize.width, _imgSize.height);
            }
            if(_corner>0){
                self.lmImgView.layer.cornerRadius = _corner;
                [self.lmImgView.layer setMasksToBounds:YES];
            }else if (_corner<0){
                self.lmImgView.layer.cornerRadius = _imgSize.width/2.0;
                [self.lmImgView.layer setMasksToBounds:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Getter

- (UILabel *)lmLab
{
    if(!_lmLab){
        _lmLab = CLP_NEW_LABEL(nil, colorFromRGB(0xffffff), CLPFont(16, FONT_TYPE_REGULAR), NSTextAlignmentCenter, 1, nil);
    }
    return _lmLab;
}

- (UIImageView *)lmImgView
{
    if(!_lmImgView){
        _lmImgView = [UIImageView new];
    }
    return _lmImgView;
}

@end
