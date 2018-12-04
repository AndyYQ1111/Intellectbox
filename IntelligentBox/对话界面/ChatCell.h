//
//  ChatCell.h
//  IntelligentBox
//
//  Created by DFung on 2017/11/17.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell

+(NSString*)ID;
+(CGFloat)cellHeight:(NSDictionary*)info;
-(void)setInfo:(NSDictionary*)info;
 

@end
