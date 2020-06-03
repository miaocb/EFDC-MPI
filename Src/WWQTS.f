      SUBROUTINE WWQTS  
C  
C **  SHEN'S MODIFICATION TO OUTPUT MACROALGAE  
C CHANGE RECORD  
C WRITE TIME-SERIES OUTPUT: WQCHLX=1/WQCHLX  
C  
      USE GLOBAL  
C
      REAL,SAVE,ALLOCATABLE,DIMENSION(:)::WQVOUT  
      IF(.NOT.ALLOCATED(WQVOUT))THEN
		ALLOCATE(WQVOUT(NWQVM+6))
	    WQVOUT=0.0 
	ENDIF
C  
      OPEN(1,FILE='WQWCTS'//ans(partid2)//'.OUT',STATUS='UNKNOWN',POSITION='APPEND')  
      IF(ISDYNSTP.EQ.0)THEN  
        TIMTMP=DT*FLOAT(N)+TCON*TBEGIN  
        TIMTMP=TIMTMP/TCTMSR  
      ELSE  
        TIMTMP=TIMESEC/TCTMSR  
      ENDIF  
      DO M=1,IWQTS  
        DO K=1,KC  
          LL=LWQTS(M)  
          IZ=IWQZMAP(LL,K)  
          DO NW=1,NWQV
            IF(ISTRWQ(NW).NE.0)THEN
              IF(ISWQLVL.EQ.1)THEN  ! PMC - CHANGE ALL WQSKE SUBROUTINES IN FUTURE
                WQVO(LL,K,NW) = (WQVO(LL,K,NW)+WQV(LL,K,NW))*0.5
              ELSE
                WQVO(LL,K,NW) = WQVO(LL,K,NW)*0.5
              ENDIF
            ENDIF  
          ENDDO
          NWQOUT=0  
          IF(ISTRWQ(1).EQ.1)THEN  
            NWQOUT=NWQOUT+1  
            WQVOUT(NWQOUT)=WQVO(LL,K,1)*WQCHLC  
          ENDIF  
          IF(ISTRWQ(2).EQ.1)THEN  
            NWQOUT=NWQOUT+1  
            WQVOUT(NWQOUT)=WQVO(LL,K,2)*WQCHLD  
          ENDIF  
          IF(ISTRWQ(3).EQ.1)THEN  
            NWQOUT=NWQOUT+1  
            WQVOUT(NWQOUT)=WQVO(LL,K,3)*WQCHLG  
          ENDIF  
          DO NW=4,NWQV  
            IF(ISTRWQ(NW).EQ.1)THEN  
              NWQOUT=NWQOUT+1  
              WQVOUT(NWQOUT)=WQVO(LL,K,NW)  
            ENDIF  
          ENDDO
          IF(IDNOTRVA>0)THEN !Macroalgae
            NWQOUT=NWQOUT+1  
            WQVOUT(NWQOUT)=WQVO(LL,K,IDNOTRVA) 
          ENDIF
          
C  
C ** ADD TEMPERATURE AND SALINITY SATUARATION  
C  
          IF(ISTRAN(3)>0)THEN !Only if temperature is calculated
            NWQOUT=NWQOUT+1  
            WQVOUT(NWQOUT)=TEM(LL,K)  
          ENDIF
          IF(ISTRAN(2)>0)THEN !Only if salinity is calculated
            NWQOUT=NWQOUT+1  
            WQVOUT(NWQOUT)=SAL(LL,K)  
          ENDIF
C  
C ** ADD DO SATUARATION  
C       
          IF(ISTRWQ(19)>0)THEN !Saturation only needed if DO is calculated
            NWQOUT=NWQOUT+1  
            TVAL1=1./(TEM(LL,K)+273.15)  
            TVAL2=TVAL1*TVAL1  
          TVAL3=TVAL1*TVAL2  
          TVAL4=TVAL2*TVAL2  
          RLNSAT1=-139.3441+(1.575701E+5*TVAL1)-(6.642308E+7*TVAL2)  
     &        +(1.2438E+10*TVAL3)-(8.621949E+11*TVAL4)  
          RLNSAT2=RLNSAT1-SAL(LL,K)*( 1.7674E-2-(1.0754E+1*TVAL1)  
     &        +(2.1407E+3*TVAL2) )  
          WQVOUT(NWQOUT) = EXP(RLNSAT2)
C  
C ** ADD FLOW INDUCED REAERATION  
C  
          NWQOUT=NWQOUT+1  
          WQVOUT(NWQOUT) = 0.  
          IF(IWQKA(IZ) .EQ. 2)THEN  
            UMRM = 0.5*( U(LL,K) + U(L+1   ,K) )  
            VMRM = 0.5*( V(LL,K) + V(LNC(LL),K) )  
            XMRM = SQRT(UMRM*UMRM + VMRM*VMRM)  
            WQVOUT(NWQOUT) = WQKRO(IZ) * XMRM**0.5 / HP(LL)**0.5  
          ENDIF
C  
C ** ADD WIND INDUCED REAERATION  
C  
          NWQOUT=NWQOUT+1  
          WINDREA = WINDST(LL)  
          WQVOUT(NWQOUT)=0.728*SQRT(WINDREA)  
     &        +(0.0372*WINDREA-0.317)*WINDREA  
        ENDIF
          WRITE(1,71) XPAR(IL(LL)),YPAR(JL(LL)),K,TIMTMP,  
     &        (WQVOUT(NWOUT),NWOUT=1,NWQOUT)
          CONTINUE
        ENDDO  
      ENDDO  
   71 FORMAT(3I5,F11.5,1X, 25E11.3)  
C  
C M. MORTON 03/11/96 ADDED BOD5 TERM FOR OUTPUT:  
C DIATOMS (CHLD) AND GREEN ALGAE (CHLG); REMOVED APCWQ AND  
C ADDED CYANOBACTERIA (CHLC):  
C HHTMP = WATER DEPTH (METERS)  
C CHLM  = MACROALGAE BIOMASS IN MICROGRAMS/SQUARE METER:  
C CHLM IN UG/L AS FOLLOWS:  
C  
      CLOSE(1)  
      RETURN  
      END  

