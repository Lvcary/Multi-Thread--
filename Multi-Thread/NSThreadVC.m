//
//  NSThreadVC.m
//  Multi-Thread
//
//  Created by 刘康蕤 on 16/6/16.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "NSThreadVC.h"

@interface NSThreadVC ()
@property(nonatomic, retain)UIImageView * imageView;

@property (nonatomic, assign) int tickets;  ///< 票数


/*  
 *   NSLock 只是简单是Lock和unLock
 *   NSCondition  不仅可以Lock和unLock 还可以使线程等待，当NSCondition发出信号时，线程继续执行
 */
@property (nonatomic, strong) NSLock * lock;  ///< 线程锁
@property (nonatomic, strong) NSCondition * condition;  ///< 线程锁

@end

@implementation NSThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSThread";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 下载图片
    [self startThreadAction];

    // 多线程卖票
    _tickets = 100;
    [self sellTickets];
    
    
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 90, 100, 100)];
    }
    return _imageView;
}

- (void)startThreadAction {
    // 两种创建方式
//    [NSThread detachNewThreadSelector:@selector(doSomeThing) toTarget:self withObject:nil];
    
    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(doSomeThing) object:nil];
    thread.name = @"我是下载图片的线程";
    [thread start];
}

- (void)doSomeThing {
    NSLog(@"thradName = %@",[NSThread currentThread].name);
    NSString * url = @"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg";
    NSURL * imageUrl = [NSURL URLWithString:url];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    UIImage *image = [UIImage imageWithData:imageData];
    
    if (image) {
        NSLog(@"ok");
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:YES];
    }else {
        NSLog(@"No");
    }
}

- (void)updateImage:(UIImage *)image {
    [self.view addSubview:self.imageView];
    self.imageView.image = image;
}


/**
 *  多线程卖票
 */

- (void)sellTickets {
    _lock = [[NSLock alloc] init];
    _condition = [[NSCondition alloc] init];
    NSThread * threadOne = [[NSThread alloc] initWithTarget:self selector:@selector(sellTicket) object:nil];
    threadOne.name = @"Thread-1";
    [threadOne start];
    
    NSThread * threadTwo = [[NSThread alloc] initWithTarget:self selector:@selector(sellTicket) object:nil];
    threadTwo.name = @"Thread-2";
    [threadTwo start];
    
    NSThread * threadThree = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    threadThree.name = @"Thread-3";
    [threadThree start];
}

- (void)sellTicket {
    
    while (true) {
        /*
        @synchronized(self) {    //  添加一个互斥锁
            if (_tickets >= 0) {
                NSLog(@"当前票数是%d,出售%d,线程是%@",_tickets,100 - _tickets,[NSThread currentThread].name);
                _tickets--;
            }else {
                break;
            }
        }
         */
        /*
        [_lock lock];
        if (_tickets >= 0) {
            NSLog(@"当前票数是%d,出售%d,线程是%@",_tickets,100 - _tickets,[NSThread currentThread].name);
            _tickets--;
        }else {
            break;
        }
        [_lock unlock];
        */
         
        [_condition lock];
        [_condition wait];
        if (_tickets >= 0) {
            NSLog(@"当前票数是%d,出售%d,线程是%@",_tickets,100 - _tickets,[NSThread currentThread].name);
            _tickets--;
        }else {
            break;
        }
        [_condition unlock];
    }
    
}

- (void)run {
    while (YES) {
        if (_tickets < 0) {
            break;
        }
        
        [_condition lock];
        [NSThread sleepForTimeInterval:3];
        [_condition signal];
        [_condition unlock];
    }
}

@end
