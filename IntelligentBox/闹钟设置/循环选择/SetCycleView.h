//
//  SetCycleView.h
//  CMD_APP
//
//  Created by Ezio on 2018/2/8.
//  Copyright © 2018年 DFung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CycleViewDelegate <NSObject>

-(void)didSelectBtnAction:(UIButton *)btn WithArray:(NSArray *)cycArray;
//-(void)didComfintBtnAction:(NSInteger )index;

@end

@interface SetCycleView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (strong,nonatomic) NSArray *cycleArray;
@property (strong,nonatomic) NSMutableArray *selectedArray;
@property (assign,nonatomic) id <CycleViewDelegate> delegate;
@property (assign,nonatomic) uint8_t repeatMode;


@end
