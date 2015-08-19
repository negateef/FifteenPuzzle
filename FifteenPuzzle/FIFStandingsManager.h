//
//  FIFStandingsManager.h
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/19/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIFStandingsManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)addPersonWithName:(NSString *)name andNumberOfSteps:(NSInteger)numberOfSteps;
- (BOOL)willEnterStandingsWithNumberOfSteps:(NSInteger)numberOfSteps;
- (NSString *)getNameOfPersonOnPosition:(NSInteger)position;
- (NSInteger)getNumberOfStepsOfPersonOnPosition:(NSInteger)position;

@property (nonatomic, assign) NSInteger maxNumberOfPeople;
@property (nonatomic, assign, readonly) NSInteger currentNumberOfPeople;

@end
