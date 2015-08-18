//
//  FIFCellLabel.m
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/17/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import "FIFCellLabel.h"

static const NSInteger maxDistance = 6;

@implementation FIFCellLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setNumberOfLines:1];
    [self setAdjustsFontSizeToFitWidth:YES];
    [self setUserInteractionEnabled:YES];
}


- (void)setNumber:(NSInteger)number {
    _number = number;
    if (number != -1)
        [self setText:[NSString stringWithFormat:@"%lu", (long)number]];
    else
        [self setText:@""];
}

- (void)updateColorWithRealCellNumber:(NSInteger)realNumber {
    NSInteger distance = labs(((realNumber - 1) % 4) - ((self.number - 1) % 4)) + labs(((realNumber - 1) / 4) - ((self.number - 1) / 4));
    CGFloat red = (1.0 / maxDistance) * distance;
    CGFloat green = 1.0 - (1.0 / maxDistance) * distance;
    self.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:0.0 alpha:1.0].CGColor;
//    self.backgroundColor = [UIColor colorWithRed:red green:green blue:0.0 alpha:1.0];
}


@end
