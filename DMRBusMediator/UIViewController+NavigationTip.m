//
//  UIViewController+NavigationTip.m
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "UIViewController+NavigationTip.h"
#import "DMRBusMediatorTipViewController.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIViewController (NavigationTip)

+ (nonnull UIViewController *)paramsError{
    return [DMRBusMediatorTipViewController paramsErrorTipController];
}


+ (nonnull UIViewController *)notFound{
    return [DMRBusMediatorTipViewController notFoundTipConctroller];
}


+ (nonnull UIViewController *)notURLController{
    return [DMRBusMediatorTipViewController notURLTipController];
}

@end

NS_ASSUME_NONNULL_END
