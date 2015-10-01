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

- (NSUInteger) getTaskCount;

- (void) uploadImageWithPath: (NSURL*) url
               thumbnailPath: (NSURL*) thumbURL
                successBlock: (void (^)(NSString *fileLink, NSString* thumbLink)) successBlock
                failureBlock: (void (^)(NSError* error)) failureBlock;


@end
