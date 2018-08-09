//
//  DMRModuleAConnector.h
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMRBusMediatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 业务组件挂接点说明：
 *
 * (1)每个业务组件的实现自定义一个挂接点，挂接点遵循中间件规定的connector协议；在挂接点需要连接上可导航的url，协议的服务承载实例；
 *
 * (2)通过挂接点＋协议的方式，组件的实现部分不用对外披露任何头文件；
 */


/**
 * @class DMRModuleAConnector
 *  业务组件A的connector
 */

@interface DMRModuleAConnector : NSObject <DMRBusMediatorProtocol>

@end

NS_ASSUME_NONNULL_END
