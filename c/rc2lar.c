//Gets log area ratios (LARs) from the reflection coefficients (RCs) along cols or rows of X.

//The complex-valued versions are defined just in case (although I don't know of their use in practice).
//They make it impossible to compile this directly under C++, so commented-out for now.

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <complex.h>

#ifdef __cplusplus
namespace ov {
extern "C" {
#endif

int rc2lar_s (float *Y, const float *X, const int N);
int rc2lar_d (double *Y, const double *X, const int N);
int rc2lar_c (float *Y, const float *X, const int N);
int rc2lar_z (double *Y, const double *X, const int N);


int rc2lar_s (float *Y, const float *X, const int N)
{
    int n;

    //for (n=0; n<N; n++) { Y[n] = -2.0f * atanhf(X[n]); }
    for (n=0; n<N; n++) { Y[n] = logf((1.0f-X[n])/(1.0f+X[n])); }

    return 0;
}


int rc2lar_d (double *Y, const double *X, const int N)
{
    int n;

    //for (n=0; n<N; n++) { Y[n] = -2.0 * atanh(X[n]); }
    for (n=0; n<N; n++) { Y[n] = log((1.0-X[n])/(1.0+X[n])); }

    return 0;
}


int rc2lar_c (float *Y, const float *X, const int N)
{
    int n;
    _Complex float z;

    for (n=0; n<N; n++)
    {
        z = -2.0f * catanhf(X[2*n]+1.0if*X[2*n+1]);
        Y[2*n] = crealf(z); Y[2*n+1] = cimagf(z);
    }

    return 0;
}


int rc2lar_z (double *Y, const double *X, const int N)
{
    int n;
    _Complex double z;

    for (n=0; n<N; n++)
    {
        z = -2.0 * catanh(X[2*n]+1.0i*X[2*n+1]);
        Y[2*n] = creal(z); Y[2*n+1] = cimag(z);
    }

    return 0;
}


#ifdef __cplusplus
}
}
#endif

