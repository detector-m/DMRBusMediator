//
//  DMRBusMediator.h
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIViewController+NavigationTip.h"

#import "DMRBusMediatorNavigator.h"

NS_ASSUME_NONNULL_BEGIN

// DMRBusMediatorNavigator
/**
 * 中间件向调用者提供:
 *  (1)baseViewController的传递key: kDMRBusMediatorRouteViewControllerKey
 *  (2)newController导航方式的传递key: kDMRBusMediatorRouteModeKey
 *  (3)DMRBusMediatorNavigator.h定义了目前支持的导航方式有三种；
 */
FOUNDATION_EXTERN NSString * __nonnull const kDMRBusMediatorRouteViewControllerKey;
FOUNDATION_EXTERN NSString * __nonnull const kDMRBusMediatorRouteModeKey;



@protocol DMRBusMediatorProtocol;

// 总线控制中心
@interface DMRBusMediator : NSObject

#pragma mark - 向总控制中心注册挂接点
// connector自load过程中，注册自己
+ (void)registerConnector:(id<DMRBusMediatorProtocol> _Nonnull)connector;

+ (NSUInteger)connectorCount;

#pragma mark - 页面跳转接口
// 判断某个URL能否导航
+ (BOOL)canRouteURL:(NSURL * _Nonnull)url;

// 通过URL直接完成页面跳转
+ (BOOL)routeURL:(nonnull NSURL *)url;
+ (BOOL)routeURL:(nonnull NSURL *)url parameters:(nullable NSDictionary<NSString *, id> *)parameters;

// 通过URL获取viewController实例
+ (nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)url;
+ (nullable UIViewController *)viewControllerForURL:(NSURL *)url parameters:(nullable NSDictionary<NSString *, id> *)parameters;

#pragma mark - 服务调用接口
// 根据protocol获取服务实例
+ (nullable id)serviceForProtocol:(nonnull Protocol *)protocol;
@end

NS_ASSUME_NONNULL_END
