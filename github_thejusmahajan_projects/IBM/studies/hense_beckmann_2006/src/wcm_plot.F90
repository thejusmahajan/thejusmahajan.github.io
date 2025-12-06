#define IBM

PROGRAM wcm_plot

IMPLICIT NONE

INTEGER, PARAMETER :: nyears=10, NN=360*nyears, Ms=200

! state variables
REAL*8                   :: temp, & ! temperature
                            phyt, & ! bulk phytoplankton
                            diat, & ! diatoms
                            detr, & ! detritus
                            aorg, & ! anorganic nutrient
                            swradl  ! short wave radiation in each layer

! plotting variables
REAL*4, DIMENSION(0:NN    ) :: tempplt, & ! temperature
                               phytplt, & ! bulk phytoplankton
                               diatplt, & ! diatoms
                               detrplt, & ! detritus
                               prodplt, & ! total producers
                               aorgplt, & ! anorganic nutrient
                               radiplt, & ! short wave radiation in each layer
                               ratioplt, & ! ratio
                               gminplt, & ! ratio
                               gmaxplt, & ! ratio
                               generation, & ! ratio
                               workplt    ! workspace
                               
common /coord/ generation

INTEGER, DIMENSION(0:Ms)     :: nbr_cls
REAL*8, DIMENSION(0:Ms)      :: strain
REAL*8                       :: growth0,growth
REAL*4, DIMENSION(0:NN,0:Ms) :: topt_bin,dama_bin
REAL*4, DIMENSION(0:NN)      :: topt_mean,dama_mean,growthmean0,growthmean

INTEGER :: it, &      ! time index
           j, &       ! number of vertical levels
           N_in, &    ! number of vertical levels
           Mgen_in, & ! number of vertical levels
           NNact, &   ! actual number of time slices 
           igmin, igmax
! input

DO it=0,NN
  READ(10,END=999,ERR=999) temp,swradl
  tempplt(it)=temp
  radiplt(it)=swradl
  READ(11,END=999,ERR=999) aorg,detr,phyt
  aorgplt(it)=aorg
  detrplt(it)=detr
  phytplt(it)=phyt
#ifdef IBM
  READ(12,END=999,ERR=999) nbr_cls,growth0,growth
  IF(SUM(nbr_cls).gt.0) topt_bin(it,:)=100.*nbr_cls(:)/SUM(nbr_cls)
  topt_mean(it)=0.0
  DO j=1,Ms
   topt_mean(it)=topt_mean(it)+(5.0+j*20./float(Ms))*topt_bin(it,j)
  ENDDO
  topt_mean(it)=topt_mean(it)/100.0
!  print *, it,topt_mean(it)
  READ(13,END=999,ERR=999) igmin,igmax
  gminplt(it)=float(igmin)
  gmaxplt(it)=float(igmax)
  generation(it)=0.5*(igmin+igmax)
  growthmean0(it)=growth0
  growthmean(it)=growth
#else
  READ(14,END=999,ERR=999) strain,growth0
  IF(SUM(strain).gt.0) topt_bin(it,:)=100.*strain(:)/SUM(strain)
  topt_mean(it)=0.0
  DO j=1,Ms
   topt_mean(it)=topt_mean(it)+(5.0+j*20./float(Ms))*topt_bin(it,j)
  ENDDO
  topt_mean(it)=topt_mean(it)/100.0
  growthmean0(it)=growth0
#endif /* IBM */
ENDDO
NNact=NN
GOTO 998
999 NNact=it-1
998 CONTINUE
PRINT *, NNact+1,' data sets read'

! plots

CALL start_plot

CALL gscr(1,0,1.,1.,1.)
CALL gscr(1,1,0.,0.,0.)
CALL gscr(1,2,1.,0.,0.)
CALL gscr(1,3,0.,1.,0.)
CALL gscr(1,4,0.,0.,1.)
CALL gscr(1,5,0.,1.,1.)
CALL gscr(1,6,1.,1.,0.)
CALL gscr(1,7,1.,0.,1.)

CALL series1(NN,tempplt,phytplt,aorgplt,detrplt,radiplt,gminplt,gmaxplt,topt_mean,growthmean0,growthmean)

#ifdef IBM
  topt_bin(:,0:Ms-50)=topt_bin(:,25:Ms-25)
  CALL histo1(NN,Ms-50,topt_bin,tempplt)
  CALL histo2(NN,Ms-50,topt_bin)
#else
  topt_bin(:,0:Ms-50)=topt_bin(:,25:Ms-25)
  CALL histo1(NN,Ms-50,topt_bin,tempplt)
  CALL histo2(NN,Ms-50,topt_bin)
#endif

CALL end_plot

END
                        
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      SUBROUTINE series1(NN,tempplt,phytplt,aorgplt,detrplt,radiplt,gminplt,gmaxplt,topt_mean,growthmean0,growthmean)

      real*4 gminplt(0:NN)
      real*4 gmaxplt(0:NN)
      real*4 tempplt(0:NN)
      real*4 phytplt(0:NN)
      real*4 detrplt(0:NN)
      real*4 aorgplt(0:NN)
      real*4 radiplt(0:NN)
      real*4 topt_mean(0:NN)
      real*4 growthmean0(0:NN)
      real*4 growthmean(0:NN)
      real*4 ref1(0:NN),ref2(0:NN)
      real*4 time(0:NN)

      REAL*4, DIMENSION(0:NN)      :: adjust

CALL gscr(1,0,1.,1.,1.)
CALL gscr(1,1,0.,0.,0.)
CALL gscr(1,2,1.,0.,0.)
CALL gscr(1,3,0.,1.,0.)
CALL gscr(1,4,0.,0.,1.)
CALL gscr(1,5,0.,1.,1.)
CALL gscr(1,6,1.,1.,0.)
CALL gscr(1,7,1.,0.,1.)

      do i=0,NN
       time(i)=float(i)/30.
       radiplt(i)=radiplt(i)/10.0
       ref1(i)=0.1d0*0.59d0*exp(0.0633d0*22.0)
       ref2(i)=0.1d0*0.59d0*exp(0.0633d0*32.0)
      enddo

      CALL agseti('FRA.',2)

      CALL agsetc('LABEL/NAME.','B')
      CALL agseti('LINE/NUMBER.',-100)
      CALL agsetc('LINE/TEXT.',' $')
      CALL agsetc('LABEL/NAME.','L')
      CALL agseti('LINE/NUMBER.',100)
      CALL agsetc('LINE/TEXT.',' $')

      CALL agsetf('GRI/LE.',0.10)
      CALL agsetf('GRI/RI.',0.90)
      CALL agsetf('GRI/BO.',0.75)
      CALL agsetf('GRI/TO.',0.95)
      CALL agsetf('X/MI.',              0.0)
      CALL agsetf('X/MA.', float(NN/30))
      CALL agsetf('Y/MI.', 10.0)
      CALL agsetf('Y/MA.', 20.0)
      CALL gstxci(2)
      CALL gsplci(2)
      CALL ezxy(time,radiplt,NN+1,'     IRRADIANCE')
      CALL gstxci(1)
      CALL gsplci(1)
      CALL ezxy(time,tempplt,NN+1,'TEMP           ')

      CALL agsetf('GRI/LE.',0.10)
      CALL agsetf('GRI/RI.',0.90)
      CALL agsetf('GRI/BO.',0.40)
      CALL agsetf('GRI/TO.',0.70)
      CALL agsetf('X/MI.',              0.0)
      CALL agsetf('X/MA.', float(NN/30))
      CALL agsetf('Y/MI.', 0.0)
      CALL agsetf('Y/MA.', 5.0)
      CALL gstxci(3)
      CALL gsplci(3)
      CALL ezxy(time,aorgplt,NN+1,'AORG          ')
      CALL gstxci(2)
      CALL gsplci(2)
      CALL ezxy(time,phytplt,NN+1,'     PHYT     ')
      CALL gstxci(1)
      CALL gsplci(1)
      CALL ezxy(time,detrplt,NN+1,'          DETR')

      CALL agsetf('GRI/LE.',0.10)
      CALL agsetf('GRI/RI.',0.90)
      CALL agsetf('GRI/BO.',0.10)
      CALL agsetf('GRI/TO.',0.35)
      CALL agsetf('X/MI.',              0.0)
      CALL agsetf('X/MA.', float(NN/30))
      CALL agsetf('Y/MI.', 0.0)
      CALL agsetf('Y/MA.', 8.0)
      CALL gstxci(1)
      CALL gsplci(1)
      CALL ezxy(time,phytplt,NN+1,'PHYT')

      CALL frame

      CALL agseti('FRA.',2)

      CALL agsetc('LABEL/NAME.','B')
      CALL agseti('LINE/NUMBER.',-100)
      CALL agsetc('LINE/TEXT.',' $')
      CALL agsetc('LABEL/NAME.','L')
      CALL agseti('LINE/NUMBER.',100)
      CALL agsetc('LINE/TEXT.',' $')

      CALL agsetf('GRI/LE.',0.10)
      CALL agsetf('GRI/RI.',0.90)
      CALL agsetf('GRI/BO.',0.75)
      CALL agsetf('GRI/TO.',0.95)
      CALL agsetf('X/MI.',              0.0)
      CALL agsetf('X/MA.', float(NN/30))
      CALL agsetf('Y/MI.',    0.0)
      CALL agsetf('Y/MA.', 500.0)
      CALL gstxci(2)
      CALL gsplci(2)
      CALL ezxy(time,gmaxplt,NN+1,'GEN     MAX')
      CALL gstxci(1)
      CALL gsplci(1)
      CALL ezxy(time,gminplt,NN+1,'GEN MIN    ')

      CALL agsetf('GRI/LE.',0.10)
      CALL agsetf('GRI/RI.',0.90)
      CALL agsetf('GRI/BO.',0.425)
      CALL agsetf('GRI/TO.',0.675)
      CALL agsetf('X/MI.',              0.0)
      CALL agsetf('X/MA.', float(NN/30))
      CALL agsetf('Y/MI.',   0.0)
      CALL agsetf('Y/MA.',   0.2)
!       CALL gstxci(4)
!       CALL gsplci(4)
!       CALL ezxy(time,ref1,NN+1,'                    ')
!       CALL gstxci(3)
!       CALL gsplci(3)
!       CALL ezxy(time,ref2,NN+1,'                    ')
      CALL gstxci(2)
      CALL gsplci(2)
      CALL ezxy(time,growthmean ,NN+1,'GROWTH MEAN               ')
      CALL gstxci(1)
      CALL gsplci(1)
      CALL ezxy(time,growthmean0,NN+1,'             GROWTH MEAN 0')
!      print *, MINVAL(growthmean),MAXVAL(growthmean)


DO it=0,NN
  adjust(it)=max(15.+5.0*(1.-exp(-(float(it-360)/(1.2*360.)))),15.0)
  write(99,*) topt_mean(it)
ENDDO

      CALL agsetf('GRI/LE.',0.10)
      CALL agsetf('GRI/RI.',0.90)
      CALL agsetf('GRI/BO.',0.10)
      CALL agsetf('GRI/TO.',0.35)
      CALL agsetf('X/MI.',              0.0)
      CALL agsetf('X/MA.', float(NN/30))
      CALL agsetf('Y/MI.',10.0)
      CALL agsetf('Y/MA.',20.0)
      CALL gstxci(2)
      CALL gsplci(2)
      CALL ezxy(time,adjust,NN+1,'                ADJUST ')
      CALL gstxci(1)
      CALL gsplci(1)
      CALL ezxy(time,topt_mean,NN+1,'TOPT MEAN ')

      CALL frame

      return
      end

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      SUBROUTINE histo1(NN,Ms,topt_bin,tempplt)
      
REAL*4, DIMENSION(0:NN,0:Ms) :: topt_bin,topt_bin2
REAL*4, DIMENSION(0:NN)      :: tempplt,adjust

real cpmin, cpmax, clevel
integer nclevels
common / cfix / cpmin, cpmax, nclevels
logical colour, tallflg, mapflag
integer lcflag, ncontr
common / cpflg / colour, tallflg, lcflag, ncontr, mapflag

 cpmin=   0.0
 cpmax=   6.4
nclevels=8 ! number of colours (< 17)
lcflag=4
tallflg=.true.

DO it=0,NN
  adjust(it)=max(15.+5.0*(1.-exp(-(float(it-360)/(1.2*360.)))),15.0)
ENDDO

topt_bin2=topt_bin
DO it=0,NN
DO k=0,Ms
  IF(topt_bin2(it,k).lt.0.8) topt_bin2(it,k)=1.e20
ENDDO
ENDDO

CALL set(0.1,0.9,0.1,0.9,0.0,float(NN),0.0,float(Ms),1)
CALL frstpt(      0.0,      0.0)
CALL vector(      0.0,float(Ms))
CALL vector(float(NN),float(Ms))
CALL vector(float(NN),      0.0)
CALL vector(      0.0,      0.0)
CALL colplot(topt_bin2,topt_bin2,NN+1,NN+1,Ms+1,0.0,0,0.0,1)
!CALL frame
DO k=0,NN,360
 CALL frstpt(float(k),0.0)
 CALL vector(float(k),0.01*float(Ms))
 CALL frstpt(float(k),0.99*float(Ms))
 CALL vector(float(k),1.00*float(Ms))
ENDDO
DO k=5,Ms,10
 CALL frstpt(0.0,            float(k))
 CALL vector(0.01*float(NN), float(k))
 CALL frstpt(0.99*float(NN), float(k))
 CALL vector(1.00*float(NN), float(k))
ENDDO

! plot temperature
CALL frstpt( float(0),10.*(tempplt(0)-7.5))
DO i=1,NN
 CALL vector(float(i),10.*(tempplt(i)-7.5))
ENDDO
! CALL frstpt(      0.0,      0.0)
! CALL vector(      0.0,float(Ms))
! CALL vector(float(NN),float(Ms))
! CALL vector(float(NN),      0.0)
! CALL vector(      0.0,      0.0)

! CALL frstpt(float( 0),10.*(20.0-5.0))
! CALL vector(float(NN),10.*(20.0-5.0))
! CALL frstpt(float( 0),10.*(10.0-5.0))
! CALL vector(float(NN),10.*(10.0-5.0))

! plot adjust
CALL frstpt( float(0),10.*(adjust(0)-7.5))
DO i=1,NN
 CALL vector(float(i),10.*(adjust(i)-7.5))
ENDDO
CALL frame

CALL cpseti('MAP',1)

CALL set(0.1,0.9,0.1,0.9,0.0,float(NN),0.0,float(Ms),1)
CALL frstpt(      0.0,      0.0)
CALL vector(      0.0,float(Ms))
CALL vector(float(NN),float(Ms))
CALL vector(float(NN),      0.0)
CALL vector(      0.0,      0.0)
CALL colplot(topt_bin2,topt_bin2,NN+1,NN+1,Ms+1,0.0,0,0.0,1)

! plot temperature
! CALL frstpt(      0.0,      0.0)
! CALL vector(      0.0,float(Ms))
! CALL vector(float(NN),float(Ms))
! CALL vector(float(NN),      0.0)
! CALL vector(      0.0,      0.0)
CALL frstpt( float(0),10.*(tempplt(0)-7.5))
DO i=1,NN
 CALL vector(float(i),10.*(tempplt(i)-7.5))
ENDDO

! plot adjust
CALL frstpt( float(0),10.*(adjust(0)-7.5))
DO i=1,NN
 CALL vector(float(i),10.*(adjust(i)-7.5))
ENDDO

CALL frame

      RETURN
      END

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      SUBROUTINE histo2(NN,Ms,topt_bin)
      
REAL*4, DIMENSION(0:NN,0:Ms) :: topt_bin
REAL*4, DIMENSION(0:Ms)      :: gaussian
REAL*4                       :: ave,stdev
CHARACTER*10                 :: string

ampli=MAXVAL(topt_bin)
print *, ampli
ampli=10.*nint(0.1*ampli)
print *, ampli

ave=0.0
DO k=0,Ms
 ave=ave+topt_bin(it,k)*(float(k)+0.5)
ENDDO
ave=ave/SUM(topt_bin(NN,:))

stdev=0.0
DO k=0,Ms
 stdev=stdev+topt_bin(NN,k)*(float(k)-ave)**2
ENDDO
 stdev=sqrt(stdev/SUM(topt_bin(NN,:)))*sqrt(2.)/10. 

print *, 'fitted width',stdev, 'mean', 5.0+ave/10.

DO k=0,Ms
  gaussian(k)=exp(-(20.d0/float(Ms)*float(k)-10.d0)**2/stdev**2)
ENDDO

DO it=0,NN
      
ave=0.0
DO k=0,Ms
 ave=ave+topt_bin(it,k)*(float(k)+0.5)
ENDDO
ave=ave/SUM(topt_bin(it,:))

stdev=0.0
DO k=0,Ms
 stdev=stdev+topt_bin(it,k)*(float(k)-ave)**2
ENDDO
 stdev=sqrt(stdev/SUM(topt_bin(it,:)))*sqrt(2.)/10. 

print *, it, 'fitted width',stdev, 'mean', 5.0+ave/10., ave

DO k=0,Ms
  gaussian(k)=MAXVAL(topt_bin(it,:))/ampli*exp(-(15.d0/float(Ms)*float(k)-0.1*ave)**2/stdev**2)
ENDDO

CALL set(0.0,1.0,0.0,1.0,0.0,1.0,0.0,1.0,1)

  DO k=0,Ms
    CALL frstpt(0.005+0.99/float(Ms+1)*float(k  ),0.1+                     0.0)
    CALL vector(0.005+0.99/float(Ms+1)*float(k  ),0.1+0.8*topt_bin(it,k)/ampli)
    CALL vector(0.005+0.99/float(Ms+1)*float(k+1),0.1+0.8*topt_bin(it,k)/ampli)
    CALL vector(0.005+0.99/float(Ms+1)*float(k+1),0.1+                     0.0)
  ENDDO
    CALL frstpt(0.005,0.1)
    CALL vector(0.005,0.9)
    CALL vector(0.995,0.9)
    CALL vector(0.995,0.1)
    CALL vector(0.005,0.1)

DO k=0,10
 CALL frstpt(0.005,0.1+0.08*float(k))
 CALL vector(0.015,0.1+0.08*float(k))
 CALL frstpt(0.985,0.1+0.08*float(k))
 CALL vector(0.995,0.1+0.08*float(k))
ENDDO
DO k=5,Ms,10
 CALL frstpt(0.005+0.99*float(k)/float(Ms),0.10)
 CALL vector(0.005+0.99*float(k)/float(Ms),0.11)
 CALL frstpt(0.005+0.99*float(k)/float(Ms),0.89)
 CALL vector(0.005+0.99*float(k)/float(Ms),0.90)
ENDDO

CALL frstpt(  0.005+0.99/float(Ms+1)*float(0),0.1+0.8*gaussian(0))
DO k=1,Ms
  CALL vector(0.005+0.99/float(Ms+1)*float(k),0.1+0.8*gaussian(k))
ENDDO

write(string,'(f10.3)') ampli
CALL plchhq(0.5,0.95,string,10.0,0.0,10.)

   CALL frame
      
ENDDO
print *, it, 'fitted width',stdev, 'mean', 5.0+ave/10., ave

RETURN
END

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      SUBROUTINE histo3(NN,Ms,topt_bin,dama_bin)
      
REAL*4, DIMENSION(0:NN,0:Ms) :: topt_bin,dama_bin

CALL gscr(1,0,1.,1.,1.)
CALL gscr(1,1,0.,0.,0.) ! black
CALL gscr(1,2,0.,0.,1.) ! blue
CALL gscr(1,3,1.,0.,0.) ! red
CALL gscr(1,4,1.,0.,1.) ! magenta
CALL gscr(1,5,1.,1.,0.)
CALL gscr(1,6,0.,1.,1.)
CALL gscr(1,7,0.,1.,0.) ! green

ampli1=MAXVAL(topt_bin)
ampli2=MAXVAL(dama_bin)

DO it=0,NN
      
CALL set(0.0,1.0,0.0,1.0,0.0,1.0,0.0,1.0,1)

  DO k=0,Ms
    CALL frstpt(0.005+0.99/float(Ms+1)*float(k  ),0.1+                      0.0)
    CALL vector(0.005+0.99/float(Ms+1)*float(k  ),0.1+0.8*topt_bin(it,k)/ampli1)
    CALL vector(0.005+0.99/float(Ms+1)*float(k+1),0.1+0.8*topt_bin(it,k)/ampli1)
    CALL vector(0.005+0.99/float(Ms+1)*float(k+1),0.1+                      0.0)
  ENDDO
    CALL SFLUSH
  CALL GSPLCI(3)
  DO k=0,Ms
    CALL frstpt(0.005+0.99/float(Ms+1)*float(k  ),0.1+                      0.0)
    CALL vector(0.005+0.99/float(Ms+1)*float(k  ),0.1+0.8*dama_bin(it,k)/ampli2)
    CALL vector(0.005+0.99/float(Ms+1)*float(k+1),0.1+0.8*dama_bin(it,k)/ampli2)
    CALL vector(0.005+0.99/float(Ms+1)*float(k+1),0.1+                      0.0)
  ENDDO
    CALL SFLUSH
  CALL GSPLCI(1)
    CALL frstpt(0.005,0.1)
    CALL vector(0.005,0.9)
    CALL vector(0.995,0.9)
    CALL vector(0.995,0.1)
    CALL vector(0.005,0.1)
CALL frame
      
ENDDO

RETURN
END
SUBROUTINE cpmpxy(imap,x,y,fx,fy)

INTEGER, PARAMETER :: NN=1801

common /coord/ generation

REAL*4,DIMENSION(1801) :: generation

!  fx=float(NN-int(x))
!  fx=float(NN)*(x/float(NN))**2

  fx=(generation(int(x)-1)*(1.-(x-int(x)))+ &
      generation(int(x)  )*(    x-int(x)) )/(generation(NN))*float(NN)
  fy=y

RETURN
END
