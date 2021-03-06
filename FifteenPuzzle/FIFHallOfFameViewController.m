//
//  FIFHallOfFameViewController.m
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/18/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import "FIFHallOfFameViewController.h"
#import "FIFStandingsTableViewCell.h"
#import "FIFStandingsManager.h"


@interface FIFHallOfFameViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static const NSInteger numberOfPeople = 5;

@implementation FIFHallOfFameViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Actions

- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numberOfPeople;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FIFStandingsTableViewCell *cell = (FIFStandingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"reuseID" forIndexPath:indexPath];
    
    NSInteger numberOfPeople = [[FIFStandingsManager sharedManager] currentNumberOfPeople];
    
    if (numberOfPeople > indexPath.row) {
        NSString *name = [[FIFStandingsManager sharedManager] getNameOfPersonOnPosition:indexPath.row];
        NSInteger numberOfSteps = [[FIFStandingsManager sharedManager] getNumberOfStepsOfPersonOnPosition:indexPath.row];
        cell.nameLabel.text = [NSString stringWithFormat:@"%ld. %@", (long)(indexPath.row + 1), name];
        cell.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfSteps];
    } else {
        cell.nameLabel.text = [NSString stringWithFormat:@"%ld. ??????", (long)(indexPath.row + 1)];
        cell.scoreLabel.text = @"???";
    }
    return cell;
}

@end
