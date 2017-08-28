      SUBROUTINE CALPSER (ISTL_)  
C  
C CHANGE RECORD  
C ** SUBROUTINE CALPSER UPDATES TIME VARIABLE SURFACE ELEVATION  
C ** BOUNDARY CONDITIONS  
C  
      USE GLOBAL  
      PSERT(0)=0.  
      DO NS=1,NPSER  
        IF(ISDYNSTP.EQ.0)THEN  
          TIME=DT*FLOAT(N)/TCPSER(NS)+TBEGIN*(TCON/TCPSER(NS))  
        ELSE  
          TIME=TIMESEC/TCPSER(NS)  
        ENDIF  
        M1=MPTLAST(NS)  
  100   CONTINUE  
        M2=M1+1  
        IF(TIME.GT.TPSER(M2,NS))THEN  
          M1=M2  
          GOTO 100  
        ELSE  
          MPTLAST(NS)=M1  
        ENDIF  
        TDIFF=TPSER(M2,NS)-TPSER(M1,NS)  
        WTM1=(TPSER(M2,NS)-TIME)/TDIFF  
        WTM2=(TIME-TPSER(M1,NS))/TDIFF  
        PSERT(NS)=WTM1*PSER(M1,NS)+WTM2*PSER(M2,NS)  
      ENDDO  
 6000 FORMAT('N, PSERT = ',I6,4X,F12.4)  
      RETURN  
      END  

