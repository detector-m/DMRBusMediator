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

NS_ASSUME_NONNULL_BEGIN

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
//+ (BOOL)routeURL:(nonnull NSURL *)url;
//+ (BOOL)routeURL:(nonnull NSURL *)url parameters:(nonnull NSDictionary<NSString *, id> *)parameters;

// 通过URL获取viewController实例
+ (nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)url;
+ (nullable UIViewController *)viewControllerForURL:(NSURL *)url parameters:(nullable NSDictionary<NSString *, id> *)parameters;

#pragma mark - 服务调用接口

@end

NS_ASSUME_NONNULL_END
