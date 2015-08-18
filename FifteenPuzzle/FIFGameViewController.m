//
//  FIFMainScreenViewController.m
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/17/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import "FIFGameViewController.h"
#import "FIFMazeView.h"


@interface FIFGameViewController ()<FIFMazeDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet FIFMazeView *mazeView;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (nonatomic, assign) NSInteger numberOfSteps;

@end

static NSString *const kCachedFileName = @"mazeState.data";

static NSString *const kStepsKey = @"Steps";
static NSString *const kMazeKey = @"Maze";

@implementation FIFGameViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfSteps = 0;
    [self.mazeView setDelegate:self];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.mazeView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *tempDirectory = NSTemporaryDirectory();
    NSString *tempFile = [tempDirectory stringByAppendingPathComponent:kCachedFileName];
    
    NSDictionary *mazeState = [[NSDictionary alloc] initWithContentsOfFile:tempFile];
    self.numberOfSteps = [mazeState[kStepsKey] integerValue];
    [self.mazeView setMaze:mazeState[kMazeKey]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSDictionary *mazeState = @{kStepsKey: @(self.numberOfSteps),
                                kMazeKey: [self.mazeView getMaze]};
    NSString *tempDirectory = NSTemporaryDirectory();
    NSString *tempFile = [tempDirectory stringByAppendingPathComponent:kCachedFileName];
    [mazeState writeToFile:tempFile atomically:YES];
}

#pragma mark - Properties

- (void)setNumberOfSteps:(NSInteger)numberOfSteps {
    _numberOfSteps = numberOfSteps;
    [self.stepsLabel setText:[NSString stringWithFormat:@"Steps : %ld", (long)self.numberOfSteps]];
}

#pragma mark - Actions

- (IBAction)restartButton:(id)sender {
    self.numberOfSteps = 0;
    [self.mazeView resetMaze];
}

- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - FIFMaze Delegate

- (void)mazeCompleted {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                        message:[NSString stringWithFormat:@"You solved 15-Puzzle game with %ld steps", (long)self.numberOfSteps]
                                                       delegate:self
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (void)mazeChanged {
    self.numberOfSteps++;
}


#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        self.numberOfSteps = 0;
        [self.mazeView resetMaze];
    }
}

@end
