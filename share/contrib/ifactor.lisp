;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                        ;;;
;;;                          ~*~  IFACTOR  ~*~                             ;;;
;;;                                                                        ;;;
;;;                  Maxima integer factorisation package.                 ;;;
;;;                                                                        ;;;
;;; Maxima level functions:                                                ;;;
;;;   - ifactor    : factorisation of integers                             ;;;
;;;   - ifactors   : factorisation of integers - returns a list of         ;;;
;;;                  prime-power factors of argument                       ;;;
;;;   - primep_pr  : probabilistic primality test                          ;;;
;;;   - next_prime : smallest prime >= n                                   ;;;
;;;                                                                        ;;;
;;;                                                                        ;;;
;;; Version  : 1.0 (april 2005)                                            ;;;
;;; Copyright: 2005 Andrej Vodopivec                                       ;;;
;;; Licence  : GPL                                                         ;;;
;;;                                                                        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "MAXIMA")
(macsyma-module ifactor)

(defmvar $save_primes nil
  "Save primes found." boolean)
(defmvar $primep_number_of_tests 10
  "Number of primep-test runs" fixnum)

(defmvar $pollard_rho_limit 0
  "Limit for pollard-rho factorisation depth" fixnum)
(defmvar $pollard_rho_limit_step 1000
  "Step for pollard-rho factorization limit" fixnum)

(defmvar $factorization_verbose nil
  "Display factorization steps" boolean)

(defmacro while (cond &rest body)
  `(do ()
       ((not ,cond))
     ,@body))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                       ;;;
;;;        ~*~  IMPLEMENTATION OF FACTORISATION METHODS   ~*~             ;;;
;;;                                                                       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Maxima level functions:
;;;   - ifactors(n):  returns a list of factors of integer n
;;;   - ifactor(n):   factors n
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun $ifactors (n)
  (if (and (integerp n)
           (> n 0))
      (let* ((factor-list (get-small-factors n))
             (large-part (car factor-list))
             (factor-list (cadr factor-list))
             (factor-list (if (> large-part 1)
                              (append (convert-list (get-large-factors large-part))
                                      factor-list)
                              factor-list))
             (factor-list (convert-to-powers factor-list)))
         `((mlist simp) ,@factor-list))
      (merror "Argument to ifactors must be positive integer:~%~M." n)))

(defun $ifactor (n)
  (if (and (integerp n)
           (> n 0))
      (let ((factors (cdr ($ifactors n))))
        (if (> (length factors) 1)
            `((mtimes simp factored) ,@factors)
            (car factors)))
      (merror "Argument to ifactor must be positive integer:~%~M." n)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; factor out primes < *largest-small-prime* and primes which were already
;;; discovered so far (if save_primes is true)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun get-small-factors (n)
  (let ((factors nil))
    (dolist (d (append *small-primes* *large-primes*))
      (let ((deg 0))
        (while (and (> n 1) (equal (mod n d) 0))
          (setq n (/ n d))
          (setq deg (1+ deg)))
        (cond ((> deg 0)
               (cond ((not (null $factorization_verbose))
                      (format t "~&Factoring out small prime: ~A (degree: ~A)" d deg)))
               (setq factors (cons `(,d ,deg) factors))))
        (cond ((equal n 1)
               (return-from get-small-factors `(1 ,factors))))))
    `(,n ,factors)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; get-large-factors returns the list of factors of integer n
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun get-large-factors (n)
  (if ($primep_pr n)
      (list n)
      (get-large-factors-1 n)))

(defun get-large-factors-1 (n)
  (let ((f (get-one-factor n)))
    (append (get-large-factors f) (get-large-factors (/ n f)))))

(defun get-one-factor (n)
  (let ((f 1) (lim $pollard_rho_limit))
    (while (or (equal f 1)
               (equal f n))
      (cond ((not (null $factorization_verbose))
             (format t "~&Starting one round")
             (format t "~&Starting one pollard-rho")))
      (setq f (get-one-factor-pollard n lim))
      (cond ((and (> f 1) (< f n))
             (cond ((not (null $factorization_verbose))
                    (format t "~&Pollard rho: ~A" f)))
             (return-from get-one-factor f)))
      (cond ((> lim 0)
             (setq lim (+ $pollard_rho_limit_step	 lim)))))
    f))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                       ;;;
;;;   ~*~  IMPLEMENTATION OF POLLARDS-RHO FACTORISATION METHOD   ~*~      ;;;
;;;                                                                       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun get-one-factor-pollard (n lim)
  (let* ((x (+ (random (- n 3)) 2))
         (a (+ (random (- n 2)) 1))
         (b (+ (random (- n 5)) 1))
         (y x) (d 1) (r 2) (j 1) (k) (terms 1))
    (setq terms (1+ (floor (log n))))
    (setq b (/ b (gcd a b)))
    (while (equal d 1)
      (setq y x)
      (setq j (+ j r))
      (dotimes (i r)
        (setq x (mod (+ (* a (mod (* x x) n)) b) n)))
      (setq k 0)
      (while (and (< k r)
                  (equal d 1))
        (dotimes (i (min terms (- r k)))
          (setq x (mod (+ (* a (mod (* x x) n)) b) n))
          (setq d (mod (* d (- x y)) n)))
        (setq d (gcd d n))
        (setq k (+ k terms)))
      (setq r (* 2 r))
      (cond ((and (> lim 0)
                  (> j lim))
             (return-from get-one-factor-pollard d))))
    d))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; convert (3 5 3 5 3 7) to ((3 3) (5 2) (7 1))
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun convert-list (l)
  (let ((l1 (sort l (lambda (u v) (> u v)))))
    (convert-list-sub (car l1) 1 (rest l1) nil)))

(defun convert-list-sub (e n l1 l2)
  (cond ((null l1)
         (append l1 (cons (list e n) l2)))
        ((equal e (car l1))
         (convert-list-sub e (1+ n) (rest l1) l2))
        (t (convert-list-sub (car l1) 1 (rest l1) (cons `(,e ,n) l2)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; convert ((3 3) (5 2) (7 1)) to (3^3, 5^2, 7)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun convert-to-powers (l)
  (let ((l1 (sort l (lambda (u v) (> (car u) (car v))))))
    (convert-to-powers-sub l1 nil)))

(defun convert-to-powers-sub (l1 l2)
  (cond ((null l1) l2)
        (t (if (equal (cadar l1) 1)
               (convert-to-powers-sub (cdr l1) (cons (caar l1) l2))
               (convert-to-powers-sub (cdr l1)
                                      (cons `((mexpt simp) ,(caar l1)
                                              ,(cadar l1)) l2))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                       ;;;
;;;           ~*~  IMPLEMENTATION OF PRIMALITY TESTS  ~*~                 ;;;
;;;                                                                       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Maxima level functions:
;;;   - primep_pr(n)  : probabilistic primality test
;;;   - next_prime(n) : smallest prime bigger than n
;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun $primep_pr (n)
  (if (and (integerp n)
           (> n 0))
      (cond ((equal n 1) nil)
            ((equal n 2) t)
            ((evenp n) nil)
            ((< n 10000) (if (member n *small-primes*) t nil))
            ((member n *large-primes*) t)
            (t (primep-prob n)))
      (merror "Argument to primep_pr must be positive integer:~%~M." n)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; strong primality test:
;;;  - run primep-test $primep_number_of_tests times
;;;  - run one lucas test for x^2-b*x+1 where jacobi(b^2-4,n)=-1
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun primep-prob (n)
  (let ((s (1- n))
        (r 0) (b 3))
    (let ((nroot (floor (sqrt n))))
      (cond ((equal (* nroot nroot) n)
             (return-from primep-prob nil))))
    (while (evenp s)
      (setq s (/ s 2))
      (setq r (1+ r)))
    (dotimes (i $primep_number_of_tests)
       (let ((a (1+ (random (- n 4)))))
          (cond ((not (primep-test a s r n))
                 (return-from primep-prob nil)))))
    (while (not (equal ($jacobi (- (* b b) 4) n) -1))
      (setq b (+ b 1)))
    (primep-lucas b (1+ n) n)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; primep-test
;;;   - write n=2^r*s
;;;   - n passes the test if:
;;;        o a^s=1 (mod n)
;;;        o a^(s*2^j)=-1 (mod n) for some j=1..r
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun power-mod (a s n)
  (cond ((equal s 1) (mod a n))
        ((oddp s) (mod (* a (power-mod a (1- s) n)) n))
        (t (let ((as (power-mod a (/ s 2) n)))
             (mod (* as as) n)))))

(defun primep-test (a s r n)
  (let ((as (power-mod a s n)))
    (if (equal as 1)
        t
        (let ((j 0))
          (while (and (< j r) (not (equal as (1- n))))
            (setq j (1+ j))
            (setq as (mod (* as as) n)))
          (not (equal j r))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; primep-lucas:
;;;
;;;  Define: x^2-a*x+b, D=a^2-4*b; x1, x2 roots of x^2+a*x+b;
;;;  U[k]=(x1^k-x2^k)/(x1-x2), V[k]=x1^k+x2^k.
;;;
;;;  Lucas theorem: If p is an odd prime, gcd(p,b)=1 and jacobi(D,p)=-1,
;;;                 then p divides U[p+1].
;;;
;;;  We calculate U[p+1] and test if p divides U[p+1].
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun primep-lucas (p k n)
  (let ((u) (v) (prmp nil))
     (setq *lucas-sequence-u* `((0 0) (1 1)))
     (setq *lucas-sequence-v* `((0 2) (1 ,p)))
     (setq u (get-lucas-sequence-u k p n))
     (setq v (get-lucas-sequence-v k p n))
     (setq prmp (and (equal v 2) (equal u 0)))
     (cond ((and prmp $save_primes)
            (setq *large-primes* (cons n *large-primes*))))
     prmp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Get lucas sequence for x^2-p*x+1.
;;;
;;; Use formulas U[2*m]   = U[m]*V[m]
;;;              U[2*m+1] = U[m+1]*V[m]-1
;;;              V[2*m]   = V[m]^2-2
;;;              V[2*m+1] = V[m+1]*V[m]-p
;;;
;;; Intermediate values are saved in *lucas-sequence-u* and
;;; *lucas-sequence-v*
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar *lucas-sequence-u* `())
(defvar *lucas-sequence-v* `())

(defun get-lucas-sequence-u (k p n)
  (cond ((null (assoc k *lucas-sequence-u*))
         (let ((u (cond ((evenp k)
                         (* (get-lucas-sequence-u (/ k 2) p n)
                            (get-lucas-sequence-v (/ k 2) p n)))
                            
                        (t (let ((k1 (/ (1- k) 2)))
                             (- (* (get-lucas-sequence-u (1+ k1) p n)
                                   (get-lucas-sequence-v k1 p n))
                                1))))))
             (setq u (mod u n))
             (setq *lucas-sequence-u* (cons `(,k ,u) *lucas-sequence-u*))
             u))
        (t (cadr (assoc k *lucas-sequence-u*)))))

(defun get-lucas-sequence-v (k p n)
  (cond ((null (assoc k *lucas-sequence-v*))
         (let ((v (cond ((evenp k)
                         (- (* (get-lucas-sequence-v (/ k 2) p n)
                               (get-lucas-sequence-v (/ k 2) p n))
                             2))
                        (t (let ((k1 (/ (1- k) 2)))
                             (- (* (get-lucas-sequence-v (1+ k1) p n)
                                   (get-lucas-sequence-v k1 p n))
                                p))))))
             (setq v (mod v n))
             (setq *lucas-sequence-v* (cons `(,k ,v) *lucas-sequence-v*))
             v))
        (t (cadr (assoc k *lucas-sequence-v*)))))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Get smallest prime bigger than n
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun $next_prime (n)
 (if (and (integerp n)
          (> n 0))
     (if (equal n 1)
         2
         (next-prime (1+ n)))
     (merror "Argument to next_prime must be positive integer:~%~M." n)))

(defun next-prime (n)
  (cond ((evenp n) (setq n (1+ n))))
  (while (not ($primep_pr n))
    (setq n (+ n 2)))
  n)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Lists of primes up to *largest-small-prime*
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar *small-primes*
  '(
    2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97
    101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181
    191 193 197 199 211 223 227 229 233 239 241 251 257 263 269 271 277
    281 283 293 307 311 313 317 331 337 347 349 353 359 367 373 379 383
    389 397 401 409 419 421 431 433 439 443 449 457 461 463 467 479 487
    491 499 503 509 521 523 541 547 557 563 569 571 577 587 593 599 601
    607 613 617 619 631 641 643 647 653 659 661 673 677 683 691 701 709
    719 727 733 739 743 751 757 761 769 773 787 797 809 811 821 823 827
    829 839 853 857 859 863 877 881 883 887 907 911 919 929 937 941 947
    953 967 971 977 983 991 997 1009 1013 1019 1021 1031 1033 1039 1049
    1051 1061 1063 1069 1087 1091 1093 1097 1103 1109 1117 1123 1129 1151
    1153 1163 1171 1181 1187 1193 1201 1213 1217 1223 1229 1231 1237 1249
    1259 1277 1279 1283 1289 1291 1297 1301 1303 1307 1319 1321 1327 1361
    1367 1373 1381 1399 1409 1423 1427 1429 1433 1439 1447 1451 1453 1459
    1471 1481 1483 1487 1489 1493 1499 1511 1523 1531 1543 1549 1553 1559
    1567 1571 1579 1583 1597 1601 1607 1609 1613 1619 1621 1627 1637 1657
    1663 1667 1669 1693 1697 1699 1709 1721 1723 1733 1741 1747 1753 1759
    1777 1783 1787 1789 1801 1811 1823 1831 1847 1861 1867 1871 1873 1877
    1879 1889 1901 1907 1913 1931 1933 1949 1951 1973 1979 1987 1993 1997
    1999 2003 2011 2017 2027 2029 2039 2053 2063 2069 2081 2083 2087 2089
    2099 2111 2113 2129 2131 2137 2141 2143 2153 2161 2179 2203 2207 2213
    2221 2237 2239 2243 2251 2267 2269 2273 2281 2287 2293 2297 2309 2311
    2333 2339 2341 2347 2351 2357 2371 2377 2381 2383 2389 2393 2399 2411
    2417 2423 2437 2441 2447 2459 2467 2473 2477 2503 2521 2531 2539 2543
    2549 2551 2557 2579 2591 2593 2609 2617 2621 2633 2647 2657 2659 2663
    2671 2677 2683 2687 2689 2693 2699 2707 2711 2713 2719 2729 2731 2741
    2749 2753 2767 2777 2789 2791 2797 2801 2803 2819 2833 2837 2843 2851
    2857 2861 2879 2887 2897 2903 2909 2917 2927 2939 2953 2957 2963 2969
    2971 2999 3001 3011 3019 3023 3037 3041 3049 3061 3067 3079 3083 3089
    3109 3119 3121 3137 3163 3167 3169 3181 3187 3191 3203 3209 3217 3221
    3229 3251 3253 3257 3259 3271 3299 3301 3307 3313 3319 3323 3329 3331
    3343 3347 3359 3361 3371 3373 3389 3391 3407 3413 3433 3449 3457 3461
    3463 3467 3469 3491 3499 3511 3517 3527 3529 3533 3539 3541 3547 3557
    3559 3571 3581 3583 3593 3607 3613 3617 3623 3631 3637 3643 3659 3671
    3673 3677 3691 3697 3701 3709 3719 3727 3733 3739 3761 3767 3769 3779
    3793 3797 3803 3821 3823 3833 3847 3851 3853 3863 3877 3881 3889 3907
    3911 3917 3919 3923 3929 3931 3943 3947 3967 3989 4001 4003 4007 4013
    4019 4021 4027 4049 4051 4057 4073 4079 4091 4093 4099 4111 4127 4129
    4133 4139 4153 4157 4159 4177 4201 4211 4217 4219 4229 4231 4241 4243
    4253 4259 4261 4271 4273 4283 4289 4297 4327 4337 4339 4349 4357 4363
    4373 4391 4397 4409 4421 4423 4441 4447 4451 4457 4463 4481 4483 4493
    4507 4513 4517 4519 4523 4547 4549 4561 4567 4583 4591 4597 4603 4621
    4637 4639 4643 4649 4651 4657 4663 4673 4679 4691 4703 4721 4723 4729
    4733 4751 4759 4783 4787 4789 4793 4799 4801 4813 4817 4831 4861 4871
    4877 4889 4903 4909 4919 4931 4933 4937 4943 4951 4957 4967 4969 4973
    4987 4993 4999 5003 5009 5011 5021 5023 5039 5051 5059 5077 5081 5087
    5099 5101 5107 5113 5119 5147 5153 5167 5171 5179 5189 5197 5209 5227
    5231 5233 5237 5261 5273 5279 5281 5297 5303 5309 5323 5333 5347 5351
    5381 5387 5393 5399 5407 5413 5417 5419 5431 5437 5441 5443 5449 5471
    5477 5479 5483 5501 5503 5507 5519 5521 5527 5531 5557 5563 5569 5573
    5581 5591 5623 5639 5641 5647 5651 5653 5657 5659 5669 5683 5689 5693
    5701 5711 5717 5737 5741 5743 5749 5779 5783 5791 5801 5807 5813 5821
    5827 5839 5843 5849 5851 5857 5861 5867 5869 5879 5881 5897 5903 5923
    5927 5939 5953 5981 5987 6007 6011 6029 6037 6043 6047 6053 6067 6073
    6079 6089 6091 6101 6113 6121 6131 6133 6143 6151 6163 6173 6197 6199
    6203 6211 6217 6221 6229 6247 6257 6263 6269 6271 6277 6287 6299 6301
    6311 6317 6323 6329 6337 6343 6353 6359 6361 6367 6373 6379 6389 6397
    6421 6427 6449 6451 6469 6473 6481 6491 6521 6529 6547 6551 6553 6563
    6569 6571 6577 6581 6599 6607 6619 6637 6653 6659 6661 6673 6679 6689
    6691 6701 6703 6709 6719 6733 6737 6761 6763 6779 6781 6791 6793 6803
    6823 6827 6829 6833 6841 6857 6863 6869 6871 6883 6899 6907 6911 6917
    6947 6949 6959 6961 6967 6971 6977 6983 6991 6997 7001 7013 7019 7027
    7039 7043 7057 7069 7079 7103 7109 7121 7127 7129 7151 7159 7177 7187
    7193 7207 7211 7213 7219 7229 7237 7243 7247 7253 7283 7297 7307 7309
    7321 7331 7333 7349 7351 7369 7393 7411 7417 7433 7451 7457 7459 7477
    7481 7487 7489 7499 7507 7517 7523 7529 7537 7541 7547 7549 7559 7561
    7573 7577 7583 7589 7591 7603 7607 7621 7639 7643 7649 7669 7673 7681
    7687 7691 7699 7703 7717 7723 7727 7741 7753 7757 7759 7789 7793 7817
    7823 7829 7841 7853 7867 7873 7877 7879 7883 7901 7907 7919 7927 7933
    7937 7949 7951 7963 7993 8009 8011 8017 8039 8053 8059 8069 8081 8087
    8089 8093 8101 8111 8117 8123 8147 8161 8167 8171 8179 8191 8209 8219
    8221 8231 8233 8237 8243 8263 8269 8273 8287 8291 8293 8297 8311 8317
    8329 8353 8363 8369 8377 8387 8389 8419 8423 8429 8431 8443 8447 8461
    8467 8501 8513 8521 8527 8537 8539 8543 8563 8573 8581 8597 8599 8609
    8623 8627 8629 8641 8647 8663 8669 8677 8681 8689 8693 8699 8707 8713
    8719 8731 8737 8741 8747 8753 8761 8779 8783 8803 8807 8819 8821 8831
    8837 8839 8849 8861 8863 8867 8887 8893 8923 8929 8933 8941 8951 8963
    8969 8971 8999 9001 9007 9011 9013 9029 9041 9043 9049 9059 9067 9091
    9103 9109 9127 9133 9137 9151 9157 9161 9173 9181 9187 9199 9203 9209
    9221 9227 9239 9241 9257 9277 9281 9283 9293 9311 9319 9323 9337 9341
    9343 9349 9371 9377 9391 9397 9403 9413 9419 9421 9431 9433 9437 9439
    9461 9463 9467 9473 9479 9491 9497 9511 9521 9533 9539 9547 9551 9587
    9601 9613 9619 9623 9629 9631 9643 9649 9661 9677 9679 9689 9697 9719
    9721 9733 9739 9743 9749 9767 9769 9781 9787 9791 9803 9811 9817 9829
    9833 9839 9851 9857 9859 9871 9883 9887 9901 9907 9923 9929 9931 9941
    9949 9967 9973
   ))

(defvar *largest-small-prime* 9973)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Lists of numbers which have already been tested and are
;;; primes > *largest-small-prime*
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar *large-primes* `())
