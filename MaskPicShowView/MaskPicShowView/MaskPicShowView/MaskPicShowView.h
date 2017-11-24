//
//  MaskPicShowView.h
//  MaskPicShowView
//
//  Created by Mac mini on 2017/11/24.
//  Copyright © 2017年 Azcdragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskPicShowView : UIView

/**
 构建方法
 
 @param imageArrays 图片数组（不支持链接）
 @param seletedIndex 当前显示第几个
 @return 创建的对象
 */
+ (instancetype)maskPicShowImages:(NSArray *)imageArrays seletedIndex:(NSInteger)seletedIndex;

- (instancetype)initWithimages:(NSArray *)imageArrays seletedIndex:(NSInteger)seletedIndex;

@end
