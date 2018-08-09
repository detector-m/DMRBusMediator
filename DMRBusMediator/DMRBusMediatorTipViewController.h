//
//  DMRBusMediatorTipViewController.h
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMRBusMediatorTipViewController : UIViewController
@property (nonatomic, readonly, getter=isParamsError) BOOL paramsError;
@property (nonatomic, readonly, getter=isNotURLSupport) BOOL notURLSupport;
@property (nonatomic, readonly, getter=isNotFound) BOOL notFound;

+ (nonnull UIViewController *)paramsErrorTipController;

+ (nonnull UIViewController *)notURLTipController;

+ (nonnull UIViewController *)notFoundTipConctroller;

- (void)showDebugTipController:(nonnull NSURL *)URL
               withParameters:(nullable NSDictionary *)parameters;
@end

NS_ASSUME_NONNULL_END
