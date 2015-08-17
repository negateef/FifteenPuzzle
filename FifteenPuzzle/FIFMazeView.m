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
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self generateMaze];
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self generateMaze];
        [self customInit];
    }
    return self;
}

- (instancetype)initWithMazeState:(NSMutableArray *)mazeState {
    self = [super init];
    if (self) {
        self.mazeState = mazeState;
        [self customInit];
    }
    return self;
}

- (void)customInit {
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:leftRecognizer];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [upRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:upRecognizer];
    
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [downRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self addGestureRecognizer:downRecognizer];
    
    for (NSInteger i = 0; i < self.mazeState.count; i++)
         [self addSubview:self.mazeState[i]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
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
                [cellLabel updateColorWithRealCellNumber:index + 1];
        }
    }

}


#pragma mark - Actions

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    NSInteger blankIndex = [self indexOfCellWithNumber:-1];
    NSInteger row = blankIndex / 4;
    NSInteger col = blankIndex % 4;
    
    NSInteger prevRow = row;
    NSInteger prevCol = col;
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        prevRow++;
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        prevRow--;
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        prevCol++;
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        prevCol--;
    }
    
    if (prevRow >= 0 && prevRow < 4 && prevCol >= 0 && prevCol < 4) {
        NSInteger prevIndex = prevRow * 4 + prevCol;
        [self moveCellWithIndex:prevIndex toIndex:blankIndex];
    }
}

- (void)cellTapped:(UITapGestureRecognizer *)recognizer {
    FIFCellLabel *cellLabel = (FIFCellLabel *)recognizer.view;
    NSInteger blankIndex = [self indexOfCellWithNumber:-1];
    NSInteger row = blankIndex / 4;
    NSInteger col = blankIndex % 4;
    
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.mazeState.count; i++)
        if (cellLabel == self.mazeState[i])
            index = i;
    
    NSInteger prevRow = index / 4;
    NSInteger prevCol = index % 4;
    
    if (labs(row - prevRow) + labs(col - prevCol) == 1)
        [self moveCellWithIndex:index toIndex:blankIndex];
}

#pragma mark - Interface

- (void)resetMaze {
    [self generateMaze];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


#pragma mark - Helper methods

- (void)moveCellWithIndex:(NSInteger)prevIndex toIndex:(NSInteger)newIndex {
    [self.delegate mazeChanged];
    [self.mazeState exchangeObjectAtIndex:prevIndex withObjectAtIndex:newIndex];
    [UIView animateWithDuration:0.3 animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if ([self completed]) {
            [self.delegate mazeCompleted];
        }
    }];
}

- (NSInteger)indexOfCellWithNumber:(NSInteger)number {
    for (NSInteger i = 0; i < self.mazeState.count; i++)
        if ([self.mazeState[i] number] == number)
            return i;
    return -1;
}

- (void)generateMaze {
    if (!self.mazeState) {
        self.mazeState = [[NSMutableArray alloc] init];
        for (NSInteger i = 1; i <= 15; i++) {
            FIFCellLabel *cellLabel = [[FIFCellLabel alloc] init];
            cellLabel.number = i;
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
            [cellLabel addGestureRecognizer:tapRecognizer];
            
            [self.mazeState addObject:cellLabel];
        }
        FIFCellLabel *cellLabel = [[FIFCellLabel alloc] init];
        cellLabel.number = -1;
        [self.mazeState addObject:cellLabel];
    }
    
    do {
        [self.mazeState shuffle];
    } while (![self solvable]);
}

- (BOOL)solvable {
    NSInteger inversions = 0;
    for (NSInteger i = 0; i < self.mazeState.count; i++) {
        for (NSInteger j = 0; j < i; j++) {
            NSInteger firstNumber = [self.mazeState[i] number];
            NSInteger secondNumber = [self.mazeState[j] number];
            if (firstNumber != -1 && secondNumber != -1 && secondNumber > firstNumber)
                inversions++;
        }
    }
    
    NSInteger blankIndex = [self indexOfCellWithNumber:-1];
    NSInteger row = blankIndex / 4 + 1;
    return (inversions + row) % 2 == 0;
}

- (BOOL)completed {
    for (NSInteger i = 0; i < 15; i++)
        if ([self.mazeState[i] number] != i + 1)
            return NO;
    return YES;
}



@end
