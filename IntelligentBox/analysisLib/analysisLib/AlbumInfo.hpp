//
//  AlbumInfo.hpp
//  AnalysisDemo
//
//  Created by ShawnHuen on 2018/3/7.
//  Copyright © 2018年 oldtree. All rights reserved.
//

#ifndef AlbumInfo_hpp
#define AlbumInfo_hpp

#include <stdio.h>
#include <string>

class AlbumInfo
{
private :
    
    
public :
    std::string id;
    std::string title;
    std::string coverUrl;
    std::string info;
    std::string author;
    
    AlbumInfo(void);
    
    std::string getId();
    std::string getTitle();
    std::string getCoverUrl();
    std::string getInfo();
    std::string getAuthor();
};
#endif /* AlbumInfo_hpp */
