//
//  ViewController.m
//  Multi-Thread
//
//  Created by 刘康蕤 on 16/6/16.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "ViewController.h"
#import "NSThreadVC.h"
#import "NSOperationVC.h"
#import "GCDVC.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableview.delegate = self;
    _tableview.dataSource = self;

    _dataSource = [[NSMutableArray alloc] initWithObjects:@"NSThread",@"NSOperation",@"GCD (Grand Central Dispatch)", nil];
}

#pragma mark  TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifer = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            NSThreadVC * threadVC = [[NSThreadVC alloc] init];
            [self.navigationController pushViewController:threadVC animated:YES];
        }
            break;
        case 1:
        {
            NSOperationVC * threadVC = [[NSOperationVC alloc] init];
            [self.navigationController pushViewController:threadVC animated:YES];
        }
            break;
        case 2:
        {
            GCDVC * threadVC = [[GCDVC alloc] init];
            [self.navigationController pushViewController:threadVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
