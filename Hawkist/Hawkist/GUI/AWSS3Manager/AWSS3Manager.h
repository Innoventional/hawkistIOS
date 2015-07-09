//
//  AWSS3Manager.h
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 7/8/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWSS3Manager : NSObject

+ (instancetype) shared;

- (void) uploadImageWithPath: (NSURL*) url
                successBlock: (void (^)(NSString* fileURL)) successBlock
                failureBlock: (void (^)(NSError* error)) failureBlock
               progressBlock: (void (^)(CGFloat progress)) progressBlock;

@end
