//
//  DMRBusMediatorProtocol.h
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIViewController;

/**
 *  DMRBusMediatorProtocol 挂接点协议
 *
 *  每个业务模块在对外开放的挂接点实现这个协议，以便被BusMediator发现和调度
 */
@protocol DMRBusMediatorProtocol <NSObject>

@optional
// 当前业务组件可导航的URL询问判断
- (BOOL)canOpenURL:(NSURL * _Nonnull)url;

/**
 * 业务模块挂接中间件，注册自己能够处理的URL，完成url的跳转；
 * 如果url跳转需要回传数据，则传入实现了数据接收的调用者；
 *  @param url          跳转到的URL，通常为 productScheme://connector/relativePath
 *  @param parameters       伴随url的的调用参数
 *  @return
 (1) UIViewController的派生实例，交给中间件present;
 (2) nil 表示不能处理;
 (3) [UIViewController notURLController]的实例，自行处理present;
 (4) [UIViewController paramsError]的实例，参数错误，无法导航;
 */
- (UIViewController * _Nullable)connectToOpenURL:(NSURL * _Nonnull)url parameters:(NSDictionary<NSString *, id> * _Nullable)parameters;

/**
 * 业务模块挂接中间件，注册自己提供的service，实现服务接口的调用；
 *
 * 通过protocol协议找到组件中对应的服务实现，生成一个服务单例；
 * 传递给调用者进行protocol接口中属性和方法的调用；
 */
- (id _Nullable)connectToHandleProtocol:(Protocol * _Nonnull)serviceProtocol;
@end

NS_ASSUME_NONNULL_END
