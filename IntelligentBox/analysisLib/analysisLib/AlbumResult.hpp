//
//  AlbumResult.hpp
//  AnalysisDemo
//
//  Created by ShawnHuen on 2018/3/7.
//  Copyright © 2018年 oldtree. All rights reserved.
//

#ifndef AlbumResult_hpp
#define AlbumResult_hpp

#include <stdio.h>
#include <string>
#include <vector>

class AlbumResult
{
private :
    
public :
    std::string author;
    std::string bigPicUrl, smallPicUrl;
    std::vector<std::string> songId;
    std::vector<std::string> songName;
    std::vector<std::string> songAuthor;
    std::vector<std::string> songPicUrl;
    std::string name;
    std::string info;
    
    AlbumResult(void);
    
    std::string getAuthor();
    std::string getBigPicUrl();
    std::string getSmallPicUrl();
    std::vector<std::string> getSongId();
    std::vector<std::string> getSongName();
    std::vector<std::string> getSongAuthor();
    std::vector<std::string> getSongPicUrl();
    std::string getName();
    std::string getInfo();
};
#endif /* AlbumResult_hpp */
