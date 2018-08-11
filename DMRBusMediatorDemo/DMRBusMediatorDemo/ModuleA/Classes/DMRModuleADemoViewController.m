//
//  DMRModuleADemoViewController.m
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "DMRModuleADemoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DMRModuleADemoViewController ()

@property (nonatomic, strong, readwrite) UILabel *valueLabel;
@property (nonatomic, strong) UIButton *returnButton;


@end

@implementation DMRModuleADemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Test";
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.valueLabel];
    [self.view addSubview:self.returnButton];
    
    CGRect frame = self.view.bounds;
    frame.origin.y = 150;
    frame.size.height = 60;
    self.valueLabel.frame = frame;
    
    frame.origin.y += 300;
    self.returnButton.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)didTappedReturnButton:(UIButton *)sender {
    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:self completion:nil];
        return;
    }
    
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Setters / Getters
- (UILabel *)valueLabel {
    if (_valueLabel == nil) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont systemFontOfSize:30];
        _valueLabel.textColor = [UIColor blackColor];
    }
    return _valueLabel;
}

- (UIButton *)returnButton {
    if (_returnButton == nil) {
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnButton addTarget:self action:@selector(didTappedReturnButton:) forControlEvents:UIControlEventTouchUpInside];
        [_returnButton setTitle:@"return" forState:UIControlStateNormal];
        [_returnButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _returnButton;
}


@end

NS_ASSUME_NONNULL_END
