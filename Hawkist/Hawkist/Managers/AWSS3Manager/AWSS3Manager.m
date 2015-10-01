//
//  AWSS3Manager.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 7/8/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "AWSS3Manager.h"
#import "AppEngine.h"
#import "AWSS3.h"
#import "NSURL+Extensions.h"
#import "HWUploadImage.h"

#define ACCESS_KEY_ID          @"AKIAJZDNOKN3IAAMLYJQ"
#define SECRET_KEY             @"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"
#define AMAZON_FILE_BUKET @"hawkist-item-images"
#define FULL_FILE_BUCKET  [[NSString stringWithFormat:@"%@-%@", AMAZON_FILE_BUKET, ACCESS_KEY_ID] lowercaseString]

@interface AWSS3Manager()

//@property (nonatomic, copy) void (^success)(NSString *fileLink, NSString* thumbLink);
//@property (nonatomic, copy) void (^failure)(NSError *error);
//@property (nonatomic, strong) NSString* fileURL;
//@property (nonatomic, strong) NSString* thumbURL;
//@property (nonatomic, assign) NSInteger numberOfFiles;

@property (nonatomic, strong) NSOperationQueue* downloadQueue;

@end

@implementation AWSS3Manager

#pragma mark -
#pragma mark Lifecycle

+ (instancetype) shared
{
    static AWSS3Manager* sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AWSS3Manager alloc] init];
    });
    return sharedManager;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        
        self.downloadQueue = [[NSOperationQueue alloc] init];
        self.downloadQueue.maxConcurrentOperationCount = 10;
        
                AWSStaticCredentialsProvider *credentialsProvider = [[AWSStaticCredentialsProvider alloc] initWithAccessKey: ACCESS_KEY_ID secretKey: SECRET_KEY];
        AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion: AWSRegionEUWest1 credentialsProvider: credentialsProvider];
        [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
        
        NSError *error = nil;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"upload"]
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error]) {
            NSLog(@"Creating 'upload' directory failed: [%@]", error);
        }
        
    }
    return self;
}


- (void) uploadImageWithPath: (NSURL*) url
               thumbnailPath: (NSURL*) thumbURL
                successBlock: (void (^)(NSString *fileLink, NSString* thumbLink)) successBlock
                failureBlock: (void (^)(NSError* error)) failureBlock;

{
    HWUploadImage* operation = [[HWUploadImage alloc] init];
        
    operation.file = url;
    operation.thumb = thumbURL;
    operation.success = successBlock;
    operation.failure = failureBlock;
    operation.backet = AMAZON_FILE_BUKET;
        
    [self.downloadQueue addOperation: operation];
}




//- (void) upload:(AWSS3TransferManagerUploadRequest *)uploadRequest {
// 
//    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
//    
//    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
//        if (task.error) {
//            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
//                switch (task.error.code) {
//                    case AWSS3TransferManagerErrorCancelled:
//                    case AWSS3TransferManagerErrorPaused:
//                    {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            
//                        });
//                        
//                    }
//                        break;
//                        
//                    default:
//                        self.failure(
//                                     
//                                     [NSError errorWithDomain:@"File Server Error" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"Please try again later"}]);
//                        
//                        NSLog(@"Upload failed: [%@]", task.error);
//                        break;
//                }
//            } else {
//                self.failure([NSError errorWithDomain:@"File Server Error" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"Please try again later"}]);
//                
//                NSLog(@"Upload failed: [%@]", task.error);
//            }
//        }
//        
//        if (task.result) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.numberOfFiles -= 1;
//                if(self.numberOfFiles < 1)
//                self.success(self.fileURL, self.thumbURL);
//
//            });
//        }
//        
//        return nil;
//    }];
//    
//}



//- (void) uploadImageWithPath: (NSURL*) url
//               thumbnailPath: (NSURL*) thumbURL 
//                successBlock: (void (^)(NSString *fileLink, NSString* thumbLink)) successBlock
//                failureBlock: (void (^)(NSError* error)) failureBlock
//{
//    self.numberOfFiles = 2;
//    self.success = successBlock;
//    self.failure = failureBlock;
//    NSString* fileName = [NSString stringWithFormat: @"%@-%ld.png",
//                          [[[AppEngine shared] user] id],
//                          (long)[[NSDate new] timeIntervalSince1970]];
//    
//    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
//    uploadRequest.body = url;
//    uploadRequest.bucket = AMAZON_FILE_BUKET;
//    uploadRequest.key = fileName;
//    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
//    uploadRequest.contentType = @"image/png";
//
//    
//    self.fileURL = [NSString stringWithFormat: @"https://s3-eu-west-1.amazonaws.com/%@/%@", AMAZON_FILE_BUKET, fileName];
//    
//    [self upload:uploadRequest];
//    
//    fileName = [NSString stringWithFormat: @"%@-%ld-thumb.png",
//                          [[[AppEngine shared] user] id],
//                          (long)[[NSDate new] timeIntervalSince1970]];
//    
//    uploadRequest = [AWSS3TransferManagerUploadRequest new];
//    uploadRequest.body = thumbURL;
//    uploadRequest.bucket = AMAZON_FILE_BUKET;
//    uploadRequest.key = fileName;
//    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
//    uploadRequest.contentType = @"image/png";
//    
//    
//    self.thumbURL = [NSString stringWithFormat: @"https://s3-eu-west-1.amazonaws.com/%@/%@", AMAZON_FILE_BUKET, fileName];
//    
//    [self upload:uploadRequest];
//

//}

@end
