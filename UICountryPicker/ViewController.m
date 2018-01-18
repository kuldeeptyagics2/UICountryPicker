//
//  ViewController.m
//  UICountryPicker
//
//  Created by Kuldeep Tyagi on 18/01/18.
//  Copyright © 2018 Kuldeep Tyagi. All rights reserved.
//

#import "ViewController.h"
#import "UICountryPicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITextField *textfld = [self createTextFieldWithPleceholder: @"Enter Mobile Number"];
    textfld.frame = CGRectMake(30, 100, self.view.frame.size.width - 60, 40);
    [self addCountryCodeLeftView:textfld];
    [self.view addSubview:textfld];
}

-(UITextField *) createTextFieldWithPleceholder:(NSString *) placeholder {
    UITextField *textField                  = [[UITextField alloc]init];
    textField.textAlignment                 = NSTextAlignmentLeft;
    textField.font                          = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    textField.backgroundColor               = [UIColor clearColor];
    textField.layer.borderColor             = [UIColor whiteColor].CGColor;
    textField.textColor                     = [UIColor whiteColor];
    textField.layer.borderWidth             = 0.8;
    textField.layer.cornerRadius            = 2;
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    textField.placeholder = placeholder;
    [textField setValue:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]
             forKeyPath:@"_placeholderLabel.textColor"];
    
    return textField;
}

-(void) addCountryCodeLeftView:(UITextField *) textField  {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 54.0f, 30.0f)];
    
    UIButton *button             = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30.0f)]; // Required for iOS7
    
    [button setImage:[UIImage imageNamed:@"arrow-point-to-down-white.png"] forState:UIControlStateNormal];
    [button setTitle:@"+91" forState:UIControlStateNormal];
    [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightLight]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    
    [button addTarget:self action:@selector(openTableForCountryCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [leftView addSubview:button];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(50.0f, 2.5f, 1.0f, 24.0f)];
    seperatorView.backgroundColor = [UIColor whiteColor];
    
    [leftView addSubview:seperatorView];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - Country Picker Calling Method
-(void)openTableForCountryCode:(UIButton *) btn  {
    [UICountryPicker showCountryPickerFromViewController:self
                                                 handler:^(NSString * _Nonnull name, NSString * _Nonnull code, NSString * _Nonnull countryCode) {
                                                     NSLog(@"%@ %@ %@", name, code, countryCode);
                                                     [btn setTitle:countryCode forState:UIControlStateNormal];
                                                 }];
}
@end
