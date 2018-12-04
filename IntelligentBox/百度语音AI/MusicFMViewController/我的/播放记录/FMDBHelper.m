//
//  FMDBHelper.m
//  IntelligentBox
//
//  Created by KW on 2018/8/15.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "FMDBHelper.h"

@implementation FMDBHelper
- (NSString *)getPath:(NSString *)dbName {
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    return [paths stringByAppendingPathComponent:dbName];
}

+ (id)sharedInstance {
    static FMDBHelper *fmdbHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmdbHelper = [[self alloc] init];
        
    });
    return fmdbHelper;
}

- (id)init {
    if (self = [super init]) {
        self.dbPath = [self getPath:@"suoai_history.db"];
        [self readyDownloadTable];
    }
    return self;
}


#pragma mark downloadTable
-(void)readyDownloadTable {
    self.queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
 
    self.tableName = @"playingHistory";
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString * sql = [NSString stringWithFormat:@"create table if not exists %@ (trackId varchar(100), playUrl varchar(100), title varchar(100), duration varchar(200), jpgUrl varchar(100), isCherish varchar(20), isPlaying int, primary key (trackId))", self.tableName];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            NSLog(@"创建表成功 >>> %@", self.dbPath);
        }else {
            NSLog(@"创建表失败");
        }
    }];
}

- (void)updateWithSong:(SearchDataModel *)model {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (trackId, playUrl, title, duration, jpgUrl, isCherish, isPlaying) VALUES (?,?,?,?,?,?,?)", self.tableName];
        
        BOOL result = [db executeUpdate:sql, model.trackId, model.playUrl, model.title, model.duration, model.jpgUrl, model.isCherish, [self intToNum:model.isPlaying]];
        
        if (result) {
            NSLog(@"插入成功");
        } else {
            NSLog(@"插入失败");
        }
    }];
}

- (NSNumber *)intToNum:(NSInteger)num {
    return [NSNumber numberWithInteger:num];
}

- (BOOL)deleteHistoryWithTrackid:(NSString *)trackid {
    
    __block BOOL isSuccess = YES;
    [self.queue inDatabase:^(FMDatabase *db) {
        db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"delete from %@ where trackId like '%@'", self.tableName, trackid];
            BOOL res = [db executeUpdate:sql];
            [db close];
            
            if (!res) {
                isSuccess = NO;
            }else {
                isSuccess = YES;
            }
        }else {
            isSuccess = NO;
        }
    }];
    return isSuccess;
}

#pragma mark -查询
- (NSArray *)getHistoryList {
    NSMutableArray *array = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        
        db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"select * from %@", self.tableName];
            FMResultSet *resultSet = [db executeQuery:sql];
            
            while ([resultSet next]) {
                //(trackId, playUrl, title, duration, jpgUrl, isCherish, isPlaying)
                SearchDataModel *model = [[SearchDataModel alloc] init];
                model.trackId = [resultSet objectForColumnName:@"trackId"];
                model.playUrl = [resultSet objectForColumnName:@"playUrl"];
                model.title = [resultSet objectForColumnName:@"title"];
                model.duration = [resultSet objectForColumnName:@"duration"];
                model.jpgUrl = [resultSet objectForColumnName:@"jpgUrl"];
                model.isCherish = [resultSet objectForColumnName:@"isCherish"];
                model.isPlaying = [resultSet intForColumn:@"isPlaying"];
                [array insertObject:model atIndex:0];
            }
        }else {
            NSLog(@"打开数据库失败");
        }
    }];
    return array;
}
@end
