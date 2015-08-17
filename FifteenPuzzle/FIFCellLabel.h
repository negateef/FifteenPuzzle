//
//  FIFCellLabel.h
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/17/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FIFCellLabel : UILabel

@property (nonatomic, assign) NSInteger number;

- (void)updateColorWithRealCellNumber:(NSInteger)realNumber;

@end
