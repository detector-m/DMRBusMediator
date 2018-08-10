//
//  DMRBusMediatorNavigator.h
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/10.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    kNavigationModeNone = 0,
    kNavigationModePush, // push a viewController in NavigationController
    kNavigationModePresent, // present a viewController in NavigationController
    kNavigationModeShare // pop to the viewController which already in NavigationController or tabBarController
} NavigationMode;

/**
 * @class DMRBusMediatorNavigator
 *  busMediator内在支持的的导航器
 */

@interface DMRBusMediatorNavigator : NSObject

// 一个应用一个统一的navigator
+ (nonnull DMRBusMediatorNavigator *)navigator;

// 设置通用的拦截跳转方式
- (void)setHookRouteBlock:(BOOL (^ _Nullable)(UIViewController * _Nonnull viewController, UIViewController * _Nullable baseViewController, NavigationMode routeMode))routeBlock;

/**
 * 在BaseViewController下展示URL对应的Controller
 *  @param viewController   当前需要present的Controller
 *  @param baseViewController 展示的BaseViewController
 *  @param routeMode  展示的方式
 */
- (void)showURLController:(nonnull UIViewController *)viewController baseViewController:(nullable UIViewController *)baseViewController routeMode:(NavigationMode)routeMode;

@end

// 外部不能调用该类别中的方法，仅供Busmediator中调用
@interface DMRBusMediatorNavigator (HookRouteBlock)

- (void)hookShowURLController:(nonnull UIViewController *)viewController baseViewController:(nullable UIViewController *)baseViewController routeMode:(NavigationMode)routeMode;

@end

NS_ASSUME_NONNULL_END
