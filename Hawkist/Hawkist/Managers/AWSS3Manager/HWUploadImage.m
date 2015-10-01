//
//  HWUploadImage.m
//  Hawkist
//
//  Created by Anton on 01.10.15.
//  Copyright © 2015 TecSynt Solutions. All rights reserved.
//

#import "HWUploadImage.h"
#import "AWSS3Manager.h"
#import "AWSS3.h"
@interface HWUploadImage()

@property (nonatomic, strong) NSString* fileURL;
@property (nonatomic, strong) NSString* thumbURL;
@property (nonatomic, assign) NSInteger numberOfFiles;

@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isCancelled;



@end

@implementation HWUploadImage
{
BOOL _isExecuting;
BOOL _isFinished;
BOOL _isCancelled;
}

@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;
@synthesize isCancelled = _isCancelled;


#pragma mark Lifecycle

- (BOOL)isConcurrent
{
    return NO;
}

- (void) start
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    
    if (_isCancelled == YES)
    {
        NSLog(@"** OPERATION CANCELED **");
    }
    else
    {
        NSLog(@"Operation started.");
        [self executeOperation];
    }
}

- (void) finish
{
    NSLog(@"operationfinished.");
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    if (_isCancelled == YES)
    {
        NSLog(@"** OPERATION CANCELED **");
    }
}

- (void) cancel
{
    [self willChangeValueForKey:@"isCancelled"];
    _isCancelled = YES;
    [self didChangeValueForKey:@"isCancelled"];
}

- (void) executeOperation
{
    [self createRequest];
}



- (void) createRequest{
    self.numberOfFiles = 2;
    
    NSString* fileName = [NSString stringWithFormat: @"%@-%ld.png",
                          [[[AppEngine shared] user] id],
                          (long)[[NSDate new] timeIntervalSince1970]];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = self.file;
    uploadRequest.bucket = self.backet;
    uploadRequest.key = fileName;
    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    uploadRequest.contentType = @"image/png";
    
    
    self.fileURL = [NSString stringWithFormat: @"https://s3-eu-west-1.amazonaws.com/%@/%@", self.backet, fileName];
    
    [self upload:uploadRequest];
    
    fileName = [NSString stringWithFormat: @"%@-%ld-thumb.png",
                [[[AppEngine shared] user] id],
                (long)[[NSDate new] timeIntervalSince1970]];
    
    uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = self.thumb;
    uploadRequest.bucket = self.backet;
    uploadRequest.key = fileName;
    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    uploadRequest.contentType = @"image/png";
    
    
    self.thumbURL = [NSString stringWithFormat: @"https://s3-eu-west-1.amazonaws.com/%@/%@", self.backet, fileName];
    
    [self upload:uploadRequest];
    
   
}


- (void) upload:(AWSS3TransferManagerUploadRequest *)uploadRequest {
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                        });
                        
                    }
                        break;
                        
                    default:
                        self.failure(
                                     
                                     [NSError errorWithDomain:@"File Server Error" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"Please try again later"}]);
                                        [self finish];
                        NSLog(@"Upload failed: [%@]", task.error);
                        break;
                }
            } else {
                                [self finish];
                self.failure([NSError errorWithDomain:@"File Server Error" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"Please try again later"}]);
                
                NSLog(@"Upload failed: [%@]", task.error);
            }
        }
        
        if (task.result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.numberOfFiles -= 1;
                if(self.numberOfFiles < 1)
                    self.success(self.fileURL, self.thumbURL);
                [self finish];
                
            });
        }
        
        return nil;
    }];
    
}

@end
