//
//  ReNameView.m
//  CMD_APP
//
//  Created by Ezio on 2018/2/5.
//  Copyright © 2018年 DFung. All rights reserved.
//

#import "ReNameView.h"

@interface ReNameView()<UITextFieldDelegate>{
    UITapGestureRecognizer *tapges;
    __weak IBOutlet UIImageView *bgImgv;
    __weak IBOutlet UIView *centerView;
}
@end
@implementation ReNameView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle] loadNibNamed:@"ReNameView" owner:self options:nil][0];
    if (self) {
        self.frame = frame;
        tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnAction:)];
        [bgImgv addGestureRecognizer:tapges];
        
        centerView.layer.cornerRadius = 8;
        centerView.layer.masksToBounds = YES;
        _nameTxfd.delegate = self;
        _cancelBtn.tag = 0;
        _finishBtn.tag = 1;
        _nameTxfd.text = _txfdStr;
    }
    return self;
    
}



- (IBAction)cancelBtnAction:(id)sender {
    [_nameTxfd endEditing:YES];
    if ([_delegate respondsToSelector:@selector(didSelectBtnAction:WithText:)]) {
        [_delegate didSelectBtnAction:_cancelBtn WithText:_nameTxfd.text];
    }
}

- (IBAction)finishBtnAction:(id)sender {
    [_nameTxfd endEditing:YES];
    if ([_delegate respondsToSelector:@selector(didSelectBtnAction:WithText:)]) {
        [_delegate didSelectBtnAction:_finishBtn WithText:_nameTxfd.text];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_nameTxfd endEditing:YES];
    [self finishBtnAction:_finishBtn];
    return YES;
}


@end
