      REAL FUNCTION CSEDTAUS(DENBULK,TAUCO,VDRO,VDR,VDRC,IOPT,L)  
      INTEGER::IOPT,L
      REAL::BULKDEN,DENBULK,TMP,TAUCO,VDRO,VDR,VDRC
C  
C CHANGE RECORD  
C  
C#######################################################################  
C  HQI ADDED, 11/18/2003, HAMRICK COMMENTED OUT SINCE NOT NEEDED FOR  
C  FOR 11/24 VERSION OF IOPT= 99 THAT IS ACTIVE AS OF 01/08/2004  
C#######################################################################  
C **  CALCULATES CRITIAL STRESS FOR SURFACE EROSION OF COHESIVE  
C **  SEDIMENT AS A FUNCTION OF BED BULK DENSITY  
C **
C **  IOPT=1  BASED ON  
C **  HWANG, K. N., AND A. J. MEHTA, 1989: FINE SEDIMENT ERODIBILITY  
C **  IN LAKE OKEECHOBEE FLORIDA. COASTAL AND OCEANOGRAPHIC ENGINEERING  
C **  DEPARTMENT, UNIVERSITY OF FLORIDA, GAINESVILLE, FL32661  
C **  
C **  IOPT=2  BASED ON J. M. HAMRICK'S MODIFICATION OF  
C **  SANFORD, L.P., AND J. P. Y. MAA, 2001: A UNIFIED EROSION FORMULATI  
C **  FOR FINE SEDIMENT, MARINE GEOLOGY, 179, 9-23.  
C  
      IF(IOPT.EQ.1)THEN  
        BULKDEN=0.001*DENBULK  ! *** PMC Changed to prevent 
        IF(BULKDEN.LE.1.065)THEN  
          CSEDTAUS=1.0E-12  ! PMC Changed from 0 to prevent div by 0
        ELSE  
          TMP=(BULKDEN-1.065)**0.2  
          CSEDTAUS=0.001*(0.883*TMP+0.05)  
        ENDIF  
      ELSEIF(IOPT.EQ.2)THEN  
        CSEDTAUS=TAUCO*(1.+VDRO)/(1.+VDR)  
      ELSEIF(IOPT.EQ.3)THEN  
        CSEDTAUS=TAUCO*(1.+VDRO)/(1.+VDRC)  
      ELSEIF(IOPT.GE.99)THEN  
        !#######################################################################  
        !  HQI CHANGE, 08/25/03, AND 11/24/03  SO AND RM  
        !  CHANGE TO IMPLEMENT CRITICAL SHEAR STRESS OPTION  
        !  CSEDTAUS IS TAU/RHO WITH TAU IN DYNE/CM^2  
        !  IWRSP(1) = 99 FOR SHEAR STRESS AS A FUNCTION OF BULK DENSITY FROM  
        !                SED-FLUME EXPERIMENTS  
        IF(L.LE.265) THEN  
          CSEDTAUS=0.2/1000.  
        ELSE  
          CSEDTAUS=0.4/1000.  
        ENDIF  
      ELSE
        STOP 'CSEDTAUS: BAD SEDIMENT RESUSPENSION OPTION! STOPPING!'
      ENDIF  
C  
C#######################################################################  
C#######################################################################  
C  HQI ADDED, 11/18/2003  
C  COMPUTE THE D90 OF A CELL BED FROM THE FRACTIONS OF EACH GRAIN SIZE  
C  AND THE COMPUTED D50'S (I.E. THE DEFF FOR THE FOUR CLASSES.  
C      SEDDIA(1)=22.0*1.E-6 !CONVERT MICRON TO METER  
C      UBND = 999.  
C      LBND = -999.  
C 6400, 570, 160, 63 IN MICRONS  
C        LBND = 0.  
C        LSIZE = 0.  
C  SEDPHIC ** GP-CONVERT SEDIMENT DIAMETERS IN M TO MM AND SET PHI SIZE  
C      SEDDIA(1)=22.0*1.E-6 !CONVERT MICRON TO METER  
C **  GP - SET MEAN PHI FOR TOP LAYER OF BED  
C      RTVAR3W=0.  
C      RTVAR3E=0.  
C      RSIGPHI=0.  
C        RTVAR3E=1.  
C      ELSE  
C      RSIGPHI=2.**(RSIGPHI)  
C **  SET MEAN D50  
C      D50SIG=0.  
C      RSNDBT=0.  
C       !D50SIG=D50SIG+SNDB(L,KTOP,NX)*(SEDDIA(NS))  
C      !D50SIG=D50SIG+SEDB(L,KTOP,1)*(SEDDIA(1))  
C      !D50SIG=D50SIG/RSNDBT  
C ** COMPUTE THE D90 FROM THE STANDARD DEVIATION OF GRAIN SIZE  
C    DISTRIBUTIONIN BED  
C      Z90 = 1.281551  !(Z-SCORE FOR THE 90TH PERCENTILE)  
C ** COHESIVE CONCENTRATION  
C      COHCON= (SEDB(L,KTOP,1)*1E-6)/HBED(L,KTOP)  
C      CSEDTAUS=(0.36*((D90SIG/D50SIG)**0.948803))  
C        CSEDTAUS = 2./10000.  
C       STOP  
C#######################################################################  
C  
      RETURN  
      END  

