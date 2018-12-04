//
//  MainPageClassResult.hpp
//  AnalysisDemo
//
//  Created by ShawnHuen on 2018/3/7.
//  Copyright © 2018年 oldtree. All rights reserved.
//

#ifndef MainPageClassResult_hpp
#define MainPageClassResult_hpp

#include <stdio.h>
#include <string>

class MainPageClassResult
{
private :
    
public :
    std::string id;
    std::string title;
    std::string coverUrl;
    
    MainPageClassResult(void);
    
    std::string getId();
    std::string getTitle();
    std::string getCoverUrl();
};
#endif /* MainPageClassResult_hpp */
