//
//  speex_bits_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef speex_bits_1_h
#define speex_bits_1_h

/** @defgroup SpeexBits_1 SpeexBits_1: Bit-stream manipulations
 *  This is the structure that holds the bit-stream when encoding or decoding
 * with Speex. It allows some manipulations as well.
 *  @{
 */

#ifdef __cplusplus
extern "C" {
#endif
    
#define  JL_SP_FREAME_SIZE            40
    
    /** Bit-packing data structure representing (part of) a bit-stream. */
    typedef struct SpeexBits_1 {
        char  chars[JL_SP_FREAME_SIZE];   /**< "raw" data */
        int   nbBits;  /**< Total number of bits stored in the stream*/
        int   charPtr; /**< Position of the byte "cursor" */
        int   bitPtr;  /**< Position of the bit "cursor" within the current char */
        int   owner;   /**< Does the struct "own" the "raw" buffer (member "chars") */
        int   overflow;/**< Set to one if we try to read past the valid data */
        int   buf_size;/**< Allocated size for buffer */
        int   reserved1; /**< Reserved for future use */
        void *reserved2; /**< Reserved for future use */
    } SpeexBits_1;
    
    
    /** Initializes and allocates resources for a SpeexBits_1 struct */
    void speex_bits_init_1(SpeexBits_1 *bits);
    
    /** Initializes SpeexBits_1 struct using a pre-allocated buffer*/
    void speex_bits_init_buffer_1(SpeexBits_1 *bits, void *buff, int buf_size);
    
    /** Sets the bits in a SpeexBits_1 struct to use data from an existing buffer (for decoding without copying data) */
    void speex_bits_set_bit_buffer_1(SpeexBits_1 *bits, void *buff, int buf_size);
    
    /** Frees all resources associated to a SpeexBits_1 struct. Right now this does nothing since no resources are allocated, but this could change in the future.*/
    void speex_bits_destroy_1(SpeexBits_1 *bits);
    
    /** Resets bits to initial value (just after initialization, erasing content)*/
    void speex_bits_reset_1(SpeexBits_1 *bits);
    
    /** Rewind the bit-stream to the beginning (ready for read) without erasing the content */
    void speex_bits_rewind_1(SpeexBits_1 *bits);
    
    /** Append bytes to the bit-stream
     *
     * @param bits Bit-stream to operate on
     * @param bytes pointer to the bytes what will be appended
     * @param len Number of bytes of append
     */
    void speex_bits_read_whole_bytes_1(SpeexBits_1 *bits, char *bytes, int len);
    
    /** Write the content of a bit-stream to an area of memory
     *
     * @param bits Bit-stream to operate on
     * @param bytes Memory location where to write the bits
     * @param max_len Maximum number of bytes to write (i.e. size of the "bytes" buffer)
     * @return Number of bytes written to the "bytes" buffer
     */
    int speex_bits_write_1(SpeexBits_1 *bits, char *bytes, int max_len);
    
    /** Like speex_bits_write_1, but writes only the complete bytes in the stream. Also removes the written bytes from the stream */
    int speex_bits_write_whole_bytes_1(SpeexBits_1 *bits, char *bytes, int max_len);
    
    /** Append bits to the bit-stream
     * @param bits Bit-stream to operate on
     * @param data Value to append as integer
     * @param nbBits number of bits to consider in "data"
     */
    void speex_bits_pack_1(SpeexBits_1 *bits, int data, int nbBits);
    
    /** Interpret the next bits in the bit-stream as a signed integer
     *
     * @param bits Bit-stream to operate on
     * @param nbBits Number of bits to interpret
     * @return A signed integer represented by the bits read
     */
    int speex_bits_unpack_signed_1(SpeexBits_1 *bits, int nbBits);
    
    /** Interpret the next bits in the bit-stream as an unsigned integer
     *
     * @param bits Bit-stream to operate on
     * @param nbBits Number of bits to interpret
     * @return An unsigned integer represented by the bits read
     */
    unsigned int speex_bits_unpack_unsigned_1(SpeexBits_1 *bits, int nbBits);
    
    /** Returns the number of bytes in the bit-stream, including the last one even if it is not "full"
     *
     * @param bits Bit-stream to operate on
     * @return Number of bytes in the stream
     */
    int speex_bits_nbytes_1(SpeexBits_1 *bits);
    
    /** Same as speex_bits_unpack_unsigned_1, but without modifying the cursor position
     *
     * @param bits Bit-stream to operate on
     * @param nbBits Number of bits to look for
     * @return Value of the bits peeked, interpreted as unsigned
     */
    unsigned int speex_bits_peek_unsigned_1(SpeexBits_1 *bits, int nbBits);
    
    /** Get the value of the next bit in the stream, without modifying the
     * "cursor" position
     *
     * @param bits Bit-stream to operate on
     * @return Value of the bit peeked (one bit only)
     */
    int speex_bits_peek_1(SpeexBits_1 *bits);
    
    /** Advances the position of the "bit cursor" in the stream
     *
     * @param bits Bit-stream to operate on
     * @param n Number of bits to advance
     */
    void speex_bits_advance_1(SpeexBits_1 *bits, int n);
    
    /** Returns the number of bits remaining to be read in a stream
     *
     * @param bits Bit-stream to operate on
     * @return Number of bits that can still be read from the stream
     */
    int speex_bits_remaining_1(SpeexBits_1 *bits);
    
    /** Insert a terminator so that the data can be sent as a packet while auto-detecting
     * the number of frames in each packet
     *
     * @param bits Bit-stream to operate on
     */
    void speex_bits_insert_terminator_1(SpeexBits_1 *bits);
    
#ifdef __cplusplus
}
#endif

/* @} */
#endif
