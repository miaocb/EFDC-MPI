
SUBROUTINE WELCOME  
    
  ! *** CHANGE RECORD  
  ! ***   
  ! DATE MODIFIED     BY           
  ! 06/25/2006        Paul M. Craig
  !                   Updated Code to Fortran 90

  ! DATE MODIFIED     BY           
  ! 09/01/2017        Fearghal O'Donncha
  !                   MPI parallelization and domain decmoposition
  !                   Modules for assimilation of HF radar data

  WRITE(6,1)  

1 FORMAT('***********************************************************************'  &
      ,/,'*                                                                     *'  &  
      ,/,'*                                                                     *'  &  
      ,/,'*            EEEEEEEEE    FFFFFFFFF    DDDDDDDD       CCCCCCCC        *'  &  
      ,/,'*           EEE          FFF          DDD     DD    CCC      CC       *'  &  
      ,/,'*          EEE          FFF          DDD     DD    CCC                *'  &  
      ,/,'*         EEEEEEEE     FFFFFFFF     DDD     DD    CCC                 *'  &  
      ,/,'*        EEE          FFF          DDD     DD    CCC                  *'  &  
      ,/,'*       EEE          FFF          DDD     DD    CCC      CC           *'  &  
      ,/,'*      EEEEEEEEE    FFF          DDDDDDDDDD      CCCCCCCCC            *'  &  
      ,/,'*                                                                     *'  &  
      ,/,'*                                                                     *'  &  
      ,/,'*                  ENVIRONMENTAL FLUID DYNAMICS CODE                  *'  &  
      ,/,'*                  DEVELOPED BY JOHN M. HAMRICK                       *'  &  
      ,/,'*                                                                     *'  &  
      ,/,'*     EFDC AND "ENVIRONMENTAL FLUID DYNAMICS CODE" ARE TRADEMARKS     *'  &  
      ,/,'*     OF JOHN M. HAMRICK                                              *'  &
      ,/,'*                                                                     *'  &
       ,/,'*    EFDC_DS:  UPDATED AND ENHANCED BY DYNAMIC SOLUTIONS, LLC        *'  &
      ,/,'*                                                                     *'  &  
      ,/,'*     EFDC_MPI - DEVELOPED BY IBM RESEARCH IRELAND                    *'  &
      ,/,'*                                                                     *'  &
      ,/,'*         CONTACT: FEARGHAL O DONNCHA (feardonn@ie.ibm.com)           *'  &
      ,/,'*                                                                     *'  &  
      ,/,'*                  VERSION DATE: 01 SEPT 2017                         *'  &  
      ,/,'*                                                                     *'  &  
      ,/,'***********************************************************************') 
RETURN  
END  

