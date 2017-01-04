//
//  NSOperationVC.m
//  Multi-Thread
//
//  Created by 刘康蕤 on 16/6/16.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "NSOperationVC.h"

@interface NSOperationVC ()

@property(nonatomic, retain)UIImageView * imageView;

@end

@implementation NSOperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"NSOperation";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    
    NSString * imageStr = @"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg";
    NSInvocationOperation * invocation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                              selector:@selector(downLoadImage:)
                                                                                object:imageStr];
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperation:invocation];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 90, 100, 100)];
        _imageView.backgroundColor = [UIColor purpleColor];
    }
    return _imageView;
}

- (void)downLoadImage:(NSString *)url {
    NSURL * ImageUrl = [NSURL URLWithString:url];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL:ImageUrl];
    UIImage * image = [UIImage imageWithData:imageData];
    if (image) {
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:YES];
    }
}

- (void)updateImage:(UIImage *)image {
    self.imageView.image = image;
}


@end
