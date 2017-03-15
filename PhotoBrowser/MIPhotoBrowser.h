//
//  MIPhotoBrowser.h
//  PhotoBrowser
//
//  Created by zc on 16/8/11.
//  Copyright © 2016年 zcDong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MIPhotoBrowser;
@protocol MIPhotoBrowserDelegate <NSObject>
- (UIImage *)photoBrowser:(MIPhotoBrowser *)photoBrowser placeholderImageForIndex:(NSInteger)index;
@end
@interface MIPhotoBrowser : UIView <UIScrollViewDelegate>
@property(nonatomic, strong) UIView *sourceImagesContainerView;
@property(nonatomic, assign) NSInteger currentImageIndex;
@property(nonatomic, assign) NSInteger imageCount;
@property(nonatomic, weak) id<MIPhotoBrowserDelegate> delegate;
- (void)show;
@end
