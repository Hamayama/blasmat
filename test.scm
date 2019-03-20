;;;
;;; Test blasmat
;;;

(use gauche.test)
(use gauche.array)
(use gauche.uvector)

(define (nearly=? x y :optional (precision 1e-12))
  (<= (abs (- x y)) precision))

(define (array-nearly=? a b)
  (or (eq? a b)
      (and (eq? (class-of a) (class-of b))
           (array-equal? a b nearly=?))))

;; for Gauche v0.9.4
(define f64array
  (if (global-variable-bound? 'gauche.array 'f64array)
    (with-module gauche.array f64array)
    (lambda (shape . inits)
      (rlet1 ar (make-f64array shape 0)
        (f64vector-copy! (slot-ref ar 'backing-storage)
                         0 (list->f64vector inits))))))

(test-start "blasmat")
(use blasmat)
(test-module 'blasmat)

;; The following is a dummy test code.
;; Replace it for your tests.
(test* "test-blasmat" "blasmat is working"
       (test-blasmat))

(define A  (f64array (shape 0 2 0 3)  1  2  3  4  5  6))
(define B  (f64array (shape 0 2 0 3)  7  8  9 10 11 12))
(test* "blas-array-daxpy 1" #,(<f64array> (0 2 0 3) 9 12 15 18 21 24)
       (blas-array-daxpy A B 2.0) array-nearly=?)

(define G1 (f64array (shape 0 0 0 0)))
(define G2 (f64array (shape 0 0 0 0)))
(test* "blas-array-daxpy 2" G1
       (blas-array-daxpy G1 G2 1.0))

(define A  (f64array (shape 0 2 0 3)  1  2  3  4  5  6))
(define B  (f64array (shape 0 3 0 2)  7  8  9 10 11 12))
(define C  (f64array (shape 0 2 0 2) 10 20 30 40))
(test* "blas-array-dgemm 1" #,(<f64array> (0 2 0 2) 68 84 169 194)
       (blas-array-dgemm A B C    1.0 1.0 #f #f) array-nearly=?)

(define TA (f64array (shape 0 3 0 2)  1  4  2  5  3  6))
(define B  (f64array (shape 0 3 0 2)  7  8  9 10 11 12))
(define C  (f64array (shape 0 2 0 2) 10 20 30 40))
(test* "blas-array-dgemm 2 (trans-A)" #,(<f64array> (0 2 0 2) 68 84 169 194)
       (blas-array-dgemm TA B C   1.0 1.0 #t #f) array-nearly=?)

(define A  (f64array (shape 0 2 0 3)  1  2  3  4  5  6))
(define TB (f64array (shape 0 2 0 3)  7  9 11  8 10 12))
(define C  (f64array (shape 0 2 0 2) 10 20 30 40))
(test* "blas-array-dgemm 3 (trans-B)" #,(<f64array> (0 2 0 2) 68 84 169 194)
       (blas-array-dgemm A TB C   1.0 1.0 #f #t) array-nearly=?)

(define TA (f64array (shape 0 3 0 2)  1  4  2  5  3  6))
(define TB (f64array (shape 0 2 0 3)  7  9 11  8 10 12))
(define C  (f64array (shape 0 2 0 2) 10 20 30 40))
(test* "blas-array-dgemm 4 (trans-A,trans-B)" #,(<f64array> (0 2 0 2) 68 84 169 194)
       (blas-array-dgemm TA TB C  1.0 1.0 #t #t) array-nearly=?)

(define G1 (f64array (shape 0 0 0 0)))
(define G2 (f64array (shape 0 0 0 0)))
(define G3 (f64array (shape 0 0 0 0)))
(test* "blas-array-dgemm 5" G1
       (blas-array-dgemm G1 G2 G3 1.0 1.0 #f #f))

;; summary
(format (current-error-port) "~%~a" ((with-module gauche.test format-summary)))

;; If you don't want `gosh' to exit with nonzero status even if
;; the test fails, pass #f to :exit-on-failure.
(test-end :exit-on-failure #t)

