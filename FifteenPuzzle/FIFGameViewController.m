//
//  FIFMainScreenViewController.m
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/17/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import "FIFGameViewController.h"
#import "FIFMazeView.h"
#import "FIFPopupViewController.h"
#import "FIFStandingsManager.h"


@interface FIFGameViewController ()<FIFMazeDelegate, FIFPopupViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet FIFMazeView *mazeView;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (nonatomic, assign) NSInteger numberOfSteps;

@property (nonatomic, strong) FIFPopupViewController *popup;
@property (nonatomic, strong) UIVisualEffectView *blurredView;

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
    
    self.popup = [[FIFPopupViewController alloc] init];
    [self addChildViewController:self.popup];
    
    CGRect popupFrame = self.popup.view.frame;
    popupFrame.origin = CGPointMake((self.view.frame.size.width - popupFrame.size.width) / 2.0, (self.view.frame.size.height - popupFrame.size.height) / 2.0);
    self.popup.view.frame = popupFrame;
    self.popup.delegate = self;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.blurredView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.blurredView.frame = self.view.frame;
    self.blurredView.alpha = 0.0;
    self.popup.view.alpha = 0.0;
    
    [self.view addSubview:self.blurredView];
    [self.view addSubview:self.popup.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tempDirectory = [paths firstObject];
    NSString *tempFile = [tempDirectory stringByAppendingPathComponent:kCachedFileName];
    
    NSDictionary *mazeState = [[NSDictionary alloc] initWithContentsOfFile:tempFile];
    if (mazeState) {
        self.numberOfSteps = [mazeState[kStepsKey] integerValue];
        [self.mazeView setMaze:mazeState[kMazeKey]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSDictionary *mazeState = @{kStepsKey: @(self.numberOfSteps),
                                kMazeKey: [self.mazeView getMaze]};
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tempDirectory = [paths firstObject];
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

- (void)keyboardWillShow:(NSNotification *)note {
    CGFloat keyboardY = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGRect newFrame = self.popup.view.frame;
    if (newFrame.origin.y + newFrame.size.height > keyboardY) {
        newFrame.origin.y = keyboardY - newFrame.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            self.popup.view.frame = newFrame;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGRect popupFrame = self.popup.view.frame;
    popupFrame.origin = CGPointMake((self.view.frame.size.width - popupFrame.size.width) / 2.0, (self.view.frame.size.height - popupFrame.size.height) / 2.0);
    [UIView animateWithDuration:0.3 animations:^{
        self.popup.view.frame = popupFrame;
    }];
}

#pragma mark - FIFMaze Delegate

- (void)mazeCompleted {
    if ([[FIFStandingsManager sharedManager] willEnterStandingsWithNumberOfSteps:self.numberOfSteps])
        [self showPopup];
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                            message:[NSString stringWithFormat:@"You finished the maze with %ld steps!", (long)self.numberOfSteps]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)mazeChanged {
    self.numberOfSteps++;
}


#pragma mark - FIFPopupViewControllerDelegate

- (void)popupCancelled {
    [self hidePopup];
}

- (void)popupDoneWithName:(NSString *)name {
    [[FIFStandingsManager sharedManager] addPersonWithName:name andNumberOfSteps:self.numberOfSteps];
    [self hidePopup];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        self.numberOfSteps = 0;
        [self.mazeView resetMaze];
    }
}

#pragma mark - Helper methods

- (void)showPopup {
    [UIView animateWithDuration:1.0 animations:^{
        self.blurredView.alpha = 1.0;
        self.popup.view.alpha = 1.0;
    }];
}

- (void)hidePopup {
    [UIView animateWithDuration:1.0 animations:^{
        self.blurredView.alpha = 0.0;
        self.popup.view.alpha = 0.0;
    }];
    self.numberOfSteps = 0;
    [self.mazeView resetMaze];
}

@end
