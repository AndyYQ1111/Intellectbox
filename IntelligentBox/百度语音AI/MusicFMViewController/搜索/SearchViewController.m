//
//  SearchViewController.m
//  IntelligentBox
//
//  Created by KW on 2018/8/13.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchNavView.h"
#import "SearchResultsVC.h"

static NSString *searchKeyword = @"searchKey";

@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableV;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.dataArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:searchKeyword]];
    [self.tableV reloadData];
}

- (void)clearBtnAction {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:searchKeyword];
    [self.dataArray removeAllObjects];
    [self.tableV reloadData];
}

- (void)search:(NSString *)key {
    [self.dataArray addObject:key];
    [[NSUserDefaults standardUserDefaults] setObject:self.dataArray forKey:searchKeyword];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    SearchResultsVC *resultVC = [[SearchResultsVC alloc] init];
    resultVC.keyword = key;
    [self presentViewController:resultVC animated:YES completion:nil];
}

#pragma mark -tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textColor = GRAY_COLOER;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *obj = self.dataArray[indexPath.row];
    [self.dataArray removeObject:obj];
    [self search:obj];
}

- (void)setUI {
    SearchNavView *navView = [[SearchNavView alloc] initWithFrame:CGRectMake(0, 0, kJL_W, SNavigationBarHeight)];
    [self.view addSubview:navView];
    
    WeakSelf
    navView.DismissBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    navView.SearchBlock = ^(NSString *key) {
        [weakSelf search:key];
    };
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, SNavigationBarHeight, kJL_W, 50)];
    titleLabel.textColor = TITLE_COLOER;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.text = @"搜索历史";
    [self.view addSubview:titleLabel];
    
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(15, titleLabel.frame.origin.y + CGRectGetHeight(titleLabel.frame), kJL_W - 30, 240) style:UITableViewStylePlain];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.separatorColor = [UIColor colorWithRed:240 / 255.0 green:241 / 255.0 blue:245 / 255.0 alpha:1.0];
    self.tableV.tableFooterView = [UIView new];
    [self.view addSubview:self.tableV];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(38, self.tableV.frame.origin.y + CGRectGetHeight(self.tableV.frame), kJL_W - 76, 40);
    clearBtn.layer.masksToBounds = YES;
    clearBtn.layer.cornerRadius = 20;
    clearBtn.layer.borderWidth = 1.0;
    clearBtn.layer.borderColor = [[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] CGColor];
    [clearBtn setTitle:@"清空历史搜索" forState:UIControlStateNormal];
    [clearBtn setTitleColor:TITLE_COLOER forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [clearBtn addTarget:self action:@selector(clearBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    
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
