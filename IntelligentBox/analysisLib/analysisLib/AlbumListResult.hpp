//
//  AlbumListResult.hpp
//  Analysis
//
//  Created by ShawnHuen on 2018/3/9.
//  Copyright © 2018年 oldtree. All rights reserved.
//

#ifndef AlbumListResult_hpp
#define AlbumListResult_hpp

#include <stdio.h>
#include <vector>
#include "AlbumInfo.hpp"

class AlbumListResult
{
private :
    
    
public :
    int recordSum;
    int pageSum;
    std::vector<AlbumInfo*> albumInfo;
    
    AlbumListResult(void);
};
#endif /* AlbumListResult_hpp */
