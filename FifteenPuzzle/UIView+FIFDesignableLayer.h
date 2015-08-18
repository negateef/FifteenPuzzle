//
//  UIView+FIFDesignable.h
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/18/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIView (FIFDesignableLayer)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@end
