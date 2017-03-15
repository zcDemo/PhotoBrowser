//
//  ViewController.m
//  PhotoBrowser
//
//  Created by zc on 16/8/11.
//  Copyright © 2016年 zcDong. All rights reserved.
//

#import "ViewController.h"
#import "MIPhotoBrowser.h"

@interface ViewController ()<MIPhotoBrowserDelegate>
@property(nonatomic, strong) UIView *contentView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_contentView];
    
    for (NSInteger i = 0; i < 9; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 110  * (i % 3), 100 + 110 * (i /3), 100, 100)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        NSString *imageName = [NSString stringWithFormat:@"pic%d.jpg", i];
        imageView.image = [UIImage imageNamed:imageName];
        [_contentView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
    }
    
    for (id view in self.view.subviews) {
        NSLog(@"subview = %@", view);
    }
  
}

- (void)tapAction:(UIGestureRecognizer *)gesture{
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSLog(@"image view = %@", imageView);
    MIPhotoBrowser *photoBrowser = [[MIPhotoBrowser alloc] init];
    photoBrowser.delegate = self;
    photoBrowser.sourceImagesContainerView = _contentView;
    photoBrowser.imageCount = 9;
    photoBrowser.currentImageIndex = imageView.tag;
    [photoBrowser show];
    NSLog(@"tap action   tag = %d", imageView.tag);
}

- (UIImage *)photoBrowser:(MIPhotoBrowser *)photoBrowser placeholderImageForIndex:(NSInteger)index{
    NSLog(@"photobrowser index = %d", index);
    UIImageView *imageView = _contentView.subviews[index];
    return imageView.image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
