
//
//  MIBrowserImageView.m
//  PhotoBrowser
//
//  Created by zc on 16/8/11.
//  Copyright © 2016年 zcDong. All rights reserved.
//

#import "MIBrowserImageView.h"
@interface MIBrowserImageView()
@property(nonatomic, strong) UIScrollView *scroll;
@property(nonatomic, strong) UIImageView *scrollImageView;
@property(nonatomic, strong) UIScrollView *zoomingScrollView;
@property(nonatomic, strong) UIImageView *zoomingImageView;
@property(nonatomic, assign) CGFloat totalScale;


@end
@implementation MIBrowserImageView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        _totalScale = 1.0;
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
        [self addGestureRecognizer:pinch];
    }
    return self;
}

- (BOOL)isScaled
{
    return  _totalScale != 1.0;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize imageSize = self.image.size;
    if (self.bounds.size.width * (imageSize.height / imageSize.width) > self.bounds.size.height) {
        if (!_scroll) {
            UIScrollView *scroll = [[UIScrollView alloc] init];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = self.image;
            _scrollImageView = imageView;
            [scroll addSubview:imageView];
            scroll.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
            _scroll = scroll;
            [self addSubview:scroll];
        }
        _scroll.frame = self.bounds;
        
        CGFloat imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
        _scrollImageView.bounds = CGRectMake(0, 0, _scroll.frame.size.width, imageViewH);
        _scrollImageView.center = CGPointMake(_scroll.frame.size.width * 0.5, _scrollImageView.frame.size.height * 0.5);
        _scroll.contentSize = CGSizeMake(0, _scrollImageView.bounds.size.height);
    } else {
        if (_scroll) [_scroll removeFromSuperview];
    }
}

- (void)zoomImage:(UIPinchGestureRecognizer *)gesture{
    [self prepareForImageViewScale];
    CGFloat scale = gesture.scale;
    CGFloat tmpScale = _totalScale+ scale - 1;
    [self setTotalScale:tmpScale];
    gesture.scale = 1.0;
}
- (void)setTotalScale:(CGFloat)totalScale
{
    if ((_totalScale < 0.5 && totalScale < _totalScale) || (_totalScale > 2.0 && totalScale > _totalScale)) return; // 最大缩放 2倍,最小0.5倍
    
    [self zoomWithScale:totalScale];
}
- (void)zoomWithScale:(CGFloat)scale{
    _totalScale = scale;
    _zoomingImageView.transform = CGAffineTransformMakeScale(scale, scale);
    
    if (scale > 1) {
        CGFloat contentW = _zoomingImageView.frame.size.width;
        CGFloat contentH = MAX(_zoomingImageView.frame.size.height, self.frame.size.height);
        
        _zoomingImageView.center = CGPointMake(contentW * 0.5, contentH * 0.5);
        _zoomingScrollView.contentSize = CGSizeMake(contentW, contentH);
        
        CGPoint offset = _zoomingScrollView.contentOffset;
        offset.x = (contentW - _zoomingScrollView.frame.size.width) * 0.5;
        _zoomingScrollView.contentOffset = offset;
        
    } else {
        _zoomingScrollView.contentSize = _zoomingScrollView.frame.size;
        _zoomingScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _zoomingImageView.center = _zoomingScrollView.center;
    }
}

- (void)prepareForImageViewScale{
    if (!_zoomingScrollView) {
        _zoomingScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _zoomingScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        _zoomingScrollView.contentSize = self.bounds.size;
        UIImageView *zoomingImageView = [[UIImageView alloc] initWithImage:self.image];
        CGSize imageSize = zoomingImageView.image.size;
        CGFloat imageViewH = self.bounds.size.height;
        if (imageSize.width > 0) {
            imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
        }
        zoomingImageView.bounds = CGRectMake(0, 0, self.bounds.size.width, imageViewH);
        zoomingImageView.center = _zoomingScrollView.center;
        zoomingImageView.contentMode = UIViewContentModeScaleAspectFit;
        _zoomingImageView = zoomingImageView;
        [_zoomingScrollView addSubview:zoomingImageView];
        [self addSubview:_zoomingScrollView];
    }
}

- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    
}

- (void)doubleTapToZoomWithScale:(CGFloat)scale{
    [self prepareForImageViewScale];
    [UIView animateWithDuration:0.5 animations:^{
        [self zoomWithScale:scale];
        
        
    } completion:^(BOOL finished) {
        if (scale == 1) {
            [self clear];
        }
    }];
}

- (void)clear{
    [_zoomingScrollView removeFromSuperview];
    _zoomingScrollView = nil;
    _zoomingImageView = nil;
}
@end
