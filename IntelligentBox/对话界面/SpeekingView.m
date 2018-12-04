//
//  SpeekingView.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/23.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "SpeekingView.h"
#import "UIImage+GIF.h"

@interface SpeekingView(){

    UIImageView *imageGif;
    
}

@end


@implementation SpeekingView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *HUDView = [[UIVisualEffectView alloc] initWithEffect:blur];
        HUDView.alpha = 0.7f;
        HUDView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:HUDView];
        imageGif = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-130, self.frame.size.width, 50)];
        imageGif.contentMode = UIViewContentModeCenter;
        [self addSubview:imageGif];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"microphone" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        imageGif.image = image;
    }
    return self; 
}

-(void)startAnimation{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"microphone" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    imageGif.image = image;
    [imageGif startAnimating];
    
}

-(void)stopAnimation { 
    [imageGif stopAnimating];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"microphone" ofType:@"gif"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    UIImage *image = [UIImage sd_animatedGIFWithData:data];
//    imageGif.image = image;
}

@end
