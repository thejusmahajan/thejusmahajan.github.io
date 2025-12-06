
MODULE wcm_arrays

IMPLICIT NONE

INTEGER :: nyears

! Namelist variables
REAL*8 :: aorg_init, phyt_init, mu_max_day, kn, mutation_width
REAL*8 :: mortality, w_mig, w_sink, tau_trans, tslope_cold, tslope_hot
LOGICAL :: use_akinetes



! state variables
REAL*8  :: temp    ! temperature

REAL*8    :: zt,       & ! depth of level center
                              zw,       & ! depth of level bottom
                              dens,     & ! density
                              av,       & ! vertical mixing coefficient
                              swrad,    & ! short wave radiation in the water column
                              heat,     & ! solar heating
                              rmatl,    & ! maxtrix lower diagonal
                              rmatd,    & ! maxtrix diagonal
                              rmatu,    & ! maxtrix upper diagonal
                              orgsum      ! total organic material

REAL*8 , PARAMETER :: secyear = 360.d0*86400.d0, & ! seconds per year
                      secmonth= 30.d0*86400.d0,  & ! seconds per month
                      secday  = 86400.d0,        & ! seconds per day
                      par     =  0.43d0,         & ! photosynthetic available fraction of radiation
                      rhocp   =  4186000.d0,     & ! rho*cp
                      rkw     =  0.08d0,         & ! attenuation coefficient for water
                      rkc     =  0.07d0            ! attenuation coefficient for organic material

REAL*8 :: dt,       & ! time step
          dtodzdz,  & ! time step per grid spacing squared
          endtime,  & ! integration period
          time,     & ! running time
          ampm,     & ! temperature amplitude
          ampt,     & ! temperature amplitude
          ampt0,    & ! temperature amplitude
          ampt1,    & ! temperature amplitude
          theta,    & ! seasonal cycle length
          theta0,   & ! seasonal cycle length
          theta1,   & ! seasonal cycle length
          dcold ,   & ! seasonal cycle phase
          dcold0,   & ! seasonal cycle phase
          dcold1,   & ! seasonal cycle phase
          timel,    & ! shifted time
          atime,    & ! inverted time
          solrad,   & ! solar radiation
          globalt,  & ! sum of temperature
          tauw,     & ! wind stress mixing depth
          topt,     & ! 
          factor,   & ! 
          delta,    & ! 
          pi          ! pi

INTEGER :: k,       & ! vertical index
           ktmp,    & ! vertical index
           kwind,   & ! vertical index1.d0
           kmix,    & ! vertical index
           iday,    & ! time index
           imonth,  & ! time index 
           iyear,   & ! time index 
           itmax,   & ! number of time steps
           lold,    & ! time level
           lnew,    & ! time level
           it         ! time loop

! state variables
REAL*8, DIMENSION(2)   :: aorg    ! anorganic nutrient

REAL*8   :: trend,    & ! trend
            aorgpos     ! pos. val of aorg
REAL*8 :: globalp,  & ! sum of temperature
          globaln ! sum of aorg

! state variables
REAL*8, DIMENSION(2)   :: detr    ! anorganic nutrient

REAL*8     :: detrpos, &   ! pos. val of aorg
                              sinkw,   &   ! pos. val of aorg
                              remin


! state variables
REAL*8, DIMENSION(2)   :: phyt    ! anorganic nutrient

REAL*8     :: puptake, & !
                              ploss,   & !
                              phytpos    ! pos. val of aorg

REAL*8 :: sigman,  & !
          sigmai     !

INTEGER, PARAMETER         :: M=2000, M2=10000, Ms=200, M0=M


INTEGER, ALLOCATABLE, DIMENSION(:) :: iliv, &   ! living cell indicator
                              igen      ! generation
                             
REAL*8     :: templim, & ! temperature limitation
                              agents     ! number of agents
INTEGER  :: nbr,nbr0        ! number of agents

REAL*8, ALLOCATABLE, DIMENSION(:) :: phybio, &      ! cell biomass
                              phyopt         ! damage level
 
REAL*8, PARAMETER          :: cpa = 1.d10/float(M),       & ! number of cells per agent
                              biopercell = 0.5d-9           ! average cell biomass [mmol N]

INTEGER                    :: M2max, i, ij, inew, icnt , ksex
REAL*8                     :: growth, dissolve,dissolve0,growthfact

REAL*8                     :: avgtemp,avgphyt,avgdetr,avgaorg,test,growthmean,growthmean0,dist

INTEGER, DIMENSION(0:Ms)   :: nbr_cls
REAL*8, DIMENSION(0:Ms,2)  :: strain
REAL*8, DIMENSION(0:Ms)    :: strainpos,sloss,suptake
END MODULE wcm_arrays
