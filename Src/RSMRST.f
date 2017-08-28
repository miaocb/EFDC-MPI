      SUBROUTINE RSMRST  
C  
C CHANGE RECORD  
C READ ICS FROM RESTART FILE FROM INSMRST.  
C  
      USE GLOBAL  
      LOGICAL FEXIST  
C  
C CHECK FIRST TO SEE IF BINARY RESTART FILE EXISTS.  IF NOT, USE  
C THE ASCII FILE INSTEAD.  
C  
      INQUIRE(FILE='WQSDRST.BIN', EXIST=FEXIST)  
      IF(.NOT. FEXIST)THEN  
        PRINT *,'WQ: READING WQSDRST.INP'
        OPEN(1,FILE='WQSDRST.INP',STATUS='UNKNOWN')  
        READ(1,999)  
        READ(1,999)  
        DO M=2,LA  
          READ(1,*) L,(SMPON(L,NW),NW=1,NSMG),  
     &        (SMPOP(L,NW),NW=1,NSMG),(SMPOC(L,NW),NW=1,NSMG),SM1NH4(L),  
     &        SM2NH4(L),SM2NO3(L),SM2PO4(L),SM2H2S(L),SMPSI(L),SM2SI(L),  
     &        SMBST(L),SMT(L)  
        ENDDO  
        CLOSE(1)  
      ELSE  
        PRINT *,'WQ: READING WQSDRST.BIN'
        OPEN(UNIT=1, FILE='WQSDRST.BIN',  
     &      FORM='UNFORMATTED', STATUS='UNKNOWN')  
        READ(1) NN_, XTIME  
        XTIME=XTIME  
        WRITE(0,911) NN_, XTIME  
  911 FORMAT(' READING BINARY WQSDRST.BIN FILE ...    NN, TIME = ',  
     &    I7, F11.5)  
        DO M=2,LA  
          READ(1) L  
          READ(1) (SMPON(L,NW),NW=1,NSMG),  
     &        (SMPOP(L,NW),NW=1,NSMG),(SMPOC(L,NW),NW=1,NSMG),SM1NH4(L),  
     &        SM2NH4(L),SM2NO3(L),SM2PO4(L),SM2H2S(L),SMPSI(L),SM2SI(L),  
     &        SMBST(L),SMT(L)  
        ENDDO  
        CLOSE(1)  
      ENDIF  
   90 FORMAT(I5, 18E12.4)  
  999 FORMAT(1X)  
      RETURN  
      END  

