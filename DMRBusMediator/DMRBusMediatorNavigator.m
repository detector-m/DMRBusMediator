//
//  DMRBusMediatorNavigator.m
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/10.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "DMRBusMediatorNavigator.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DMRBusMediatorNavigator {
    BOOL (^ _Nullable _routeBlock)(UIViewController * _Nonnull viewController, UIViewController * _Nullable baseViewController, NavigationMode routeMode);
}

+ (nonnull DMRBusMediatorNavigator *)navigator {
    static DMRBusMediatorNavigator *_navigator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _navigator = [DMRBusMediatorNavigator new];
    });
    
    return _navigator;
}

// 设置通用的拦截跳转方式
- (void)setHookRouteBlock:(BOOL (^ _Nullable)(UIViewController * _Nonnull viewController, UIViewController * _Nullable baseViewController, NavigationMode routeMode))routeBlock {
    _routeBlock = routeBlock;
}

/**
 * 在BaseViewController下展示URL对应的Controller
 *  @param viewController   当前需要present的Controller
 *  @param baseViewController 展示的BaseViewController
 *  @param routeMode  展示的方式
 */
- (void)showURLController:(nonnull UIViewController *)viewController baseViewController:(nullable UIViewController *)baseViewController routeMode:(NavigationMode)routeMode {
    [self setHookRouteBlock:nil];
    
    if (routeMode == kNavigationModeNone) {
        routeMode = kNavigationModePush;
    }
    
    switch (routeMode) {
        case kNavigationModePush:
            break;
        
        case kNavigationModePresent:
            break;
            
        case kNavigationModeShare:
            break;
            
        default:
            break;
    }
}

#pragma mark - Private
- (void)pushViewController:(nonnull UIViewController *)viewController baseViewController:(nullable UIViewController *)baseViewController {
    
}

// 最顶层的控制权（viewController）
- (nullable UIViewController *)topmostViewController {
    //rootViewController需要是TabBarController,排除正在显示FirstPage的情况
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (!rootViewController) {
        return nil;
    }
    
    if (![rootViewController isKindOfClass:[UITabBarController class]] &&
        ![rootViewController isKindOfClass:[UINavigationController class]]) {
        return nil;
    }
    
    // 当前显示哪个tab页
    UINavigationController *navigationController = nil;
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        navigationController = (UINavigationController *) [(UITabBarController *)rootViewController selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *)rootViewController;
    }
    else {
        return rootViewController;
    }
    
    if (!navigationController) {
        return nil;
    }
    
    while ([navigationController isKindOfClass:[UINavigationController class]]) {
        UIViewController *topViewController = [navigationController topViewController];
        if ([topViewController isKindOfClass:[UINavigationController class]]) {
            // 顶层是个导航控制器，继续循环
            navigationController = (UINavigationController *)topViewController;
        }
        else {
            // 是否有弹出presentViewControllr
            UIViewController *presentedViewController = topViewController.presentedViewController;
            while (presentedViewController) {
                topViewController = presentedViewController;
                if ([topViewController isKindOfClass:[UINavigationController class]]) {
                    break;
                }
                else {
                    presentedViewController = topViewController.presentedViewController;
                }
            }
            
            navigationController = (UINavigationController *) topViewController;
        }
    }
    
    return navigationController;
}

@end

@implementation DMRBusMediatorNavigator (HookRouteBlock)

- (void)hookShowURLController:(nonnull UIViewController *)viewController baseViewController:(nullable UIViewController *)baseViewController routeMode:(NavigationMode)routeMode {
    BOOL success = NO;
    if (_routeBlock) {
        success = _routeBlock(viewController, baseViewController, routeMode);
    }
    
    if (!success) {
        [self showURLController:viewController baseViewController:baseViewController routeMode:routeMode];
    }
}

@end

NS_ASSUME_NONNULL_END
