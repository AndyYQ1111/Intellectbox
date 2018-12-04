//
//  Speex_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef Speex_1_h
#define Speex_1_h

/** @defgroup Codec Speex encoder and decoder
 *  This is the Speex codec itself.
 *  @{
 */

#include "speex_bits_1.h"
#include "speex_types_1.h"
#include "if_decoder_ctrl_1.h"
#include "speex_encode_api_1.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    /* Values allowed for *ctl() requests */
    
    /** Set enhancement on/off (decoder only) */
#define JL_SPEEX_SET_ENH 0
    /** Get enhancement state (decoder only) */
#define JL_SPEEX_GET_ENH 1
    
    /*Would be SPEEX_SET_FRAME_SIZE, but it's (currently) invalid*/
    /** Obtain frame size used by encoder/decoder */
#define JL_SPEEX_GET_FRAME_SIZE 3
    
    /** Set quality value */
#define JL_SPEEX_SET_QUALITY 4
    /** Get current quality setting */
    /* #define SPEEX_GET_QUALITY 5 -- Doesn't make much sense, does it? */
    
    /** Set sub-mode to use */
#define JL_SPEEX_SET_MODE 6
    /** Get current sub-mode in use */
#define JL_SPEEX_GET_MODE 7
    
    /** Set low-band sub-mode to use (wideband only)*/
#define JL_SPEEX_SET_LOW_MODE 8
    /** Get current low-band mode in use (wideband only)*/
#define JL_SPEEX_GET_LOW_MODE 9
    
    /** Set high-band sub-mode to use (wideband only)*/
#define JL_SPEEX_SET_HIGH_MODE 10
    /** Get current high-band mode in use (wideband only)*/
#define JL_SPEEX_GET_HIGH_MODE 11
    
    /** Set VBR on (1) or off (0) */
#define JL_SPEEX_SET_VBR 12
    /** Get VBR status (1 for on, 0 for off) */
#define JL_SPEEX_GET_VBR 13
    
    /** Set quality value for VBR encoding (0-10) */
#define JL_SPEEX_SET_VBR_QUALITY 14
    /** Get current quality value for VBR encoding (0-10) */
#define JL_SPEEX_GET_VBR_QUALITY 15
    
    /** Set complexity of the encoder (0-10) */
#define JL_SPEEX_SET_COMPLEXITY 16
    /** Get current complexity of the encoder (0-10) */
#define JL_SPEEX_GET_COMPLEXITY 17
    
    /** Set bit-rate used by the encoder (or lower) */
#define JL_SPEEX_SET_BITRATE 18
    /** Get current bit-rate used by the encoder or decoder */
#define JL_SPEEX_GET_BITRATE 19
    
    /** Define a handler function for in-band Speex request*/
#define JL_SPEEX_SET_HANDLER 20
    
    /** Define a handler function for in-band user-defined request*/
#define JL_SPEEX_SET_USER_HANDLER 22
    
    /** Set sampling rate used in bit-rate computation */
#define JL_SPEEX_SET_SAMPLING_RATE 24
    /** Get sampling rate used in bit-rate computation */
#define JL_SPEEX_GET_SAMPLING_RATE 25
    
    /** Reset the encoder/decoder memories to zero*/
#define JL_SPEEX_RESET_STATE 26
    
    /** Get VBR info (mostly used internally) */
#define JL_SPEEX_GET_RELATIVE_QUALITY 29
    
    /** Set VAD status (1 for on, 0 for off) */
#define JL_SPEEX_SET_VAD 30
    
    /** Get VAD status (1 for on, 0 for off) */
#define JL_SPEEX_GET_VAD 31
    
    /** Set Average Bit-Rate (ABR) to n bits per seconds */
#define JL_SPEEX_SET_ABR 32
    /** Get Average Bit-Rate (ABR) setting (in bps) */
#define JL_SPEEX_GET_ABR 33
    
    /** Set DTX status (1 for on, 0 for off) */
#define JL_SPEEX_SET_DTX 34
    /** Get DTX status (1 for on, 0 for off) */
#define JL_SPEEX_GET_DTX 35
    
    /** Set submode encoding in each frame (1 for yes, 0 for no, setting to no breaks the standard) */
#define JL_SPEEX_SET_SUBMODE_ENCODING 36
    /** Get submode encoding in each frame */
#define JL_SPEEX_GET_SUBMODE_ENCODING 37
    
    /*#define SPEEX_SET_LOOKAHEAD 38*/
    /** Returns the lookahead used by Speex */
#define JL_SPEEX_GET_LOOKAHEAD 39
    
    /** Sets tuning for packet-loss concealment (expected loss rate) */
#define JL_SPEEX_SET_PLC_TUNING 40
    /** Gets tuning for PLC */
#define JL_SPEEX_GET_PLC_TUNING 41
    
    /** Sets the max bit-rate allowed in VBR mode */
#define JL_SPEEX_SET_VBR_MAX_BITRATE 42
    /** Gets the max bit-rate allowed in VBR mode */
#define JL_SPEEX_GET_VBR_MAX_BITRATE 43
    
    /** Turn on/off input/output high-pass filtering */
#define JL_SPEEX_SET_HIGHPASS 44
    /** Get status of input/output high-pass filtering */
#define JL_SPEEX_GET_HIGHPASS 45
    
    /** Get "activity level" of the last decoded frame, i.e.
     how much damage we cause if we remove the frame */
#define JL_SPEEX_GET_ACTIVITY 47
    
    
    /* Preserving compatibility:*/
    /** Equivalent to JL_SPEEX_SET_ENH */
#define JL_SPEEX_SET_PF 0
    /** Equivalent to JL_SPEEX_GET_ENH */
#define JL_SPEEX_GET_PF 1
    
    
    
    
    /* Values allowed for mode queries */
    /** Query the frame size of a mode */
#define JL_SPEEX_MODE_FRAME_SIZE 0
    
    /** Query the size of an encoded frame for a particular sub-mode */
#define JL_SPEEX_SUBMODE_BITS_PER_FRAME 1
    
    
    
    /** Get major Speex version */
#define JL_SPEEX_LIB_GET_MAJOR_VERSION 1
    /** Get minor Speex version */
#define JL_SPEEX_LIB_GET_MINOR_VERSION 3
    /** Get micro Speex version */
#define JL_SPEEX_LIB_GET_MICRO_VERSION 5
    /** Get extra Speex version */
#define JL_SPEEX_LIB_GET_EXTRA_VERSION 7
    /** Get Speex version string */
#define JL_SPEEX_LIB_GET_VERSION_STRING 9
    
    /*#define SPEEX_LIB_SET_ALLOC_FUNC 10
     #define SPEEX_LIB_GET_ALLOC_FUNC 11
     #define SPEEX_LIB_SET_FREE_FUNC 12
     #define SPEEX_LIB_GET_FREE_FUNC 13
     
     #define SPEEX_LIB_SET_WARNING_FUNC 14
     #define SPEEX_LIB_GET_WARNING_FUNC 15
     #define SPEEX_LIB_SET_ERROR_FUNC 16
     #define SPEEX_LIB_GET_ERROR_FUNC 17
     */
    
    /** Number of defined modes in Speex */
#define JL_SPEEX_NB_MODES 3
    
    /** modeID for the defined narrowband mode */
#define JL_SPEEX_MODEID_NB 0
    
    /** modeID for the defined wideband mode */
#define JL_SPEEX_MODEID_WB 1
    
    /** modeID for the defined ultra-wideband mode */
#define JL_SPEEX_MODEID_UWB 2
    
    struct SpeexMode_1;
    
    
    
#define  JL_FIXED_POINT
#define  JL_DISABLE_VBR
#define  JL_DISABLE_FLOAT_API
#define  JL_DISABLE_WARNINGS
#define  JL_DISABLE_NOTIFICATIONS
#define  JL_DISABLE_WARNINGS
    
    
    /* Prototypes for mode function pointers */
    
    /** Encoder state initialization function */
    typedef void *(*encoder_init_func_1)(const struct SpeexMode_1 *mode);
    
    /** Encoder state destruction function */
    typedef void (*encoder_destroy_func_1)(void *st);
    
    /** Main encoding function */
    typedef int (*encode_func_1)(void *state, void *in, SpeexBits_1 *bits);
    
    /** Function for controlling the encoder options */
    typedef int (*encoder_ctl_func_1)(void *state, int request, void *ptr);
    
    /** Decoder state initialization function */
    typedef void *(*decoder_init_func_1)(const struct SpeexMode_1 *mode);
    
    /** Decoder state destruction function */
    typedef void (*decoder_destroy_func_1)(void *st);
    
    /** Main decoding function */
    typedef int  (*decode_func_1)(void *state, SpeexBits_1 *bits, void *out);
    
    /** Function for controlling the decoder options */
    typedef int (*decoder_ctl_func_1)(void *state, int request, void *ptr);
    
    
    /** Query function for a mode */
    typedef int (*mode_query_func_1)(const void *mode, int request, void *ptr);
    
    /** Struct defining a Speex mode */
    typedef struct SpeexMode_1 {
        /** Pointer to the low-level mode data */
        const void *mode;
        
        /** Pointer to the mode query function */
        mode_query_func_1 query;
        
        /** The name of the mode (you should not rely on this to identify the mode)*/
        const char *modeName;
        
        /**ID of the mode*/
        int modeID;
        
        /**Version number of the bitstream (incremented every time we break
         bitstream compatibility*/
        int bitstream_version;
        
        /** Pointer to encoder initialization function */
        encoder_init_func_1 enc_init;
        
        /** Pointer to encoder destruction function */
        encoder_destroy_func_1 enc_destroy;
        
        /** Pointer to frame encoding function */
        encode_func_1 enc;
        
        /** Pointer to decoder initialization function */
        decoder_init_func_1 dec_init;
        
        /** Pointer to decoder destruction function */
        decoder_destroy_func_1 dec_destroy;
        
        /** Pointer to frame decoding function */
        decode_func_1 dec;
        
        /** ioctl-like requests for encoder */
        encoder_ctl_func_1 enc_ctl;
        
        /** ioctl-like requests for decoder */
        decoder_ctl_func_1 dec_ctl;
        
    } SpeexMode_1;
    
    int decode_speex_1(char*bitsFile ,char * outFile);
    
    /**
     * Returns a handle to a newly created Speex encoder state structure. For now,
     * the "mode" argument can be &jl_nb_mode or &wb_mode . In the future, more modes
     * may be added. Note that for now if you have more than one channels to
     * encode, you need one state per channel.
     *
     * @param mode The mode to use (either speex_nb_mode_1 or speex_wb.mode)
     * @return A newly created encoder state or NULL if state allocation fails
     */
    void *speex_encoder_init_1(const SpeexMode_1 *mode);
    
    /** Frees all resources associated to an existing Speex encoder state.
     * @param state Encoder state to be destroyed */
    void speex_encoder_destroy_1(void *state);
    
    /** Uses an existing encoder state to encode one frame of speech pointed to by
     "in". The encoded bit-stream is saved in "bits".
     @param state Encoder state
     @param in Frame that will be encoded with a +-2^15 range. This data MAY be
     overwritten by the encoder and should be considered uninitialised
     after the call.
     @param bits Bit-stream where the data will be written
     @return 0 if frame needs not be transmitted (DTX only), 1 otherwise
     */
    int speex_encode_1(void *state, float *in, SpeexBits_1 *bits);
    
    /** Uses an existing encoder state to encode one frame of speech pointed to by
     "in". The encoded bit-stream is saved in "bits".
     @param state Encoder state
     @param in Frame that will be encoded with a +-2^15 range
     @param bits Bit-stream where the data will be written
     @return 0 if frame needs not be transmitted (DTX only), 1 otherwise
     */
    int speex_encode_int_1(void *state, jl_spx_int16_t *in, SpeexBits_1 *bits);
    
    /** Used like the ioctl function to control the encoder parameters
     *
     * @param state Encoder state
     * @param request ioctl-type request (one of the SPEEX_* macros)
     * @param ptr Data exchanged to-from function
     * @return 0 if no error, -1 if request in unknown, -2 for invalid parameter
     */
    int speex_encoder_ctl_1(void *state, int request, void *ptr);
    
    
    /** Returns a handle to a newly created decoder state structure. For now,
     * the mode argument can be &jl_nb_mode or &wb_mode . In the future, more modes
     * may be added.  Note that for now if you have more than one channels to
     * decode, you need one state per channel.
     *
     * @param mode Speex mode (one of speex_nb_mode_1 or speex_wb_mode_1)
     * @return A newly created decoder state or NULL if state allocation fails
     */
    void *speex_decoder_init_1(const SpeexMode_1 *mode);
    
    /** Frees all resources associated to an existing decoder state.
     *
     * @param state State to be destroyed
     */
    void speex_decoder_destroy_1(void *state);
    
    /** Uses an existing decoder state to decode one frame of speech from
     * bit-stream bits. The output speech is saved written to out.
     *
     * @param state Decoder state
     * @param bits Bit-stream from which to decode the frame (NULL if the packet was lost)
     * @param out Where to write the decoded frame
     * @return return status (0 for no error, -1 for end of stream, -2 corrupt stream)
     */
    int speex_decode_1(void *state, SpeexBits_1 *bits, float *out);
    
    /** Uses an existing decoder state to decode one frame of speech from
     * bit-stream bits. The output speech is saved written to out.
     *
     * @param state Decoder state
     * @param bits Bit-stream from which to decode the frame (NULL if the packet was lost)
     * @param out Where to write the decoded frame
     * @return return status (0 for no error, -1 for end of stream, -2 corrupt stream)
     */
    int speex_decode_int_1(void *state, SpeexBits_1 *bits, jl_spx_int16_t *out);
    
    /** Used like the ioctl function to control the encoder parameters
     *
     * @param state Decoder state
     * @param request ioctl-type request (one of the SPEEX_* macros)
     * @param ptr Data exchanged to-from function
     * @return 0 if no error, -1 if request in unknown, -2 for invalid parameter
     */
    int speex_decoder_ctl_1(void *state, int request, void *ptr);
    
    
    /** Query function for mode information
     *
     * @param mode Speex mode
     * @param request ioctl-type request (one of the SPEEX_* macros)
     * @param ptr Data exchanged to-from function
     * @return 0 if no error, -1 if request in unknown, -2 for invalid parameter
     */
    int speex_mode_query_1(const SpeexMode_1 *mode, int request, void *ptr);
    
    /** Functions for controlling the behavior of libspeex
     * @param request ioctl-type request (one of the SPEEX_LIB_* macros)
     * @param ptr Data exchanged to-from function
     * @return 0 if no error, -1 if request in unknown, -2 for invalid parameter
     */
    int speex_lib_ctl_1(int request, void *ptr);
    
    /** Default narrowband mode */
    extern const SpeexMode_1 speex_nb_mode_1;
    
    /** Default wideband mode */
    extern const SpeexMode_1 speex_wb_mode_1;
    
    /** Default "ultra-wideband" mode */
    extern const SpeexMode_1 speex_uwb_mode_1;
    
    /** List of all modes available */
    extern const SpeexMode_1 * const speex_mode_list_1[JL_SPEEX_NB_MODES];
    
    /** Obtain one of the modes available */
    const SpeexMode_1 * speex_lib_get_mode_1 (int mode);
    int  test_andrio_addfun_gcc_1(int a1,int a2);
#ifndef WIN32
    /* We actually override the function in the narrowband case so that we can avoid linking in the wideband stuff */
#define speex_lib_get_mode_1(mode) ((mode)==JL_SPEEX_MODEID_NB ? &speex_nb_mode_1 : speex_lib_get_mode_1 (mode))
#endif
    
#ifdef __cplusplus
}
#endif

/** @}*/
#endif
