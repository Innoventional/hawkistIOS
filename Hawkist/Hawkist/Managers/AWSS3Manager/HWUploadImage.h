//
//  HWUploadImage.h
//  Hawkist
//
//  Created by Anton on 01.10.15.
//  Copyright © 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWSS3.h"
@interface HWUploadImage : NSOperation

@property (nonatomic, strong) NSURL* file;
@property (nonatomic, strong) NSURL* thumb;

@property (nonatomic, copy) void (^success)(NSString *fileLink, NSString* thumbLink);
@property (nonatomic, copy) void (^failure)(NSError *error);
@property (nonatomic, strong) NSString* backet;
// need to be overwritten
//- (void) executeOperation;

//- (void) upload:(AWSS3TransferManagerUploadRequest *)uploadRequest;

@end
