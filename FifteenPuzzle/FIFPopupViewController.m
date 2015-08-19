//
//  FIFPopupViewController.m
//  FifteenPuzzle
//
//  Created by Misha Babenko on 8/18/15.
//  Copyright (c) 2015 Misha Babenko. All rights reserved.
//

#import "FIFPopupViewController.h"

@interface FIFPopupViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation FIFPopupViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cancelButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.okButton.enabled = NO;
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

#pragma mark - Actions


- (IBAction)okButtonTapped:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.delegate popupDoneWithName:self.nameTextField.text];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.delegate popupCancelled];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"])
        return NO;
    
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    [text replaceCharactersInRange:range withString:string];
    if ([text length] == 0) {
        self.okButton.enabled = NO;
        self.okButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    else {
        self.okButton.enabled = YES;
        self.okButton.layer.borderColor = [UIColor yellowColor].CGColor;
    }
    
    return YES;
}


@end
