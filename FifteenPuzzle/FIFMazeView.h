//
//  FIFMazeView.h
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/17/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FIFMazeDelegate <NSObject>

- (void)mazeChanged;

@end

IB_DESIGNABLE
@interface FIFMazeView : UIView

@property (nonatomic, assign) IBInspectable CGFloat cellSize;
@property (nonatomic, weak) id<FIFMazeDelegate> delegate;

- (void)resetMaze;

@end
