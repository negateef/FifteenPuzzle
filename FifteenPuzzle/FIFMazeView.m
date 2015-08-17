//
//  FIFMazeView.m
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/17/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import "FIFMazeView.h"
#import "FIFCellLabel.h"
#import "NSMutableArray+FIFShuffling.h"

@interface FIFMazeView()

@property (nonatomic, strong) NSMutableArray *mazeState;

@end

@implementation FIFMazeView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self generateMaze];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self generateMaze];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self generateMaze];
    }
    return self;
}

- (instancetype)initWithMazeState:(NSMutableArray *)mazeState {
    self = [super init];
    if (self) {
        self.mazeState = mazeState;
    }
    return self;
}


- (void)generateMaze {
    
    self.mazeState = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 1; i <= 15; i++) {
        FIFCellLabel *cellLabel = [[FIFCellLabel alloc] init];
        cellLabel.number = i;
        
        [self.mazeState addObject:cellLabel];
    }
    
    FIFCellLabel *cellLabel = [[FIFCellLabel alloc] init];
    cellLabel.number = -1;
    
    [self.mazeState addObject:cellLabel];
    
    [self.mazeState shuffle];
}

- (void)drawRect:(CGRect)rect {
    self.cellSize = MIN(self.cellSize, self.frame.size.width / 4.0);
    self.cellSize = MIN(self.cellSize, self.frame.size.height / 4.0);
    
    CGFloat freeWidth = (self.frame.size.width - 4 * self.cellSize) / 3.0;
    CGFloat freeHeight = (self.frame.size.height - 4 * self.cellSize) / 3.0;
    
    for (NSInteger row = 0; row < 4; row++) {
        for (NSInteger col = 0; col < 4; col++) {
            NSInteger index = row * 4 + col;
            FIFCellLabel *cellLabel = self.mazeState[index];
            [cellLabel setFrame:CGRectMake(self.cellSize * col + freeWidth * col, self.cellSize * row + freeHeight * row, self.cellSize, self.cellSize)];
            
            if (cellLabel.number != -1)
                [cellLabel updateColorWithRealCellNumber:index];
            [self addSubview:cellLabel];
            
        }
    }
}

- (void)resetMaze {
    for (NSInteger i = 0; i < self.mazeState.count; i++) {
        [self.mazeState[i] removeFromSuperview];
    }
    [self generateMaze];
    [self setNeedsDisplay];
}

@end
