      SUBROUTINE SCANEFDC(NCSER1,NCSER2,NCSER3,NCSER4)  
     
      USE GLOBAL
      INTEGER foo
      OPEN(1,FILE='EFDC.INP',STATUS='OLD')  
      CALL SEEK('C4')  
      READ(1,*,IOSTAT=foo) ISLTMT,ISSSMMT,ISLTMTS,ISIA,RPIA,RSQMIA,  
     &    ITRMIA,ISAVEC
      IF(ISLTMT.GT.0)THEN
        STOP'ISLTMT LONG TERM SIMULATION DISABLED!'
      ENDIF
      CALL SEEK('C5')  
      READ(1,*,ERR=10) ISCDMA,ISHDMF,ISDISP,ISWASP,ISDRY,  
     &    ISQQ,ISRLID,ISVEG,ISVEGL,ISITB,ISEVER,IINTPG  
      IF(ISCDMA.EQ.10)THEN
        STOP'EFDC 1D CHANNEL MODE IS DISABLED IN THIS VERSION OF EFDC'
      ENDIF
      IF(ISCDMA.GT.2)THEN
        STOP'EXPERIMENTAL MOMENTUM OPTIONs ARE ARE DISABLED IN THIS VERS
     &ION OF EFDC'
      ENDIF
      CALL SEEK('C6')  
      DO N=0,8  
        READ(1,*,ERR=10) ISTRAN(N),ISTOPT(N),ISCDCA(N),ISADAC(N),  
     &      ISFCT(N),ISPLIT(N),ISADAH(N),ISADAV(N),ISCI(N),ISCO(N)  
      ENDDO  

      CALL SEEK('C7')  
      READ(1,*,ERR=10) NTC,NTSPTC,NLTC,NTTC,NTCPP,NTSTBC,NTCNB,  
     &                 NTCVB,NTSMMT,NFLTMT,NDRYSTP  
      NDDAM=NTC
      CALL SEEK('C9')  
      READ(1,*,ERR=10,END=30)KC,IC,JC,LC,LVC,ISCLO,NDM,LDM,ISMASK,  
     &    ISPGNS,NSHMAX,NSBMAX,WSMH,WSMB  
      KC=ABS(KC)  
      IF(KC.GE.1)THEN  
        KCM=KC+1  
      ELSE  
      STOP'KC MUST BE AT LEAST 1'  
      ENDIF  
      IF(IC.GE.3)THEN  
        ICM=IC+1  
      ELSE  
      STOP'IC MUST BE AT LEAST 3'  
      ENDIF  
      IF(JC.GE.3)THEN  
        JCM=JC+1  
      ELSE  
      STOP'IJ MUST BE AT LEAST 3'  
      ENDIF  
      IF(LC.GE.3)THEN  
        LCM=LC+1  
      ELSE  
      STOP'LC MUST BE AT LEAST 3'  
      ENDIF  
      CALL SEEK('C14')  
      READ(1,*,ERR=10,END=30)MTIDE,NWSER,NASER,ISGWIT,ISCHAN,ISWAVE,  
     &    ITIDASM,ISPERC,ISBODYF,ISPNHYDS  
      MTM=MAX(1,MTIDE)+1  
      NWSERM=MAX(1,NWSER)  
      NASERM=MAX(1,NASER)  
      NGWSERM=1  
      NDASER=1  
      NDWSER=1  
      NDGWSER=1  

      CALL SEEK('C16')  
      READ(1,*,ERR=10,END=30)NPBS,NPBW,NPBE,NPBN,NPFOR,NPFORT,NPSER,  
     &    PDGINIT  
      NPBSM=MAX(1,NPBS)  
      NPBWM=MAX(1,NPBW)  
      NPBEM=MAX(1,NPBE)  
      NPBNM=MAX(1,NPBN)  
      NPSERM=MAX(1,NPSER)  
      NPFORM=MAX(1,NPFOR,NPSER)  
      NDPSER=1  
      CALL SEEK('C22')  
      READ(1,*,ERR=10,END=30)NTOX,NSED,NSND,NCSER1,NCSER2,NCSER3,  
     &    NCSER4,NTOXSER,NSEDSER,NSNDSER,ISSBAL  
      NTXM=MAX(1,NTOX)  
      NSCM=MAX(1,NSED)  
      NSNM=MAX(1,NSND)  
      NCSERM=MAX(1,NCSER1,NCSER2,NCSER3,NCSER4,NTOXSER,NSEDSER,NSNDSER)  
      NDCSER=1  
      CALL SEEK('C23')  
      READ(1,*,ERR=10,END=30)NVBS,NUBW,NUBE,NVBN,NQSIJ,NQJPIJ,NQSER,  
     &    NQCTL,NQCTLT,NQWR,NQWRSR,ISDIQ  
      NUBSM=MAX(1,NVBS)  
      NUBWM=MAX(1,NUBW)  
      NVBEM=MAX(1,NUBE)  
      NVBNM=MAX(1,NVBN)  
      NQSIJM=MAX(1,NQSIJ)  
      NQJPM=MAX(1,NQJPIJ)  
      NQSERM=MAX(1,NQSER)  
      NQCTLM=MAX(1,NQCTL)  
      NQCTTM=MAX(1,NQCTLT)  
      NQWRM=MAX(1,NQWR)  
      NQWRSRM=MAX(1,NQWRSR)  
      NDQSER=1   ! *** Flow              : Maximum number of  points in a series
      NDQWRSR=1  ! *** Withdrawal/Return : Maximum number of  points in a series
      IF(NSED.GT.0.OR.NSND.GT.0)THEN  
        CALL SEEK('C36')  
        READ(1,*,ERR=10,END=30)ISEDINT,ISEDBINT,ISEDWC,ISMUD,ISNDWC,  
     &      ISEDVW,ISNDVW,KB,ISDTXBUG  
        IF(KB.GE.1)THEN  
          KBM=KB  
        ELSE  
          STOP'KB MUST BE AT LEAST 1'  
        ENDIF  
      ELSE  
        KBM=1  
      ENDIF  

      CALL SEEK('C36A')  
      READ(1,*,IOSTAT=ISO)ISBEDSTR,ISBSDFUF,COEFTSBL,VISMUDST
      CALL SEEK('C40')
	READ(1,*,ERR=50)IWRSP(1) 
50    CONTINUE
      IF(NTOX.GT.0)THEN
        CALL SEEK('C45A')  
        READ(1,*,ERR=10)ISTDOCW,ISTPOCW,ISTDOCB,ISTPOCB,  
     &                    STDOCWC,STPOCWC,STDOCBC,STPOCBC  
      ENDIF
      CALL SEEK('C46')  
      READ(1,*,ERR=10,END=30)BSC,TEMO,HEQT,RKDYE,NCBS,NCBW,NCBE,NCBN  
      NBBSM=MAX(1,NCBS)  
      NBBWM=MAX(1,NCBW)  
      NBBEM=MAX(1,NCBE)  
      NBBNM=MAX(1,NCBN)  
      CALL SEEK('C66A')  
      READ(1,*,ERR=10) NLCDA,TSCDA,(ISCDA(K),K=1,7)  
      NLDAM=NLCDA
      CALL SEEK('C67')  
      READ(1,*,ERR=10) ISPD,NPD,NPDRT,NWPD,ISLRPD,ILRPD1,ILRPD2,  
     &    JLRPD1, JLRPD2, MLRPDRT,IPLRPD  
      NPDM=MAX(1,NPD)
      CALL SEEK('C82')  
      READ(1,*,ERR=10,END=30)ISLSHA,MLLSHA,NTCLSHA,ISLSTR,ISHTA  
      MLM=MAX(1,MLLSHA)  

      CALL SEEK('C84')  
      READ(1,*,ERR=10,END=30)ISTMSR,MLTMSR,NBTMSR,NSTMSR,NWTMSR,  
     &    NTSSTSP,TCTMSR  
      MLTMSRM=MAX(1,MLTMSR)  
      NTSSTSPM=MAX(1,NTSSTSP)  
      MTSSTSPM=1  
      IF(NTSSTSP.GT.0)THEN  
        CALL SEEK('C85')  
        DO ITSSS=1,NTSSTSP  
          READ(1,*,ERR=10,END=30)I,M  
          MTSSTSPM=MAX(MTSSTSPM,M)  
        ENDDO  
      ENDIF  
      CLOSE(1)  


      IF(ISVEG.GE.1)THEN  
        OPEN(1,FILE='VEGE.INP',STATUS='UNKNOWN')  
        DO NS=1,12  
          READ(1,*)  
        ENDDO  
        READ(1,*,ERR=10,END=30)MVEGTYP,MVEGOW,NVEGSER,UVEGSCL  
        NVEGTPM=MAX(NVEGTPM,MVEGTYP)
        NVEGSERM=MAX(NVEGSERM,NVEGSER)
        CLOSE(1)

        IF(NVEGSER.GE.1)THEN  
          OPEN(1,FILE='VEGSER.INP',STATUS='UNKNOWN')  
          DO IS=1,8  
            READ(1,*)  
          ENDDO  
          DO NS=1,NVEGSER  
            READ(1,*,ERR=10,END=30) M1,TC1,TAV1
            NDVEGSER=MAX(NDVEGSER,M1)
            DO M=1,M1  
              READ(1,*)
            ENDDO  
          ENDDO  
          CLOSE(1)  
        ENDIF
	    OPEN(1,FILE='MHK.INP',STATUS='UNKNOWN')
        DO NS=1,29  
          READ(1,*)  
        ENDDO
	    READ(1,*,ERR=10,END=30)MHKTYP
        CLOSE(1)
        OPEN(1,FILE='DXDY.INP',STATUS='UNKNOWN')
        DO I=1,4
          READ(1,*)
        ENDDO
        TCOUNT=0
        DO I=1,LVC
          READ(1,*)IITMP,IITMP,R1TMP,R2TMP,R3TMP,R4TMP,R5TMP,IJTMP
          IF(IJTMP>90)THEN
            TCOUNT=TCOUNT+1
          ENDIF
        ENDDO
        CLOSE(1)  
      ENDIF
      RETURN  
   10 WRITE(*,20)  
      WRITE(8,20)  
   20 FORMAT('READ ERRDOR IN INPUT FILE')  
      STOP  
   30 WRITE(*,40)  
      WRITE(8,40)  
   40 FORMAT('UNEXPECTED END OF INPUT FILE')  
      STOP  
      END  

