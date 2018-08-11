//
//  ViewController.m
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "ViewController.h"
#import "DMRBusMediator.h"
#import "DMRModuleAServiceProtocol.h"
#import "DMRModuleAItem.h"

NSString * const kCellIdentifier = @"kCellIdentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Main";
    
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        UIViewController *controller = [DMRBusMediator viewControllerForURL:[NSURL URLWithString:@"productScheme://ADetail"] parameters:@{@"image": @"", @"key": @"Test URL Push"}];
        if (controller) {
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        return;
    }
    
    if (indexPath.row == 1) {
        UIViewController *controller = [DMRBusMediator viewControllerForURL:[NSURL URLWithString:@"productScheme://ADetail"] parameters:@{@"123": @"", @"abc": @"Test ADetailxx"}];
        if (controller) {
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        return;
    }
    
    if (indexPath.row == 2) {
        [[DMRBusMediator serviceForProtocol:@protocol(DMRModuleAServiceProtocol)] moduleAShowAlertWithMessage:@"Alert Message" cancelAction:nil confirmAction:^(NSDictionary * _Nullable info) {
            NSLog(@"%@", info);
        }];
        return;
    }
    
    if (indexPath.row == 3) {
        id<DMRModuleAItemProtocol> item = [[DMRBusMediator serviceForProtocol:@protocol(DMRModuleAServiceProtocol)] moduleAGetItemWithName:@"Get Item" tag:10];
        [[DMRBusMediator  serviceForProtocol:@protocol(DMRModuleAServiceProtocol)] moduleADeliveAProtocolModel:item];
        return;
    }
    
    if (indexPath.row == 4) {
        DMRModuleAItem *itme = [DMRModuleAItem new];
        itme.name = @"name";
        itme.tag = 100;
        [[DMRBusMediator serviceForProtocol:@protocol(DMRModuleAServiceProtocol)] moduleADeliveAProtocolModel:itme];
        return;
    }
    
    if (indexPath.row == 5) {
        [DMRBusMediator routeURL:[NSURL URLWithString:@"productScheme://ADetail"] parameters:@{kDMRBusMediatorRouteModeKey: @(kNavigationModePresent)}];
        return;
    }
    
    if (indexPath.row == 6) {
        [[DMRBusMediatorNavigator navigator] setHookRouteBlock:nil];
        NSURL *url = [NSURL URLWithString:@"productScheme://ADetail"];
        if ([DMRBusMediator canRouteURL:url]) {
            [DMRBusMediator routeURL:url];
        }
        return;
    }
    
    if (indexPath.row == 7) {
        [DMRBusMediator routeURL:[NSURL URLWithString:@"productScheme://ADetail"] parameters:@{@"key":@"test ------ abc"}];

        return;
    }
    
    if (indexPath.row == 8) {
        __weak typeof(self)weakSelf = self;
        
        [[DMRBusMediatorNavigator navigator] setHookRouteBlock:^BOOL(UIViewController * _Nonnull viewController, UIViewController * _Nullable baseViewController, NavigationMode routeMode) {
            UIViewController *controller = [DMRBusMediator viewControllerForURL:[NSURL URLWithString:@"productScheme://ADetail"] parameters:@{@"123": @"", @"abc": @"Test ADetailxx", @"key": @"----------"}];
            if (controller) {
                [weakSelf.navigationController pushViewController:controller animated:YES];
                return YES;
            }
            return NO;
        }];
        NSURL *url = [NSURL URLWithString:@"productScheme://ADetail"];
        [DMRBusMediator routeURL:url];
        return;
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
//        _dataSource = @[@"present detail view controller",
//                        @"push detail view controller",
//                        @"present image",
//                        @"present image when error",
//                        @"service: show alert",
//                        @"service:get protcol model",
//                        @"service: set protocol model",
//                        @"get url controller",
//                        @"route url with hook",
//                        @"route url not found"];
        
        _dataSource = @[@"push detail view controller",
                        @"push detail with none Connector",
                        @"alert message",
                        @"get service item",
                        @"set service item",
                        @"route url with present",
                        @"route url with hook nil",
                        @"route url with parameters",
                        @"route url with hook"];
    }
    return _dataSource;
}

@end
