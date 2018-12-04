
#include "speex.h"
#include "speex_callbacks.h"
#include "speex_bits.h"
//#include "nb_celp.h"
#include "sb_celp.h"
#include "typedef.h"
#include "sb_celp.h"
#include "string.h"

#ifdef WIN32
#include <stdio.h>
#include <stdlib.h>
#endif


//#define  TEST_SPEEX_SELF_ED_MODE

static void speex_encoder_open(u8 *ptr,SPEEX_EN_FILE_IO *audioIO,u8 complexity)
{
	SBEncState *st;
	memset(ptr,0,sizeof(SBEncState));
	st=(SBEncState *)ptr;
	memcpy(&st->audio_io,audioIO,sizeof(SPEEX_EN_FILE_IO));
	sb_encoder_init(st,&speex_wb_mode,complexity);
	st->bits.buf_size=SP_FREAME_SIZE;
}


static u32 speex_encode_needbuf(void)
{
	return sizeof(SBEncState);
}


const speex_enc_ops speex_enc_ops_c=
{
	speex_encode_needbuf,
	speex_encoder_open,
	sb_encode
};

speex_enc_ops *get_speex_enc_obj()
{
	return (speex_enc_ops *)&speex_enc_ops_c;
}

static  u32 speex_decoder_open(void *work_buf, const struct if_decoder_io *decoder_io, u8 *bk_point_ptr)
{
	SBDecState *st;
	memset(work_buf,0,sizeof(SBDecState));
	st=(SBDecState *)work_buf;
	memcpy((u8 *)&(st->decoder_io),(u8 *)decoder_io,sizeof(struct if_decoder_io));
	memcpy((u8 *)&(st->st_dec.decoder_io),(u8 *)decoder_io,sizeof(struct if_decoder_io));
//	st->decoder_io=decoder_io;
	sb_decoder_init(st,&speex_wb_mode);
	st->st_dec.bits.buf_size=SP_FREAME_SIZE;
	st->st_dec.decoder_io.input(st->decoder_io.priv ,st->st_dec.fr_cnt,st->st_dec.rd_buf,RDDATA_BLOCK_SIZE,1);

	st->st_dec.dec_info_obj.sr=16000;
	st->st_dec.dec_info_obj.br=16;
	st->st_dec.dec_info_obj.nch=1;
#ifndef TEST_SPEEX_SELF_ED_MODE
//	st->dec_info_obj.total_time=st->decoder_io->get_lslen(st->decoder_io->priv)/2000;
#endif
	return 0;
}

static u32 speex_file_format_check(void *work_buf)
{
	return 0;
}



static u32 speex_decode_needbuf()
{
	return sizeof(SBDecState);
}

static u32 speex_decode_neerddbuf()
{
	return 512;
}

static  u32 speex_decoder_stop()
{
	return 0;                   //�ͷŲ���
}

u32 speex_decoder_run(void *work_buf, u32 type)
{
	SBDecState *st;
	st=(SBDecState *)work_buf;
	return sb_decode((void *)st);
}

static  dec_inf_t *speex_get_dec_inf(void *work_buf)
{
	DecState *st;
	st=(DecState *)work_buf;
	return &(st->dec_info_obj);
}

static  u32 speex_get_time(void *work_buf)
{
	SBDecState *st;
	st=(SBDecState *)work_buf;
	return ((st->fr_cnt-st->data_remain)/2000);
}


static  void speex_set_step(void *work_buf,u32 step)
{
}

static unsigned int speex_need_bkbuf_size(void *work_buf)
{
	return 4;
}

static void speex_set_buf_bp(void *work_buf,void* ptr)
{
}

static void speex_set_bkbuf(void *work_buf,void* ptr)
{
}

static u32 speex_get_buf_bp()
{
	return 4;
}


static void speex_set_err_info(void *work_buf,u32 cmd,u8 *ptr,u32 size)
{

}

static u32 speex_get_bp_inf(void *work_buf)
{
	return 0 ;
}

static u32 speex_dec_confing(void *work_buf,u32 cmd,void*parm)
{;
	return 0;
}


/*int  test_andrio_addfun_gcc(int a1,int a2)
{
	return (a1+a2);
}
*/
#ifndef TEST_SPEEX_SELF_ED_MODE
const audio_decoder_ops speex_decoder_ops={
	/*.name              = */ "speex",
	/*.open              = */ speex_decoder_open,
	/*.format_check      = */ speex_file_format_check,
	/*.run               = */ speex_decoder_run,
	/*.get_dec_inf       = */ speex_get_dec_inf,
	/*.get_playtime      = */ speex_get_time,
	/*.get_bp_inf        = */ speex_get_bp_inf,
	/*.need_dcbuf_size   = */ speex_decode_needbuf,
	/*.need_rdbuf_size   = */ speex_decode_neerddbuf,
	/*.need_bpbuf_size   = */ speex_get_buf_bp,
	/*.set_step         = */ speex_set_step,
	/*.set_err_info         = */ speex_set_err_info,
	/*.dec_confing          = */ speex_dec_confing,
};
#endif

#ifdef TEST_SPEEX_SELF_ED_MODE


#ifdef TEST_SPEEX_SELF_ED_MODE

const short  test_indata[160]=
{
	0x0000,
	0x0f39,
	0x1ddb,
	0x2b59,
	0x372b,
	0x40df,
	0x4815,
	0x4c86,
	0x4e05,
	0x4c86,
	0x4815,
	0x40df,
	0x372b,
	0x2b59,
	0x1ddb,
	0x0f39,
	0x0000,
	0xf0c7,
	0xe225,
	0xd4a7,
	0xc8d5,
	0xbf21,
	0xb7eb,
	0xb37a,
	0xb1fb,
	0xb37a,
	0xb7eb,
	0xbf21,
	0xc8d5,
	0xd4a7,
	0xe225,
	0xf0c7,
	0x0000,
	0x0f39,
	0x1ddb,
	0x2b59,
	0x372b,
	0x40df,
	0x4815,
	0x4c86,
	0x4e05,
	0x4c86,
	0x4815,
	0x40df,
	0x372b,
	0x2b59,
	0x1ddb,
	0x0f39,
	0x0000,
	0xf0c7,
	0xe225,
	0xd4a7,
	0xc8d5,
	0xbf21,
	0xb7eb,
	0xb37a,
	0xb1fb,
	0xb37a,
	0xb7eb,
	0xbf21,
	0xc8d5,
	0xd4a7,
	0xe225,
	0xf0c7,
	0x0000,
	0x0f39,
	0x1ddb,
	0x2b59,
	0x372b,
	0x40df,
	0x4815,
	0x4c86,
	0x4e05,
	0x4c86,
	0x4815,
	0x40df,
	0x372b,
	0x2b59,
	0x1ddb,
	0x0f39,
	0x0000,
	0xf0c7,
	0xe225,
	0xd4a7,
	0xc8d5,
	0xbf21,
	0xb7eb,
	0xb37a,
	0xb1fb,
	0xb37a,
	0xb7eb,
	0xbf21,
	0xc8d5,
	0xd4a7,
	0xe225,
	0xf0c7,
	0x0000,
	0x0f39,
	0x1ddb,
	0x2b59,
	0x372b,
	0x40df,
	0x4815,
	0x4c86,
	0x4e05,
	0x4c86,
	0x4815,
	0x40df,
	0x372b,
	0x2b59,
	0x1ddb,
	0x0f39,
	0x0000,
	0xf0c7,
	0xe225,
	0xd4a7,
	0xc8d5,
	0xbf21,
	0xb7eb,
	0xb37a,
	0xb1fb,
	0xb37a,
	0xb7eb,
	0xbf21,
	0xc8d5,
	0xd4a7,
	0xe225,
	0xf0c7,
	0x0000,
	0x0f39,
	0x1ddb,
	0x2b59,
	0x372b,
	0x40df,
	0x4815,
	0x4c86,
	0x4e05,
	0x4c86,
	0x4815,
	0x40df,
	0x372b,
	0x2b59,
	0x1ddb,
	0x0f39,
	0x0000,
	0xf0c7,
	0xe225,
	0xd4a7,
	0xc8d5,
	0xbf21,
	0xb7eb,
	0xb37a,
	0xb1fb,
	0xb37a,
	0xb7eb,
	0xbf21,
	0xc8d5,
	0xd4a7,
	0xe225,
	0xf0c7
};

unsigned char test_encode_res[20];

#endif


static u32 speex_decode_needbuf2(u32 *dt_buf_size)
{
	(*dt_buf_size)=512;
	return sizeof(TEST_ENC_SPEED);
}

static u32 speex_file_format_check2(void *work_buf)
{
    printf("format_out;\n");
	return 0;
}

static  u32 speex_decoder_open2(void *work_buf, const struct if_decoder_io *decoder_io, u8 *bk_point_ptr)
{
	TEST_ENC_SPEED *tns=(TEST_ENC_SPEED *)work_buf;
	EncState *st=&tns->st;
	DecState *dec=&tns->dec;
	memset(st,0,sizeof(EncState));
	st = nb_encoder_init(st,&speex_nb_mode,0);//(SPEEX_MODEID_WB));//
	st->bits.buf_size=160;

	speex_decoder_open(dec,decoder_io,0);
    return 0;
}


u32 speex_decoder_run2(void *work_buf, u32 type)
{
	TEST_ENC_SPEED *tns=(TEST_ENC_SPEED *)work_buf;
	EncState *st=&tns->st;
    nb_encode((u8 *)st);
	nb_decode((u8 *)(&tns->dec));
	return 0;
}

static  dec_inf_t *speex_get_dec_inf2(void *work_buf)
{
	TEST_ENC_SPEED *tns=(TEST_ENC_SPEED *)work_buf;
	return &(tns->dec.dec_info_obj);
}

static  u32 speex_get_time2(void *work_buf)
{
	return 2;
}

const audio_decoder_ops speex_decoder_ops={
	/*.name              = */ "speex",
	/*.open              = */ speex_decoder_open2,
	/*.format_check      = */ speex_file_format_check2,
	/*.run               = */ speex_decoder_run2,
	/*.get_dec_inf       = */ speex_get_dec_inf2,
	/*.get_playtime      = */ speex_get_time2,
	/*.get_bp_inf        = */ speex_get_bp_inf,
	/*.need_dcbuf_size   = */ speex_decode_needbuf2,
	/*.need_bpbuf_size   = */ speex_get_buf_bp,
	/*.need_bkbuf_size   = */ speex_need_bkbuf_size,
	/*.set_bpbuf         = */ speex_set_buf_bp,
	/*.set_bkbuf         = */ speex_set_bkbuf,
	/*.set_step          = */ speex_set_step,
	/*.set_err_info      = */ speex_set_err_info
};

#endif


audio_decoder_ops *get_speex_ops()
{
	return (audio_decoder_ops *)(&speex_decoder_ops);
}




#ifdef WIN32


#define FRAME_SIZE 160
FILE *fram3,*fram2;
int frame_cnt = 0;
int preprocess_or_not=1;
FILE *ly_leak;
FILE *fin, *fout, *fbits=NULL;


u16 e_input_data(void *priv,s16 *buf,u16 len)
{
	return (fread(buf, sizeof(short), len, fin));
}
void e_output_data(void *priv,u8 *buf,u16 len)
{
	fwrite(buf, 1, len, fbits);
}

SPEEX_EN_FILE_IO speex_en_io=
{
	NULL,
	e_input_data,
	e_output_data
};

int d_input(void *priv ,u32 addr , void *buf, int len,u8 type)
{
	unsigned int rlen=0;
	if(type==0)
	{
		fseek(fbits,addr,SEEK_SET);
		rlen=fread(buf,sizeof(char),len,fbits);
	}
	return rlen;
}

int check_buf(void *priv ,u32 addr , void *buf)
{
	unsigned int rlen=0;
	fseek(fbits,addr,SEEK_SET);
	rlen=fread(buf,sizeof(char),RDDATA_BLOCK_SIZE,fbits);
	return rlen;
}

void output(void *priv  ,void *data, int len)
{
	//return;
	fwrite(data,1,len,fout);
}

u32 get_lslen(void *priv)
{
	unsigned int tmp0,tmp1;
	tmp0=ftell(fbits);
	fseek(fbits,0,SEEK_END);
	tmp1=ftell(fbits);
	fseek(fbits,tmp0,SEEK_SET);
	return tmp1;
}
u32 get_dec_mode(void *priv)          ///<0�����ش��̽���ģʽ  ��=0 ���������ģʽ
{
	return 0;
}
u32 get_max_bksize(void *priv)     ///<��ȡ��������У������Իض�ƫ��ֵ
{
	return 0;
}


u32 mp_store_rev_data(void *priv,u32 addr ,int len)
{	///<0�����ش��̽���ģʽ  ��=0 ���������ģʽ
	priv=priv;
	addr=addr;
	return len;
}

const struct if_decoder_io speex_dec_io=
{
	NULL,
	d_input,
	check_buf,
	output,
	get_lslen,
	mp_store_rev_data
};

FILE *fpak;
FILE *fptest0,*fptest1;


int decode_speex(char*bitsFile ,char * outFile){
    
    //bitsFile = argv[1];
    fbits = fopen(bitsFile, "rb");
    
    if(bitsFile==NULL)
    {
        printf("wwww:%s,\n",bitsFile);
        return 0;
    }
    
    
    printf("%s,\n",bitsFile);
    
    //outFile = argv[2];
    fout = fopen(outFile, "wb");
    
    
    audio_decoder_ops  *testdec_ops=get_speex_ops();
    bufsize=testdec_ops->need_dcbuf_size();
    dec=malloc(bufsize);
    testdec_ops->open(dec,&speex_dec_io,NULL);
    
    while(!testdec_ops->run(dec,0))
    {
        //printf("%d,\n",testdec_ops->get_playtime(dec));
    }
    free(dec);
    
    
    
    fclose(fout);
    fclose(fbits);
    
    return 0;
}



int main(int argc, char **argv)
{
    char *inFile, *outFile, *bitsFile;
    short in_short[FRAME_SIZE];
    short out_short[FRAME_SIZE];
    int snr_frames = 0;
    char cbits[200];
    int nbBits;
    int i;
    void *st;
    void *dec;
    SpeexBits bits;
    spx_int32_t tmp;
    int bitCount=0;
    spx_int32_t skip_group_delay;
    SpeexCallback callback;
    u32 bufsize;
    unsigned char *bufptr;

#if 0
    fptest0=fopen("testts.raw","wb");
    inFile = argv[1];
    fin = fopen(inFile, "rb");
    bitsFile = argv[3];
    fbits = fopen(bitsFile, "wb");

    fseek(fin,44,SEEK_SET);

    {
        speex_enc_ops *tst_ops=get_speex_enc_obj();
        bufsize=tst_ops->need_buf();
        st=malloc(bufsize);
        tst_ops->open(st,&speex_en_io,0);
        while(!tst_ops->run(st))
        {
        }
        free(st);

    }



    fclose(fin);
    fclose(fbits);


    fclose(fptest0);


    bitsFile = argv[3];
    //bitsFile="S_SPEX_I.RAW";
    //fbits = fopen(bitsFile, "rb");
    fbits = fopen("ott - ����.spx", "rb");
    //fbits = fopen("123 - ���� - ����.mp3", "rb");

    outFile = argv[2];
    fout = fopen(outFile, "wb");


    {
        audio_decoder_ops  *testdec_ops=get_speex_ops();
        bufsize=testdec_ops->need_dcbuf_size();
        dec=malloc(bufsize);
        testdec_ops->open(dec,&speex_dec_io,NULL);

        while(!testdec_ops->run(dec,0))
        {
            //printf("%d,\n",testdec_ops->get_playtime(dec));
        }
        free(dec);

    }




    fclose(fout);
    fclose(fbits);

#else

    bitsFile = argv[1];
    fbits = fopen(bitsFile, "rb");

    if(bitsFile==NULL)
    {
        printf("wwww:%s,\n",bitsFile);
        return 0;
    }


    printf("%s,\n",bitsFile);

    outFile = argv[2];
    fout = fopen(outFile, "wb");


    {
        audio_decoder_ops  *testdec_ops=get_speex_ops();
        bufsize=testdec_ops->need_dcbuf_size();
        dec=malloc(bufsize);
        testdec_ops->open(dec,&speex_dec_io,NULL);

        while(!testdec_ops->run(dec,0))
        {
            //printf("%d,\n",testdec_ops->get_playtime(dec));
        }
        free(dec);

    }



    fclose(fout);
    fclose(fbits);


#endif




    return 0;
}


#endif
