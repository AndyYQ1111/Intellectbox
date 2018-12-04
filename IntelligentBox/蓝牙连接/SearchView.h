//
//  SearchView.h
//  BTMate2
//
//  Created by DFung on 2017/11/16.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DFUnits/DFUnits.h>
#import "JL_BLEUsage.h"


typedef void(^SearchBk)(BOOL ret);

@interface SearchView : UIView

-(void)reloadCellData;
-(void)removeMe;
@end
