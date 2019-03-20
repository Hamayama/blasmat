;; -*- coding: utf-8 -*-
;;
;; blasmat.scm
;; 2019-3-20 v1.03
;;
;; ＜内容＞
;;   Gauche で、OpenBLAS ライブラリを使って行列の高速演算を行うためのモジュールです。
;;   OpenBLAS は、C/Fortran で書かれた線形代数用のライブラリです ( https://www.openblas.net )。
;;   現状、本モジュールは、標準の gauhce.array モジュールにおける
;;   2次元の f64array の ごく一部の演算のみが可能です。
;;
;;   詳細については、以下のページを参照ください。
;;   https://github.com/Hamayama/blasmat
;;
(define-module blasmat
  (use gauche.uvector)
  (use gauche.array)
  (use gauche.version)
  (export
    test-blasmat
    blas-array-daxpy
    blas-array-dgemm
    ))
(select-module blasmat)

;; Loads extension
(dynamic-load "blasmat")

;;
;; Put your Scheme definitions here
;;

;; == 内部処理用 ==

;; 行列の情報取得(エラーチェックなし)
(define-inline (array-rank   A)
  (s32vector-length (slot-ref A 'start-vector)))
(define-inline (array-start  A dim)
  (s32vector-ref    (slot-ref A 'start-vector) dim))
(define-inline (array-end    A dim)
  (s32vector-ref    (slot-ref A 'end-vector)   dim))
(define-inline (array-length A dim)
  (- (s32vector-ref (slot-ref A 'end-vector)   dim)
     (s32vector-ref (slot-ref A 'start-vector) dim)))

;; 行列の次元数のチェック
(define-syntax check-array-rank
  (syntax-rules ()
    ((_ A B ...)
     (unless (= (array-rank A) (array-rank B) ... 2)
       (error "array rank must be 2")))))

;; == ここから 公開I/F ==

;; B = alpha A + B を計算
(define-method blas-array-daxpy ((A <f64array>)
                                 (B <f64array>)
                                 (alpha <real>))
  (check-array-rank A B)
  (let ((data1 (slot-ref A 'backing-storage))
        (n1    (array-length A 0))
        (m1    (array-length A 1))
        (data2 (slot-ref B 'backing-storage))
        (n2    (array-length B 0))
        (m2    (array-length B 1)))
    (unless (and (= n1 n2) (= m1 m2))
      (error "array shape mismatch"))
    (blas-matrix-daxpy data1 data2 (* n1 m1) alpha)
    B))

;; C = alpha A B + beta C を計算
(define-method blas-array-dgemm ((A <f64array>)
                                 (B <f64array>)
                                 (C <f64array>)
                                 (alpha <real>)
                                 (beta  <real>)
                                 (trans-A <boolean>)
                                 (trans-B <boolean>))
  (check-array-rank A B C)
  (let ((data1 (slot-ref A 'backing-storage))
        (n1    (array-length A 0))
        (m1    (array-length A 1))
        (data2 (slot-ref B 'backing-storage))
        (n2    (array-length B 0))
        (m2    (array-length B 1))
        (data3 (slot-ref C 'backing-storage))
        (n3    (array-length C 0))
        (m3    (array-length C 1))
        (temp  0))
    (when trans-A
      (set! temp n1) (set! n1 m1) (set! m1 temp))
    (when trans-B
      (set! temp n2) (set! n2 m2) (set! m2 temp))
    (unless (and (= m1 n2) (= n1 n3) (= m2 m3))
      (error "array shape mismatch"))
    (blas-matrix-dgemm data1 data2 data3 n1 m2 m1 alpha beta
                       (if trans-A 1 0) (if trans-B 1 0))
    C))

