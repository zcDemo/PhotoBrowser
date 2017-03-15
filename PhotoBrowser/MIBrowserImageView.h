//
//  MIBrowserImageView.h
//  PhotoBrowser
//
//  Created by zc on 16/8/11.
//  Copyright © 2016年 zcDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIBrowserImageView : UIImageView
@property(nonatomic, assign) BOOL isScaled;

- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)doubleTapToZoomWithScale:(CGFloat)scale;
@end
