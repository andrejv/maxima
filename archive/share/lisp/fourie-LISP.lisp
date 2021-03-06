;;; -*- Mode: Lisp; package:maxima; syntax:common-lisp ;Base: 10 -*- ;;;

(in-package "MAXIMA")
;;** Variable settings were **

;;TRANSCOMPILE:FALSE;
;;TR\_SEMICOMPILE:FALSE;
;;TRANSLATE\_FAST\_ARRAYS:TRUE;
;;TR\_WARN\_UNDECLARED:COMPILE;
;;TR\_WARN\_MEVAL:COMPFILE;
;;TR\_WARN\_FEXPR:COMPFILE;
;;TR\_WARN\_MODE:ALL;
;;TR\_WARN\_UNDEFINED\_VARIABLE:ALL;
;;TR\_FUNCTION\_CALL\_DEFAULT:GENERAL;
;;TR\_ARRAY\_AS\_REF:TRUE;
;;TR\_NUMER:FALSE;
;;DEFINE\_VARIABLE:FALSE;

(EVAL-WHEN (COMPILE LOAD EVAL)
  (MEVAL* '(($DECLARE) ((MLIST) $A $B) $SPECIAL)))
(PROGN
  'COMPILE
  (MEVAL* '(($MODEDECLARE) $SINNPIFLAG $BOOLEAN))
  (MEVAL* '(($DECLARE) $SINNPIFLAG $SPECIAL))
  (DEFPROP $SINNPIFLAG ASSIGN-MODE-CHECK ASSIGN)
  (DEF-MTRVAR $SINNPIFLAG T))
(PROGN
  'COMPILE
  (MEVAL* '(($MODEDECLARE) $COSNPIFLAG $BOOLEAN))
  (MEVAL* '(($DECLARE) $COSNPIFLAG $SPECIAL))
  (DEFPROP $COSNPIFLAG ASSIGN-MODE-CHECK ASSIGN)
  (DEF-MTRVAR $COSNPIFLAG T))
(PROGN
  'COMPILE
  (DEFPROP $REMFUN1 T TRANSLATED)
  (ADD2LNC '$REMFUN1 $PROPS)
  (DEFMTRFUN ($REMFUN1 $ANY MDEFINE NIL NIL) ($FUN $EXP) NIL
      (SIMPLIFY
          (SCANMAP1
              (GETOPR (M-TLAMBDA&ENV (($Q) ($FUN)) NIL
                          (SIMPLIFY (MFUNCTION-CALL $DELFUN1 $FUN $Q))))
              $EXP))))
(PROGN
  'COMPILE
  (DEFPROP $DELFUN1 T TRANSLATED)
  (ADD2LNC '$DELFUN1 $PROPS)
  (DEFMTRFUN ($DELFUN1 $ANY MDEFINE NIL NIL) ($FUN $EXP) NIL
      (COND
        ((AND (NOT (MFUNCTION-CALL $ATOM $EXP))
              (LIKE (SIMPLIFY (MFUNCTION-CALL $INPART $EXP 0)) $FUN))
         (SIMPLIFY ($FIRST (SIMPLIFY (MFUNCTION-CALL $ARGS $EXP)))))
        (T $EXP))))
(PROGN
  'COMPILE
  (DEFPROP $REMFUNN1 T TRANSLATED)
  (ADD2LNC '$REMFUNN1 $PROPS)
  (DEFMTRFUN ($REMFUNN1 $ANY MDEFINE NIL NIL) ($FUN $EXP) NIL
      (SIMPLIFY
          (SCANMAP1
              (GETOPR (M-TLAMBDA&ENV (($Q) ($FUN)) NIL
                          (SIMPLIFY (MFUNCTION-CALL $DELFUNN1 $FUN $Q))))
              $EXP))))
(PROGN
  'COMPILE
  (DEFPROP $DELFUNN1 T TRANSLATED)
  (ADD2LNC '$DELFUNN1 $PROPS)
  (DEFMTRFUN ($DELFUNN1 $ANY MDEFINE NIL NIL) ($FUN $EXP) NIL
      (COND
        ((AND (NOT (MFUNCTION-CALL $ATOM $EXP))
              (LIKE (SIMPLIFY (MFUNCTION-CALL $INPART $EXP 0)) $FUN))
         (*MMINUS (SIMPLIFY
                      ($FIRST (SIMPLIFY (MFUNCTION-CALL $ARGS $EXP))))))
        (T $EXP))))
(PROGN
  'COMPILE
  (DEFPROP $REMFUN2 T TRANSLATED)
  (ADD2LNC '$REMFUN2 $PROPS)
  (DEFMTRFUN ($REMFUN2 $ANY MDEFINE NIL NIL) ($FUN $EXP $VAR) NIL
      (SIMPLIFY
          (SCANMAP1
              (GETOPR (M-TLAMBDA&ENV (($Q) ($FUN $VAR)) NIL
                          (SIMPLIFY
                              (MFUNCTION-CALL $DELFUN2 $FUN $Q $VAR))))
              $EXP))))
(PROGN
  'COMPILE
  (DEFPROP $DELFUN2 T TRANSLATED)
  (ADD2LNC '$DELFUN2 $PROPS)
  (DEFMTRFUN ($DELFUN2 $ANY MDEFINE NIL NIL) ($FUN $EXP $VAR) NIL
      (COND
        ((AND (NOT (MFUNCTION-CALL $ATOM $EXP))
              (LIKE (SIMPLIFY (MFUNCTION-CALL $INPART $EXP 0)) $FUN)
              (MFUNCTION-CALL $MEMBER $VAR
                  (SIMPLIFY (MFUNCTION-CALL $LISTOFVARS $EXP))))
         (SIMPLIFY ($FIRST (SIMPLIFY (MFUNCTION-CALL $ARGS $EXP)))))
        (T $EXP))))
(PROGN
  'COMPILE
  (DEFPROP $REMFUNN2 T TRANSLATED)
  (ADD2LNC '$REMFUNN2 $PROPS)
  (DEFMTRFUN ($REMFUNN2 $ANY MDEFINE NIL NIL) ($FUN $EXP $VAR) NIL
      (SIMPLIFY
          (SCANMAP1
              (GETOPR (M-TLAMBDA&ENV (($Q) ($FUN $VAR)) NIL
                          (SIMPLIFY
                              (MFUNCTION-CALL $DELFUNN2 $FUN $Q $VAR))))
              $EXP))))
(PROGN
  'COMPILE
  (DEFPROP $DELFUNN2 T TRANSLATED)
  (ADD2LNC '$DELFUNN2 $PROPS)
  (DEFMTRFUN ($DELFUNN2 $ANY MDEFINE NIL NIL) ($FUN $EXP $VAR) NIL
      (COND
        ((AND (NOT (MFUNCTION-CALL $ATOM $EXP))
              (LIKE (SIMPLIFY (MFUNCTION-CALL $INPART $EXP 0)) $FUN)
              (MFUNCTION-CALL $MEMBER $VAR
                  (SIMPLIFY (MFUNCTION-CALL $LISTOFVARS $EXP))))
         (*MMINUS (SIMPLIFY
                      ($FIRST (SIMPLIFY (MFUNCTION-CALL $ARGS $EXP))))))
        (T $EXP))))
(PROGN
  'COMPILE
  (DEFPROP $REMFUN T TRANSLATED)
  (ADD2LNC '$REMFUN $PROPS)
  (DEFMTRFUN ($REMFUN $ANY MDEFINE T NIL) ($FUN $EXP $VAR) NIL
      (COND
        ((LIKE $VAR '((MLIST)))
         (SIMPLIFY (MFUNCTION-CALL $REMFUN1 $FUN $EXP)))
        ((EQL (MFUNCTION-CALL $LENGTH $VAR) 1)
         (SIMPLIFY
             (MFUNCTION-CALL $REMFUN2 $FUN $EXP
                 (SIMPLIFY ($FIRST $VAR)))))
        (T (SIMPLIFY
               (MFUNCTION-CALL $ERROR '|&TOO MANY ARGUMENTS TO REMFUN|))))))
(PROGN
  'COMPILE
  (DEFPROP $REMFUNN T TRANSLATED)
  (ADD2LNC '$REMFUNN $PROPS)
  (DEFMTRFUN ($REMFUNN $ANY MDEFINE T NIL) ($FUN $EXP $VAR) NIL
      (COND
        ((LIKE $VAR '((MLIST)))
         (SIMPLIFY (MFUNCTION-CALL $REMFUNN1 $FUN $EXP)))
        ((EQL (MFUNCTION-CALL $LENGTH $VAR) 1)
         (SIMPLIFY
             (MFUNCTION-CALL $REMFUNN2 $FUN $EXP
                 (SIMPLIFY ($FIRST $VAR)))))
        (T (SIMPLIFY
               (MFUNCTION-CALL $ERROR
                   '|&TOO MANY ARGUMENTS TO REMFUNN|))))))
(PROGN
  'COMPILE
  (DEFPROP $FUNP1 T TRANSLATED)
  (ADD2LNC '$FUNP1 $PROPS)
  (DEFMTRFUN ($FUNP1 $BOOLEAN MDEFINE NIL NIL) ($FUN $EXP) NIL
      ((LAMBDA ($INFLAG)
         NIL
         (SETQ $INFLAG T)
         (COND
           ((MFUNCTION-CALL $MAPATOM $EXP) NIL)
           ((LIKE (SIMPLIFY (MFUNCTION-CALL $INPART $EXP 0)) $FUN) T)
           (T (MFUNCTION-CALL $MEMBER T
                  (MAPLIST_TR
                      (M-TLAMBDA&ENV (($Q) ($FUN)) NIL
                          (SIMPLIFY (MFUNCTION-CALL $FUNP1 $FUN $Q)))
                      $EXP)))))
       '$INFLAG)))
(PROGN
  'COMPILE
  (DEFPROP $FUNP2 T TRANSLATED)
  (ADD2LNC '$FUNP2 $PROPS)
  (DEFMTRFUN ($FUNP2 $BOOLEAN MDEFINE NIL NIL) ($FUN $EXP $VAR) NIL
      ((LAMBDA ($INFLAG)
         NIL
         (SETQ $INFLAG T)
         (COND
           ((MFUNCTION-CALL $MAPATOM $EXP) NIL)
           ((AND (LIKE (SIMPLIFY (MFUNCTION-CALL $INPART $EXP 0)) $FUN)
                 (MFUNCTION-CALL $MEMBER $VAR
                     (SIMPLIFY (MFUNCTION-CALL $LISTOFVARS $EXP))))
            T)
           (T (MFUNCTION-CALL $MEMBER T
                  (MAPLIST_TR
                      (M-TLAMBDA&ENV (($Q) ($FUN $VAR)) NIL
                          (SIMPLIFY
                              (MFUNCTION-CALL $FUNP2 $FUN $Q $VAR)))
                      $EXP)))))
       '$INFLAG)))
(PROGN
  'COMPILE
  (DEFPROP $FUNP T TRANSLATED)
  (ADD2LNC '$FUNP $PROPS)
  (DEFMTRFUN ($FUNP $ANY MDEFINE T NIL) ($FUN $EXP $VAR) NIL
      (COND
        ((LIKE $VAR '((MLIST))) (MFUNCTION-CALL $FUNP1 $FUN $EXP))
        ((EQL (MFUNCTION-CALL $LENGTH $VAR) 1)
         (MFUNCTION-CALL $FUNP2 $FUN $EXP (SIMPLIFY ($FIRST $VAR))))
        (T (SIMPLIFY
               (MFUNCTION-CALL $ERROR '|&TOO MANY ARGUMENTS TO FUNP|))))))
(PROGN
  'COMPILE
  (DEFPROP $EQUALP T TRANSLATED)
  (ADD2LNC '$EQUALP $PROPS)
  (DEFMTRFUN ($EQUALP $BOOLEAN MDEFINE NIL NIL) ($X $Y) NIL
      ((LAMBDA ($PREDERROR)
         NIL
         (SETQ $PREDERROR NIL)
         (COND ((LIKE (IS-BOOLE-CHECK (MEQP $X $Y)) T) T)))
       '$PREDERROR)))
(PROGN
  'COMPILE
  (DEFPROP $PARITY T TRANSLATED)
  (ADD2LNC '$PARITY $PROPS)
  (DEFMTRFUN ($PARITY $ANY MDEFINE NIL NIL) ($F $X) NIL
      (COND
        ((IS-BOOLE-CHECK (SIMPLIFY (MFUNCTION-CALL $EVENFUNP $F $X)))
         '$EVEN)
        ((IS-BOOLE-CHECK (SIMPLIFY (MFUNCTION-CALL $ODDFUNP $F $X)))
         '$ODD)
        (T '$NEITHER))))
(PROGN
  'COMPILE
  (DEFPROP $EVENFUNP T TRANSLATED)
  (ADD2LNC '$EVENFUNP $PROPS)
  (DEFMTRFUN ($EVENFUNP $BOOLEAN MDEFINE NIL NIL) ($F $X) NIL
      (COND
        ((MFUNCTION-CALL $EQUALP $F
             (SIMPLIFY (MFUNCTION-CALL $SUBSTITUTE (*MMINUS $X) $X $F)))
         T))))
(PROGN
  'COMPILE
  (DEFPROP $ODDFUNP T TRANSLATED)
  (ADD2LNC '$ODDFUNP $PROPS)
  (DEFMTRFUN ($ODDFUNP $BOOLEAN MDEFINE NIL NIL) ($F $X) NIL
      (COND
        ((MFUNCTION-CALL $EQUALP $F
             (*MMINUS (SIMPLIFY
                          (MFUNCTION-CALL $SUBSTITUTE (*MMINUS $X) $X
                              $F))))
         T))))
(PROGN
  'COMPILE
  (DEFPROP $PARINT T TRANSLATED)
  (ADD2LNC '$PARINT $PROPS)
  (DEFMTRFUN ($PARINT $ANY MDEFINE NIL NIL) ($F $X $A $B) NIL
      (COND
        ((NOT (OR (MFUNCTION-CALL $EQUALP
                      (*MMINUS (TRD-MSYMEVAL $A '$A))
                      (TRD-MSYMEVAL $B '$B))
                  (AND (LIKE (TRD-MSYMEVAL $A '$A) '$MINF)
                       (LIKE (TRD-MSYMEVAL $B '$B) '$INF))
                  (AND (LIKE (TRD-MSYMEVAL $A '$A) '$INF)
                       (LIKE (TRD-MSYMEVAL $B '$B) '$MINF))))
         $F)
        ((OR (MFUNCTION-CALL $ATOM $F)
             (NOT (LIKE (SIMPLIFY (MFUNCTION-CALL $INPART $F 0)) '&+)))
         (SIMPLIFY (MFUNCTION-CALL $PARINT1 $F $X)))
        (T (SIMPLIFY
               (MAP1 (GETOPR (M-TLAMBDA&ENV (($Q) ($X)) NIL
                                 (SIMPLIFY
                                     (MFUNCTION-CALL $PARINT1 $Q $X))))
                     $F))))))
(PROGN
  'COMPILE
  (DEFPROP $PARINT1 T TRANSLATED)
  (ADD2LNC '$PARINT1 $PROPS)
  (DEFMTRFUN ($PARINT1 $ANY MDEFINE NIL NIL) ($F $X) NIL
      (COND ((MFUNCTION-CALL $ODDFUNP $F $X) 0) (T $F))))
(PROGN
  'COMPILE
  (DEFPROP $ADEFINT T TRANSLATED)
  (ADD2LNC '$ADEFINT $PROPS)
  (DEFMTRFUN ($ADEFINT $ANY MDEFINE NIL NIL) ($F $X $A $B) NIL
      ((LAMBDA ($ASIGN $BSIGN)
         NIL
         (COND
           ((MFUNCTION-CALL $EQUALP (TRD-MSYMEVAL $A '$A)
                (TRD-MSYMEVAL $B '$B))
            0)
           ((NOT (AND (MFUNCTION-CALL $FREEOF '$%I $F)
                      (MFUNCTION-CALL $FREEOF '$%I
                          (TRD-MSYMEVAL $A '$A))
                      (MFUNCTION-CALL $FREEOF '$%I
                          (TRD-MSYMEVAL $B '$B))))
            (SIMPLIFY (MFUNCTION-CALL $LDEFINT $F $X
                          (TRD-MSYMEVAL $A '$A) (TRD-MSYMEVAL $B '$B))))
           (T (SETQ $F
                    (SIMPLIFY
                        (MFUNCTION-CALL $PARINT $F $X
                            (TRD-MSYMEVAL $A '$A)
                            (TRD-MSYMEVAL $B '$B))))
              (COND
                ((MFUNCTION-CALL $EQUALP $F 0) 0)
                ((NOT (MFUNCTION-CALL $FUNP2 'MABS $F $X))
                 (SIMPLIFY
                     (MFUNCTION-CALL $LDEFINT $F $X
                         (TRD-MSYMEVAL $A '$A) (TRD-MSYMEVAL $B '$B))))
                (T (SETQ $ASIGN
                         (SIMPLIFY
                             (MFUNCTION-CALL $ASKSIGN
                                 (TRD-MSYMEVAL $A '$A))))
                   (SETQ $BSIGN
                         (SIMPLIFY
                             (MFUNCTION-CALL $ASKSIGN
                                 (TRD-MSYMEVAL $B '$B))))
                   (COND
                     ((AND (OR (LIKE $ASIGN '$NEG)
                               (LIKE $ASIGN '$ZERO))
                           (OR (LIKE $BSIGN '$NEG)
                               (LIKE $BSIGN '$ZERO)))
                      (SIMPLIFY
                          (MFUNCTION-CALL $LDEFINT
                              (SIMPLIFY
                                  (MFUNCTION-CALL $REMFUNN2 'MABS $F
                                      $X))
                              $X (TRD-MSYMEVAL $A '$A)
                              (TRD-MSYMEVAL $B '$B))))
                     ((AND (OR (LIKE $ASIGN '$ZERO)
                               (LIKE $ASIGN '$POS))
                           (OR (LIKE $BSIGN '$ZERO)
                               (LIKE $BSIGN '$POS)))
                      (SIMPLIFY
                          (MFUNCTION-CALL $LDEFINT
                              (SIMPLIFY
                                  (MFUNCTION-CALL $REMFUN2 'MABS $F $X))
                              $X (TRD-MSYMEVAL $A '$A)
                              (TRD-MSYMEVAL $B '$B))))
                     ((LIKE $ASIGN '$NEG)
                      (SIMPLIFY
                          (MFUNCTION-CALL $RATSIMP
                              (ADD* (SIMPLIFY
                                     (MFUNCTION-CALL $LDEFINT
                                      (SIMPLIFY
                                       (MFUNCTION-CALL $REMFUNN2 'MABS
                                        $F $X))
                                      $X (TRD-MSYMEVAL $A '$A) 0))
                                    (SIMPLIFY
                                     (MFUNCTION-CALL $LDEFINT
                                      (SIMPLIFY
                                       (MFUNCTION-CALL $REMFUN2 'MABS
                                        $F $X))
                                      $X 0 (TRD-MSYMEVAL $B '$B)))))))
                     (T (SIMPLIFY
                            (MFUNCTION-CALL $RATSIMP
                                (ADD* (SIMPLIFY
                                       (MFUNCTION-CALL $LDEFINT
                                        (SIMPLIFY
                                         (MFUNCTION-CALL $REMFUN2 'MABS
                                          $F $X))
                                        $X (TRD-MSYMEVAL $A '$A) 0))
                                      (SIMPLIFY
                                       (MFUNCTION-CALL $LDEFINT
                                        (SIMPLIFY
                                         (MFUNCTION-CALL $REMFUNN2
                                          'MABS $F $X))
                                        $X 0 (TRD-MSYMEVAL $B '$B)))))))))))))
       '$ASIGN '$BSIGN)))
(PROGN
  'COMPILE
  (DEFPROP $INDEFINT T TRANSLATED)
  (ADD2LNC '$INDEFINT $PROPS)
  (DEFMTRFUN ($INDEFINT $ANY MDEFINE NIL NIL) ($F $X $HALFPLANE) NIL
      (COND
        ((LIKE $HALFPLANE '$POS)
         (SIMPLIFY
             (MFUNCTION-CALL $INTEGRATE
                 (SIMPLIFY (MFUNCTION-CALL $REMFUN2 'MABS $F $X)) $X)))
        ((LIKE $HALFPLANE '$NEG)
         (SIMPLIFY
             (MFUNCTION-CALL $INTEGRATE
                 (SIMPLIFY (MFUNCTION-CALL $REMFUNN2 'MABS $F $X)) $X)))
        ((LIKE $HALFPLANE '$BOTH)
         (SIMPLIFY
             (MFUNCTION-CALL $APPEND
                 (DISPLAY-FOR-TR T NIL
                     (SIMPLIFY
                         (MFUNCTION-CALL $INTEGRATE
                             (SIMPLIFY
                                 (MFUNCTION-CALL $REMFUNN2 'MABS $F $X))
                             $X)))
                 (DISPLAY-FOR-TR T NIL
                     (SIMPLIFY
                         (MFUNCTION-CALL $INTEGRATE
                             (SIMPLIFY
                                 (MFUNCTION-CALL $REMFUN2 'MABS $F $X))
                             $X))))))
        (T (SIMPLIFY
               (MFUNCTION-CALL $ERROR '|&INVALID HALFPLANE:|
                   $HALFPLANE))))))
(PROGN
  'COMPILE
  (DEFPROP $ABSINT T TRANSLATED)
  (ADD2LNC '$ABSINT $PROPS)
  (DEFMTRFUN ($ABSINT $ANY MDEFINE T NIL) ($F $X $RANGE) NIL
      (COND
        ((LIKE $RANGE '((MLIST)))
         (SIMPLIFY (MFUNCTION-CALL $INDEFINT $F $X '$POS)))
        ((EQL (MFUNCTION-CALL $LENGTH $RANGE) 1)
         (SIMPLIFY
             (MFUNCTION-CALL $INDEFINT $F $X
                 (SIMPLIFY ($FIRST $RANGE)))))
        ((EQL (MFUNCTION-CALL $LENGTH $RANGE) 2)
         (SIMPLIFY
             (MFUNCTION-CALL $ADEFINT $F $X (MAREF $RANGE 1)
                 (MAREF $RANGE 2))))
        (T (SIMPLIFY
               (MFUNCTION-CALL $ERROR '|&TOO MANY ARGUMENTS TO ABSINT|))))))
(PROGN
  'COMPILE
  (DEFPROP $FOURINT T TRANSLATED)
  (ADD2LNC '$FOURINT $PROPS)
  (DEFMTRFUN ($FOURINT $ANY MDEFINE NIL NIL) ($F $X) NIL
      ((LAMBDA ($Z)
         NIL
         (COND
           ((MFUNCTION-CALL $EVENFUNP $F $X)
            (SIMPLIFY
                (MFUNCTION-CALL $APPEND
                    (SIMPLIFY (MFUNCTION-CALL $FOURINTCOS $F $X))
                    (DISPLAY-FOR-TR T NIL
                        (SIMPLIFY
                            (LIST '(MEQUAL)
                                  (MAREF (TRD-MSYMEVAL $B '$B) $Z) 0))))))
           ((MFUNCTION-CALL $ODDFUNP $F $X)
            (SIMPLIFY
                (MFUNCTION-CALL $APPEND
                    (DISPLAY-FOR-TR T NIL
                        (SIMPLIFY
                            (LIST '(MEQUAL)
                                  (MAREF (TRD-MSYMEVAL $A '$A) $Z) 0)))
                    (SIMPLIFY (MFUNCTION-CALL $FOURINTSIN $F $X)))))
           (T (SIMPLIFY (MFUNCTION-CALL $FOURINTCOEFF $F $X)))))
       '$Z)))
(PROGN
  'COMPILE
  (DEFPROP $FOURINTCOEFF T TRANSLATED)
  (ADD2LNC '$FOURINTCOEFF $PROPS)
  (DEFMTRFUN ($FOURINTCOEFF $ANY MDEFINE NIL NIL) ($F $X) NIL
      ((LAMBDA ($AZ $BZ $Z)
         NIL
         (SIMPLIFY
             (LIST '(MLIST)
                   (ASSUME (SIMPLIFY (LIST '(MGREATERP) $Z 0)))))
         (SETQ $AZ
               (DIV (SIMPLIFY
                        (MFUNCTION-CALL $ADEFINT
                            (MUL* $F
                                  (SIMPLIFY
                                      (LIST '(%COS) (MUL* $Z $X))))
                            $X '$MINF '$INF))
                    '$%PI))
         (SETQ $BZ
               (DIV (SIMPLIFY
                        (MFUNCTION-CALL $ADEFINT
                            (MUL* $F
                                  (SIMPLIFY
                                      (LIST '(%SIN) (MUL* $Z $X))))
                            $X '$MINF '$INF))
                    '$%PI))
         (SIMPLIFY
             (MFUNCTION-CALL $APPEND
                 (DISPLAY-FOR-TR T NIL
                     (SIMPLIFY
                         (LIST '(MEQUAL)
                               (MAREF (TRD-MSYMEVAL $A '$A) $Z) $AZ)))
                 (DISPLAY-FOR-TR T NIL
                     (SIMPLIFY
                         (LIST '(MEQUAL)
                               (MAREF (TRD-MSYMEVAL $B '$B) $Z) $BZ))))))
       '$AZ '$BZ '$Z)))
(PROGN
  'COMPILE
  (DEFPROP $FOURINTCOS T TRANSLATED)
  (ADD2LNC '$FOURINTCOS $PROPS)
  (DEFMTRFUN ($FOURINTCOS $ANY MDEFINE NIL NIL) ($F $X) NIL
      ((LAMBDA ($AZ $Z)
         NIL
         (SIMPLIFY
             (LIST '(MLIST)
                   (ASSUME (SIMPLIFY (LIST '(MGREATERP) $Z 0)))))
         (SETQ $AZ
               (DIV (MUL* 2
                          (SIMPLIFY
                              (MFUNCTION-CALL $ADEFINT
                                  (MUL* $F
                                        (SIMPLIFY
                                         (LIST '(%COS) (MUL* $Z $X))))
                                  $X 0 '$INF)))
                    '$%PI))
         (DISPLAY-FOR-TR T NIL
             (SIMPLIFY
                 (LIST '(MEQUAL) (MAREF (TRD-MSYMEVAL $A '$A) $Z) $AZ))))
       '$AZ '$Z)))
(PROGN
  'COMPILE
  (DEFPROP $FOURINTSIN T TRANSLATED)
  (ADD2LNC '$FOURINTSIN $PROPS)
  (DEFMTRFUN ($FOURINTSIN $ANY MDEFINE NIL NIL) ($F $X) NIL
      ((LAMBDA ($BZ $Z)
         NIL
         (SIMPLIFY
             (LIST '(MLIST)
                   (ASSUME (SIMPLIFY (LIST '(MGREATERP) $Z 0)))))
         (SETQ $BZ
               (DIV (MUL* 2
                          (SIMPLIFY
                              (MFUNCTION-CALL $ADEFINT
                                  (MUL* $F
                                        (SIMPLIFY
                                         (LIST '(%SIN) (MUL* $Z $X))))
                                  $X 0 '$INF)))
                    '$%PI))
         (DISPLAY-FOR-TR T NIL
             (SIMPLIFY
                 (LIST '(MEQUAL) (MAREF (TRD-MSYMEVAL $B '$B) $Z) $BZ))))
       '$BZ '$Z)))
(PROGN
  'COMPILE
  (DEFPROP $FOURIER T TRANSLATED)
  (ADD2LNC '$FOURIER $PROPS)
  (DEFMTRFUN ($FOURIER $ANY MDEFINE NIL NIL) ($F $X $P) NIL
      ((LAMBDA ($N)
         NIL
         (COND
           ((MFUNCTION-CALL $EVENFUNP $F $X)
            (SIMPLIFY
                (MFUNCTION-CALL $APPEND
                    (SIMPLIFY (MFUNCTION-CALL $FOURCOS $F $X $P))
                    (DISPLAY-FOR-TR T NIL
                        (SIMPLIFY
                            (LIST '(MEQUAL)
                                  (MAREF (TRD-MSYMEVAL $B '$B) $N) 0))))))
           ((MFUNCTION-CALL $ODDFUNP $F $X)
            (SIMPLIFY
                (MFUNCTION-CALL $APPEND
                    (DISPLAY-FOR-TR T NIL
                        (SIMPLIFY
                            (LIST '(MEQUAL)
                                  (MAREF (TRD-MSYMEVAL $A '$A) 0) 0)))
                    (DISPLAY-FOR-TR T NIL
                        (SIMPLIFY
                            (LIST '(MEQUAL)
                                  (MAREF (TRD-MSYMEVAL $A '$A) $N) 0)))
                    (SIMPLIFY (MFUNCTION-CALL $FOURSIN $F $X $P)))))
           (T (SIMPLIFY (MFUNCTION-CALL $FOURCOEFF $F $X $P)))))
       '$N)))
(PROGN
  'COMPILE
  (DEFPROP $FOURCOEFF T TRANSLATED)
  (ADD2LNC '$FOURCOEFF $PROPS)
  (DEFMTRFUN ($FOURCOEFF $ANY MDEFINE NIL NIL) ($F $X $P) NIL
      ((LAMBDA ($A0 $AN $BN $N)
         NIL
         (SIMPLIFY
             (LIST '(MLIST)
                   (ASSUME (SIMPLIFY (LIST '(MGREATERP) $N 0)))))
         (SETQ $A0
               (DIV (SIMPLIFY
                        (MFUNCTION-CALL $ADEFINT $F $X (*MMINUS $P) $P))
                    (MUL* 2 $P)))
         (SETQ $AN
               (DIV (SIMPLIFY
                        (MFUNCTION-CALL $ADEFINT
                            (MUL* $F
                                  (SIMPLIFY
                                      (LIST '(%COS)
                                       (DIV (MUL* $N '$%PI $X) $P))))
                            $X (*MMINUS $P) $P))
                    $P))
         (SETQ $BN
               (DIV (SIMPLIFY
                        (MFUNCTION-CALL $ADEFINT
                            (MUL* $F
                                  (SIMPLIFY
                                      (LIST '(%SIN)
                                       (DIV (MUL* $N '$%PI $X) $P))))
                            $X (*MMINUS $P) $P))
                    $P))
         (SIMPLIFY
             (MFUNCTION-CALL $APPEND
                 (DISPLAY-FOR-TR T NIL
                     (SIMPLIFY
                         (LIST '(MEQUAL)
                               (MAREF (TRD-MSYMEVAL $A '$A) 0) $A0)))
                 (DISPLAY-FOR-TR T NIL
                     (SIMPLIFY
                         (LIST '(MEQUAL)
                               (MAREF (TRD-MSYMEVAL $A '$A) $N) $AN)))
                 (DISPLAY-FOR-TR T NIL
                     (SIMPLIFY
                         (LIST '(MEQUAL)
                               (MAREF (TRD-MSYMEVAL $B '$B) $N) $BN))))))
       '$A0 '$AN '$BN '$N)))
(PROGN
  'COMPILE
  (DEFPROP $FOURCOS T TRANSLATED)
  (ADD2LNC '$FOURCOS $PROPS)
  (DEFMTRFUN ($FOURCOS $ANY MDEFINE NIL NIL) ($F $X $P) NIL
      ((LAMBDA ($A0 $AN $N)
         NIL
         (SIMPLIFY
             (LIST '(MLIST)
                   (ASSUME (SIMPLIFY (LIST '(MGREATERP) $N 0)))))
         (SETQ $A0
               (DIV (SIMPLIFY (MFUNCTION-CALL $ADEFINT $F $X 0 $P)) $P))
         (SETQ $AN
               (DIV (MUL* 2
                          (SIMPLIFY
                              (MFUNCTION-CALL $ADEFINT
                                  (MUL* $F
                                        (SIMPLIFY
                                         (LIST '(%COS)
                                          (DIV (MUL* $N '$%PI $X) $P))))
                                  $X 0 $P)))
                    $P))
         (SIMPLIFY
             (MFUNCTION-CALL $APPEND
                 (DISPLAY-FOR-TR T NIL
                     (SIMPLIFY
                         (LIST '(MEQUAL)
                               (MAREF (TRD-MSYMEVAL $A '$A) 0) $A0)))
                 (DISPLAY-FOR-TR T NIL
                     (SIMPLIFY
                         (LIST '(MEQUAL)
                               (MAREF (TRD-MSYMEVAL $A '$A) $N) $AN))))))
       '$A0 '$AN '$N)))
(PROGN
  'COMPILE
  (DEFPROP $FOURSIN T TRANSLATED)
  (ADD2LNC '$FOURSIN $PROPS)
  (DEFMTRFUN ($FOURSIN $ANY MDEFINE NIL NIL) ($F $X $P) NIL
      ((LAMBDA ($BN $N)
         NIL
         (SIMPLIFY
             (LIST '(MLIST)
                   (ASSUME (SIMPLIFY (LIST '(MGREATERP) $N 0)))))
         (SETQ $BN
               (DIV (MUL* 2
                          (SIMPLIFY
                              (MFUNCTION-CALL $ADEFINT
                                  (MUL* $F
                                        (SIMPLIFY
                                         (LIST '(%SIN)
                                          (DIV (MUL* $N '$%PI $X) $P))))
                                  $X 0 $P)))
                    $P))
         (DISPLAY-FOR-TR T NIL
             (SIMPLIFY
                 (LIST '(MEQUAL) (MAREF (TRD-MSYMEVAL $B '$B) $N) $BN))))
       '$BN '$N)))
(PROGN
  'COMPILE
  (DEFPROP $FOURSIMP T TRANSLATED)
  (ADD2LNC '$FOURSIMP $PROPS)
  (DEFMTRFUN ($FOURSIMP $ANY MDEFINE NIL NIL) ($EXP) NIL
      (COND
        ((MFUNCTION-CALL $LISTP $EXP)
         (SIMPLIFY
             (MAP1 (GETOPR (M-TLAMBDA ($Q) NIL
                               (SIMPLIFY
                                   ($FIRST
                                    (DISPLAY-FOR-TR T NIL
                                     (SIMPLIFY
                                      (MFUNCTION-CALL $FOURSIMP
                                       (SIMPLIFY (MFUNCALL '$EV $Q)))))))))
                   $EXP)))
        ((NOT (MFUNCTION-CALL $FREEOF '&= $EXP))
         (SIMPLIFY
             (LIST '(MEQUAL) (SIMPLIFY (MFUNCTION-CALL $LHS $EXP))
                   (SIMPLIFY
                       (MFUNCTION-CALL $FOURSIMPLE
                           (SIMPLIFY (MFUNCTION-CALL $RHS $EXP)))))))
        (T (SIMPLIFY (MFUNCTION-CALL $FOURSIMPLE $EXP))))))
(PROGN
  'COMPILE
  (DEFPROP $FOURSIMPLE T TRANSLATED)
  (ADD2LNC '$FOURSIMPLE $PROPS)
  (DEFMTRFUN ($FOURSIMPLE $ANY MDEFINE NIL NIL) ($EXP) NIL
      ((LAMBDA ($N)
         NIL
         (COND
           ((MFUNCTION-CALL $FUNP1 '$INTEGRATE $EXP) $EXP)
           (T (COND
                ((TRD-MSYMEVAL $SINNPIFLAG NIL)
                 (SETQ $EXP
                       (SIMPLIFY
                           (MFUNCTION-CALL $RATSUBST 0
                               (SIMPLIFY
                                   (LIST '(%SIN) (MUL* $N '$%PI)))
                               $EXP)))))
              (COND
                ((TRD-MSYMEVAL $COSNPIFLAG NIL)
                 (SETQ $EXP
                       (SIMPLIFY
                           (MFUNCTION-CALL $RATSUBST (POWER -1 $N)
                               (SIMPLIFY
                                   (LIST '(%COS) (MUL* $N '$%PI)))
                               $EXP)))))
              (SIMPLIFY (MFUNCTION-CALL $FACTOR $EXP)))))
       '$N)))
(PROGN
  'COMPILE
  (DEFPROP $FOUREXPAND T TRANSLATED)
  (ADD2LNC '$FOUREXPAND $PROPS)
  (DEFMTRFUN ($FOUREXPAND $ANY MDEFINE NIL NIL) ($L $X $P $NN) NIL
      ((LAMBDA ($SIMPSUM $SERIES $L1 $LHSL1 $N)
         NIL
         (COND
           ((NOT (MFUNCTION-CALL $LISTP $L))
            (SIMPLIFY
                (MFUNCTION-CALL $ERROR '|&FIRST ARGUMENT NOT A LIST|)))
           ((LIKE $L '((MLIST)))
            (SIMPLIFY
                (MFUNCTION-CALL $ERROR '|&ARGUMENT LIST IS EMPTY|)))
           (T (SETQ $L (SIMPLIFY (MFUNCALL '$EV $L))) (SETQ $SIMPSUM T)
              (SETQ $SERIES 0)
              (DO ((MDO 1 (F+ 1 MDO))) ((LIKE $L '((MLIST))) '$DONE)
                (SETQ $L1 (SIMPLIFY ($FIRST $L)))
                (SETQ $L (SIMPLIFY (MFUNCTION-CALL $REST $L)))
                (SETQ $LHSL1 (SIMPLIFY (MFUNCTION-CALL $LHS $L1)))
                (COND
                  ((LIKE $LHSL1 (MAREF (TRD-MSYMEVAL $A '$A) 0))
                   (SETQ $SERIES
                         (ADD* $SERIES
                               (SIMPLIFY (MFUNCTION-CALL $RHS $L1)))))
                  ((LIKE $LHSL1 (MAREF (TRD-MSYMEVAL $A '$A) $N))
                   (SETQ $SERIES
                         (ADD* $SERIES
                               (SIMPLIFY
                                   (MFUNCALL '$SUM
                                    (MUL*
                                     (SIMPLIFY
                                      (MFUNCTION-CALL $RHS $L1))
                                     (SIMPLIFY
                                      (LIST '(%COS)
                                       (DIV (MUL* $N '$%PI $X) $P))))
                                    $N 1 $NN)))))
                  ((LIKE $LHSL1 (MAREF (TRD-MSYMEVAL $B '$B) $N))
                   (SETQ $SERIES
                         (ADD* $SERIES
                               (SIMPLIFY
                                   (MFUNCALL '$SUM
                                    (MUL*
                                     (SIMPLIFY
                                      (MFUNCTION-CALL $RHS $L1))
                                     (SIMPLIFY
                                      (LIST '(%SIN)
                                       (DIV (MUL* $N '$%PI $X) $P))))
                                    $N 1 $NN)))))
                  (T (SIMPLIFY
                         (MFUNCTION-CALL $ERROR
                             '|&INVALID EQUATI
ON IN ARGUMENT LIST:| $L1)))))
              $SERIES)))
       '$SIMPSUM '$SERIES '$L1 '$LHSL1 '$N)))
(PROGN
  'COMPILE
  (DEFPROP $TOTALFOURIER T TRANSLATED)
  (ADD2LNC '$TOTALFOURIER $PROPS)
  (DEFMTRFUN ($TOTALFOURIER $ANY MDEFINE NIL NIL) ($F $X $P) NIL
      (SIMPLIFY
          (MFUNCTION-CALL $FOUREXPAND
              (SIMPLIFY
                  (MFUNCTION-CALL $FOURSIMP
                      (SIMPLIFY (MFUNCTION-CALL $FOURIER $F $X $P))))
              $X $P '$INF))))