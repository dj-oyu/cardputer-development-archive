       
typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef short int __int16_t;
typedef short unsigned int __uint16_t;
typedef long int __int32_t;
typedef long unsigned int __uint32_t;
typedef long long int __int64_t;
typedef long long unsigned int __uint64_t;
typedef signed char __int_least8_t;
typedef unsigned char __uint_least8_t;
typedef short int __int_least16_t;
typedef short unsigned int __uint_least16_t;
typedef long int __int_least32_t;
typedef long unsigned int __uint_least32_t;
typedef long long int __int_least64_t;
typedef long long unsigned int __uint_least64_t;
typedef long long int __intmax_t;
typedef long long unsigned int __uintmax_t;
typedef int __intptr_t;
typedef unsigned int __uintptr_t;
       
typedef int ptrdiff_t;
typedef unsigned int size_t;
typedef short unsigned int wchar_t;
typedef struct {
  long long __max_align_ll __attribute__((__aligned__(__alignof__(long long))));
  long double __max_align_ld __attribute__((__aligned__(__alignof__(long double))));
} max_align_t;
  typedef __typeof__(nullptr) nullptr_t;
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       

typedef __int8_t int8_t ;
typedef __uint8_t uint8_t ;
typedef __int16_t int16_t ;
typedef __uint16_t uint16_t ;
typedef __int32_t int32_t ;
typedef __uint32_t uint32_t ;
typedef __int64_t int64_t ;
typedef __uint64_t uint64_t ;
typedef __intmax_t intmax_t;
typedef __uintmax_t uintmax_t;
typedef __intptr_t intptr_t;
typedef __uintptr_t uintptr_t;


typedef __int_least8_t int_least8_t;
typedef __uint_least8_t uint_least8_t;
typedef __int_least16_t int_least16_t;
typedef __uint_least16_t uint_least16_t;
typedef __int_least32_t int_least32_t;
typedef __uint_least32_t uint_least32_t;
typedef __int_least64_t int_least64_t;
typedef __uint_least64_t uint_least64_t;
  typedef int int_fast8_t;
  typedef unsigned int uint_fast8_t;
  typedef int int_fast16_t;
  typedef unsigned int uint_fast16_t;
  typedef int int_fast32_t;
  typedef unsigned int uint_fast32_t;
  typedef long long int int_fast64_t;
  typedef long long unsigned int uint_fast64_t;
 
typedef struct {int64_t values[23];int32_t params[3];int side;unsigned tag;} mc_frame;
typedef struct {int64_t color[3],mix,transparent,params[3];} mc_output;
int mc_prepare(const int32_t controls[9],int side,int diagnostic_style,mc_frame *out);
int mc_eval(const mc_frame*,const int32_t xz[2],mc_output*);
int mc_block(const mc_frame*,const int32_t *xz,unsigned width,mc_output*);
unsigned mc_bits(void);
enum { IL_LIGHTS=3, IL_SAMPLES=16, IL_POSITION_MAX=524288 };
typedef struct {int32_t center[3],sample[16][3];int16_t normal[3];uint32_t power[3];} il_light;
typedef struct {il_light light[3];uint32_t world[3];} il_scene;
typedef struct {int32_t p[3];int16_t normal[3];uint16_t rho[3],visible[3];} il_pixel;
typedef enum {IL_OK,IL_INVALID,IL_FALLBACK_PLANE,IL_FALLBACK_SAMPLE,IL_RANGE} il_status;
static uint64_t il_sqrt(uint64_t x){uint64_t r=0,b=1ULL<<62;while(b>x)b>>=2;while(b){if(x>=r+b){x-=r+b;r=(r>>1)+b;}else r>>=1;b>>=2;}return r;}
static uint64_t il_round(uint64_t n,uint64_t d){uint64_t q=n/d,r=n%d;return q+(r>d-r||(r==d-r&&(q&1)));}
static int64_t il_signed_round(int64_t n,uint64_t d){return n<0?-(int64_t)il_round((uint64_t)(-n),d):(int64_t)il_round((uint64_t)n,d);}
static bool il_position(const int32_t p[3]){for(unsigned k=0;k<3;k++)if(p[k]<-IL_POSITION_MAX||p[k]>IL_POSITION_MAX)return false;return true;}
static uint64_t il_normal_length(const int16_t n[3]){uint64_t s=0;for(unsigned k=0;k<3;k++){if(n[k]==(-0x7fff - 1))return 0;s+=(int64_t)n[k]*n[k];}if(s<32762ULL*32762||s>32772ULL*32772)return 0;return il_sqrt(s<<16);}
static bool il_scene_valid(const il_scene *s){if(!s)return false;for(unsigned k=0;k<3;k++)if(s->world[k]>(16u<<24))return false;for(unsigned l=0;l<3;l++){const il_light *a=&s->light[l];if(!il_position(a->center)||!il_normal_length(a->normal))return false;for(unsigned k=0;k<3;k++)if(a->power[k]>(256u<<16))return false;for(unsigned j=0;j<16;j++)if(!il_position(a->sample[j]))return false;}return true;}
static il_status il_eval(const il_scene *s,const il_pixel *p,uint64_t out[3]){
 if(!s||!p||!out||!il_position(p->p))return IL_INVALID;
 uint64_t nr=il_normal_length(p->normal);if(!nr)return IL_INVALID;
 for(unsigned k=0;k<3;k++)if(p->rho[k]>32767)return IL_INVALID;
 uint64_t rgb[3]={s->world[0],s->world[1],s->world[2]};
 for(unsigned l=0;l<3;l++){
  const il_light *a=&s->light[l];uint64_t nl=il_normal_length(a->normal);if(!nl)return IL_INVALID;
  int64_t plane=0;for(unsigned k=0;k<3;k++)plane+=((int64_t)a->center[k]-p->p[k])*a->normal[k];
  uint64_t ap=plane<0?(uint64_t)-plane:(uint64_t)plane;
  if(ap<272722101ULL)return IL_FALLBACK_PLANE;
  uint64_t sum=0;
  for(unsigned j=0;j<16;j++){
   int64_t d[3];uint64_t rr=0;for(unsigned k=0;k<3;k++){d[k]=(int64_t)a->sample[j][k]-p->p[k];if(d[k]<-1048576||d[k]>1048576)return IL_RANGE;rr+=(uint64_t)(d[k]*d[k]);}
   if(rr<(1ULL<<26))return IL_FALLBACK_SAMPLE;
   uint64_t length=il_sqrt(rr<<16);int16_t wi[3];for(unsigned k=0;k<3;k++)wi[k]=(int16_t)il_signed_round(d[k]*4194304LL,length);
   int64_t dr=0,ds=0;for(unsigned k=0;k<3;k++){dr+=(int64_t)p->normal[k]*wi[k];ds-=(int64_t)a->normal[k]*wi[k];}
   if(dr<=0||ds<=0||!(p->visible[l]&(1u<<j)))continue;
   uint64_t cr=il_round((uint64_t)dr*256,nr),cs=il_round((uint64_t)ds*256,nl);
   if(cr>16387||cs>16387)return IL_RANGE;
   uint64_t inverse=il_round(1ULL<<56,rr);
   uint64_t kernel=il_round(cr*cs*inverse,1ULL<<28);sum+=kernel;
  }
  uint64_t mean=il_round(sum,16);
  for(unsigned k=0;k<3;k++)rgb[k]+=il_round((uint64_t)a->power[k]*mean,1ULL<<16);
 }
 for(unsigned k=0;k<3;k++)out[k]=il_round(rgb[k]*p->rho[k],32767);
 return IL_OK;
}
static bool il_hdr19(const uint64_t in[3],uint32_t out[3]){uint64_t q[3];for(unsigned k=0;k<3;k++){q[k]=il_round(in[k],32);if(q[k]>(0xffffffffUL))return false;}for(unsigned k=0;k<3;k++)out[k]=(uint32_t)q[k];return true;}
static bool il_block(const il_scene *s,const il_pixel *p,unsigned count,uint64_t out[8][3],il_status status[8]){if(count!=1&&count!=2&&count!=4&&count!=8)return false;for(unsigned i=0;i<count;i++)status[i]=il_eval(s,p+i,out[i]);return true;}
typedef enum {IL_NORMAL_OK=0,IL_NORMAL_NEAR_ZERO=1,IL_NORMAL_RANGE=2} il_normal_status;
static il_normal_status il_normalize_interpolated(const int16_t in[3],int16_t out[3]){
 uint64_t sq=0;for(unsigned k=0;k<3;k++)sq+=(int64_t)in[k]*in[k];
 if(sq<512ULL*512)return IL_NORMAL_NEAR_ZERO;
 uint64_t length=il_sqrt(sq<<16),result_sq=0;int16_t result[3];
 for(unsigned k=0;k<3;k++){
  int64_t v=il_signed_round((int64_t)in[k]*8388352LL,length);
  if(v < -32767||v>32767)return IL_NORMAL_RANGE;
  result[k]=(int16_t)v;result_sq+=(uint64_t)(v*v);
 }
 if(result_sq<32762ULL*32762||result_sq>32772ULL*32772)return IL_NORMAL_RANGE;
 for(unsigned k=0;k<3;k++)out[k]=result[k];return IL_NORMAL_OK;
}
typedef struct {uint64_t sum[3];uint8_t count,seen;} aa_state;
typedef struct {uint32_t hdr19[3];uint16_t pixel;uint8_t high_clamped;} aa_result;
typedef enum {AA_OK=0,AA_INVALID=1,AA_INCOMPLETE=2,AA_RANGE=3,AA_HDR19_OVERFLOW=4,AA_ENCODE_ERROR=5} aa_status;
typedef enum {AA_KEEP=0,AA_REPLACE=1} aa_action;
typedef int (*aa_encoder)(void*,const uint32_t[3],uint16_t*);
aa_status aa_init(aa_state*,unsigned sample_count);
aa_status aa_put(aa_state*,unsigned slot,aa_action,const uint64_t original[3],const uint64_t replacement[3]);
aa_status aa_reduce(const aa_state*,uint32_t hdr19[3]);
aa_status aa_finish(const aa_state*,aa_encoder,void*,aa_result*);
aa_status aa_finish_block(const aa_state*,unsigned n,aa_encoder,void*,aa_result*);
typedef struct {
 uint32_t block, start, end;
 uint16_t values[3][64];
 uint8_t encoded[396];
 uint8_t valid, age;
} agx_cache_entry;
typedef struct {
 const uint8_t *blob;
 size_t length;
 uint64_t hits, misses, invalidations;
 agx_cache_entry entries[4];
} agx_block_cache;
void agx_cache_init(agx_block_cache *cache);
void agx_cache_clear(agx_block_cache *cache);
int agx_cache_bind(agx_block_cache *cache,const uint8_t *blob,size_t length);
int agx_cache_fetch4(agx_block_cache *cache,const uint32_t vertices[4],uint16_t rgb[4][3]);
int agx_cache_profile_eval(agx_block_cache *cache,const float in[3],float out[3]);
int agx_cache_bind_profile(agx_block_cache *cache);
typedef struct { uint32_t high_code; const uint32_t *shape; } integer_profile;
uint32_t integer_shape(const integer_profile *, uint32_t code);
int integer_output(agx_block_cache *, const integer_profile *, const uint32_t rgb[3], uint16_t *pixel);
int private_integer_profile_bind(agx_block_cache *cache);
int private_integer_profile_encode(agx_block_cache *cache,const uint32_t hdr_q19[3],uint16_t *rgb565);
int aa_private_profile(void*,const uint32_t[3],uint16_t*);
typedef struct {int32_t local[3][2],world[3][3];int16_t normal[3][3];uint16_t bary[3],visible[3];} kc_slot;
typedef struct {kc_slot slots[4];} kc_input;
typedef struct {mc_output material[4];int32_t local[4][2],world[4][3];int16_t normal[4][3];uint16_t rho[4][3];uint64_t radiance[4][3];aa_result final;} kc_output;
enum {KC_OK,KC_INVALID,KC_MATERIAL,KC_NONOPAQUE,KC_RHO,KC_NORMAL,KC_LIGHT,KC_ACCUMULATE,KC_ENCODE};
int kc_rho(int64_t value,uint16_t *out);
int kc_block(const mc_frame*,const il_scene*,const kc_input*,unsigned,agx_block_cache*,kc_output*);
int kcc_block(const mc_frame*,const il_scene*,const kc_input*,unsigned,agx_block_cache*,aa_result*);
typedef int locale_t;
typedef unsigned int wint_t;
typedef long __blkcnt_t;
typedef __int64_t __blkcnt64_t;
typedef long __blksize_t;
typedef __uint64_t __fsblkcnt_t;
typedef __uint32_t __fsfilcnt_t;
typedef long _off_t;
typedef int __pid_t;
typedef short __dev_t;
typedef unsigned short __uid_t;
typedef unsigned short __gid_t;
typedef __uint32_t __id_t;
typedef unsigned short __ino_t;
typedef __uint64_t __ino64_t;
typedef __uint32_t __mode_t;
__extension__ typedef long long _off64_t;
typedef _off_t __off_t;
typedef __uint64_t __off64_t;
typedef _off64_t __loff_t;
typedef long __key_t;
typedef long _fpos_t;
typedef _off64_t _fpos64_t;
typedef unsigned int __size_t;
typedef signed int _ssize_t;
typedef _ssize_t __ssize_t;
typedef struct
{
  int __count;
  union
  {
    wint_t __wch;
    unsigned char __wchb[4];
    __uint32_t __ucs;
    __uint16_t __ucs2;
  } __value;
} _mbstate_t;
struct __iconv_t;
typedef struct __iconv_t *_iconv_t;
typedef unsigned long __clock_t;
typedef __int_least64_t __time_t;
typedef unsigned long __clockid_t;
typedef long __daddr_t;
typedef unsigned long __timer_t;
typedef __uint8_t __sa_family_t;
typedef __uint32_t __socklen_t;
typedef __int32_t __nl_item;
typedef unsigned short __nlink_t;
typedef long __suseconds_t;
typedef unsigned long __useconds_t;

int bcmp(const void *, const void *, size_t) __attribute__((__pure__));
void bcopy(const void *, void *, size_t);
void bzero(void *, size_t);
void explicit_bzero(void *, size_t);
int ffs(int) __attribute__((__const__));
int ffsl(long) __attribute__((__const__));
int ffsll(long long) __attribute__((__const__));
int fls(int) __attribute__((__const__));
int flsl(long) __attribute__((__const__));
int flsll(long long) __attribute__((__const__));
char *index(const char *, int) __attribute__((__pure__));
char *rindex(const char *, int) __attribute__((__pure__));
int strcasecmp(const char *, const char *) __attribute__((__pure__));
int strncasecmp(const char *, const char *, size_t) __attribute__((__pure__));
int strcasecmp_l (const char *, const char *, locale_t);
int strncasecmp_l (const char *, const char *, size_t, locale_t);


char *__attribute__((__nonnull__ (1)))
         basename (const char *) __asm__("" "__gnu_basename");
void *memccpy (void *restrict, const void *restrict, int, size_t);
void *memchr (const void *, int, size_t);
int memcmp (const void *, const void *, size_t);
void *memcpy (void *restrict, const void *restrict, size_t);
void *memmem (const void *, size_t, const void *, size_t);
void *memmove (void *, const void *, size_t);
void *mempcpy (void *, const void *, size_t);
void *memrchr (const void *, int, size_t);
void *memset (void *, int, size_t);
void *rawmemchr (const void *, int);
char *stpcpy (char *restrict, const char *restrict);
char *stpncpy (char *restrict, const char *restrict, size_t);
char *strcasestr (const char *, const char *);
char *strcat (char *restrict, const char *restrict);
char *strchr (const char *, int);
char *strchrnul (const char *, int);
int strcmp (const char *, const char *);
int strcoll (const char *, const char *);
int strcoll_l (const char *, const char *, locale_t);
char *strcpy (char *restrict, const char *restrict);
size_t strcspn (const char *, const char *);
void free (void *) __attribute__((__nothrow__));
char *strdup (const char *) __attribute__((__malloc__, __malloc__(free,1))) __attribute__((__warn_unused_result__));
char *strerror (int);
char *strerror_l (int, locale_t);
char *strerror_r (int, char *, size_t);
const char *strerrorname_np(int errnum);
const char *strerrordesc_np(int errnum);
size_t strlcat (char *, const char *, size_t);
size_t strlen (const char *);
size_t strlcpy (char *, const char *, size_t);
char *strlwr (char *);
char *strncat (char *restrict, const char *restrict, size_t);
int strncmp (const char *, const char *, size_t);
char *strncpy (char *restrict, const char *restrict, size_t);
char *strndup (const char *, size_t) __attribute__((__malloc__, __malloc__(free,1))) __attribute__((__warn_unused_result__));
size_t strnlen (const char *, size_t);
char *strnstr(const char *, const char *, size_t) __attribute__((__pure__));
char *strpbrk (const char *, const char *);
char *strrchr (const char *, int);
char *strsep (char **, const char *);
char *strsignal (int __signo);
size_t strspn (const char *, const char *);
char *strstr (const char *, const char *);
char *strtok (char *restrict, const char *restrict);
char *strtok_r (char *restrict, const char *restrict, char **restrict);
char *strupr (char *);
int strverscmp (const char *, const char *);
size_t strxfrm (char *restrict, const char *restrict, size_t);
size_t strxfrm_l (char *restrict, const char *restrict, size_t, locale_t);
int timingsafe_bcmp (const void *, const void *, size_t);
int timingsafe_memcmp (const void *, const void *, size_t);

static int compact_rho(int64_t x,uint16_t *out){if(!out||x<0||x>(1LL<<20))return KC_RHO;*out=(uint16_t)il_round((uint64_t)x*32767,1ULL<<20);return 0;}
static int lane(const mc_frame*f,const il_scene*s,const kc_input*in,agx_block_cache*c,aa_result*out){
 aa_result t;memset(&t,0,sizeof t);aa_state a;if(aa_init(&a,4))return KC_ACCUMULATE;
 for(unsigned j=0;j<4;j++){
  mc_output material;int32_t world[3],local[2];int16_t unit_normal[3];uint16_t rho[3];uint64_t radiance[3];
  const kc_slot*v=&in->slots[j];if((unsigned)v->bary[0]+v->bary[1]+v->bary[2]!=16384)return KC_INVALID;
  for(unsigned n=0;n<3;n++)for(unsigned k=0;k<3;k++)if(v->world[n][k]<-(8<<20)||v->world[n][k]>(8<<20))return KC_INVALID;
  for(unsigned n=0;n<3;n++)for(unsigned k=0;k<2;k++)if(v->local[n][k]<-(128LL<<20)||v->local[n][k]>(128LL<<20))return KC_INVALID;
  int16_t raw[3];for(unsigned k=0;k<3;k++){int64_t w=0,r=0;for(unsigned n=0;n<3;n++){w+=(int64_t)v->bary[n]*v->world[n][k];r+=(int64_t)v->bary[n]*v->normal[n][k];}world[k]=(int32_t)il_signed_round(il_signed_round(w,16384),16);raw[k]=(int16_t)il_signed_round(r,16384);}
  for(unsigned k=0;k<2;k++){int64_t x=0;for(unsigned n=0;n<3;n++)x+=(int64_t)v->bary[n]*v->local[n][k];int64_t q20=il_signed_round(x,16384);
if(q20<(-0x7fffffffL - 1)||q20>(0x7fffffffL))return KC_INVALID;local[k]=(int32_t)q20;}
  if(mc_eval(f,local,&material))return KC_MATERIAL;
  if(material.mix!=(1LL<<20))return KC_NONOPAQUE;
  for(unsigned k=0;k<3;k++)if(compact_rho(material.color[k],&rho[k]))return KC_RHO;
  if(il_normalize_interpolated(raw,unit_normal))return KC_NORMAL;
  il_pixel p;memcpy(p.p,world,sizeof p.p);memcpy(p.normal,unit_normal,sizeof p.normal);memcpy(p.rho,rho,sizeof p.rho);memcpy(p.visible,v->visible,sizeof p.visible);
  if(il_eval(s,&p,radiance))return KC_LIGHT;
  if(aa_put(&a,j,AA_KEEP,radiance,0))return KC_ACCUMULATE;
 }
 if(aa_finish(&a,aa_private_profile,c,&t))return KC_ENCODE;
 *out=t;return 0;
}
int kcc_block(const mc_frame*f,const il_scene*s,const kc_input*in,unsigned n,agx_block_cache*c,aa_result*out){
 if(!f||!s||!in||!c||!out||(n!=1&&n!=2&&n!=4&&n!=8)||!il_scene_valid(s))return KC_INVALID;
 aa_result temp[8];for(unsigned i=0;i<n;i++){int e=lane(f,s,in+i,c,temp+i);if(e)return e;}memcpy(out,temp,n*sizeof *out);return 0;
}
