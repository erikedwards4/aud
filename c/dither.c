//Based on Kaldi, dithering for floating-point numbers is
//just adding Gaussian random noise: x[n] += d*randn,
//where d is a dither weight, for which they suggest 0.1 or 1.0.

//However, I don't currently know of a good random number generator for C.
//So, initially, I used drand48 and an idea from Knuth, which only requires include <time.h>.
//Turns out, this is identical to Kaldi (except more robust 1.0-drand48 within log).
//Later, after making better randn using improved code from PCG-random directly,
//this was put into current version.

#include <stdio.h>
#include <stdint.h>
#include <float.h>
#include <math.h>
#include <time.h>

#ifndef M_PI
   #define M_PI 3.141592653589793238462643383279502884
#endif

#ifdef __cplusplus
namespace ov {
extern "C" {
#endif

int dither_s (float *X, const size_t N, const float d);
int dither_d (double *X, const size_t N, const double d);


int dither_s (float *X, const size_t N, const float d)
{
    if (d<0.0f) { fprintf(stderr,"error in dither_s: d (dither weight) must be nonnegative\n"); return 1; }

    if (N==0u || d<FLT_EPSILON) {}
    else
    {
        const float M_2PI = (float)(2.0*M_PI);
        float u1, u2, R;
        uint32_t r, xorshifted, rot;
        uint64_t state = 0u;
        const uint64_t inc = ((uint64_t)(&state) << 1u) | 1u;
        struct timespec ts;

        //Init random num generator
	    if (timespec_get(&ts,TIME_UTC)==0) { fprintf(stderr, "error in dither_s: timespec_get.\n"); perror("timespec_get"); return 1; }
	    state = (uint64_t)(ts.tv_nsec^ts.tv_sec) + inc;

        for (size_t n=0u; n<N-1u; n+=2u)
        {
            state = state*6364136223846793005ull + inc;
            xorshifted = (uint32_t)(((state >> 18u) ^ state) >> 27u);
            rot = state >> 59u;
            r = (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
            u1 = ldexp((float)r,-32);
            state = state*6364136223846793005ull + inc;
            xorshifted = (uint32_t)(((state >> 18u) ^ state) >> 27u);
            rot = state >> 59u;
            r = (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
            u2 = ldexp((float)r,-32);
            R = d * sqrtf(-2.0f*logf(1.0f-u1));
            *X++ += R * cosf(M_2PI*u2);
            *X++ += R * sinf(M_2PI*u2);
        }
        if (N%2==1)
        {
            state = state*6364136223846793005ull + inc;
            xorshifted = (uint32_t)(((state >> 18u) ^ state) >> 27u);
            rot = state >> 59u;
            r = (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
            u1 = ldexp((float)r,-32);
            state = state*6364136223846793005ull + inc;
            xorshifted = (uint32_t)(((state >> 18u) ^ state) >> 27u);
            rot = state >> 59u;
            r = (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
            u2 = ldexp((float)r,-32);
            R = d * sqrtf(-2.0f*logf(1.0f-u1));
            *X++ += R * cosf(M_2PI*u2);
        }
    }

    //Old
    // if (d>FLT_EPSILON)
    // {
    //     if (clock_gettime(CLOCK_REALTIME,&ts)) { fprintf(stderr,"error in dither_s: clock_gettime failed. "); perror("clock_gettime"); return 1; }
	//     srand48(ts.tv_nsec^ts.tv_sec); //seed random number generator
    //     for (n=0; n<N; n++)
    //     {
    //         X[n] += d * sqrtf(-2.0f*logf(1.0f-(float)drand48())) * cosf(M_2PI*(float)drand48());
    //     }
    // }

    return 0;
}


int dither_d (double *X, const size_t N, const double d)
{
    if (d<0.0) { fprintf(stderr,"error in dither_d: d (dither weight) must be nonnegative\n"); return 1; }

    if (N==0u || d<DBL_EPSILON) {}
    else
    {
        const double M_2PI = 2.0 * M_PI;
        double u1, u2, R;
        uint32_t r, xorshifted, rot;
        uint64_t state = 0u;
        const uint64_t inc = ((uint64_t)(&state) << 1u) | 1u;
        struct timespec ts;

        //Init random num generator
	    if (timespec_get(&ts,TIME_UTC)==0) { fprintf(stderr, "error in dither_d: timespec_get.\n"); perror("timespec_get"); return 1; }
	    state = (uint64_t)(ts.tv_nsec^ts.tv_sec) + inc;

        for (size_t n=0u; n<N-1u; n+=2u)
        {
            state = state*6364136223846793005ull + inc;
            xorshifted = (uint32_t)(((state >> 18u) ^ state) >> 27u);
            rot = state >> 59u;
            r = (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
            u1 = ldexp((double)r,-32);
            state = state*6364136223846793005ull + inc;
            xorshifted = (uint32_t)(((state >> 18u) ^ state) >> 27u);
            rot = state >> 59u;
            r = (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
            u2 = ldexp((double)r,-32);
            R = d * sqrt(-2.0*log(1.0-u1));
            *X++ += R * cos(M_2PI*u2);
            *X++ += R * sin(M_2PI*u2);
        }
        if (N%2==1)
        {
            state = state*6364136223846793005ull + inc;
            xorshifted = (uint32_t)(((state >> 18u) ^ state) >> 27u);
            rot = state >> 59u;
            r = (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
            u1 = ldexp((double)r,-32);
            state = state*6364136223846793005ull + inc;
            xorshifted = (uint32_t)(((state >> 18u) ^ state) >> 27u);
            rot = state >> 59u;
            r = (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
            u2 = ldexp((double)r,-32);
            R = d * sqrt(-2.0*log(1.0-u1));
            *X++ += R * cos(M_2PI*u2);
        }
    }

    return 0;
}


#ifdef __cplusplus
}
}
#endif
