//
//  songListTbCell.h
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/16.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface songListTbCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *IntroLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introHeight;
@property (weak, nonatomic) IBOutlet UIImageView *animaImgv;


@end
