//
//  GCDVC.m
//  Multi-Thread
//
//  Created by 刘康蕤 on 16/6/16.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "GCDVC.h"

@interface GCDVC ()

@property(nonatomic, retain)UIImageView * imageView;

@end

@implementation GCDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GCD";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self gcdAction];
//    [self gcdGroupAction];
//    [self gcdBarrierAction];
    [self gcdApply];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 90, 100, 100)];
        _imageView.backgroundColor = [UIColor purpleColor];
    }
    return _imageView;
}


- (void)gcdAction {
    // 异步处理  在提供的线程中异步处理
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 在这写耗时的操作 如数据请求
        NSString * imageStr = @"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg";
        NSData * imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageStr]];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                // 获取主线程 更新界面
                self.imageView.image = image;
            });
        }
    });
}


- (void)gcdGroupAction {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group1");
        
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"group2");
        
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group3");
    });
    
    // 当三个任务都下载完成后才通知界面说完成的了
    dispatch_group_notify(group, queue, ^{
        NSLog(@"updateUI");
    });
}

- (void)gcdBarrierAction {
    dispatch_queue_t queue = dispatch_queue_create("gcdBarrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"queue1");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1.5];
        NSLog(@"queue2");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"queue3");
    });
    
    // dispatch_barrier_async是在前面的任务执行结束后它才执行，而且它后面的任务等它执行完成之后才会执行
    dispatch_barrier_async(queue, ^{
        NSLog(@"over");
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"queue4");
    });
}

- (void)gcdApply {
    
    // dispatch_apply可以利用多核的优势，所以输出的index顺序不是一定的
    // dispatch_apply 和 dispatch_apply_f 是同步函数,会阻塞当前线程直到所有循环迭代执行完成。当提交到并发queue时,循环迭代的执行顺序是不确定的
    dispatch_apply(5, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"count = %ld",index);
    });
}
@end
