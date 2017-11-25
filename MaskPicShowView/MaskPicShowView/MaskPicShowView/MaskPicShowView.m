//
//  MaskPicShowView.m
//  MaskPicShowView
//
//  Created by Mac mini on 2017/11/24.
//  Copyright © 2017年 Azcdragon. All rights reserved.
//

#import "MaskPicShowView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenFull [UIScreen mainScreen].bounds

@interface MaskPicShowView()<UIScrollViewDelegate>

@property (nonatomic,assign) CGFloat offset;
@property (nonatomic,strong) UIScrollView *imageScrollView;
@property (nonatomic,assign) NSInteger seletedIndex;//只有一张图片填0;

@end


@implementation MaskPicShowView

+ (instancetype)maskPicShowImages:(NSArray<UIImage *> *)imageArrays seletedIndex:(NSInteger)seletedIndex{
    MaskPicShowView *maskView = [[MaskPicShowView alloc] initWithimages:imageArrays seletedIndex:seletedIndex];
    return maskView;
}

- (instancetype)initWithimages:(NSArray<UIImage *> *)imageArrays seletedIndex:(NSInteger)seletedIndex{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.seletedIndex = seletedIndex;
        [self addImageToSelf:imageArrays];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

- (void)addImageToSelf:(NSArray *)imageArrays{
    self.offset = 0.0;
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.imageScrollView.contentSize = CGSizeMake(ScreenWidth * imageArrays.count, ScreenHeight);
    self.imageScrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.imageScrollView.showsVerticalScrollIndicator = NO;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.bounces = NO;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.delegate = self;
    self.imageScrollView.contentOffset = CGPointMake(ScreenWidth * self.seletedIndex, 0);
    [self addSubview:self.imageScrollView];
    
    for (int i = 0; i < imageArrays.count; i++) {
        
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UIImage *image = imageArrays[i];
        CGSize size = image.size;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        CGSize changesize = [self makeSizeToScreen:size];
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, changesize.width, changesize.height);
        imageView.userInteractionEnabled = YES;
        imageView.tag = i+1;
        [imageView addGestureRecognizer:doubleTap];
        
        //        imageView.center = CGPointMake(ScreenWidth / 2 + (ScreenWidth * i), ScreenHeight / 2);
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:ScreenFull];
        s.center = CGPointMake(ScreenWidth / 2 + (ScreenWidth * i), ScreenHeight / 2);
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        s.tag = i+1;
        [s setZoomScale:1.0];
        imageView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
        [s addSubview:imageView];
        [self.imageScrollView addSubview:s];
    }
    
    
}
- (CGSize)makeSizeToScreen:(CGSize)size{
    CGSize retuSize;
    if (size.width > ScreenWidth || size.height > ScreenHeight) {
        if ((size.width / size.height) > (ScreenWidth / ScreenHeight)) {
            return  retuSize = CGSizeMake(ScreenWidth, ScreenWidth * size.height / size.width);
        }else{
            return  retuSize = CGSizeMake(ScreenHeight * size.width / size.height, ScreenHeight);
        }
    }
    return size;
}

#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    UIView *view = gesture.view.superview;
    if ([view isKindOfClass:[UIScrollView class]]){
        UIScrollView *s = (UIScrollView *)view;
        [s zoomToRect:zoomRect animated:YES];
    }
}

#pragma mark - Utility methods

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}
#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        if ([v isKindOfClass:[UIImageView class]]) {
            return v;
        }
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.imageScrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x==self.offset){
            
        }
        else {
            self.offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    UIImageView *image = [[s subviews] objectAtIndex:0];
                    image.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
                }
            }
        }
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"Did zoom!");
    UIView *v = [scrollView.subviews objectAtIndex:0];
    if ([v isKindOfClass:[UIImageView class]]){
        if (v.frame.size.width >= ScreenWidth && v.frame.size.height >= ScreenHeight) {
            v.center = CGPointMake(scrollView.contentSize.width/2.0, scrollView.contentSize.height/2.0);
        }else if (v.frame.size.width > ScreenWidth){
            v.center = CGPointMake(scrollView.contentSize.width/2.0, ScreenHeight / 2);
        }else if (v.frame.size.height > ScreenHeight){
            v.center = CGPointMake(ScreenWidth / 2, scrollView.contentSize.height/2.0);
        }else{
            v.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
        }
        
        if (scrollView.zoomScale<1.0){
        }
    }
}


@end
