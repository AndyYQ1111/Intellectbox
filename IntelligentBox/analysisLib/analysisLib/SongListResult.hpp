//
//  SongListResult.hpp
//  Analysis
//
//  Created by ShawnHuen on 2018/3/9.
//  Copyright © 2018年 oldtree. All rights reserved.
//

#ifndef SongListResult_hpp
#define SongListResult_hpp

#include <stdio.h>
#include <vector>
#include "SongInfo.hpp"

class SongListResult
{
private :
    
    
public :
    int recordSum;
    int pageSum;
    std::vector<SongInfo*> songInfo;
    
    SongListResult(void);
};
#endif /* SongListResult_hpp */
