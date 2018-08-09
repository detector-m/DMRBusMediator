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

@end

@implementation DMRModuleADemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Test";
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.valueLabel];
    
    CGRect frame = self.view.bounds;
    frame.origin.y = 150;
    frame.size.height = 60;
    self.valueLabel.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)valueLabel {
    if (_valueLabel == nil) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont systemFontOfSize:30];
        _valueLabel.textColor = [UIColor blackColor];
    }
    return _valueLabel;
}

@end

NS_ASSUME_NONNULL_END
