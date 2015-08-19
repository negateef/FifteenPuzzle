//
//  FIFMainViewController.m
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/18/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import "FIFMainViewController.h"
#import "FIFStandingsManager.h"

@implementation FIFMainViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[FIFStandingsManager sharedManager] setMaxNumberOfPeople:5];
}

@end
