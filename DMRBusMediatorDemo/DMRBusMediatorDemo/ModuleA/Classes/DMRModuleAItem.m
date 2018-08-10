//
//  DMRModuleAItem.m
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/10.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "DMRModuleAItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface DMRModuleAItem ()

@end

@implementation DMRModuleAItem
@synthesize name;
@synthesize title;
@synthesize tag;

- (nonnull instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
        self.tag = 0;
    }
    
    return self;
}

- (nonnull NSString *)description {
    NSString *description = [NSString stringWithFormat:@"MduleA: itemName == %@, itemTag == %ld", self.name, self.tag];
    return description;
}
@end

NS_ASSUME_NONNULL_END
