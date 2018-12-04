//
//  Analysis.hpp
//  AnalysisDemo
//
//  Created by ShawnHuen on 2018/3/6.
//  Copyright © 2018年 oldtree. All rights reserved.
//

#ifndef Analysis_hpp
#define Analysis_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include "AnalysisResult.hpp"
#include "AlbumResult.hpp"

// net error call back.
typedef void (*NetErrorFunc)(int errorCode);

class Analysis
{
private :
    char* url1Buff;
    char* url2Buff;
    char* askBuff;
    char* talkBuff;
    char* songNameBuff;
    char* songAuthorBuff;
    char* songSmallPicUrlBuff;
    char* songBigPicUrlBuff;
    char* songIdBuff;
    char* songTimeLenBuff;
    char* abumIdBuff;
    std::string currSongId;
    void stopStream2(char* buff, int len);
//    AnalysisResult* getSongInfo(std::string songId, int timeoutOnce, int timeoutCnt);
    
    NetErrorFunc NetErrorCallback;
    AnalysisResult* getSongInfo(std::string songId, int timeoutOnce, int timeoutCnt);
public :
    void init(void);
    bool login(std::string mac);
    AnalysisResult* ask(std::string question);
    AnalysisResult* recommendSong();
    AnalysisResult* nextSong();
    AlbumResult* queryAlbum(std::string albumId, int timeoutOnce, int timeoutCnt);
    AnalysisResult* playSong(std::string songId, int timeoutOnce, int timeoutCnt);
    std::vector<AnalysisResult*> playSong(std::vector<std::string> songId, int timeoutOnce, int timeoutCnt);
    std::string tts(std::string s);
    void exitAnalysis(void);
    void setTtsPerson(int type);
    
    void startStream(char* buff, int len);
    void sendStream(char* buff, int len);
    AnalysisResult* stopStream(char* buff, int len);
    
    
    // register net error function.
    void registerNetErrorFunc(NetErrorFunc func);
};



#endif /* Analysis_hpp */
