//
//  ViewController.m
//  YYGCountDown
//
//  Created by Jack on 16/7/21.
//  Copyright © 2016年 HaiDaFu. All rights reserved.
//

#import "ViewController.h"

#define kMaxCount 60

@interface ViewController ()

//tip：这是一个Custom 按钮，改为System 按钮的话，当按钮标题改变的时候，会出现一闪一闪的情况。
@property (weak, nonatomic) IBOutlet UIButton *countDownButton;

@property (strong, nonatomic) NSTimer *countDownTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)countDownButtonClick:(id)sender {
    
    [self rightFunction];
    
    //[self wrongFunction];
}

- (void)rightFunction {
    self.countDownButton.enabled = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSDate *date = [NSDate date];
        NSInteger count = kMaxCount;
        NSTimeInterval interval = 0;
        
        while (count > 0) {
            interval = [[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970];
            count = kMaxCount - (NSInteger)interval;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.countDownButton setTitle:[NSString stringWithFormat:@"%@",@(count)] forState:UIControlStateNormal];
            });
            
            [NSThread sleepForTimeInterval:1];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.countDownButton setTitle:@"倒计时" forState:UIControlStateNormal];
            self.countDownButton.enabled = YES;
        });
        
    });
}


//使用这种做法，开始倒计时之后，若app进入后台，倒计时的秒数会停止不动。
- (void)wrongFunction {
    self.countDownButton.enabled = NO;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
}

static NSInteger maxCount = 60;

- (void)countDown:(id)sender {
    maxCount -= 1;
    [self.countDownButton setTitle:[NSString stringWithFormat:@"%@",@(maxCount)] forState:UIControlStateNormal];
    
    if (maxCount == 0) {
        [self.countDownTimer invalidate];
        maxCount = 60;
        [self.countDownButton setTitle:@"倒计时" forState:UIControlStateNormal];
        self.countDownButton.enabled = YES;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
