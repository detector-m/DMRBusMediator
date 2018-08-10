//
//  DMRModuleAItemProtocol.h
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/10.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @protocol ModuleAXXXServiceProtocol (model协议)
 *  ModuleA对外开放的xxxItem，将数据向外传递，或者将数据通过参数传入调用服务
 */
@protocol DMRModuleAItemProtocol <NSObject>

@required
@property (nonatomic, copy, nonnull) NSString *name;
@property (nonatomic, copy, nonnull) NSString *title;
@property (nonatomic, assign) NSInteger tag;

@optional
@property (nonatomic, readonly, copy, nonnull) NSString *description;
- (nonnull instancetype)initWithName:(nonnull NSString *)name;

@end

NS_ASSUME_NONNULL_END
