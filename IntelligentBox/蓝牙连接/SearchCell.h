//
//  SearchCell.h
//  BTMate2
//
//  Created by DFung on 2017/11/17.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DFUnits/DFUnits.h>



@interface SearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImg;

+(NSString*)ID;


@end
