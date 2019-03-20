/*
 * blasmat.c
 */

#include "blasmat.h"
#include <stdio.h>
#include <OpenBLAS/cblas.h>

/*
 * The following function is a dummy one; replace it for
 * your C function definitions.
 */

ScmObj test_blasmat(void)
{
    int m, n, k;
    double A[6] = {  1.0,  2.0,  3.0,  4.0,  5.0,  6.0 };
    double B[6] = {  7.0,  8.0,  9.0, 10.0, 11.0, 12.0 };
    double C[4] = { 10.0, 20.0, 30.0, 40.0 };
    double alpha = 1.0;
    double beta  = 1.0;

    m = 2; n = 2; k = 3;
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
                m, n, k, alpha, A, k, B, n, beta, C, n);
    //printf("\n");
    //printf("C[0] = %lf\n", C[0]); //  68.000000
    //printf("C[1] = %lf\n", C[1]); //  84.000000
    //printf("C[2] = %lf\n", C[2]); // 169.000000
    //printf("C[3] = %lf\n", C[3]); // 194.000000
    return SCM_MAKE_STR("blasmat is working");
}

// B = alpha A + B を計算
//   A     : 行列 (サイズは 1 x n)
//   B     : 行列 (サイズは 1 x n)
//   alpha : スカラー
int blas_matrix_daxpy(double* data1, double* data2, int n, double alpha) {
    if (n < 0) return FALSE;
    cblas_daxpy(n, alpha, data1, 1, data2, 1);
    return TRUE;
}

// C = alpha A B + beta C を計算
//   A     : 行列 (サイズは m x k)
//   B     : 行列 (サイズは k x n)
//   C     : 行列 (サイズは m x n)
//   alpha : スカラー
//   beta  : スカラー
int blas_matrix_dgemm(double* data1, double* data2, double* data3,
                      int m, int n, int k, double alpha, double beta,
                      int trans1, int trans2) {
    if (m < 0 || n < 0 || k < 0) return FALSE;
    cblas_dgemm(CblasRowMajor,
                (trans1 ? CblasTrans : CblasNoTrans),
                (trans2 ? CblasTrans : CblasNoTrans),
                m, n, k, alpha,
                data1, (trans1 ? m : k),
                data2, (trans2 ? k : n),
                beta,
                data3, n);
    return TRUE;
}

/*
 * Module initialization function.
 */
extern void Scm_Init_blasmatlib(ScmModule*);

void Scm_Init_blasmat(void)
{
    ScmModule *mod;

    /* Register this DSO to Gauche */
    SCM_INIT_EXTENSION(blasmat);

    /* Create the module if it doesn't exist yet. */
    mod = SCM_MODULE(SCM_FIND_MODULE("blasmat", TRUE));

    /* Register stub-generated procedures */
    Scm_Init_blasmatlib(mod);
}
