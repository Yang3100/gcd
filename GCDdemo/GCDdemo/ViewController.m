//
//  ViewController.m
//  GCDdemo
//
//  Created by 杨科军 on 2018/9/1.
//  Copyright © 2018年 杨科军. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    dispatch_semaphore_t semaphoreLock;
    __block  int ticketCount;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    // 同步执行 + 并发队列
    //    [self syncConcurrent];
    
    //    // 异步执行 + 并发队列
    //    [self asyncConcurrent];
    
    //    // 同步执行 + 串行队列
    //    [self syncSerial];
    
    //    // 异步执行 + 串行队列
    //    [self asyncSerial];
    
    // 同步执行 + 主队列
    //    dispatch_queue_t queue = dispatch_queue_create("com.yangkejun.GCDdemo", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_async(queue, ^{
    //        [self syncMain];
    //    });
    
    //    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
    
    //    // 异步执行 + 主队列
    //    [self asyncMain];
    
    //    // 线程间通信
    //    [self communication];
    
    //    // 栅栏方法 dispatch_barrier_async
    //    [self barrier];
    
    //    // 延时执行
    //    [self after];
    
    //    // 快速迭代方法
    //    [self apply];
    
    // 队列组
    //    [self groupNotify];
    //    [self groupWait];
    //    [self groupEnterAndLeave];
    
    //    // 线程同步
    //    [self semaphoreSync];
    
    // 线程安全：使用 semaphore 加锁
    [self initTicketStatusSave];
}

/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncConcurrent{
    NSLog(@"syncConcurrent---begin");
    
    /* com.yangkejun.GCDdemo
    @param label 第一个参数，一般以Bundle Identifier
    @param attr  DISPATCH_QUEUE_CONCURRENT（同步）  DISPATCH_QUEUE_SERIAL_INACTIVE（异步）
     */
    
    dispatch_queue_t queue = dispatch_queue_create("com.yangkejun.GCDdemo", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"任务1");
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"任务2");
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"任务3");
        }
    });
    
    NSLog(@"syncConcurrent---end");
}

/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 */
- (void)asyncConcurrent {
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("com.yangkejun.GCDdemo", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务1");
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务2");
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 3; ++i) {
            NSLog(@"任务3");
        }
    });
    
    NSLog(@"asyncConcurrent---end");
}

/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)syncSerial {
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("com.yangkejun.GCDdemo", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务1");
        }
    });
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务2");
        }
    });
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务3");
        }
    });
    NSLog(@"syncSerial---end");
}

/**
 * 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)asyncSerial {
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("com.yangkejun.GCDdemo", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务1");
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务2");
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 3; ++i) {
            NSLog(@"任务3");
        }
    });
    NSLog(@"asyncSerial---end");
}

/**
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行。
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncMain {
    NSLog(@"syncMain---begin");
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务1");
        }
    });
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务2");
        }
    });
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务3");
        }
    });
    NSLog(@"syncMain---end");
}

/**
 * 异步执行 + 主队列
 * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)asyncMain {
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务1");
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务2");
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 3; ++i) {
            NSLog(@"任务3");
        }
    });
    NSLog(@"asyncMain---end");
}

/**
 * 线程间通信
 */
- (void)communication {
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 异步追加任务
        for (int i = 0; i < 2; ++i) {
            NSLog(@"异步追加任务");
        }
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            NSLog(@"追加在主线程中执行的任务");
        });
    });
}

/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier{
    dispatch_queue_t queue = dispatch_queue_create("com.yangkejun.GCDdemo", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务1");
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 3; ++i) {
            NSLog(@"任务2");
        }
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            NSLog(@"追加任务 barrier");
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 3; ++i) {
            NSLog(@"任务3");
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务4");
        }
    });

}


/**
 * 延时执行方法 dispatch_after
 */
- (void)after{
    NSLog(@"after-begin");
    int64_t delayInSeconds = 5.0; // 延迟的时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 5.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after-end");
    });
}

/**
 * 一次性代码（只执行一次）dispatch_once
 */
- (void)once{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
    });
}

/**
 * 快速迭代方法 dispatch_apply
 */
- (void)apply{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd",index);
    });
    NSLog(@"apply---end");
}

/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify{
    NSLog(@"group---begin");
    dispatch_group_t group =  dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务1");
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 3; ++i) {
            NSLog(@"任务2");
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i) {
            NSLog(@"等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务");
        }
        NSLog(@"group---end");
    });
}

/**
 * 队列组 dispatch_group_wait
 */
- (void)groupWait{
    NSLog(@"group---begin");
    dispatch_group_t group =  dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务1");
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务2");
        }
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"group---end");
}

/**
 * 队列组 dispatch_group_enter、dispatch_group_leave
 */
- (void)groupEnterAndLeave{
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务1");
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务2");
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        for (int i = 0; i < 2; ++i) {
            NSLog(@"等前面的异步操作都执行完毕后，回到主线程.");
        }
        NSLog(@"group---end");
    });
    
    //    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    //    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //
    //    NSLog(@"group---end");
}

/**
 * semaphore 线程同步
 */
- (void)semaphoreSync{
    NSLog(@"semaphore---begin");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务1
        NSLog(@"任务1");
        number = 10;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore---end,number = %d",number);
}

/**
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
 */
- (void)initTicketStatusSave{
    NSLog(@"semaphore---begin");
    
    semaphoreLock = dispatch_semaphore_create(1);
    ticketCount = 10;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("com.yangkejun.GCDdemo1", DISPATCH_QUEUE_SERIAL);
    
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("com.yangkejun.GCDdemo2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe{
    while (1) {
        // 相当于加锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        if (ticketCount > 0) {  //如果还有票，继续售卖
            ticketCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%d 窗口:%@", ticketCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完 窗口:%@",[NSThread currentThread]);
            // 相当于解锁
            dispatch_semaphore_signal(semaphoreLock);
            break;
        }
        
        // 相当于解锁
        dispatch_semaphore_signal(semaphoreLock);
    }
}

@end


