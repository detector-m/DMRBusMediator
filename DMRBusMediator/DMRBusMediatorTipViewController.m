//
//  DMRBusMediatorTipViewController.m
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "DMRBusMediatorTipViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DMRBusMediatorTipViewController ()
@property (nonatomic, readwrite, getter=isParamsError) BOOL paramsError;
@property (nonatomic, readwrite, getter=isNotURLSupport) BOOL notURLSupport;
@property (nonatomic, readwrite, getter=isNotFound) BOOL notFound;

@property (nonatomic, readwrite) NSString *showText;

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIButton *returnButton;
@end

@implementation DMRBusMediatorTipViewController

- (void)dealloc {
    
}

+ (nonnull UIViewController *)paramsErrorTipController {
    DMRBusMediatorTipViewController *controller = [[DMRBusMediatorTipViewController alloc] init];
    controller.paramsError = YES;
    return (UIViewController *)controller;
}


+ (nonnull UIViewController *)notURLTipController {
    DMRBusMediatorTipViewController *controller = [[DMRBusMediatorTipViewController alloc] init];
    controller.notURLSupport = YES;
    return (UIViewController *)controller;
}

+ (nonnull UIViewController *)notFoundTipConctroller {
    DMRBusMediatorTipViewController *controller = [[DMRBusMediatorTipViewController alloc] init];
    controller.notFound = YES;
    return (UIViewController *)controller;
}

- (instancetype)init {
    if (self = [super init]) {
        _paramsError = NO;
        _notURLSupport = NO;
        _notFound = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.font = [UIFont systemFontOfSize:16];
    _valueLabel.backgroundColor = [UIColor clearColor];
    _valueLabel.textColor = [UIColor whiteColor];
    _valueLabel.frame = CGRectMake(10.0f, 50.0f, self.view.frame.size.width-20, self.view.frame.size.height-100.0f);
    [self.view addSubview:_valueLabel];
    
    _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _returnButton.layer.cornerRadius = 4.0f;
    [_returnButton setBackgroundColor:[UIColor grayColor]];
    [_returnButton addTarget:self action:@selector(didTappedReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [_returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [_returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _returnButton.frame = CGRectMake((self.view.frame.size.width-100)/2, self.view.frame.size.height-75, 100,50);
    [self.view addSubview:_returnButton];
    
    
    //show 显示
    _valueLabel.numberOfLines = [_showText componentsSeparatedByString:@"\n"].count + 1;
    _valueLabel.text = _showText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showDebugTipController:(nonnull NSURL *)URL
               withParameters:(nullable NSDictionary *)parameters {
    NSString *errorString = @"";
    if (self.isParamsError) {
        errorString = @"params error!!!";
    }
    
    if (self.isNotURLSupport) {
        errorString = @"can not support return a url-based controller!!!";
    }
    
    if (self.isNotFound) {
        errorString = @"can not found url!!!";
    }
    
    self.showText = [NSString stringWithFormat:@"open url error: %@\n\nurlString:\n\t%@\n\nparameters:\n%@",errorString, URL, parameters];
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(rootViewController.presentedViewController){
        [rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [rootViewController presentViewController:self animated:YES completion:nil];
        }];
    } else {
        [rootViewController presentViewController:self animated:YES completion:nil];
    }
}


- (void)didTappedReturnButton:(UIButton *)button {
    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (self.parentViewController) {
            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end

NS_ASSUME_NONNULL_END
