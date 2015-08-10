//
//  UIImageView+Extensions.m
//  Hawkist
//
//  Created by User on 09.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "UIImageView+Extensions.h"

@implementation UIImageView (Extensions)

-(void) setImageWithUrl:(NSURL *)url withIndicator:(UIActivityIndicatorView *)indicator
{

   if([url.description isEqual:@""])
   {
       self.image = [UIImage  imageNamed:@"noPhoto"];
       [indicator stopAnimating] ;
        return;
   }
    __weak __block UIImageView *blockSelf = self;
    __weak __block UIActivityIndicatorView* indic = indicator;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [blockSelf setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       blockSelf.image = image;
                                       [indic stopAnimating];
                                       
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       
                                       
                                       
                                   }];
    

    
    
}

@end
