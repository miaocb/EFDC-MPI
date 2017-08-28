      SUBROUTINE BUDGET5  
C  
C **  ADDED BY DON KINGERY, CH2M-HILL ON 15 OCTOBER 1996  
C CHANGE RECORD  
C **  SUBROUTINES BUDGETN CALCULATE SEDIMENT BUDGET (TOTAL SEDIMENTS)  
C  
      USE GLOBAL  
	IMPLICIT NONE
	INTEGER::NS,L,K
	REAL::SEDBTMP1,SEDBTMP,SFLXTMP,BSEDERR,SSEDOUT,BSEDOUT,SSEDERE
	REAL::BSEDERE,SSEDBMO,BSEDBMO,SSEDERR,SDFLUX,VOLMBMO
	REAL::SMASSBMO,VOLMERR,SMASSERR
C  
C **  CHECK FOR END OF BALANCE PERIOD  
C  
      IF(NBUD.EQ.NTSMMT)THEN  
 6666 FORMAT(' ACTIVE CALL TO BUDGET5, N,NBUD = ',2I5)  
C  
C **  CALCULATE ENDING SUSPENDED AND BOTTOM SEDIMENT IN THE MODEL DOMAIN  
C  
        SDFLUX=0.  
        SSEDEND=0.  
        BSEDEND=0.  
        VOLMEND=0.  
        SMASSEND=0.  
        IF(N.EQ.NTSMMT)THEN  
          DO L=2,LA  
            VOLMEND=VOLMEND+SPB(L)*DXYP(L)*H1P(L)  
          ENDDO  
        ELSE  
          DO L=2,LA  
            VOLMEND=VOLMEND+SPB(L)*DXYP(L)*HP(L)  
          ENDDO  
        ENDIF  
        IF(N.EQ.NTSMMT)THEN  
          DO K=1,KC  
            DO L=2,LA  
              SMASSEND=SMASSEND+SCB(L)*DXYP(L)*H1P(L)*SAL1(L,K)*DZC(K)  
            ENDDO  
          ENDDO  
        ELSE  
          DO K=1,KC  
            DO L=2,LA  
              SMASSEND=SMASSEND+SCB(L)*DXYP(L)*HP(L)*SAL(L,K)*DZC(K)  
            ENDDO  
          ENDDO  
        ENDIF  
C  
C  INITIALIZE BOTTOM AND SUSPENDED SEDIMENT MASS  ---  DLK 9/26  
C  
        DO L=2,LA  
          SDFLUX=SDFLUX+SCB(L)*VOLBW3(L,KB)  
        ENDDO  
        DO K=1,KB  
          DO L=2,LA  
            SEDBT(L,K)=0.  
            SNDBT(L,K)=0.  
          ENDDO  
        ENDDO  
        IF(N.EQ.NTSMMT)THEN  
          DO NS=1,NSED  
            DO K=1,KB  
              DO L=2,LA  
                SEDBT(L,K)=SEDBT(L,K)+SCB(L)*SEDB1(L,K,NS)  
              ENDDO  
            ENDDO  
          ENDDO  
          DO NS=1,NSND  
            DO K=1,KB  
              DO L=2,LA  
                SNDBT(L,K)=SNDBT(L,K)+SCB(L)*SNDB1(L,K,NS)  
              ENDDO  
            ENDDO  
          ENDDO  
        ELSE  
          DO NS=1,NSED  
            DO K=1,KB  
              DO L=2,LA  
                SEDBT(L,K)=SEDBT(L,K)+SCB(L)*SEDB(L,K,NS)  
              ENDDO  
            ENDDO  
          ENDDO  
          DO K=1,KB  
            DO NS=1,NSND  
              DO L=2,LA  
                SNDBT(L,K)=SNDBT(L,K)+SCB(L)*SNDB(L,K,NS)  
              ENDDO  
            ENDDO  
          ENDDO  
        ENDIF  
        DO K=1,KB  
          DO L=2,LA  
            BSEDEND=BSEDEND+SCB(L)*DXYP(L)*(SEDBT(L,K)+SNDBT(L,K))  
          ENDDO  
        ENDDO  
        IF(N.EQ.NTSMMT)THEN  
          DO NS=1,NSED  
            DO K=1,KC  
              DO L=2,LA  
               SSEDEND=SSEDEND+SCB(L)*DXYP(L)*H1P(L)*SED1(L,K,NS)*DZC(K)  
              ENDDO  
            ENDDO  
          ENDDO  
          DO NS=1,NSND  
            DO K=1,KC  
              DO L=2,LA  
               SSEDEND=SSEDEND+SCB(L)*DXYP(L)*H1P(L)*SND1(L,K,NS)*DZC(K)  
              ENDDO  
            ENDDO  
          ENDDO  
        ELSE  
          DO NS=1,NSED  
            DO K=1,KC  
              DO L=2,LA  
                SSEDEND=SSEDEND+SCB(L)*DXYP(L)*HP(L)*SED(L,K,NS)*DZC(K)  
              ENDDO  
            ENDDO  
          ENDDO  
          DO NS=1,NSND  
            DO K=1,KC  
              DO L=2,LA  
                SSEDEND=SSEDEND+SCB(L)*DXYP(L)*HP(L)*SND(L,K,NS)*DZC(K)  
              ENDDO  
            ENDDO  
          ENDDO  
        ENDIF  
        SEDEND=SSEDEND+BSEDEND  
        SEDOUT=DT*SEDOUT  
        SEDIN=DT*SEDIN  
        VOLMOUT=DT*VOLMOUT  
        VOLMIN=DT*VOLMIN  
        SMASSIN=DT*SMASSIN  
        SMASSOUT=DT*SMASSOUT  
        SDFLUX=DT*SDFLUX  
        SEDBMO=SEDBEG+SEDIN-SEDOUT  
        VOLMBMO=VOLMBEG+VOLMIN-VOLMOUT  
        SMASSBMO=SMASSBEG+SMASSIN-SMASSOUT  
        SEDERR=SEDEND-SEDBMO  
        VOLMERR=VOLMEND-VOLMBMO  
        SMASSERR=SMASSEND-SMASSBMO  
        RSDERDE=-9999.  
        RSDERDO=-9999.  
        IF(SEDEND.NE.0.) RSDERDE=SEDERR/SEDEND  
        IF(SEDOUT.NE.0.) RSDERDO=SEDERR/(SEDIN+SEDOUT)  
C  
C **  OUTPUT BALANCE RESULTS TO FILE BUDGET.OUT  
C  
        IF(JSSBAL.EQ.1)THEN  
          OPEN(89,FILE='BUDGET.OUT',STATUS='UNKNOWN')  
          OPEN(93,FILE='BUDGET2.OUT',STATUS='UNKNOWN')  
          OPEN(94,FILE='BUDGET3.OUT',STATUS='UNKNOWN')  
          CLOSE(89,STATUS='DELETE')  
          CLOSE(93,STATUS='DELETE')  
          CLOSE(94,STATUS='DELETE')  
          OPEN(89,FILE='BUDGET.OUT',STATUS='UNKNOWN')  
          WRITE(89,888)NTSMMT,TBEGIN  
          OPEN(93,FILE='BUDGET2.OUT',STATUS='UNKNOWN')  
          WRITE(93,893)NTSMMT,TBEGIN  
          OPEN(94,FILE='BUDGET3.OUT',STATUS='UNKNOWN')  
          WRITE(94,894)NTSMMT,TBEGIN  
          JSSBAL=0  
        ELSE  
          OPEN(89,FILE='BUDGET.OUT',POSITION='APPEND',STATUS='UNKNOWN')  
          OPEN(93,FILE='BUDGET2.OUT',POSITION='APPEND',STATUS='UNKNOWN')  
          OPEN(94,FILE='BUDGET3.OUT',POSITION='APPEND',STATUS='UNKNOWN')  
        ENDIF  
        WRITE(89,892)N,BSEDBEG,SSEDBEG,SEDIN,SEDOUT,SEDBMO,BSEDEND,  
     &      SSEDEND,SEDERR,RSDERDE,RSDERDO  
        WRITE(93,895)N,VOLMBEG,VOLMIN,VOLMOUT,VOLMBMO,VOLMEND,VOLMERR  
        WRITE(94,895)N,SMASSBEG,SMASSIN,SMASSOUT,SMASSBMO,SMASSEND,  
     &      SMASSERR  
        SSEDBMO=SSEDBEG+SEDIN-SEDOUT+SDFLUX  
        BSEDBMO=BSEDBEG-SDFLUX  
        SSEDERR=SSEDEND-SSEDBMO  
        BSEDERR=BSEDEND-BSEDBMO  
        SSEDOUT=SEDOUT-SEDIN-SDFLUX  
        BSEDOUT=SDFLUX  
        SSEDBMO=SSEDBEG-SSEDOUT  
        BSEDBMO=BSEDBEG-BSEDOUT  
        SSEDERR=SSEDEND-SSEDBMO  
        BSEDERR=BSEDEND-BSEDBMO  
        IF(SSEDEND.NE.0.)SSEDERE=SSEDERR/SSEDEND  
        IF(BSEDEND.NE.0.)BSEDERE=BSEDERR/BSEDEND  
        DO L=2,LA  
          VOLBW3(L,KB)=DT*VOLBW3(L,KB)  
          SEDBTMP1=DXYP(L)*SEDB1(L,KBT(L),1)  
          SEDBTMP=DXYP(L)*SEDB(L,KB,1)  
          SFLXTMP=DT*DXYP(L)*SEDF(L,0,1)  
        ENDDO  
        CLOSE(89)  
        CLOSE(93)  
        CLOSE(94)  
 9510 FORMAT(//' SUS AND BED SED BUDGET ENDING AT N =',I7/)  
 9511 FORMAT(' SEDIN,SEDOUT,SDFLUX = ',3E15.7/)  
 9512 FORMAT(' SSEDBEG,BSEDBEG = ',2E15.7/)  
 9513 FORMAT(' SSEDOUT,BSEDOUT = ',2E15.7/)  
 9514 FORMAT(' SSEDBMO,BSEDBMO = ',2E15.7/)  
 9515 FORMAT(' SSEDEND,BSEDEND = ',2E15.7/)  
 9516 FORMAT(' SSEDERR,BSEDERR = ',2E15.7/)  
 9517 FORMAT(' SSEDERE,BSEDERE = ',2E15.7/)  
 9600 FORMAT(/'C ACCUMULATED SED FLUX AT N = ',I5)  
 9601 FORMAT(2I5,5E15.7)  
  888 FORMAT (6X,' SEDIMENT BUDGET CALCULATIONS'//  
     &    6X,'SEDIMENT BUDGET OVER ',I5,' TIME STEPS'/  
     &    6X,'STARTING ON JULIAN DAY ',F6.2/  
     &    6X,'N       = LAST TIME STEP IN PERIOD'/  
     &    6X,'BSEDBEG  = TOTAL BED SEDIMENT IN MODEL DOMAIN 
     &    AT BEGINNING',' OF TIME PERIOD'/  
     &    6X,'SSEDBEG  = TOTAL SUSPENDED SEDIMENT IN MODEL DOMAIN AT',  
     &    ' BEGINNING OF TIME PERIOD'/  
     &    6X,'SEDIN   = SEDIMENT ADDED TO MODEL FROM OUTFALL'/  
     &    6X,'SEDOUT  = SEDIMENT REMOVED ACROSS MODEL BOUNDARIES'/  
     &    6X,'SEDBMO  = SEDBEG+SEDIN-SEDOUT'/  
     &    6X,'SEDEND  = SEDIMENT REMAINING IN MODEL DOMAIN'/  
     &    6X,'SEDERR  = SEDEND-SEDBMO'/  
     &    6X,'RSDERDE = ERROR AS A FRACTION OF SEDIMENT IN 
     & MODEL DOMAIN'/6X,'RSDERDO = ERROR AS A FRACTION OF 
     & SEDIMENT ADDED/REMOVED'//1X,'       N         BSEDBEG        
     &  SSEDBEG        SEDIN',1X,'          SEDOUT          SEDBMO    
     &  ',1X,'    BSEDEND          SSEDEND          SEDERR       
     &  RSDERDE',1X,'         RSDERDO'/)  
  892 FORMAT (1X,I9,10(2X,E14.6))  
  893 FORMAT (6X,' MASS BALANCE CALCULATIONS'//  
     &    6X,'MASS BALANCE OVER ',I5,' TIME STEPS'/  
     &    6X,'STARTING ON JULIAN DAY ',F6.2/  
     &    6X,'N       = LAST TIME STEP IN PERIOD'/  
     &    6X,'VOLMBEG = TOTAL WATER VOLUME IN MODEL DOMAIN 
     &    AT BEGINNING',' OF TIME PERIOD'/  
     &    6X,'VOLMIN  = WATER VOLUME ADDED TO MODEL FROM INFLOWS'/  
     &    6X,'VOLMOUT = WATER VOLUME REMOVED ACROSS MODEL BOUNDARIES'/  
     &    6X,'VOLMBMO = VOLMBEG-(VOLMIN+VOLMOUT)'/  
     &    6X,'VOLMEND = WATER VOLUME REMAINING IN MODEL DOMAIN'/  
     &    6X,'VOLMERR = VOLMEND-VOLMBMO'//  
     &    1X,'       N         VOLMBEG        VOLMIN         VOLMOUT',  
     &    1X,'        VOLMBMO        VOLMEND          VOLMERR'/)  
  894 FORMAT (6X,' SALT BALANCE CALCULATIONS'//  
     &    6X,'SALT BALANCE OVER ',I5,' TIME STEPS'/  
     &    6X,'STARTING ON JULIAN DAY ',F6.2/  
     &    6X,'N        = LAST TIME STEP IN PERIOD'/  
     &    6X,'SMASSBEG = TOTAL WATER VOLUME IN MODEL DOMAIN 
     &    AT BEGINNING',' OF TIME PERIOD'/  
     &    6X,'SMASSIN  = WATER VOLUME ADDED TO MODEL FROM INFLOWS'/  
     &    6X,'SMASSOUT = WATER VOLUME REMOVED ACROSS MODEL BOUNDARIES'/  
     &    6X,'SMASSBMO = VOLMBEG-(VOLMIN+VOLMOUT)'/  
     &    6X,'SMASSEND = WATER VOLUME REMAINING IN MODEL DOMAIN'/  
     &    6X,'SMASSERR = VOLMEND-VOLMBMO'//  
     &    1X,'       N        SMASSBEG       SMASSIN        SMASSOUT',  
     &    1X,'       SMASSBMO       SMASSEND         SMASSERR'/)  
  895 FORMAT (1X,I9,6(2X,E14.6))  
        NBUD=0  
      ENDIF  
      NBUD=NBUD+1  
      RETURN  
      END  

