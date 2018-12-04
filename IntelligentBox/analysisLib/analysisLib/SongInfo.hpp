//
//  SongInfo.hpp
//  AnalysisDemo
//
//  Created by ShawnHuen on 2018/3/8.
//  Copyright © 2018年 oldtree. All rights reserved.
//

#ifndef SongInfo_hpp
#define SongInfo_hpp

#include <stdio.h>
#include <string>

class SongInfo
{
private :
    
    
public :
    std::string id;
    std::string title;
    std::string url;
    int size;
    int timeLen;
    
    std::string getId();
    std::string getTitle();
    std::string getUrl();
    int getSize();
    int getTimeLen();
};
#endif /* SongInfo_hpp */
