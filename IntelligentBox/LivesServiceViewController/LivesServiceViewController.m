//
//  LivesServiceViewController.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/13.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "LivesServiceViewController.h"
#import "ToolsCell.h"
#import "TipsTableViewCell.h"
#import "TipsViewController.h"
#import "TipsModel.h"
#import "UIViewController+LMSideBarController.h"

@interface LivesServiceViewController ()<UITableViewDelegate,UITableViewDataSource>{
 
    __weak IBOutlet UILabel *titleLab;
    __weak IBOutlet UITableView *TipsTable;
    
    NSArray *itemArray;
    NSArray *tipsArray;
    __weak IBOutlet NSLayoutConstraint *tableviewBottom;
    
}

@end

@implementation LivesServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self stepUI];
    
}


- (IBAction)leftBtnAction:(id)sender {
    [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionLeft];
}

-(void)stepUI{
    tipsArray = @[@{@"image":@"k33_voice",
                    @"type":@"音乐",
                    @"albums":@"播放张学友的歌\n唱首歌大中国"},
                  @{@"image":@"k30_weather",
                    @"type":@"天气",
                    @"albums":@"明天广州下雨吗\n今天北京天气怎样"},
                  @{@"image":@"k31_zaojiao",
                    @"type":@"早教",
                    @"albums":@"讲个故事\n背诵弟子规"},
                  @{@"image":@"k43_radio",
                    @"type":@"英文",
                    @"albums":@"翻译：好好学习 天天向上"},
                  @{@"image":@"k41_calculator",
                    @"type":@"百科",
                    @"albums":@"地球是圆的吗\n太阳为何东升西落"},
                  @{@"image":@"k25_news",
                    @"type":@"新闻",
                    @"albums":@"播报国际新闻\n播放财经资讯"}
                  ];
 
    TipsTable.dataSource = self;
    TipsTable.delegate = self;
    TipsTable.rowHeight = 90;
    TipsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    TipsTable.backgroundColor = [UIColor clearColor];
    TipsTable.tableFooterView = [UIView new];
    
     NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] >= 11.0 ) {
        
    }else{
        tableviewBottom.constant = 50;
    }
}


#pragma mark<- tableviewDelegate ->
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tipsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TipsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipsCell"];
    if (cell == nil) {
        cell = [[TipsTableViewCell alloc] init];
    }
    NSDictionary *dict = tipsArray[indexPath.row];
    cell.typeImgv.image = [UIImage imageNamed:dict[@"image"]];
    cell.typeLab.text = dict[@"type"];
    cell.albumLab.text = dict[@"albums"];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell; 
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
