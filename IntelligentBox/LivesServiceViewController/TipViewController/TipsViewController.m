//
//  TipsViewController.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/13.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "TipsViewController.h"
#import "TipsModel.h"
#import "TipsTableViewCell.h"

@interface TipsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UILabel *titleLab;
    __weak IBOutlet UIButton *leftBtn;
    __weak IBOutlet UITableView *itemTable;
 
    
}

@end

@implementation TipsViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleLab.text = _titleStr;
    itemTable.dataSource = self;
    itemTable.delegate = self;
    itemTable.tableFooterView = [UIView new];
    itemTable.backgroundColor = [UIColor clearColor];
    itemTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    itemTable.rowHeight = 70;
    
    
    
}


- (IBAction)leftBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <- tableviewDelegate ->

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    return _tipsArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TipsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipsCell"];
    if (cell == nil) {
        cell = [[TipsTableViewCell alloc] init];
        
    }
    
    TipsModel *tmpMode = _tipsArray[indexPath.row];
    cell.typeImgv.image = tmpMode.tipImg;
    cell.typeLab.text = tmpMode.typeString;
    cell.albumLab.text = tmpMode.albumIntro;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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
