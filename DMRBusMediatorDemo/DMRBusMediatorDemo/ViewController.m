//
//  ViewController.m
//  DMRBusMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "ViewController.h"
#import "DMRBusMediator.h"

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (NSArray *)dataSource
{
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
                        ];
    }
    return _dataSource;
}

@end