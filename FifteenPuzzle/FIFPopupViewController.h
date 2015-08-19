//
//  FIFPopupViewController.h
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/18/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FIFPopupViewControllerDelegate <NSObject>

@optional

- (void)popupCancelled;
- (void)popupDoneWithName:(NSString *)name;

@end

@interface FIFPopupViewController : UIViewController

@property (nonatomic, weak) id<FIFPopupViewControllerDelegate> delegate;

@end
