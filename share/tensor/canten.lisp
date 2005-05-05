;;; -*- Mode:LISP; Package:MACSYMA -*-
;; 
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.
;;
;; Comments: Canonical simplification for itensor.lisp
;;

;	** (c) Copyright 1979 Massachusetts Institute of Technology **

(in-package "MAXIMA")



(DECLARE-TOP (SPECIAL FREI BOUNI $CANTERM BREAKLIST SMLIST $IDUMMYX))

(SETQ NODOWN '($ICHR2 $ICHR1 %ICHR2 %ICHR1 $KDELTA %KDELTA))

(DEFUN NDOWN (X) (PUTPROP X T 'NODOWN))

(DEFUN NDOWNL (L) (MAPCAR 'NDOWN L))

(NDOWNL NODOWN)

(SETQ BREAKLIST NIL $CANTERM NIL)


(DEFUN BREK (I) (COND  ((ZL-MEMBER I BREAKLIST) T) ))

; This package blindly rearranges the indices of RPOBJs, even those for
; which such index mangling is forbidden, like our special tensors. To
; avoid this, we use a private version of RPOBJ that excludes special
; tensors like the Levi-Civita or Christoffel symbols

(defun specialrpobj (e)
  (cond ((or (atom e) (atom (car e))) nil)
        (t (or (member (caar e) christoffels)
               (eq (caar e) '$kdelta) (eq (caar e) '%kdelta)
               (eq (caar e) '$levi_civita) (eq (caar e) '%levi_civita)
           )
        )
  )
)

(defun reallyrpobj (e) (cond ((specialrpobj e) nil) (t (rpobj e))))

;L IS A LIST OF FACTORS WHICH RPOBS SEPARATES INTO A LIST OF TWO LISTS.  THE
;FIRST IS A LIST OF THE RPOBECTS IN L.  THE SECOND IS A LIST OF NON-RP OBJECTS

(DEFUN RPOBS (L)
 (DO ( (X L (CDR X))
       (Y NIL (COND ((reallyRPOBJ (CAR X)) (APPEND (LIST (CAR X)) Y) )
                    (T  Y) )    )
       (Z NIL (COND ((reallyRPOBJ (CAR X)) Z) 
                    (T (APPEND (LIST (CAR X)) Z)) ) )    )

     ( (NULL X) (CONS  Y (LIST Z)))  ))
     
;(DEFUN NAME (RP) (COND ((RPOBJ RP) (CAAR RP) )
;                        (T (MERROR "NOT RPOBJECT"))))
;(DEFUN CONTI (RP) (COND ((RPOBJ RP) (CDADDR RP))
;                       (T (MERROR "NOT RPOBJECT"))))
;
;(DEFUN COVI (RP) (COND ((RPOBJ RP) (CDADR RP))
;                       (T (MERROR "NOT RPOBJECT"))))
;
;(DEFUN DERI (RP) (COND ((RPOBJ RP) (CDDDR RP))
;                       (T (MERROR "NOT RPOBJECT"))))
;
;(DEFMFUN $NAME (RP) (COND (($TENPR RP) (CAAR RP) ) ;test the name of tensor
;                        (T (MERROR "NOT TENPRECT"))))
;(DEFMFUN $CONTI (RP) (COND (($TENPR RP) (cons SMLIST (CDADDR RP)))
;                       (T (MERROR "NOT RPOBJECT")))) ;test the contravariant indices
;
;(DEFMFUN $COVI (RP) (COND (($TENPR RP) (cons SMLIST (CDADR RP)))
;                       (T (MERROR "NOT RPOBJECT")))) ;test the contravariant indices
;
;(DEFUN $DERI (RP) (COND (($TENPR RP) (cons SMLIST (CDDDR RP)))
;                       (T (MERROR "NOT RPOBJECT"))))

(DEFUN FRE (L) (INTERSECT L FREI))

(DEFUN BOUN (L) (INTERSECT L BOUNI))


(DEFUN GRADE (RP) (f+ (LENGTH (COVI RP))
                   (f+ (LENGTH (CONTI RP)) (LENGTH (DERI RP))) ) )

;MON IS A MONOMIAL WHOSE "APPARENT" RANK IS ARANK

(DEFUN ARANK (MON) 
  (DO ( (I 0 (f+ (LENGTH (ALLIND (CAR L))) I))
        (L (CDR MON) (CDR L) ) )
        ((NULL L)  I)  ))

(DEFUN EQARANK (M1 M2) (= (ARANK M1) (ARANK M2)))

;RP1 AND RP2 ARE RPOBJECTS WITH THE SAME GRADE

(DEFUN ALPHADI (RP1 RP2)
  (ALPHALESSP
   (CATENATE (INDLIS RP1))
   (CATENATE (INDLIS RP2))))


(DEFUN CATENATE (LIS)  (IMPLODE (EXPLODEN LIS)))

(DEFUN INDLIS (RP) (PROG (F1 F2 F3 B1 B2 B3)
 (SETQ F1 (FRE (COVI RP))
       F2 (FRE (CONTI RP))
       F3 (FRE (DERI RP))
       B1 (BOUN (COVI RP))
       B2 (BOUN (CONTI RP))
       B3 (BOUN (DERI RP)))
(RETURN
 (APPEND (SORT (APPEND F1 F2 F3 NIL) 'ALPHALESSP)
	 (LIST (CAAR RP))
	 (SORT (APPEND B1 B2 B3 NIL) 'ALPHALESSP)))))

;HOW TO USE ARRAY NAME AS PROG VARIABLE?

(DEFUN ASORT (L P ) (COND ((LESSP (LENGTH L) 2) L)
(T 
(PROG (I J K AZ) 
   (SETQ I 0 J 0 K (LENGTH L) AZ (ARRAY NIL T K))
   (FILLARRAY AZ L)
A  (COND ((EQUAL J (f+ -1 K))
           (RETURN (LISTARRAY AZ)))
        ((EQUAL I (f- K 1)) (SETQ I 0) (GO A))
        ((APPLY P (LIST (ARRAYCALL T AZ I) (ARRAYCALL T AZ (f+ 1 I)))) 
            (SETQ I (f+ 1 I) J (f+ 1 J)) (GO A))
        ((APPLY P (LIST (ARRAYCALL T AZ (f+ 1 I)) (ARRAYCALL T AZ I)))
            (PERMUTE AZ I (f+ 1 I))
            (SETQ I (f+ 1 I) J 0)  (GO A) ))   ))))

(DEFUN PERMUTE (ARRA I J)  (PROG (X) (SETQ X (ARRAYCALL T ARRA I))
       (STORE (ARRAYCALL T ARRA I) (ARRAYCALL T ARRA J)) 
       (STORE (ARRAYCALL T ARRA J)  X)  ))

(DEFUN PRANK (RP1 RP2) (COND
    ((> (GRADE RP1) (GRADE RP2)) T)
    ((EQUAL (GRADE RP1) (GRADE RP2)) (ALPHADI RP1 RP2))  ))


(DEFUN SA (X) (SORT (APPEND X NIL) 'ALPHALESSP))

(DEFUN TOP (RP) (CDADDR RP))
(DEFUN BOT (RP) (APPEND (CDADR RP) (CDDDR RP)))
(DEFUN ALLIND (RP) (COND ((NOT (reallyRPOBJ RP)) NIL)
            (T (APPEND (CDADR RP) (CDADDR RP) (CDDDR RP)))))

;MON IS A MONOMIAL WHOSE FACTORS ARE ANYBODY
;$IRPMON AND IRPMON RETURN LIST IS FREE AND DUMMY INDICES

(DEFUN $IRPMON (MON) (PROG (L CF DUM FREE CL CI)
 (SETQ L    (CDR MON)  
       CF   (CAR L)  
       DUM  NIL
       FREE NIL
       CL   (ALLIND CF)
       CI   NIL )
 A  (COND ((NULL L) (when (eq T (BREK 19)) (break "19"))
            (RETURN (APPEND (LIST SMLIST)
                            (LA (LIST SMLIST) FREE)
                            (LA (LIST SMLIST) DUM) ) ))
          ((NULL CL) (when (eq T (BREK 18)) (break "18"))
            (SETQ L (CDR L) CF (CAR L) CL (ALLIND CF))
                     (GO A) )
          (T (SETQ CI (CAR CL))
             (COND ((NOT (MEMQ CI FREE)) (when (eq T (BREK 17)) (break "17"))
                     (SETQ FREE (ENDCONS CI FREE)
                           CL (CDR CL))  (GO A) )
                   (T  (when (eq T (BREK 16)) (break "16"))
                    (SETQ FREE (COMP FREE (LIST CI))          
                           DUM (ENDCONS CI DUM) 
                            CL (CDR CL))  (GO A) ) ) ))))

(DEFUN IRPMON (MON) (PROG (L CF DUM FREE UNIO CL CI)
 (SETQ L    (CDR MON)
       CF   (CAR L)  
       DUM  NIL
       FREE NIL
       UNIO NIL
       CL   (ALLIND CF)
       CI   NIL )
 A  (COND ((NULL L) (when (eq T (BREK 15)) (break "15"))
             (SETQ FREE (COMP UNIO DUM)
                   DUM (COMP UNIO FREE))
            (RETURN (APPEND (LIST FREE) (LIST DUM)) ))

          ((NULL CL) (when (eq T (BREK 14)) (break "14"))
            (SETQ L (CDR L) CF (CAR L) CL (ALLIND CF))
                     (GO A) )
          (T (SETQ CI (CAR CL))
             (COND ((NOT (MEMQ CI UNIO)) (when (eq T (BREK 13)) (break "13"))
                     (SETQ UNIO (ENDCONS CI UNIO)
                           CL (CDR CL))  (GO A) )
                   (T  (when (eq T (BREK 12)) (break "12"))
                    (SETQ DUM (ENDCONS CI DUM) 
                            CL (CDR CL))  (GO A) ) ) ))))

;THE ARGUMENT E IS A PRODUCT OF FACTORS SOME OF WHICH ARE NOT RPOBJECTS. THE
;FUNCTION RPOBS SEPARATES THESE AND PUTS THEM INTO NRPFACT.  THE RPFACTORS ARE
;SORTED AND PUT IN A

(DEFUN REDCAN (E) 
  (PROG (A B C D L NRPFACT CCI COI CT CIL OCIL)  (when (eq T (BREK 6)) (break "6"))
    (SETQ NRPFACT  (CADR (RPOBS (CDR E)))
          D (IRPMON E)
	  FREI (CAR D) BOUNI (CADR D)
          A (SORT (APPEND (CAR (RPOBS (CDR E))) NIL) 'PRANK)
	  L (LENGTH A) 
          B (ARRAY NIL T L)
          C (ARRAY NIL T L 4))
    (FILLARRAY B A) (when (eq T (BREK 7)) (break "7"))
    (DO  ( (I 0 (f+ 1 I)) )
         ( (EQUAL I L)    )
         (STORE (ARRAYCALL T C I 0) (NAME (ARRAYCALL T B I)))
         (STORE (ARRAYCALL T C I 1) (CONTI (ARRAYCALL T B I)))
         (STORE (ARRAYCALL T C I 2) (COVI (ARRAYCALL T B I)))
         (STORE (ARRAYCALL T C I 3) (DERI (ARRAYCALL T B I)))   )


     (SETQ OCIL (DO  ((I 0 (f+ 1 I)) 
		      (M NIL (APPEND (ARRAYCALL T C I 3) M) ) )
		     ((EQUAL I L) M)    )
           OCIL (APPEND OCIL (ARRAYCALL T C 0 2) (CAR D))
           CT  0
           CIL  (ARRAYCALL T C CT 1)
           CCI  (CAR CIL)  )
     (STORE (ARRAYCALL T C CT 1) NIL)

 A (COND 
    ((EQUAL CT (f+ -1 L))
     (when (eq T (BREK 1)) (break "1"))
     (STORE (ARRAYCALL T C CT 1) CIL)
     (RETURN 
      (APPEND NRPFACT 
	      (DO ((I 0 (f+ 1 I))
		   (LIS (APDVAL C 0) (APPEND LIS (APDVAL C (f+ 1 I))) ) )
		  ((EQUAL I (f+ -1 L)) LIS ) ))) )     

    ((ZL-GET (ARRAYCALL T C CT 0) 'NODOWN)
     (STORE (ARRAYCALL T C CT 1) CIL)
     (SETQ CT (f+ 1 CT) CIL (ARRAYCALL T C CT 1)
	   OCIL (APPEND (ARRAYCALL T C CT 2) OCIL))
     (STORE (ARRAYCALL T C CT 1) NIL) (GO A))

    ((NULL CIL) 
     (when (eq T (BREK 2)) (break "2"))
     (SETQ CT (f+ 1 CT) CIL (ARRAYCALL T C CT 1) 
	   OCIL (APPEND (ARRAYCALL T C CT 2) OCIL) )
     (STORE (ARRAYCALL T C CT 1) NIL) (GO A) )

    (T (SETQ CCI (CAR CIL))  (when (eq T (BREK 5)) (break "5"))
       (COND ((NOT (MEMQ CCI OCIL)) 
	     (when (eq T (BREK 3)) (break "3"))
	      (SETQ COI (DO  ((I (f+ 1 CT) (f+ 1 I) ) )
			     ((MEMQ CCI (ARRAYCALL T C I 2)) I)))
 
              (STORE (ARRAYCALL T C CT 2) 
                    (CONS CCI (ARRAYCALL T C CT 2)))
              (STORE (ARRAYCALL T C COI 1) 
                    (CONS CCI (ARRAYCALL T C COI 1)))
              (STORE (ARRAYCALL T C COI 2)
                    (COMP (ARRAYCALL T C COI 2) (LIST CCI)))
              (SETQ OCIL (CONS CCI OCIL)
                     CIL (CDR CIL)       )  (GO A)   )
         (T  (when (eq T (BREK 4)) (break "4"))
             (STORE (ARRAYCALL T C CT 1) (CONS CCI (ARRAYCALL T C CT 1)) )
             (SETQ CIL (CDR CIL)  ) (GO A) ) )) )   ) )
                     
(DEFUN LA (X Y) (LIST (APPEND X Y)))
                                   
(DEFUN APDVAL (C I) (LIST (APPEND (LIST (CONS (ARRAYCALL T C I 0)
                                          (LIST 'SIMP)))
                             (LA (LIST SMLIST)
                                 (SA (ARRAYCALL T C I 2)))
                             (LA (LIST SMLIST)
                                 (SA (ARRAYCALL T C I 1)))
                             (SA (ARRAYCALL T C I 3) ))))
(DEFUN CANFORM (E)
   (COND ((ATOM E) E)
         ((RPOBJ E)   E)
         ((AND (EQ (CAAR E) 'MTIMES) 
               (= 0 (LENGTH (CAR (RPOBS (CDR E))))) )  E)
         ((EQ (CAAR E) 'MTIMES)
          (CONS '(MTIMES) (REDCAN E)) )
         ((EQ (CAAR E) 'MPLUS)
            (MYSUBST0
             (SIMPLUS (CONS '(MPLUS) 
              (MAPCAR #'(LAMBDA (V) (CONS '(MPLUS) (CANARANK V)))   
		      (STRATA (CDR E) 'EQARANK) ))
                1. NIL)              E)  )
          (T E) ))


(DEFUN ENDCONS (X L) (REVERSE (CONS X (REVERSE L))))

(DEFUN COMP (X Y)
 (DO  ((Z  (COND ((ATOM Y) (NCONS Y)) (Y)));patch for case when Y is not a list
       (L  X  (CDR L))
       (A  NIL (COND ((ZL-MEMBER (CAR L) Z)  A)
                     (T  (ENDCONS (CAR L) A)) )))
      ((NULL L) A)  )  )

(DEFUN APDUNION (X Y)
(DO  ((L  Y  (CDR L))
      (A  X  (COND ((ZL-MEMBER (CAR L) A)  A)
                   (T (ENDCONS (CAR L) A))  )))
     ((NULL L)  A) ))

;; Removed - duplicates INTERSECT function -- vtt
;;(DEFUN INT (A B) (PROG (A1 B1 C)
;;		       (SETQ A1 A B1 B C NIL)
;;		  A    (COND ((NULL A1) (RETURN C))
;;			     ((ZL-MEMBER (CAR A1) B1)
;;			      (SETQ C (CONS (CAR A1) C))
;;			      (SETQ B1 (COMP B1 (CAR A1)))
;;			      (SETQ A1 (CDR A1))
;;			      (GO B))
;;			     (T (SETQ A1 (CDR A1)) (GO B)))
;;		  B    (COND ((NULL B1) (RETURN C))
;;			     ((ZL-MEMBER (CAR B1) A1)
;;			      (SETQ C (CONS (CAR B1) C))
;;			      (SETQ A1 (COMP A1 (CAR B1)))
;;			      (SETQ B1 (CDR B1))
;;			      (GO A))
;;			     (T (SETQ B1 (CDR B1)) (GO A)))))

;LIST IS A LIST OF CANFORMED MONOMIALS OF THE SAME ARANK
;CANARANK FINDS THE EQUIVALENT ONES

(DEFUN CANARANK (LIS) (PROG (A B C D CT CNT I)
     (SETQ  A  LIS
            B  NIL
            C  (CDR A)
            D  (ARRAY NIL T (LENGTH A))
           CT  (CANFORM (CAR A))  
          CNT  (CANFORM (CAR C))
            I  1  )
     (FILLARRAY D A)

A   (COND ((NULL A)   
               (RETURN B))
         
          ((AND (NULL (CDR A)) (NULL C))
               (SETQ B (CONS CT B))
               (RETURN B) )


          ((NULL C) (when (eq T (BREK 9)) (break "9"))
             (SETQ B (CONS CT B))
             (STORE (ARRAYCALL T D 0) NIL)
             (SETQ A (COMP (LISTARRAY D) (LIST NIL))
                   C (CDR A)
                   I 1
                  CT (CANFORM (CAR A))
                 CNT (CANFORM (CAR C)) ) 
            (COND ((NULL A) (RETURN B)) 
                  (T (SETQ D (ARRAY NIL T (LENGTH A)))
                     (FILLARRAY D A)))
            (GO A))

          ((SAMESTRUC CT CNT) (when (eq T (BREK 10)) (break "10"))
             (SETQ B (CONS (CANFORM (TRANSFORM CNT CT)) B))
             (STORE (ARRAYCALL T D I) NIL)
             (SETQ C (CDR C)
                 CNT (CANFORM (CAR C))
                   I (f+ 1 I) )  (GO A) )
      
           (T (when (eq T (BREK 11)) (break "11"))
             (SETQ C (CDR C)
                 CNT (CANFORM (CAR C))
                   I (f+ 1 I)) (GO A)) )))

;M1,M2 ARE (CANFORMED) MONOMIALS WHOSE INDEX STRUCTURE MAY BE THE SAME

(DEFUN SAMESTRUC (M1 M2) (EQUAL (INDSTRUC M1) (INDSTRUC M2)))
     
;MON IS (MTIMES) A LIST OF RP AND NON-RP FACTORS IN A MONOMIAL.  THE NEXT
;FUNCTION RETURNS A LIST WHOSE ELEMENTS ARE 4-ELEMENT LISTS GIVING THE NAME
;(MON) AND THE LENGTHS OF THE COVARIANT,CONTRAVARIANT,DERIVATIVE INDICES.

(DEFUN INDSTRUC (MON)
 (DO  ( (L (CDR MON) (CDR L))
        (B NIL (COND ((reallyRPOBJ (CAR L)) 
                       (APPEND B  (LIST (FINDSTRUC (CAR L))) ))
                      (T  B) ))  )
      ( (NULL L)  B)  )  )


 
;FACT IS AN RP  FACTOR IN MON. HERE WE FIND ITS INDEX STRUCTURE

(DEFUN FINDSTRUC (FACT)
       (APPEND (LIST (CAAR FACT) )
               (LIST (LENGTH (CDADR FACT)))
               (LIST (LENGTH (CDADDR FACT)))
               (LIST (LENGTH (CDDDR FACT))) ))

;M1,M2 ARE MONOMIALS WITH THE SAMESTRUC TURE. THE NEXT FUNCTION TRANSFORMS
;(PERMUTES) THE FORM OF M1 INTO M2.

(DEFUN TRANSFORM  (M1 M2)
  (SUBLIS  (FINDPERM M1 M2) M1))

(DEFUN STRATA (LIS P)
 (COND ((OR (NULL LIS) (NULL (CDR LIS))) (LIST LIS))
       (T

  (PROG  (L BL CS)   (SETQ L LIS CS NIL BL NIL)

  A  (COND ((NULL L) (when (eq T (BREK 1)) (break "1"))
                     (RETURN (COND ((NULL CS) BL)
                                   (T (ENDCONS CS BL)))))

           ((AND (NULL (CDR L)) (NULL CS)) (when (eq T (BREK 2)) (break "2"))
                      (SETQ BL (ENDCONS (LIST (CAR L)) BL))
                      (RETURN BL) )
        ((AND (NULL (CDR L)) (NOT (NULL CS))) (when (eq T (BREK 3)) (break "3"))
             (RETURN (COND ((FUNCALL P (CAR L) (CAR CS)) 
                     (SETQ CS (CONS (CAR L) CS)
                           BL (ENDCONS CS BL)))
                   (T (SETQ BL (ENDCONS (LIST (CAR L)) (ENDCONS CS BL)))))))

           ((NULL CS) (when (eq T (BREK 4)) (break "4"))
 (SETQ CS (LIST (CAR L)) L (CDR L)) (GO A))
           ((FUNCALL P (CAR L) (CAR CS)) (when (eq T (BREK 5)) (break "5"))
             (SETQ CS (CONS (CAR L) CS)
                   L (CDR L)) (GO A)   )

           (T   (when (eq T (BREK 6)) (break "6"))
 (SETQ BL (ENDCONS  CS BL)
                    CS (LIST (CAR L))
                    L  (CDR L) )  (GO A) ) ) ))))



(DEFUN TINDSTRUC (MON)
 (DO ( (L (CDR MON) (CDR L))
       (B NIL (COND ((reallyRPOBJ (CAR L))
                     (APPEND B  (TFINDSTRUC (CAR L)) ))
                    (T B) )))
     ((NULL L) B)))

(DEFUN TFINDSTRUC (FACT)
     (APPEND (CDADR FACT) (CDADDR FACT) (CDDDR FACT) ))   

(DEFUN DUMM (X)  (EQUAL (CADR (EXPLODEC X)) $IDUMMYX))


(DEFUN FINDPERMUT (I1 I2) 
  (COMP (MAPCAR 'PIJ I1 I2) (LIST NIL)))

(DEFUN PIJ (X Y)
  (COND ((AND (DUMM X) (DUMM Y) (NOT (EQ X Y))) (CONS X Y))))
     

;(SAMESTRUC M1 M2) IS  T  FOR THE ARGUMENTS BELOW
;THE RESULTING PERMUTATION IS GIVEN TO TRANSFORM

(DEFUN FINDPERM (M1 M2)
  (DO  ((D1 (CADR (IRPMON M1))    )
        (D2 (CADR (IRPMON M2))    )
        (I1 (TINDSTRUC M1) (CDR I1) )
        (I2 (TINDSTRUC M2) (CDR I2) )  
        (L NIL (COND ((AND (MEMQ (CAR I1) D1) (MEMQ (CAR I2) D2)
                           (NOT (EQ (CAR I1) (CAR I2)))
                           (NOT (MEMQ (CAR I1) (CAR L)))
                           (NOT (MEMQ (CAR I2) (CADR L))) )
                      (CONS (ENDCONS (CAR I1) (CAR L))
                       (LIST (ENDCONS (CAR I2) (CADR L))) ) )
		     (T L))))
  
  ((NULL I1) (MAPCAR 'CONS
                      (APPEND (CAR L) (COMP D1 (CAR L)))
                      (APPEND (CADR L) (COMP D2 (CADR L)))))))

     
 
(DEFUN $CANTEN (X)  (DO ((I ($NTERMS X) ($NTERMS L))
                      (L (CANFORM X) (CANFORM L)) )
                     ((= I ($NTERMS L))  L) 
		      (COND ((EQ $CANTERM T) (PRINT I))) ))

(DEFUN $CONCAN (X) (DO ((I ($NTERMS X) ($NTERMS L))
			(L (CANFORM X) ($CONTRACT (CANFORM L))))
		       ((= I ($NTERMS L)) L)
		       (COND ((EQ $CANTERM T) (PRINT I))) ))


