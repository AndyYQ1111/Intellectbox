//
//  MainPageResult.hpp
//  AnalysisDemo
//
//  Created by ShawnHuen on 2018/3/8.
//  Copyright © 2018年 oldtree. All rights reserved.
//

#ifndef MainPageResult_hpp
#define MainPageResult_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include "MainPageClassResult.hpp"
#include "AlbumInfo.hpp"

class MainPageResult
{
private :
    
    
public :
    std::vector<MainPageClassResult*> classResult;
    std::vector<AlbumInfo*> latestAlbumResult;
    std::vector<AlbumInfo*>  bestAlbumResult;
    
    MainPageResult(void);
    
    std::vector<MainPageClassResult*> getMainPageClassResult();
    std::vector<AlbumInfo*> getLatestAlbumResult();
    std::vector<AlbumInfo*> getBestAlbumResult();
    
};

#endif /* MainPageResult_hpp */
