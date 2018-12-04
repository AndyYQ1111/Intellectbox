//
//  speex_method.h
//  IntelligentBox
//
//  Created by DFung on 2017/11/21.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#ifndef speex_method_h
#define speex_method_h

int decode_speex_path(char*bitsFile ,char * outFile);

int decode_speex_buf(char*inBuf,int inSize ,char *outBuf,int *outSize);

#endif /* speex_method_h */
