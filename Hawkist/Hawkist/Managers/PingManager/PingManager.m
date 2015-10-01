//
//  PingManager.m
//  Hawkist
//
//  Created by Anton on 28.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "PingManager.h"
#import "NetworkManager.h"

@interface PingManager()

@property (nonatomic, assign) BOOL isStopUpdating;
@property (nonatomic, assign) BOOL inProccess;
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation PingManager

+ (instancetype) shared
{
    static PingManager* sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PingManager alloc] init];
    });
    return sharedManager;
}

- (void) startUpdatingNotification
{
    if (self.inProccess)
    {
        return;
    }
    self.isStopUpdating = NO;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            while (true) {
//                if (self.isStopUpdating)
//                {
//                    self.inProccess = NO;
//                    break;
//                }
//                
//             
//        self.inProccess = YES;
//        [[NetworkManager shared]getNotificationsCount:^(NSString *count) {
//            
//            [AppEngine shared].countNewNotifications = count;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotification" object:self];
//            NSLog(@"%@",count);
//        } failureBlock:^(NSError *error) {
//            
//            
//        }];
//            [NSThread sleepForTimeInterval:15];
//            }
//    });
    [self startObserver];
    
    
}

- (void) observerQueque
{
    __weak PingManager* weakSelf = self;
    
    if (weakSelf.isStopUpdating)
    {
        weakSelf.inProccess = NO;
        [weakSelf.timer invalidate];
        return;
    }
    
    
    self.inProccess = YES;
    [[NetworkManager shared]getNotificationsCount:^(NSString *count) {
        
        [AppEngine shared].countNewNotifications = count;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotification" object:self];
        NSLog(@"%@",count);
    } failureBlock:^(NSError *error) {
        
        
    }];
}
- (void) startObserver
{
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 15.0f
                                                  target: self
                                                selector: @selector(observerQueque)
                                                userInfo: nil
                                                 repeats: YES];
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:self.timer forMode: NSDefaultRunLoopMode];
    

}

- (BOOL) isRunned
{
    return self.inProccess;
}

- (void) stopUpdating
{
    self.isStopUpdating = YES;
}
@end
