//
//  ChatVC.m
//  IntelligentBox
//
//  Created by DFung on 2017/11/17.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "ChatVC.h"
#import "ChatCell.h"
//#import "JL_BDSpeechAI.h"
#import "UIViewController+LMSideBarController.h"

@interface ChatVC ()<UITableViewDelegate,
                     UITableViewDataSource>
{
    __weak IBOutlet UITableView *subTableView;
    __weak IBOutlet UIImageView *subImg;
    __weak IBOutlet UILabel *subLb;
    NSArray *dataArray;
}
@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    subTableView.delegate = self;
    subTableView.dataSource = self;
    subTableView.backgroundColor = [UIColor clearColor];
    subTableView.tableFooterView = [UIView new];
    subTableView.allowsSelection = NO;
 
    [self addNote];
}

- (void)viewWillAppear:(BOOL)animated {
    dataArray = [JL_Talk talkRed];
    [subTableView reloadData];
}

-(void)setUINot{
    subLb.hidden = NO;
    subImg.hidden = NO;
    subTableView.hidden = YES;
}

-(void)setUIHave{
    subLb.hidden = YES;
    subImg.hidden = YES;
    subTableView.hidden = NO;
}

- (IBAction)menuBtnAction:(id)sender {
    [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionLeft];
}

#pragma mark - 对话记录回调 
-(void)noteTalkRecond:(NSNotification *)note {
    NSDictionary *info = [note object];
    [JL_Talk talkWrite:info];
    [self setUIHave];
    
    dataArray = [JL_Talk talkRed];
    [subTableView reloadData];
    [self scrollToBottom];
}

-(void)scrollToBottom {
    NSIndexPath *ip = [NSIndexPath indexPathForRow:dataArray.count - 1 inSection:0];
    [subTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = dataArray[indexPath.row];
    CGFloat h = [ChatCell cellHeight:info];
    return h;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChatCell ID]];
    if (cell == nil) {
        cell = [[ChatCell alloc] init];
    }
    NSDictionary* info = dataArray[indexPath.row];
    [cell setInfo:info];
    return cell;
}

-(void)addNote{
    [DFNotice add:kJL_BDTalk Action:@selector(noteTalkRecond:) Own:self];
}

-(void)dealloc{
    [DFNotice remove:kJL_BDTalk Own:self]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
