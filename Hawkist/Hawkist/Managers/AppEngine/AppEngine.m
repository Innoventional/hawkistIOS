//
//  AppEngine.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/17/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "AppEngine.h"

@implementation AppEngine

#pragma mark -
#pragma mark Lifecycle
@synthesize user;
+ (instancetype) shared
{
    static AppEngine* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedInstance = [[AppEngine alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

#pragma mark -
#pragma mark Public

+ (BOOL) isFirsTimeLaunch
{
    BOOL isFirstTime = ![[[NSUserDefaults standardUserDefaults] objectForKey: @"isFirstTime"] boolValue];
    if(isFirstTime)
        [[NSUserDefaults standardUserDefaults] setObject: @(YES) forKey: @"isFirstTime"];
    return isFirstTime;
}

#pragma mark -
#pragma mark Setters/Getters

- (void) setPin: (NSString*) pin
{
     [[NSUserDefaults standardUserDefaults] setObject: pin forKey: @"pin"];
}

- (NSString*) pin
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"pin"];
}

- (void) setNumber: (NSString*) number
{
    [[NSUserDefaults standardUserDefaults] setObject: number forKey: @"number"];

}


- (NSString*) number
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"number"];

}

- (void) setTags:(NSMutableArray *)tags
{
    _tags = tags;
}

- (NSString*) categoryNameById: (NSInteger) id
{
    HWTag* tag = [self tagWithId: [NSString stringWithFormat: @"%ld", id] fromArray: self.tags];
    if(tag)
        return tag.name;
    else
        return nil;
}

- (HWTag*) tagWithId: (NSString*) tagId fromArray: (NSArray*) array
{
    for(HWTag* tag in array)
    {
        if([tag.id isEqualToString: tagId])
        {
            return tag;
        }
        else if(tag.children && tag.children.count > 0)
        {
            HWTag* aTag = [self tagWithId: tagId fromArray: tag.children];
            if(aTag)
                return aTag;
        }
    }
    return nil;
}


+ (void) showAlertWithTitle:(NSString*)title Message:(NSString*) message
{
    NSLog(@"%@",message);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc]initWithTitle:title
                                   message:message
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil] show];
        
    });
    
}
@end
