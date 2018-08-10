//
//  DMRBusMediator.m
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "DMRBusMediator.h"
#import "DMRBusMediatorProtocol.h"
#import "DMRBusMediatorTipViewController.h"
#import "UIViewController+NavigationTip.h"

NS_ASSUME_NONNULL_BEGIN

// 保存各个模块的connector实例
static NSMutableDictionary<NSString *, id<DMRBusMediatorProtocol>> * _Nullable _gConnectorMap = nil;

@implementation DMRBusMediator

#pragma mark - 向总控制中心注册挂接点

// connector自load过程中，注册自己
+ (void)registerConnector:(id<DMRBusMediatorProtocol> _Nonnull)connector {
    if (![connector conformsToProtocol:@protocol(DMRBusMediatorProtocol)]) {
        return;
    }
    
    @synchronized(self) {
        if (!_gConnectorMap) {
            _gConnectorMap = [[NSMutableDictionary alloc] initWithCapacity:5];
        }
        
        NSString *connectorClassName = NSStringFromClass([connector class]);
        if ([_gConnectorMap objectForKey:connectorClassName] == nil) {
            _gConnectorMap[connectorClassName] = connector;
        }
    }
}

+ (NSUInteger)connectorCount {
    @synchronized(self) {
        return _gConnectorMap.count;
    }
}

#pragma mark - 页面跳转接口
// 判断某个URL能否导航
+ (BOOL)canRouteURL:(NSURL * _Nonnull)url {
    if (_gConnectorMap.count == 0) return NO;
    
    // 遍历connector 不能并发
    @synchronized(self) {
        __block BOOL success = NO;
        [_gConnectorMap enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, id<DMRBusMediatorProtocol>  _Nonnull connector, BOOL * _Nonnull stop) {
            if ([connector respondsToSelector:@selector(canOpenURL:)]) {
                if ([connector canOpenURL:url]) {
                    success = YES;
                    *stop = YES;
                }
            }
        }];
        
        return success;
    }
}


// 通过URL获取viewController实例
+ (nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)url {
    return [self viewControllerForURL:url parameters:nil];
}
+ (nullable UIViewController *)viewControllerForURL:(NSURL *)url parameters:(nullable NSDictionary<NSString *, id> *)parameters {
    if (_gConnectorMap.count == 0) return nil;
    
    __block UIViewController *retVC = nil;
    __block NSInteger queryCount = 0;
    
    NSDictionary<NSString *, id> *userParameters = [self userParametersWithURL:url parameters:parameters];
    
    [_gConnectorMap enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, id<DMRBusMediatorProtocol> _Nonnull connector, BOOL * _Nonnull stop) {
        queryCount += 1;
        if ([connector respondsToSelector:@selector(connectToOpenURL:parameters:)]) {
            retVC = [connector connectToOpenURL:url parameters:userParameters];
            if ([retVC isKindOfClass:[UIViewController class]]) {
                *stop = YES;
            }
        }
    }];
    
#if DEBUG
    if (!retVC && queryCount == _gConnectorMap.count) {
        [((DMRBusMediatorTipViewController *)[UIViewController notFound]) showDebugTipController:url withParameters:parameters];
        
        return nil;
    }

#endif
    
    if ([retVC class] == [UIViewController class]) {
        return nil;
    }
    else if ([retVC isKindOfClass:NSClassFromString(@"DMRBusMediatorTipViewController")]) {
#if DEBUG
        [((DMRBusMediatorTipViewController *)retVC) showDebugTipController:url withParameters:parameters];
#endif
        
        return nil;
    }
    else {
        return retVC;
    }
    
    return nil;
}

#pragma mark - 服务调用接口
// 根据protocol获取服务实例
+ (nullable id)serviceForProtocol:(nonnull Protocol *)protocol {
    if (_gConnectorMap.count == 0) {
        return nil;
    }
    
    __block id returnService = nil;
    [_gConnectorMap enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, id<DMRBusMediatorProtocol>  _Nonnull connector, BOOL * _Nonnull stop) {
        if ([connector respondsToSelector:@selector(connectToHandleProtocol:)]) {
            returnService = [connector connectToHandleProtocol:protocol];
            if (returnService) {
                *stop = YES;
            }
        }
    }];
    
    return returnService;
}

#pragma mark - Private
// 从url获取query参数放入到参数列表中
+ (nonnull NSDictionary<NSString *, id> *)userParametersWithURL:(nonnull NSURL *)url parameters:(nullable NSDictionary<NSString *, id> *)parameters {
    NSArray<NSString *> *pairs = [url.query componentsSeparatedByString:@"&"];
    NSMutableDictionary<NSString *, id> *userParameters = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray<NSString *> *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *key = kv.firstObject;
            NSString *value = kv.lastObject;
            value = [self urlDecodedString:value];
            
            userParameters[key] = value;
        }
    }
    
    [userParameters addEntriesFromDictionary:parameters];
    
    return [NSDictionary dictionaryWithDictionary:userParameters];
}

// 对url的value部分进行urlDecoding
+ (nonnull NSString *)urlDecodedString:(nonnull NSString *)urlString {
    NSString *retStr = urlString;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
    // ios9以下以及ios9
    retStr = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef)urlString, CFSTR(""), kCFStringEncodingUTF8);
#else
    
    retStr = [urlString stringByRemovingPercentEncoding];
#endif
    
    return retStr;
}


@end

NS_ASSUME_NONNULL_END
