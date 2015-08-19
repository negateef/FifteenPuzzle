//
//  FIFStandingsManager.m
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/19/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import "FIFStandingsManager.h"

static NSString *const kCachedStandingsFileName = @"standings.data";

@interface FIFStandingsManager ()

@property (nonatomic, assign, readwrite) NSInteger currentNumberOfPeople;

@end

@implementation FIFStandingsManager

+ (instancetype)sharedManager {
    static FIFStandingsManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[FIFStandingsManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *tempDirectory = [paths firstObject];
        NSString *tempFile = [tempDirectory stringByAppendingPathComponent:kCachedStandingsFileName];
        NSMutableArray *standings = [[NSMutableArray alloc] initWithContentsOfFile:tempFile];
        self.currentNumberOfPeople = [standings count];
    }
    return self;
}

- (BOOL)addPersonWithName:(NSString *)name andNumberOfSteps:(NSInteger)numberOfSteps {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tempDirectory = [paths firstObject];
    NSString *tempFile = [tempDirectory stringByAppendingPathComponent:kCachedStandingsFileName];
    NSMutableArray *standings = [[NSMutableArray alloc] initWithContentsOfFile:tempFile];
    if (!standings)
        standings = [[NSMutableArray alloc] init];
    if ([standings count] == 0) {
        [standings addObject:@{name: @(numberOfSteps)}];
        self.currentNumberOfPeople++;
        [standings writeToFile:tempFile atomically:YES];
        return YES;
    }
    
    NSInteger lastSteps = [[[[standings lastObject] allValues] lastObject] integerValue];
    if (lastSteps <= numberOfSteps && standings.count == self.maxNumberOfPeople)
        return NO;
    
    for (NSInteger position = 0; position < standings.count; position++) {
        NSInteger nStep = [[[standings[position] allValues] lastObject] integerValue];
        if (nStep > numberOfSteps) {
            [standings insertObject:@{name: @(numberOfSteps)} atIndex:position];
            [standings removeLastObject];
            [standings writeToFile:tempFile atomically:YES];
            return YES;
        }
    }
    
    [standings insertObject:@{name: @(numberOfSteps)} atIndex:standings.count];
    self.currentNumberOfPeople++;
    [standings writeToFile:tempFile atomically:YES];
    return YES;
}

- (BOOL)willEnterStandingsWithNumberOfSteps:(NSInteger)numberOfSteps {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tempDirectory = [paths firstObject];
    NSString *tempFile = [tempDirectory stringByAppendingPathComponent:kCachedStandingsFileName];
    NSMutableArray *standings = [[NSMutableArray alloc] initWithContentsOfFile:tempFile];
    if ([standings count] == 0)
        return YES;
    
    NSInteger lastSteps = [[[[standings lastObject] allValues] lastObject] integerValue];
    if (lastSteps <= numberOfSteps && standings.count == self.maxNumberOfPeople)
        return NO;
    return YES;
}

- (NSString *)getNameOfPersonOnPosition:(NSInteger)position {
    assert(position >= 0 && position < self.currentNumberOfPeople);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tempDirectory = [paths firstObject];
    NSString *tempFile = [tempDirectory stringByAppendingPathComponent:kCachedStandingsFileName];
    NSMutableArray *standings = [[NSMutableArray alloc] initWithContentsOfFile:tempFile];
    
    return [[standings[position] allKeys] firstObject];
}

- (NSInteger)getNumberOfStepsOfPersonOnPosition:(NSInteger)position {
    assert(position >= 0 && position < self.currentNumberOfPeople);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tempDirectory = [paths firstObject];
    NSString *tempFile = [tempDirectory stringByAppendingPathComponent:kCachedStandingsFileName];
    NSMutableArray *standings = [[NSMutableArray alloc] initWithContentsOfFile:tempFile];
    
    return [[[standings[position] allValues] firstObject] integerValue];
}

@end
