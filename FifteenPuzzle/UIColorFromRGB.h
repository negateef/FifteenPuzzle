//
//  UIColorFromRGB.h
//  Slayt
//
//  Created by Dmitry Utenkov on 6/9/14.
//  Copyright (c) 2014 Coderivium. All rights reserved.
//


#ifndef Slayt_UIColorFromRGB_h
#define Slayt_UIColorFromRGB_h

// For example:
// UIColorFromRGBA(0xffee00, 0.5)
// UIColorFromRGB(0xffee00)

static inline UIColor *UIColorFromRGBAHex(int rgb, float a) {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0
                           green:((float)((rgb & 0xFF00) >> 8))/255.0
                            blue:((float)(rgb & 0xFF))/255.0 alpha:a];
}

static inline UIColor *UIColorFromRGBHex(int rgb) {
    return UIColorFromRGBAHex(rgb, 1.f);
}

static inline UIColor *UIColorFromRGB(int r, int g, int b) {
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}

static inline UIColor *UIColorFromRGBA(int r, int g, int b, float a) {
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

#endif
