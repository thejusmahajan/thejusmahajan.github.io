!forcing
#undef TEMP_JUMP
#undef CONSTANT_TEMP
#define SEASONAL_TEMP
#undef ALTERNATING_TEMP



#undef DIURNAL_L
#undef DIURNAL_T
#undef SOLARHEAT
#undef CHAOS
#undef TREND
#undef INTERANNUAL
#undef CONVECTION

! biology
#define AORG_COM
#define PHYT_IBM
#define DETR_COM
#undef PHYT_COM
#undef DETR_IBM

PROGRAM WaterColumnModel

! program to compute a one dimensional compartment/individual based model system

USE wcm_arrays

REAL*4 :: rand
REAL*8 :: rand_normal
REAL*8 :: rand_uniform
! --------------------------------------------------------------------------

! general set up
NAMELIST /model_params/ dt, nyears, aorg_init, phyt_init
NAMELIST /bio_params/ mu_max_day, kn, tslope, mutation_width

OPEN(UNIT=100, FILE='parameters.nml', STATUS='OLD')
READ(100, NML=model_params)
READ(100, NML=bio_params)
CLOSE(100)

! dt=3600.d0 ! Read from namelist
endtime=nyears*secyear
time=0.0d0
itmax=int(endtime/dt)
pi=2.0d0*dasin(1.0d0)

! biology
topt=18.d0
tslope=6.d0

! atmospheric forcing
ampm=  12.5d0
ampt0= 12.5d0
ampt1= 12.5d0
theta0=2.6d0
theta1=2.6d0
dcold0=270.d0
dcold1=270.d0

! time stepping
lnew=2
lold=1

nbr0=0

!read(5,*) dist

! initialization
temp=0.000d0      ! [degC]
swrad=0.000d0      ! [degC]
phyt(:)=phyt_init      ! [mmolN/m^3]
strain(:,:)=3.5d0/float(Ms+1)   ! [mmolN/m^3]
aorg(:)=aorg_init      ! [mmolN/m^3]
detr(:)=0.0d0      ! [mmolN/m^3]

#ifdef PHYT_IBM
ALLOCATE(iliv(M2))
ALLOCATE(igen(M2))
ALLOCATE(phybio(M2))
ALLOCATE(phyopt(M2))

! Seed the random number generator
CALL RANDOM_SEED()

phybio  =0.0d0
iliv =0
       
       
icnt=500
M2max=500

! Seed the random number generator
CALL RANDOM_SEED()

DO i=1,500
   iliv(i)=1
   call random_number(test)
   phybio(i)=0.5d0*cpa*biopercell*(1.0d0+test)
!     call random_number(test)
!     phyopt(i)=10.0d0+10.d0*test
#ifdef CONSTANT_TEMP
    phyopt(i)=rand_uniform(5.d0,25.d0)
#endif
#ifdef TEMP_JUMP
   phyopt(i)=rand_normal(15.d0,0.862d0)
#endif
#ifdef SEASONAL_TEMP
   phyopt(i)=rand_normal(15.d0,0.862d0)
#endif
#ifdef ALTERNATING_TEMP
   phyopt(i)=rand_normal(15.d0,0.60705d0)
!    phyopt(i)=rand_uniform(5.d0,25.d0)
#endif
   igen(i)=1
ENDDO
! aorg(:)=5.000d0-1.2d0-SUM(phybio(1:M))      ! [mmolN/m^3]

phyt=0.0d0
DO i=1,M
  IF(iliv(i).eq.1) THEN
    phyt(:)=phyt(:)+phybio(i)
  ENDIF
ENDDO
#endif /* PHYT_IBM */
!print *, aorg(1),detr(1),phyt(1),SUM(phybio(1:M))
!stop
!read(*,*)
phytpos=phyt(1)

globalp    = 0.0d0
globalt    = 0.0d0
globaln    = 0.0d0

nbr_cls=0
DO i=1,M
   IF(iliv(i).eq.1) THEN
    iii=int((phyopt(i)-5.d0)/0.1d0)
    nbr_cls(iii)=nbr_cls(iii)+1
!    print*,iii
!    read*,
   ENDIF
ENDDO
growthmean0=0.d0
growthmean=0.d0

!output
WRITE(10) temp,swrad
WRITE(11) aorg(lnew),detr(lnew),phyt(lnew)
WRITE(12) nbr_cls,growthmean0,growthmean
WRITE(13) MINVAL(igen,igen.gt.0), MAXVAL(igen,igen.gt.0)
WRITE(14) strain(:,lnew),growthmean0

! main time loop

DO 1000 it=1,itmax

! advance time
time=time+dt

! set variables positive
aorgpos = max(aorg(lold),0.0d0)
phytpos = max(phyt(lold),0.0d0)
detrpos = max(detr(lold),0.0d0)
strainpos(:) = max(strain(:,lold),0.0d0)

! irradiance
timel=time+10.d0*secday
#ifdef DIURNAL_L
CALL sunlight(time,pi,solrad)
#else
CALL sunlightd(time,solrad)
#endif /* DIURNAL_L */
! solrad=110.d0 ! Removed hardcoding to allow seasonal cycle

! light penetration
! swrad=solrad*par
swrad = 100.0d0 ! Hardcoded to remove high-frequency noise for paper reproduction
! print *, 'DEBUG: time=', time, 'solrad=', solrad, 'swrad=', swrad


#ifdef PHYT_COM
  delta=0.36d0
! step phyt
  sigman=aorgpos/(0.15d0+aorgpos)
!  sigmai=swrad/(21.0d0+swrad)
!   puptake=1.0d0/secday*exp(-((temp-topt)/tslope)**2) *sigman*sigmai*phytpos
!   ploss=0.1d0/secday*phytpos
!   phyt(lnew)=phyt(lold)+ dt*(puptake-ploss)
DO j=0,Ms
!  suptake(j)=log(2.d0)/secday*sigman*exp(-((temp-(5.05d0+0.1*float(j)))/tslope)**2)*strainpos(j)
  suptake(j)=log(2.d0)/secday*sigman*exp(-((temp-(5.d0+10.d0/float(Ms)+20.d0/float(Ms)*float(j)))/tslope)**2)*strainpos(j)
!  suptake(j)=0.59d0*exp(0.0633*(5.d0+0.1*float(j)))/secday*sigman*exp(-((temp-(5.d0+0.1*float(j)))/tslope)**2)*strainpos(j)
  sloss(j)=0.10d0/secday*strainpos(j)
ENDDO

  strain( 0,lnew)=strain( 0,lold)+ dt*((1.d0-     delta)*suptake( 0)+delta* suptake(  1)              -  sloss( 0))
DO j=1,Ms-1
  strain( j,lnew)=strain( j,lold)+ dt*((1.d0-2.d0*delta)*suptake( j)+delta*(suptake(j-1)+suptake(j+1))-  sloss( j))
ENDDO
  strain(Ms,lnew)=strain(Ms,lold)+ dt*((1.d0-     delta)*suptake(Ms)+delta* suptake(Ms-1)             -  sloss(Ms))

  ploss  = SUM(sloss(:))
puptake= SUM(suptake(:))
phyt(lnew)= SUM(strain(:,lnew))
growthmean0=0.d0
DO j=0,Ms
  growthmean0=growthmean0+log(2.d0)*exp(-((temp-(5.d0+10.d0/float(Ms)+20.d0/float(Ms)*float(j)))/tslope)**2)*strainpos(j)
ENDDO
growthmean0=growthmean0/SUM(strainpos(:))
#endif /* PHYT_COM */

#ifdef PHYT_IBM
CALL phyt_ibm
#endif /* PHYT_IBM */

#ifdef DETR_COM
! step detr
remin=0.25d0/secday*detrpos
detr(lnew)=detr(lold)+ dt*(ploss-remin)
#endif /* DETR_COM */

#ifdef AORG_COM
! step aorg
aorg(lnew)=aorg(lold)+ dt*(remin-puptake)
#endif /* AORG_COM */

orgsum=phyt(lnew)+detr(lnew)

! global sums (for conservation check)
globalp    = globalp    + phyt(lnew)
globalt    = globalt    + temp
globaln    = globaln    + aorg(lnew)+phyt(lnew)+detr(lnew)

IF(mod(time,secyear).eq.0) THEN
WRITE(50,'(8e15.6)') time/secyear, &
                     globalt*dt/secyear, &
                     globaln*dt/secyear, &
                     globalp*dt/secyear
globalt    = 0.0d0
globaln    = 0.0d0
globalp    = 0.0d0
ENDIF

! temperature 
#ifdef CHAOS
IF(mod(time,secyear).eq.0) THEN
read(99,*) dummy1,dummy2,dummy3
  ampm=9.0d0
  ampt0=ampt1
  ampt1=9.d0+4.d0*(dummy1-0.5d0)
  theta0=theta1
  theta1=2.6d0+0.60d0*(dummy2-0.5d0)
  dcold0=dcold1
  dcold1=270.d0+30.d0*(dummy3-0.5d0)
ENDIF
#endif /* CHAOS */

ampt  = ampt0  + (ampt1 -ampt0) *mod(time,secyear)/secyear
theta = theta0 + (theta1-theta0)*mod(time,secyear)/secyear
dcold = dcold0 + (dcold1-dcold0)*mod(time,secyear)/secyear

timel=time+dcold*secday
atime=mod(timel,secyear)/(secyear)
atime=sinh(theta*(1.-atime))/sinh(theta)
       
temp=ampm-ampt*cos(2.*pi*atime)
#ifdef INTERANNUAL
temp=temp*(1.00d0-2.0d0/18.0d0*sin(2.0d0*pi*time/(10.d0*secyear)))
#endif /* INTERANNUAL */
#ifdef TREND
temp=temp+2.0d0*time/(60.d0*secyear)
#endif /* TREND */
#ifdef DIURNAL_T
theta=2.0d0
timel=time+0.75d0*secday
atime=mod(timel,secday)/(secday)
atime=sinh(theta*(1.-atime))/sinh(theta)
temp=temp-2.5d0*sin(2.0d0*pi*time/secday) * (1.25d0+0.75d0*cos(2.d0*pi*time/secyear)) 
#endif /* DIURNAL_T */

#ifdef CONSTANT_TEMP
temp=15.d0
#endif /* CONSTANT_TEMP */
#ifdef TEMP_JUMP
temp=15.d0
IF(time.ge.1.d0*secyear) temp=20.d0
#endif /* TEMP_JUMP */
#ifdef SEASONAL_TEMP
temp=15.d0+5.0d0*sin(2.d0*pi*time/(secyear))
#endif /* SEASONAL_TEMP */
#ifdef ALTERNATING_TEMP
temp=15.d0+sign(5.d0,sin(2.d0*pi*time/(secday)))
#endif /* ALTERNATING_TEMP */

! monitoring

IF(dmod(time+0.5d0*secday,secday).eq.0.0d0) THEN
  iday   = dmod(time-secday,secmonth)/secday+1
  imonth = dmod(time-secday,secyear)/(secmonth)+1
  iyear  = int((time-secday)/secyear)+1
  
  ! Print only every 10 days to reduce I/O overhead
  IF (mod(iday, 10) .eq. 0) THEN
      WRITE(6,'(3i4,5f10.4,7i9)') iyear,imonth,iday,temp, &
                                  aorg(lnew),detr(lnew),phyt(lnew),aorg(lnew)+detr(lnew)+phyt(lnew), &
                                  icnt, M2max, COUNT(iliv.eq.1), COUNT(iliv.eq.-1), COUNT(iliv.eq.2), &
                                  MINVAL(igen,igen.gt.0), MAXVAL(igen,igen.gt.0)
  ENDIF
! print *, 0.1d0*(1.d0+0.15/aorg(lnew)), 0.1d0*(1.d0+0.15d0/aorg(lnew))*aorg(lnew)/(0.15d0+aorg(lnew)) &
!        , 0.25d0/0.35d0*(5.-aorg(lnew))/phyt(lnew) , 0.10d0/0.35d0*(5.-aorg(lnew))/detr(lnew)
ENDIF


! output
IF(dmod(time+0.5d0*secday,secday).eq.0.d0) THEN

#ifdef PHYT_IBM 
nbr_cls=0
growthmean0=0.d0
DO i=1,M2max
   IF(iliv(i).eq.1) THEN
    iii=int((phyopt(i)-5.d0)/0.1d0)
    IF(iii.lt.0) iii=0
    IF(iii.gt.Ms) iii=Ms
    nbr_cls(iii)=nbr_cls(iii)+1

    growthmean0=growthmean0+exp(-((temp-phyopt(i))/tslope)**2)
   ENDIF
ENDDO
growthmean0=growthmean0/COUNT(iliv.eq.1)*aorgpos/(0.15d0+aorgpos)
#endif /* PHYT_IBM */

  WRITE(10) temp,swrad
  WRITE(11) aorg(lnew),detr(lnew),phyt(lnew)
  WRITE(12) nbr_cls,growthmean0,growthmean
  WRITE(13) MINVAL(igen,igen.gt.0), MAXVAL(igen,igen.gt.0)
  WRITE(14) strain(:,lnew),growthmean0
ENDIF

! switch time level
     lnew=lold
     lold=3-lnew
!print*,lold,lnew
!read*,
1000 CONTINUE

END

! --------------------------------------------------------------------------

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! sunlight                                          a.beckmann 02.2000 !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      SUBROUTINE sunlight(time,pi,solrad)

      REAL*8 :: time,pi,solrad
      REAL*8 :: dayofyear,hourofday,rlat,rlon,geodekl,geophi,geolam,cosz

      pi=2.0d0*DASIN(1.0d0)

      dayofyear=DMOD(time,360.d0*86400.d0)/86400.d0
      hourofday=(12.d0-DMOD(time,86400.d0)/3600.d0)*pi/12.d0

      rlat=60.0d0
      rlat=55.0d0
      rlon=22.0d0
      geodekl=23.44d0*pi/180.d0*COS(2.d0*pi*(172.d0-dayofyear)/360.d0)
      geophi=rlat*pi/180.d0
      geolam=hourofday-rlon*pi/180.d0

      cosz=SIN(geophi)*SIN(geodekl)+COS(geophi)*COS(geodekl)*COS(geolam)
      cosz=DMAX1(cosz,0.0d0)

      solrad = 1353.0d0*cosz**2*(1.0d0-0.6d0*(0.7d0)**3) / ((cosz+2.7d0)*611.d-5 + 1.085d0*cosz + 0.1d0) *0.94d0 ! due to albeDO

      RETURN
      END
      
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! sunlightd                                         a.beckmann 02.2000 !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      subroutine sunlightd(time,solrad)

      implicit double precision (a-h,o-z)

      pi=2.0d0*dasin(1.0d0)

      rlat=60.0d0
      rlat=55.0d0
      rlon=22.0d0
      geophi=rlat*pi/180.d0

      solrad=0.0d0

      DO i=1,24
      time2=time+1800.d0+float(i-13)*3600.d0

      dayofyear=dmod(time2,360.d0*86400.d0)/86400.d0
      hourofday=(12.-dmod(time2,86400.d0)/3600.d0)*pi/12.d0

      geodekl=23.44d0*pi/180.d0*cos(2.*pi*(172.d0-dayofyear)/360.d0)
      geolam=hourofday-rlon*pi/180.d0

      cosz=sin(geophi)*sin(geodekl)+cos(geophi)*cos(geodekl)*cos(geolam)
      cosz=dmax1(cosz,0.0d0)

      solrad = solrad + cosz**2*(1.0d0-0.6d0*(0.7d0)**3) / ((cosz+2.7d0)*611.d-5 + 1.085d0*cosz + 0.1d0)

      ENDDO

      solrad = 1353.0d0*solrad/24.d0 *0.94d0 ! due to albeDO

      return
      end
      
      FUNCTION rand_normal(mean,stdev) RESULT(c)
        REAL*8, PARAMETER :: PI=3.141592653589793238462
        REAL*8 :: mean,stdev,c,temp(2)
        CALL RANDOM_NUMBER(temp)
        r=(-2.0d0*log(temp(1)))**0.5
        theta = 2.0d0*pi*temp(2)
        c= mean+stdev*r*sin(theta)
      END FUNCTION
      FUNCTION rand_uniform(a,b) RESULT(c)
        REAL*8, PARAMETER :: PI=3.141592653589793238462
        REAL*8 :: a,b,c,temp
        CALL RANDOM_NUMBER(temp)
        c= a+temp*(b-a)
      END FUNCTION


