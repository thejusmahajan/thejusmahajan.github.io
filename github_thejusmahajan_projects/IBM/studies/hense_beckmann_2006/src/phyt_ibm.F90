#define NORMAL

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! phyt_ibm                                          a.beckmann 09.2015 !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SUBROUTINE phyt_ibm

USE wcm_arrays

REAL*4 :: rand
REAL*8 :: rand_normal
REAL*8 :: rand_uniform


!initialization
puptake=0.0d0
ploss=0.0d0
remin=0.0d0
dissolve0=0.1d0*dt/secday*biopercell*cpa

! IF(icnt.gt.1) THEN
! ! compute remineralization
! DO i=1,M2max
!   IF(iliv(i).eq.-1) THEN
!     dissolve=min(dissolve0,phybio(i))
!     remin=remin+dissolve
!     phybio(i)=phybio(i)-dissolve
!     IF(phybio(i).eq.0.d0) THEN
!       iliv(i)=0
!       igen(i)=0
!     ENDIF
!   ENDIF
! ENDDO
! ENDIF

IF(icnt.gt.1) THEN

! ! compute damaging mortality
! DO i=1,M2max
!  IF(iliv(i).eq.1) THEN
!    call random_number(test)
!    IF(test.le.phydam(i)**3) THEN
!      iliv(i)=-1
!      igen(i)=-1
!    ENDIF
!  ENDIF
! ENDDO
! 
! ! adjust array size
! CALL array_adjust(M2, M2max, phybio, phyopt, iliv, igen)

! compute natural mortality
nbr=COUNT(iliv.eq.1)
growthmean=log(2.0)*log(float(nbr)/float(nbr0))/dt*secday
!print*,growthmean,nbr,nbr0,float(nbr0)
!read*,
!$OMP PARALLEL DO PRIVATE(i, test) REDUCTION(+:ploss)
DO i=1,M2max
  IF(iliv(i).eq.1) THEN
    call random_number(test)
!    test=rand_uniform(0.d0,1.d0)
!    IF(test.le.0.1d0/secday*dt*phyopt(i)/15.d0) THEN
    IF(test.le.0.1d0/secday*dt) THEN
!      iliv(i)=-1
!      igen(i)=-1
      ploss=ploss+phybio(i)
      iliv(i)=0
      igen(i)=0
    ENDIF
  ENDIF
ENDDO
!$OMP END PARALLEL DO
nbr0=COUNT(iliv.eq.1)

! adjust array size
CALL array_adjust(M2, M2max, phybio, phyopt, iliv, igen)

ENDIF

!print *, MINVAL(phyopt),MAXVAL(phyopt),MINVAL(phydam),MAXVAL(phydam)
! compute cell growth
!$OMP PARALLEL DO PRIVATE(i, templim, growth) REDUCTION(+:puptake)
DO i=1,M2max
  IF(iliv(i).eq.1) THEN
!    IF(swrad.ne.0.d0) THEN      
!      templim=exp(-((temp-phyopt(i))/(tslope*15.d0/phyopt(i)))**2)*0.59d0*exp(0.0633*phyopt(i))
!      templim=exp(-((temp-phyopt(i))/tslope)**2)*0.59d0*exp(0.0633*phyopt(i))
      templim=exp(-((temp-phyopt(i))/tslope)**2)
!      templim=0.d0
!      IF(abs(phyopt(i)-temp).le.3.0d0) templim=1.d0
!      templim=exp(-((temp-phyopt(i))/(40.d0*dist))**2)
! !       IF(temp.le.phyopt(i)) THEN
! !          templim= exp(-(abs(temp-phyopt(i))/9.d0)**2) 
! !       ELSE
! !          templim= exp(-(abs(temp-phyopt(i))/3.d0)**3) 
! !       ENDIF
      growth=(mu_max_day * log(2.0d0))/secday*biopercell*cpa &
            *aorgpos/(kn+aorgpos) &
            *templim
      phybio(i)=phybio(i)+dt*growth
      puptake=puptake+growth
!    ENDIF                  
  ENDIF
ENDDO
!$OMP END PARALLEL DO

! cell division
inew=0
do i=1,M2max
  IF(iliv(i).eq.1) THEN
    IF(phybio(i).ge.cpa*biopercell) THEN
      phybio(i)=0.5d0*phybio(i)
      igen(i)=igen(i)+1
      DO ij=inew+1,M2
        IF(iliv(ij).eq.0) THEN
          inew=ij
          GOTO 2345
        ENDIF
      ENDDO
      STOP 'ARRAY OVERFLOW'
      2345 CONTINUE
      phybio(inew)=phybio(i)
      iliv(inew)=1
      igen(inew)=igen(i)
#ifdef NORMAL
      phyopt(inew)=rand_normal(phyopt(i),mutation_width)
!      phyopt(inew)=rand_normal(phyopt(i),dist)
!      phyopt(inew)=rand_normal(phyopt(i),0.4d0)
#else
!      phyopt(inew)=rand_uniform(phyopt(i)-0.1,phyopt(i)+0.1d0)
!       call random_number(test)
!       phyopt(inew)=phyopt(i)+(test-0.5d0)*0.2d0
      phyopt(inew)=rand_uniform(phyopt(i)-0.1732d0,phyopt(i)+0.1732d0)
#endif 
!       phyopt(inew)=phyopt(i)
!       call random_number(test)
!       IF(test.le.1.0d-6) THEN
!         call random_number(test)
!         phyopt(inew)=10.d0+25.0d0*test
!         PRINT *, 'MUTATION',phyopt(inew)
!         WRITE(77,*) int(time/secyear)+1,phyopt(inew)
!       ENDIF
    ENDIF
  ENDIF
enddo

! adjust array size
CALL array_adjust(M2, M2max, phybio, phyopt, iliv, igen)

! determination of biomasses 
nbr=0
agents=0.d0
phyt(lnew)=0.0d0
!detr(lnew)=0.0d0
!$OMP PARALLEL DO PRIVATE(i) REDUCTION(+:phyt, agents, nbr)
DO i=1,M2max
!   IF(iliv(i).eq.-1) THEN
!     detr(lnew)=detr(lnew)+phybio(i)
!     agents=agents+1.d0
!     nbr=nbr+1
!   ENDIF
  IF(iliv(i).eq.1) THEN
    phyt(lnew)=phyt(lnew)+phybio(i)
    agents=agents+1.d0
    nbr=nbr+1
  ENDIF
ENDDO
!$OMP END PARALLEL DO
icnt=COUNT(iliv.ne.0)

puptake=puptake
remin=remin/dt
ploss=ploss/dt

RETURN
END
            
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! array_adjust                                      a.beckmann 10.2014 !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SUBROUTINE array_adjust(M2, M2max, phybio, phyopt, iliv, igen)

IMPLICIT NONE

INTEGER                    :: M2, M2max, i, ij 

INTEGER, DIMENSION(M2)     :: iliv, &   ! living cell indicator
                              igen      ! generation

REAL*8, DIMENSION(M2)      :: phybio, &       ! diatom cell biomass
                              phyopt

!determine array size ...
DO i=M2,1,-1
  IF(iliv(i).ne.0) THEN
     M2max=i
     GOTO 5678
   ENDIF
ENDDO
5678 CONTINUE

! ... and rearrange
!ij=MINLOC(iliv,DIM=1)
ij=MINLOC(iliv,DIM=1,MASK=iliv.eq.0)
IF(ij.lt.M2max) THEN
  phybio(ij) = phybio(M2max)
  phyopt(ij) = phyopt(M2max)
  igen(ij)   = igen(M2max)
  iliv(ij)   = iliv(M2max)
  
  phybio(M2max) =0.0d0
  phyopt(M2max) =0.0d0
  iliv(M2max)   =0
  igen(M2max)   =0

  M2max=M2max-1
ENDIF

RETURN
END
