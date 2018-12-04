//
//  speex_header_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef speex_header_1_h
#define speex_header_1_h

/** @defgroup SpeexHeader_1 SpeexHeader_1: Makes it easy to write/parse an Ogg/Speex header
 *  This is the Speex header for the Ogg encapsulation. You don't need that if you just use RTP.
 *  @{
 */

#include "speex_types_1.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    struct SpeexMode_1;
    
    /** Length of the Speex header identifier */
#define JL_SPEEX_HEADER_STRING_LENGTH 8
    
    /** Maximum number of characters for encoding the Speex version number in the header */
#define JL_SPEEX_HEADER_VERSION_LENGTH 20
    
    /** Speex header info for file-based formats */
    typedef struct SpeexHeader_1 {
        char speex_string[JL_SPEEX_HEADER_STRING_LENGTH];   /**< Identifies a Speex bit-stream, always set to "Speex   " */
        char speex_version[JL_SPEEX_HEADER_VERSION_LENGTH]; /**< Speex version */
        jl_spx_int32_t speex_version_id;       /**< Version for Speex (for checking compatibility) */
        jl_spx_int32_t header_size;            /**< Total size of the header ( sizeof(SpeexHeader_1) ) */
        jl_spx_int32_t rate;                   /**< Sampling rate used */
        jl_spx_int32_t mode;                   /**< Mode used (0 for narrowband, 1 for wideband) */
        jl_spx_int32_t mode_bitstream_version; /**< Version ID of the bit-stream */
        jl_spx_int32_t nb_channels;            /**< Number of channels encoded */
        jl_spx_int32_t bitrate;                /**< Bit-rate used */
        jl_spx_int32_t frame_size;             /**< Size of frames */
        jl_spx_int32_t vbr;                    /**< 1 for a VBR encoding, 0 otherwise */
        jl_spx_int32_t frames_per_packet;      /**< Number of frames stored per Ogg packet */
        jl_spx_int32_t extra_headers;          /**< Number of additional headers after the comments */
        jl_spx_int32_t reserved1;              /**< Reserved for future use, must be zero */
        jl_spx_int32_t reserved2;              /**< Reserved for future use, must be zero */
    } SpeexHeader_1;
    
    /** Initializes a SpeexHeader_1 using basic information */
    void speex_init_header_1(SpeexHeader_1 *header, int rate, int nb_channels, const struct SpeexMode_1 *m);
    
    /** Creates the header packet from the header itself (mostly involves endianness conversion) */
    char *speex_header_to_packet_1(SpeexHeader_1 *header, int *size);
    
    /** Creates a SpeexHeader_1 from a packet */
    SpeexHeader_1 *speex_packet_to_header_1(char *packet, int size);
    
    /** Frees the memory allocated by either speex_header_to_packet_1() or speex_packet_to_header_1() */
    void speex_header_free_1(void *ptr);
    
#ifdef __cplusplus
}
#endif

/** @} */
#endif
