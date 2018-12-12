//
//  ECRootViewController.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/13.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "ECRootViewController.h"
#import "LeftSideViewController.h"
#import "LMSideBarController.h"
#import "UIViewController+LMSideBarController.h"
#import "MainTabControllerView.h"
#import "LMSideBarDepthStyle.h"
#import "JLDefine.h"
#import "IntelligentBox-Swift.h"

@interface ECRootViewController ()

@end

@implementation ECRootViewController



-(void)awakeFromNib{
    
    [super awakeFromNib];
        [self stepUpSiderView];

//    UINavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[IndexVC new]];
//    [self setContentViewController:nav];
}


-(void)stepUpSiderView{
    
    
    LMSideBarDepthStyle *sideBarStyle = [LMSideBarDepthStyle new];
    sideBarStyle.menuWidth = kJL_W-90;
    
    
    MainTabControllerView *mainVC = [MainTabControllerView new];
    
    LeftSideViewController *leftVC = [LeftSideViewController  new];
    
    self.delegate = self;
    [self setPanGestureEnabled:YES];
    [self setMenuViewController:leftVC forDirection:LMSideBarControllerDirectionLeft];
    [self setSideBarStyle:sideBarStyle forDirection:LMSideBarControllerDirectionLeft];
    [self setContentViewController:mainVC];
}

#pragma mark - SIDE BAR DELEGATE

- (void)sideBarController:(LMSideBarController *)sideBarController willShowMenuViewController:(UIViewController *)menuViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)sideBarController:(LMSideBarController *)sideBarController didShowMenuViewController:(UIViewController *)menuViewController
{
    
}

- (void)sideBarController:(LMSideBarController *)sideBarController willHideMenuViewController:(UIViewController *)menuViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)sideBarController:(LMSideBarController *)sideBarController didHideMenuViewController:(UIViewController *)menuViewController
{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    


    
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
