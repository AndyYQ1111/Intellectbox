//
//  FMDBHelper.h
//  IntelligentBox
//
//  Created by KW on 2018/8/15.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicMainModel.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface FMDBHelper : NSObject
@property (copy, nonatomic) NSString *dbPath;
@property (retain, nonatomic) FMDatabaseQueue *queue; 
@property (copy, nonatomic) NSString *tableName;

+ (id)sharedInstance;

- (void)updateWithSong:(SearchDataModel *)model;

- (NSArray *)getHistoryList;

- (BOOL)deleteHistoryWithTrackid:(NSString *)trackid;
@end
