//
//  RecipeView.h
//  iPadDianCan
//
//  Created by 李炜 on 13-4-24.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
@interface RecipeView : UIView
@property(nonatomic,retain)Recipe *recipe;
@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UILabel *rNameLabel;
@property(nonatomic,retain)UILabel *priceLabel;
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size;

@end
