//
//  ReNameView.h
//  CMD_APP
//
//  Created by Ezio on 2018/2/5.
//  Copyright © 2018年 DFung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReNameViewDelegate <NSObject>

-(void)didSelectBtnAction:(UIButton *)btn WithText:(NSString *)text;

@end


@interface ReNameView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *nameTxfd;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (strong, nonatomic) NSString *txfdStr;
@property (assign, nonatomic) id <ReNameViewDelegate> delegate;

@end
