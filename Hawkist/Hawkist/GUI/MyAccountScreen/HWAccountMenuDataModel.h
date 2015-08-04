//
//  HWAccountMenuDataModel.h
//  Hawkist
//
//  Created by User on 01.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWAccountMenuDataModel : NSObject

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *title;

- (instancetype) initWithImageName:(NSString*)imageName withTitle:(NSString*)title;
@end
