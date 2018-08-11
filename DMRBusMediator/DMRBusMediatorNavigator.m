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
            [self pushViewController:viewController baseViewController:baseViewController];
            break;
        
        case kNavigationModePresent:
            [self presentedViewController:viewController baseViewController:baseViewController];
            break;
            
        case kNavigationModeShare:
            [self popToSharedViewController:viewController baseViewController:baseViewController];
            break;
            
        default:
            break;
    }
}

#pragma mark - Private
- (void)pushViewController:(nonnull UIViewController *)viewController baseViewController:(nullable UIViewController *)baseViewController {
    if (!viewController) {
        return;
    }
    if (!baseViewController) {
        baseViewController = [self topmostViewController];
    }
    if (baseViewController == nil) {
        return;
    }
    
    if ([baseViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)baseViewController pushViewController:viewController animated:YES];
    }
    else if (baseViewController.navigationController) {
        [baseViewController.navigationController pushViewController:viewController animated:YES];
    }
    else {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [baseViewController presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)presentedViewController:(nonnull UIViewController *)viewController baseViewController:(nullable UIViewController *)baseViewController {
    if (!viewController) {
        return;
    }
    if (!baseViewController) {
        baseViewController = [self topmostViewController];
    }
    if ([baseViewController isKindOfClass:[UITabBarController class]] ||
        [baseViewController isKindOfClass:[UINavigationController class]]) {
        return;
    }
    
    if (baseViewController.presentedViewController) {
        [baseViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [baseViewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)popToSharedViewController:(nonnull UIViewController *)viewController baseViewController:(nullable UIViewController *)baseViewController {
    if (!viewController) return;
    
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (!rootViewController) return;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *rootTabBarController = (UITabBarController *)rootViewController;
        NSArray<UIViewController *> *viewControllers = rootTabBarController.viewControllers;
        NSInteger selectIndex = -1;
        for (int i=0; i<viewControllers.count; i++) {
            id tmpController = viewControllers[i];
            if ([tmpController isKindOfClass:[UINavigationController class]]) {
                if ([self popToSharedViewController:viewController inNavigationController:tmpController]) {
                    selectIndex = i;
                    break;
                }
            }
            else {
                if (tmpController == viewController) {
                    selectIndex = i;
                    break;
                }
            }
        }
        
        // 选中变化的viewController
        if (selectIndex != -1 &&
            selectIndex != rootTabBarController.selectedIndex) {
            if ([rootTabBarController.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
                [rootTabBarController.delegate tabBarController:rootTabBarController shouldSelectViewController:rootTabBarController.viewControllers[selectIndex]];
            }
            rootTabBarController.selectedIndex = selectIndex;
        }
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [self popToSharedViewController:viewController inNavigationController:(UINavigationController *)rootViewController];
    }
    else {
        // 当前已经在最上面一层
        if (viewController != rootViewController) {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [rootViewController presentViewController:navigationController animated:YES completion:nil];
        }
    }
}

// pop到具体的viewController
- (BOOL)popToSharedViewController:(nonnull UIViewController *)viewController inNavigationController:(nonnull UINavigationController *)navigationController {
    NSInteger count = navigationController.viewControllers.count;
    if (count == 0) return NO;
    
    BOOL success = NO;
    for (NSInteger i = count-1; i >= 0; i--) {
        UIViewController *tmpViewController = navigationController.viewControllers[i];
        if (tmpViewController.presentedViewController) {
            if ([tmpViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
                if ([self popToSharedViewController:viewController inNavigationController:(UINavigationController *)tmpViewController.presentedViewController]) {
                    [navigationController popToViewController:tmpViewController animated:NO];
                    success = YES;
                    break;
                }
            }
            else {
                if (tmpViewController.presentedViewController == viewController) {
                    [navigationController popToViewController:tmpViewController animated:NO];
                    success = YES;
                    break;
                }
            }
        }
        else {
            if (tmpViewController == viewController) {
                [navigationController popToViewController:tmpViewController animated:NO];
                success = YES;
                break;
            }
        }
    }
    
    return success;
}

// 最顶层的控制器（viewController）
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
