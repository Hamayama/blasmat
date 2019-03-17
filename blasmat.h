/*
 * blasmat.h
 */

/* Prologue */
#ifndef GAUCHE_BLASMAT_H
#define GAUCHE_BLASMAT_H

#include <gauche.h>
#include <gauche/extend.h>

SCM_DECL_BEGIN

/*
 * The following entry is a dummy one.
 * Replace it for your declarations.
 */

extern ScmObj test_blasmat(void);

int blas_matrix_daxpy(double* data1, double* data2, int n, double alpha);

int blas_matrix_dgemm(double* data1, double* data2, double* data3,
                      int m, int n, int k, double alpha, double beta);

/* Epilogue */
SCM_DECL_END

#endif  /* GAUCHE_BLASMAT_H */
