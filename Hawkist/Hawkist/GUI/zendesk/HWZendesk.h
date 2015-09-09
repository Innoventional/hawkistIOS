//
//  HWZendesk.h
//  Hawkist
//
//  Created by User on 07.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWZendesk : NSObject

+(HWZendesk*)shared;
-(void) supportView;
-(void) myTiket;
-(void) newTiket;

-(void)createTicketWithSubject:(NSString*)subject
               withDescription:(NSString*)descript;

@property (nonatomic, strong) UINavigationController *navigationController;

-(void) whyWeNeedThis;

@end
