//
//  FIFMainScreenViewController.m
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/17/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import "FIFMainScreenViewController.h"
#import "FIFMazeView.h"


@interface FIFMainScreenViewController ()

@property (weak, nonatomic) IBOutlet FIFMazeView *mazeView;

@end

@implementation FIFMainScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)restartButton:(id)sender {
    [self.mazeView resetMaze];
}

@end
