//
//  DMRModuleAConnector.m
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "DMRModuleAConnector.h"
#import "DMRBusMediator.h"
#import "DMRModuleADemoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DMRModuleAConnector

#pragma mark - 向总控制中心注册挂接点
/**
 * 每个组件的实现必须自己通过load完成挂载；load只需要在挂载connector的时候完成当前connecotor的初始化，挂载量、挂载消耗、挂载所耗内存都在可控范围内；
 */
+ (void)load {
    @autoreleasepool {
        [DMRBusMediator registerConnector:[self sharedConnector]];
    }
}

+ (DMRModuleAConnector * _Nonnull)sharedConnector {
    static DMRModuleAConnector *_moduleAConnector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _moduleAConnector = [DMRModuleAConnector new];
    });
    
    return _moduleAConnector;
}

#pragma mark - DMRConnectorProtocol
/**
 * (1)当调用方需要通过判断URL是否可导航显示界面的时候，告诉调用方该组件实现是否可导航URL；可导航，返回YES，否则返回NO；
 * (2)这个方法跟connectToOpenURL:params配套实现；如果不实现，则调用方无法判断某个URL是否可导航；
 */
- (BOOL)canOpenURL:(nonnull NSURL *)url {
    if ([url.host isEqualToString:@"ADetail"]) {
        return YES;
    }
    
    return NO;
}

- (UIViewController * _Nullable)connectToOpenURL:(NSURL * _Nonnull)url parameters:(NSDictionary<NSString *, id> * _Nullable)parameters {
    //处理scheme://ADetail的方式
    // tip: url较少的时候可以通过if-else去处理，如果url较多，可以自己维护一个url和ViewController的map，加快遍历查找，生成viewController；
    if ([url.host isEqualToString:@"ADetail"]) {
        DMRModuleADemoViewController *vc = [[DMRModuleADemoViewController alloc] init];
        vc.valueLabel.text = parameters[@"key"];
        
        return vc;
    }
    
    return nil;
}

@end

NS_ASSUME_NONNULL_END
