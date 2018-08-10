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

/**
 * (1)通过connector向busMediator挂载可导航的URL，具体解析URL的host还是path，由connector自行决定；
 * (2)如果URL在本业务组件可导航，则从params获取参数，实例化对应的viewController进行返回；如果参数错误，则返回一个错误提示的[UIViewController paramsError]; 如果不需要中间件进行present展示，则返回一个[UIViewController notURLController],表示当前可处理；如果无法处理，返回nil，交由其他组件处理；
 * (3)需要在connector中对参数进行验证，不同的参数调用生成不同的ViewController实例；也可以通过参数决定是否自行展示，如果自行展示，则用户定义的展示方式无效；
 * (4)如果挂接的url较多，这里的代码比较长，可以将处理方法分发到当前connector的category中；
 */
- (UIViewController * _Nullable)connectToOpenURL:(NSURL * _Nonnull)url parameters:(NSDictionary<NSString *, id> * _Nullable)parameters {
    // 处理scheme://ADetail的方式
    // tip: url较少的时候可以通过if-else去处理，如果url较多，可以自己维护一个url和ViewController的map，加快遍历查找，生成viewController；
    if ([url.host isEqualToString:@"ADetail"]) {
//        if (parameters)
        DMRModuleADemoViewController *vc = [[DMRModuleADemoViewController alloc] init];
        
        if (parameters.count == 0) {
            return vc;
        }
        
        if (parameters[@"key"]) {
            vc.valueLabel.text = parameters[@"key"];
        }
        else if (parameters[@"image"]) {
            
        }
        else {
            vc.valueLabel.text = @"no image";
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
            return [UIViewController notURLController];
        }
        
        return vc;
    }
    
    return nil;
}

/**
 * （1)通过connector向BusMediator挂接可处理的Protocol，根据Protocol获取当前组件中可处理protocol的服务实例；
 *  (2)具体服务协议的实现可放到其他类实现文件中，只需要在当前connetor中引用，返回一个服务实例即可；
 *  (3)如果不能处理，返回一个nil；
 */
- (nullable id)connectToHandleProtocol:(Protocol *)serviceProtocol {
//    if (serviceProtocol == @protocol(xxx)) {
//        return xxx;
//    }
    
    return nil;
}

@end

NS_ASSUME_NONNULL_END
