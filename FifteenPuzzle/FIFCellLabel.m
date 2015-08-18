//
//  FIFCellLabel.m
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/17/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import "FIFCellLabel.h"
#import "UIColorFromRGB.h"

@interface FIFCellLabel ()

@property (nonatomic, strong) NSDictionary *colors;

@end

@implementation FIFCellLabel

#pragma mark - View lifecycle

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
    UIFont *font = [UIFont systemFontOfSize:self.font.pointSize + 2];
    self.font = font;
    [self setUserInteractionEnabled:YES];
    self.colors = @{@(0): UIColorFromRGBHex(0x4caf50),
                    @(1): UIColorFromRGBHex(0xcddc39),
                    @(2): UIColorFromRGBHex(0xffeb3b),
                    @(3): UIColorFromRGBHex(0xff9800),
                    @(4): UIColorFromRGBHex(0xef6c00),
                    @(5): UIColorFromRGBHex(0xf44336),
                    @(6): UIColorFromRGBHex(0xb71c1c)};
}

#pragma mark - Properties


- (void)setNumber:(NSInteger)number {
    _number = number;
    if (number != -1)
        [self setText:[NSString stringWithFormat:@"%lu", (long)number]];
    else
        [self setText:@""];
}

#pragma mark - Interface methods

- (void)updateColorWithRealCellNumber:(NSInteger)realNumber {
    NSInteger distance = labs(((realNumber - 1) % 4) - ((self.number - 1) % 4)) + labs(((realNumber - 1) / 4) - ((self.number - 1) / 4));
    self.layer.backgroundColor = ((UIColor *)self.colors[@(distance)]).CGColor;
}


@end
