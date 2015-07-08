//
//  HWTags.h
//  Hawkist
//
//  Created by Anton on 07.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol HWTag
@end

@interface HWTag : JSONModel

@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray<HWTag,Optional>* children;

@end
