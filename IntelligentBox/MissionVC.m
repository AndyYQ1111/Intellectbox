//
//  MissionVC.m
//  IntelligentBox
//
//  Created by DFung on 2018/4/2.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "MissionVC.h"

@interface MissionVC ()

@end

@implementation MissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMissionNote];
}

-(void)noteMissionDisConnect:(NSNotification*)note{
    [DFAudioPlayer didPauseLast];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addMissionNote {
    [DFNotice add:kUI_DISCONNECTED Action:@selector(noteMissionDisConnect:) Own:self];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
