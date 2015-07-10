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
#define ACCESS_KEY_ID          @"AKIAJZDNOKN3IAAMLYJQ"
#define SECRET_KEY             @"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"
#define AMAZON_FILE_BUKET @"hawkist-item-images"
#define FULL_FILE_BUCKET  [[NSString stringWithFormat:@"%@-%@", AMAZON_FILE_BUKET, ACCESS_KEY_ID] lowercaseString]

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
                successBlock: (void (^)(NSString* fileURL)) successBlock
                failureBlock: (void (^)(NSError* error)) failureBlock
               progressBlock: (void (^)(CGFloat progress)) progressBlock
{
    NSString* fileName = [NSString stringWithFormat: @"%@-%ld.png",
                          [[[AppEngine shared] user] id],
                          (long)[[NSDate new] timeIntervalSince1970]];
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = url;
    uploadRequest.bucket = AMAZON_FILE_BUKET;
    uploadRequest.key = fileName;
    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    uploadRequest.contentType = @"image/png";

    
    NSString* fileURL = [NSString stringWithFormat: @"https://s3-eu-west-1.amazonaws.com/%@/%@", AMAZON_FILE_BUKET, fileName];
    
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
                        failureBlock([NSError errorWithDomain: @""
                                                         code: 13
                                                     userInfo: nil]);
                        NSLog(@"Upload failed: [%@]", task.error);
                        break;
                }
            } else {
                failureBlock([NSError errorWithDomain: @""
                                                 code: 13
                                             userInfo: nil]);
                NSLog(@"Upload failed: [%@]", task.error);
            }
        }
        
        if (task.result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(fileURL);
            });
        }
        
        return nil;
    }];
}

@end
