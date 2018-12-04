//
//  AnalysisResult.hpp
//  AnalysisDemo
//
//  Created by ShawnHuen on 2018/3/6.
//  Copyright © 2018年 oldtree. All rights reserved.
//

#ifndef AnalysisResult_hpp
#define AnalysisResult_hpp

#include <stdio.h>
#include <string>

class AnalysisResult
{
private :
    
    
public :
    std::string url1;
    std::string url2;
    std::string askValue;
    std::string talkValue;
    std::string songName;
    std::string songAuthor;
    std::string songSmallPicUrl;
    std::string songBigPicUrl;
    std::string songId;
    std::string albumId;
    
    int songTimeLen;
    int field;
    int intention;
    std::string intentionParam1;
    std::string intentionParam2;
    
    AnalysisResult(void);
    
    std::string getTalkUrl(void);
    std::string getSongUrl(void);
    std::string getAskValue(void);
    std::string getTalkValue(void);
    std::string getSongName(void);
    std::string getSongAuthor(void);
    std::string getSongSmallPicUrl(void);
    std::string getSongBigPicUrl(void);
    std::string getSongId(void);
    int getSongTimeLen(void);
    std::string getAlbumId(void);
    int getField(void);
    int getIntention(void);
    std::string getIntentionParam1(void);
    std::string getIntentionParam2(void);
};


#endif /* AnalysisResult_hpp */
