C VERSION  WITH  SUPPLEMENT SPHERICAL HARMONIC COEFFICIENTS OF THE 1995
C REVISION OF THE INTERNATIONAL GEOMAGNETIC REFERENCE  FIELD
C DATE: 16.6.1998
c    Calculation a trajectory of particle by program EX89KP
c    for years from 1965 to 1994 e.g.<1965,1994>
c Output data are: "end point" of trajectory in spherical coordinates
c            or  asymptotic coordinates
c            or  all points of trajectory in spherical coordinates.
c 26.04.2000 + oblikly direction + calculation with atmosph. influence

       character*40 infil,outfil,tragsm,trasfer

       DOUBLE PRECISION rig

       FNX(y,z)=d*(y*bz-z*by)
       FNY(x,z)=d*(z*bx-x*bz)
       FNZ(x,y)=d*(x*by-y*bx)

 4     format(a)
       open(4,file='infil',STATUS='OLD')
       open(5,file='outfil',STATUS='NEW')
c       open(6,file='tragsm')
c       open(7,file='trasfer')

c  Input data: rig is starting value of rigidity in GV
c             zn is number of elementary charges of a particle
c             rk is ending value of rigidity, which stops calculation
131    continue 
       write(5,118)rmi,rmx,rms
 9     READ(4,100)rig,zn,rk
       WRITE(5,100)rig,zn,rk
       IF(rig.lt.0.)go to 16
cc     cccccccccc
       nza=0
       nmi=0
       rmi=0.0
       rni=rig

       alength=0
       time=0
       atm=0
       sumaaion=0

c   Using constants
       pi=3.141592654
       rad=pi/180.
       q=1.6021e-19
       c=2.99725e+08
       hm0=1.6725e-27
       Re=6.3712e+06
       nr=1

c      Pridan� pre integr�l po��taj�ci "pozbieran� atmosf�ru"
       rrp=Re

c  Input data: spherical coordinates of starting point
c             year,month,day,day(in year),time
c             starting step,iopt,ist=1

c      Nacitanie " unikoveho bodu"
       READ(4,101)r0,the0,fi0

c      Nacitanie asymptotickeho smeru
       READ(4,107)the1,fi1
       WRITE(5,107)the1,fi1
       READ(4,116)iy,mes,ide,id,ih,min,is
       WRITE(5,116)iy,mes,ide,id,ih,min,is
       READ(4,102)nk1,iopt,ist
       WRITE(5,102)nk1,iopt,ist
       READ(4,203)idst,pdyni,byim,bzim
       WRITE(5,203)idst,pdyni,byim,bzim
c       WRITE(5,*)idst,pdyni,byim,bzim
c  Writing input data in intorduction output file
       WRITE(5,111)the0,fi0,r0,the1,fi1,iy,mes,ide,ih,min,is
       WRITE(5,113)rig
       WRITE(5,114)
       WRITE(5,112)
       WRITE(5,204)

        CALL RECALC(iy,id,ih,mim,is)

c       write(*,*)rig

  5    a=rig*1.0e+09*zn*q/(hm0*c*c)
       v=c*sqrt(1.-1./(1.+a*a))
       nk0=nk1
       r=r0
       td=90.-the0
       td1=90.-the1
       fei=fi0
       fei1=fi1
       th=td*rad
       th1=td1*rad
       f=fei*rad
       f1=fei1*rad
       rr=r*Re
       jj=0

       alength=0
       time=0
       atm=0
       sumaaion=0


c       write(*,*)f,f1

        CALL SPHCAR(rr,th,f,x,y,z,1)
        CALL GEOGSM(x,y,z,xs,ys,zs,1)
       xx=xs/Re
       yy=ys/Re
       zz=zs/Re

c       pdyni = 2
c       idst = 20
c       byim = 2
c       bzim = 2

       CALL BTOT(xx,yy,zz,pdyni,idst,byim,bzim,iopt,bxs,bys,bzs,ist)
       CALL GEOGSM(bx,by,bz,bxs,bys,bzs,-1)

       d=1.e-09*zn*q/hm0

       b=1.e-09*sqrt(bx*bx+by*by+bz*bz)

       vx=v*sin(th1)*cos(f1)
       vy=v*sin(th1)*sin(f1)
       vz=v*cos(th1)
       vv=v

  3    nk=nk0

c Sumation for total number of steps of a trajetory
       jj=jj+1

c  Remembering preceded data of coordinates and velocity
       xp=x
       yp=y
       zp=z
       vxp=vx
       vyp=vy
       vzp=vz
       tdp=td
       feip=fei
       rp=r

       vc=vv/c
       IF(vc.gt.1) go to 11
       hm=hm0/sqrt(1.-vc*vc)
       t=2.*pi*hm/(ABS(zn)*q*b)
       d=1.e-09*zn*q/hm
       v=vv
  1    h=t/nk

c Code of RUNGE -KUTTA of 6-th order
       a1=h*FNX(vy,vz)
       b1=h*FNY(vx,vz)
       c1=h*FNZ(vx,vy)
       a2=h*FNX(vy+b1/3.,vz+c1/3.)
       b2=h*FNY(vx+a1/3.,vz+c1/3.)
       c2=h*FNZ(vx+a1/3.,vy+b1/3.)
       a3=h*FNX(vy+(4.*b1+6.*b2)/25.,vz+(4.*c1+6.*c2)/25.)
       b3=h*FNY(vx+(4.*a1+6.*a2)/25.,vz+(4.*c1+6.*c2)/25.)
       c3=h*FNZ(vx+(4.*a1+6.*a2)/25.,vy+(4.*b1+6.*b2)/25.)
       a4=h*FNX(vy+(b1-12.*b2+15.*b3)/4.,vz+(c1-12.*c2+15.*c3)/4.)
       b4=h*FNY(vx+(a1-12.*a2+15.*a3)/4.,vz+(c1-12.*c2+15.*c3)/4.)
       c4=h*FNZ(vx+(a1-12.*a2+15.*a3)/4.,vy+(b1-12.*b2+15.*b3)/4.)
       a5=h*FNX(vy+(6.*b1+90.*b2-50.*b3+8.*b4)/81.,
     / vz+(6.*c1+90.*c2-50.*c3+8.*c4)/81.)
       b5=h*FNY(vx+(6.*a1+90.*a2-50.*a3+8.*a4)/81.,
     / vz+(6.*c1+90.*c2-50.*c3+8.*c4)/81.)
       c5=h*FNZ(vx+(6.*a1+90.*a2-50.*a3+8.*a4)/81.,
     / vy+(6.*b1+90.*b2-50.*b3+8.*b4)/81.)
       a6=h*FNX(vy+(6.*b1+36.*b2+10.*b3+8.*b4)/75.,
     / vz+(6.*c1+36.*c2+10.*c3+8.*c4)/75.)
       b6=h*FNY(vx+(6.*a1+36.*a2+10.*a3+8.*a4)/75.,
     / vz+(6.*c1+36.*c2+10.*c3+8.*c4)/75.)
       c6=h*FNZ(vx+(6.*a1+36.*a2+10.*a3+8.*a4)/75.,
     / vy+(6.*b1+36.*b2+10.*b3+8.*b4)/75.)
       aa1=h*vx
       bb1=h*vy
       cc1=h*vz
       aa2=h*(vx+aa1/3.)
       bb2=h*(vy+bb1/3.)
       cc2=h*(vz+cc1/3.)
       aa3=h*(vx+(4.*aa1+6.*aa2)/25.)
       bb3=h*(vy+(4.*bb1+6.*bb2)/25.)
       cc3=h*(vz+(4.*cc1+6.*cc2)/25.)
       aa4=h*(vx+(aa1-12.*aa2+15.*aa3)/4.)
       bb4=h*(vy+(bb1-12.*bb2+15.*bb3)/4.)
       cc4=h*(vz+(cc1-12.*cc2+15.*cc3)/4.)
       aa5=h*(vx+(6.*aa1+90.*aa2-50.*aa3+8.*aa4)/81.)
       bb5=h*(vy+(6.*bb1+90.*bb2-50.*bb3+8.*bb4)/81.)
       cc5=h*(vz+(6.*cc1+90.*cc2-50.*cc3+8.*cc4)/81.)
       aa6=h*(vx+(6.*aa1+36.*aa2+10.*aa3+8.*aa4)/75.)
       bb6=h*(vy+(6.*bb1+36.*bb2+10.*bb3+8.*bb4)/75.)
       cc6=h*(vz+(6.*cc1+36.*cc2+10.*cc3+8.*cc4)/75.)
       vx=vx+(23.*a1+125.*a3-81.*a5+125.*a6)/192.
       vy=vy+(23.*b1+125.*b3-81.*b5+125.*b6)/192.
       vz=vz+(23.*c1+125.*c3-81.*c5+125.*c6)/192.
       x=x+(23.*aa1+125.*aa3-81.*aa5+125.*aa6)/192.
       y=y+(23.*bb1+125.*bb3-81.*bb5+125.*bb6)/192.
       z=z+(23.*cc1+125.*cc3-81.*cc5+125.*cc6)/192.
       vv=sqrt(vx*vx+vy*vy+vz*vz)

c  Testing deviation of velocity
c       rv=abs(vv-v)/v

c  Testing of angle between a velocity and next velocity
       gc=(vx*vxp+vy*vyp+vz*vzp)/(vv*v)
       IF(gc.gt.1.0) go to 2
       gs=sqrt((1.-gc)*(1.+gc))
       gu=atan2(gs,gc)
       go to 8
  2    go to 6

  8    continue

c Regulation of length of step (by testing of angle of velocities)
       tu=0.01
       IF(gu.lt.tu) go to 6
       IF(nk0.gt.50000) go to 6
       nk0=nk0*2
       go to 7

  6    continue

        CALL SPHCAR(rr,th,f,x,y,z,-1)



c Equation of magnetosphere
        CALL GEOGSM(x,y,z,xsp,ysp,zsp,1)
       pax=(xsp/Re+25.3)/36.08
       paz=(ysp*ysp+zsp*zsp)/(Re*Re)
       paus=pax*pax+paz/459.6736
       r=rr/Re
       teh=th/rad
       fei=f/rad
       td=90.-teh

       IF(r.GE.25.) go to 10
       IF(paus.GE.1.) go to 13
       IF(r.LT.1.) go to 11
       IF(f.GE.31.4) go to 12

        CALL GEOGSM(x,y,z,xs,ys,zs,1)
       xx=xs/Re
       yy=ys/Re
       zz=zs/Re

        CALL BTOT(xx,yy,zz,pdyni,idst,byim,bzim,iopt,bxs,bys,bzs,ist)
        CALL GEOGSM(bx,by,bz,bxs,bys,bzs,-1)

       b=1.e-09*sqrt(bx*bx+by*by+bz*bz)

c Limity of total number of steps
        IF(jj.gt.25000) go to 12

c  Writing all points of a trajectory in spherical coordinates
c        write(5,110)rig,td,fei,r

       nk0=nk1

       time=time+(t/nk)
       a1length=sqrt((x-xp)*(x-xp)+(y-yp)*(y-yp)+(z-zp)*(z-zp))
       alength=alength+a1length

c       if ((rig.gt.3.0059).and.(rig.lt.3.0061)) write(6,201)jj,xs,
c     *ys,zs,vv,time,alength
c       if ((rig.gt.3.0059).and.(rig.lt.3.0061)) write(7,202)jj,r,
c     *td,fei,vv,time,alength


       rr=sqrt((x*x)+(y*y)+(z*z))
       rrp=sqrt((xp*xp)+(yp*yp)+(zp*zp))

       satm=a1length
       satm1=rrp

       alfa=(x-xp)/satm
       beta=(y-yp)/satm
       gama=(z-zp)/satm

       alfa1=xp/satm1
       beta1=yp/satm1
       gama1=zp/satm1

       omega=(alfa*alfa1+beta*beta1+gama*gama1)

c     Zistovanie pozbieranej zvyskovej atmosfery
      x1=(rrp-Re)/1000
      x2=(rr-Re)/1000
      if ((x1.lt.200).and.(x2.lt.200)) ro=(1000/abs(omega))*abs
     *(1.24758*8.60995*(exp(-x1/8.609)-exp(-x2/8.609)))
      if ((x1.ge.200).and.(x2.ge.200)) ro=(1000/abs(omega))*abs
     *(2.9561e-10*48.99094*(exp(-(x1-216.3)/48.99094)-exp(-(x2-216.3)
     */48.99094)))
      if ((x2.ge.200).and.(x1.le.200)) ro=(1000/abs(omega))*(abs
     *(1.24758*8.60995*(exp(-200/8.609)-exp(-x1/8.609)))+abs
     *(2.9561e-10*(exp(-(200-216.3)/48.99094)-exp(-(x1-216.3)
     */48.99094))))

      ro=ro/10

c      write(*,*)ro,abs(x1-x2),a1length,atm
      atm=atm+ro


c     Vypocet stratenej energie
c       aiond v [eV*cm^2/g]
        aiond=0.3070e6
        aionzmed=1
c       aionromed v g/cm^2
        aionromed=ro/a1length
        aionamed=1

        aionbeta=vv/c

        aion=(aiond*aionzmed*aionromed)/aionamed
        aion=aion*(1./aionbeta)*(1./aionbeta)
        aionarg=0.511e6*2*vv*vv/(1-((vv*vv)/(c*c)))
        aionI=16*(aionzmed)**0.9
        aion=aion*((alog(aionarg/aionI))-(aionbeta*aionbeta))

c       Toto ????
        aion=aion*a1length
c       ?????

        sumaaion=sumaaion+aion
c        write(*,*)aion,sumaaion

c     koniec vypoctu stratenej energie


c     Zapametanie si predchadzajucej hodnoty rr pre vypocet atmosfery
c     ktorou castica presla
      rrp=rr


       go to 3

c    Regulation of length of step
c  in order to "end point" must be on magnetosphere
 13    IF(abs(paus-1.).lt.0.002) go to 15
       nk0=nk0*2
       go to 7

 11    continue

c  Calculations for Cutoff's rigidities
c  nza  is number of forbiden rigidities
c  rmx is last forbiden rigidity
               nza=nza+1
               rmx1=rig

        go to 505
 12    continue

               nza=nza+1
               rmx2=rig

         go to 505

c    Regulation of length of step
c  in order to "end point" must be on sphere with r=25Re
 10    IF(abs(r-25.).lt.0.002)go to 15
       nk0=nk0*2
  7    x=xp
       y=yp
       z=zp
       vx=vxp
       vy=vyp
       vz=vzp
        CALL SPHCAR(rr,th,f,x,y,z,-1)
        CALL GEOGSM(x,y,z,xs,ys,zs,1)
       xx=xs/Re
       yy=ys/Re
       zz=zs/Re
       jj=jj-1

        CALL BTOT(xx,yy,zz,pdyni,idst,byim,bzim,iopt,bxs,bys,bzs,ist)
        CALL GEOGSM(bx,by,bz,bxs,bys,bzs,-1)

       b=1.e-09*sqrt(bx*bx+by*by+bz*bz)
       go to 3

 15    continue
c  Writing "end point" of trajectory(needed only for writing trajectory)
c        write(5,110)rig,td,fei,r

c  Calculations for Cutoff's rigidities
c  rmi is the smallest allowed rigidity
           nmi=nmi+1
           IF(nmi.gt.1) go to 61
           rmi=rig

 61    continue

c Calculation of asymptotic coordinates
         CALL CARBSP(th,f,vx,vy,vz,vr,vt,vf)
         CALL ASYMP(th,f,vr,vt,vf,at,af)
          ast=at/rad
          asf=af/rad
           IF(asf.gt.360.) asf=asf-360.

c Writing "end point" of trajectory in spherical coordinates
c       WRITE(5,110)rig,td,fei,r
c       write(6,110)rig,td,fei,r
c Writing asymptotic coordinates
c       WRITE(5,110)rig,ast,asf,r
c      write(5,200)rig,r,ast,asf,vv,time,alength
      write(5,200)rig,vv/c,r,td,fei,ast,asf,time,alength/1000.0

      alength=0
      time=0
      atm=0
      sumaaion=0



c      write(6,110)rig,ast,asf,r

 505   continue

c Writing total number of step (needed only for writing of trajectory)
c       WRITE(5,117)jj

c Change of rigidity by multiplication by 1.1
c        IF(nr.ge.2)go to 16
c        nr=nr+1
c        rig=rig*1.1
c        IF(rig.gt.20.0) go to 9

c Change of rigidity by adition 0.001 GV if rig<=4.1 GV for Lomnicky S.
c                         resp. 0.01 GV if rig<=4.5 GV for Lomnicky S.
c                         resp. 0.1 GV if rig<=10 GV for Lomnicky Stit
c        IF(rig.gt.7.91)go to 52
        IF(rig.gt.27.91)go to 52
c        IF(rig.gt.6.491)go to 50
        IF(rig.gt.26.491)go to 50
c        IF(rig.gt.5.0991)go to 53
        IF(rig.gt.25.0991)go to 53
         rig=rig+0.01000000
        go to 51
  53    rig=rig+0.01000000
        go to 51
  50    rig=rig+0.1000000
        go to 51
  52    rig=rig+1.000000
  51    continue

c        write(*,*)rig

c        IF(rig.gt.(rk+1)) go to 70
c        Zmenene pri prepoctoch atmosfery
         IF(rig.gt.(rk)) go to 70
c        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



c Reading rigidities from input file while last date <0.0
c       READ(4,115)rig
c       IF(rig.LT.0.)go to 16

       GO TO 5

 70     continue
c Calculation of Cutoff's rigidities
        rmx=amax1(rmx1,rmx2)
        zan=float(nza)-(rmi-rni)/0.010
        rms=rmi+zan*0.010

c       nove
        rmx = rmx + 0.01
      

         WRITE(5,118)rmi,rmx,rms
         go to 131
         
 16    continue

c     Formats
 100   FORMAT(f9.5,f4.0,f9.5)
c 101   FORMAT(f10.6,1x,f8.4,1x,f8.4)
 101   FORMAT(f10.6,f9.4,f9.4)
 102   FORMAT(i6,2i4)
 107   FORMAT(11x,f8.4,1x,f8.4)
 110   FORMAT(f9.5,2f10.3,f9.3)
 111   FORMAT(///38H                ASYMPTOTIC COORDINATES/
     / 44H   calculated by model of exter.field T96   ,/
     / 27H Station with geo.latitude:,f9.3,14H  & longitude:,f9.3,
     / 12H & radius : ,f8.5/
     / 40H Direction of trajectory with latitude: ,f9.3, 
     / 14H & longitude: ,f9.3/
     / 7H Datum:,i5,2i3,7H  time:,i3,4H hod,i3,4H min,i3,4H sec)
 112   FORMAT()
 113   FORMAT(21H Starting rigidity : ,f8.4,3H GV,13H Epsilon=0.01)
 114   FORMAT(40H Limit of total number of steps : 25000 )
 115   FORMAT(f9.5)
 116   FORMAT(i5,2i3,i4,3i3)
 117   FORMAT(//2x,45HTotal number of steps using for trajectory N=,i6)
 118   FORMAT(2x,39HCUTOFF s rigidities P(S),P(C),P(M) are:,/3f12.5/)
c 200   FORMAT(f8.4,2f10.6,2f10.5,f14.2,f15.10,f18.2)
 200   FORMAT(f10.6,f15.10,f12.6,4f10.3,f12.6,f16.2)
 201   FORMAT(i6,3f17.5,f14.2,f15.10,f18.2)
 202   FORMAT(i6,3f17.5,f14.2,f15.10,f18.2)
 203   FORMAT(i5,3f7.2)
 204   FORMAT(54H rig : v : rad : eth : efi : ath : afi : time : length)

       

       close(4)
       close(5)
c       close(6)
c       close(7)
       stop
       end

c************************************************************************
       SUBROUTINE CARBSP(th,f,bx,by,bz,br,bt,bf)
c Transfer for magnetic field from kartezian to spherical coordinates

         s=sin(th)
         c=cos(th)
         sf=sin(f)
         cf=cos(f)
         be=bx*cf+by*sf
         br=be*s+bz*c
         bf=-bx*sf+by*cf
         bt=be*c-bz*s

         return
         end

c************************************************************************
       SUBROUTINE ASYMP(th,f,vr,vt,vf,at,af)
c Calculation of asymptotic coordinates

        ct=cos(th)
        st=sin(th)
        va=vt*ct+vr*st
        dp=-vt*st+vr*ct
        dm=sqrt(vt*vt+va*va)
        at=atan2(dp,dm)
        af=f+atan2(vf,va)

        return
        end

c************************************************************************

        SUBROUTINE BTOT(X,Y,Z,PDYNI,IDST,BYIM,BZIM,IOPT,BX,BY,BZ,count)
c Peredo's program for total geomagnetic field

      INTEGER IY,K,count,i,iopt,IHARM

      REAL ST0,CT0,SL0,CL0,CTCL,STCL,CTSL,STSL,SFI,CFI,SPS,CPS,
     1   SHI,CHI,HI,PSI,XMUT,A11,A21,A31,A12,A22,A32,A13,A23,A33,
     2   DS3,X,Y,Z,BX,BY,
     3   BZ,BXEXT,BYEXT,BZEXT,XGEO,YGEO,ZGEO,R,T,F,FX,FY,
     4   FZ,BXINT,BYINT,BZINT,BR,BF,BT,BA(8),HX,HY,HZ
      
       REAL PARMOD(10)

       COMMON/C1/ ST0,CT0,SL0,CL0,CTCL,STCL,CTSL,STSL,SFI,CFI,SPS,CPS,
     * SHI,CHI,HI,PSI,XMUT,A11,A21,A31,A12,A22,A32,A13,A23,A33,DS3,
     * K,IY,BA


c  (1) SOLAR WIND PRESSURE PDYN (NANOPASCALS)
      PARMOD(1) = PDYNI
c  (2) DST (NANOTESLA)      
      PARMOD(2) = IDST
c  (3) BYIMF, AND (4) BZIMF (NANOTESLA).      
      PARMOD(3) = BYIM     
      PARMOD(4) = BZIM            


C       Compute external field
        CALL T96_01 (IOPT,PARMOD,PS,X,Y,Z,BXEXT,BYEXT,BZEXT)
C
           
        CALL IGRF_GSM (X,Y,Z,HX,HY,HZ)         
         

C
C       Sum up internal and external contributions
C
c Vynulovanie Bext, t.j. len IGRF pole
c             BXEXT=0.
c             BYEXT=0.
c             BZEXT=0.

           BX = HX + BXEXT
           BY = HY + BYEXT
           BZ = HZ + BZEXT


 100    continue
c         write(*,*)HX,HY,HZ
c         write(*,*)BX,BY,BZ

        return
        END
c-------------------------------------------------------------------------








C----------------------------------------------------------------------
c
      SUBROUTINE T96_01 (IOPT,PARMOD,PS,X,Y,Z,BX,BY,BZ)
C
c     RELEASE DATE OF THIS VERSION:   JUNE 22, 1996.

C----------------------------------------------------------------------
C
C  WITH TWO CORRECTIONS, SUGGESTED BY T.SOTIRELIS' COMMENTS (APR.7, 1997)
C
C  (1) A "STRAY "  CLOSING PARENTHESIS WAS REMOVED IN THE S/R   R2_BIRK
C  (2) A 0/0 PROBLEM ON THE Z-AXIS WAS SIDESTEPPED (LINES 44-46 OF THE
c       DOUBLE PRECISION FUNCTION XKSI)
c--------------------------------------------------------------------
C DATA-BASED MODEL CALIBRATED BY (1) SOLAR WIND PRESSURE PDYN (NANOPASCALS),
C           (2) DST (NANOTESLA),  (3) BYIMF, AND (4) BZIMF (NANOTESLA).
c THESE INPUT PARAMETERS SHOULD BE PLACED IN THE FIRST 4 ELEMENTS
c OF THE ARRAY PARMOD(10).
C
C   THE REST OF THE INPUT VARIABLES ARE: THE GEODIPOLE TILT ANGLE PS (RADIANS),
C AND   X,Y,Z -  GSM POSITION (RE)
C
c   IOPT  IS JUST A DUMMY INPUT PARAMETER, NECESSARY TO MAKE THIS SUBROUTINE
C COMPATIBLE WITH THE NEW RELEASE (APRIL 1996) OF THE TRACING SOFTWARE
C PACKAGE (GEOPACK). IOPT VALUE DOES NOT AFFECT THE OUTPUT FIELD.
c
C
c OUTPUT:  GSM COMPONENTS OF THE EXTERNAL MAGNETIC FIELD (BX,BY,BZ, nanotesla)
C            COMPUTED AS A SUM OF CONTRIBUTIONS FROM PRINCIPAL FIELD SOURCES
C
c  (C) Copr. 1995, 1996, Nikolai A. Tsyganenko, Raytheon STX, Code 695, NASA GSFC
c      Greenbelt, MD 20771, USA
c
C                            REFERENCES:
C
C               (1) N.A. TSYGANENKO AND D.P. STERN, A NEW-GENERATION GLOBAL
C           MAGNETOSPHERE FIELD MODEL  , BASED ON SPACECRAFT MAGNETOMETER DATA,
C           ISTP NEWSLETTER, V.6, NO.1, P.21, FEB.1996.
C
c              (2) N.A.TSYGANENKO,  MODELING THE EARTH'S MAGNETOSPHERIC
C           MAGNETIC FIELD CONFINED WITHIN A REALISTIC MAGNETOPAUSE,
C           J.GEOPHYS.RES., V.100, P. 5599, 1995.
C
C              (3) N.A. TSYGANENKO AND M.PEREDO, ANALYTICAL MODELS OF THE
C           MAGNETIC FIELD OF DISK-SHAPED CURRENT SHEETS, J.GEOPHYS.RES.,
C           V.99, P. 199, 1994.
C
c----------------------------------------------------------------------

      IMPLICIT REAL*8 (A-H,O-Z)
      REAL PDYN,DST,BYIMF,BZIMF,PS,X,Y,Z,BX,BY,BZ,QX,QY,QZ,PARMOD(10),
     *   A(9)
c
      DATA PDYN0,EPS10 /2.,3630.7/
C
      DATA A/1.162,22.344,18.50,2.602,6.903,5.287,0.5790,0.4462,0.7850/
C
      DATA  AM0,S0,X00,DSIG/70.,1.08,5.48,0.005/
      DATA  DELIMFX,DELIMFY /20.,10./
C
       PDYN=PARMOD(1)
       DST=PARMOD(2)
       BYIMF=PARMOD(3)
       BZIMF=PARMOD(4)
C
       SPS=SIN(PS)
       PPS=PS
C
       DEPR=0.8*DST-13.*SQRT(PDYN)  !  DEPR is an estimate of total near-Earth
c                                         depression, based on DST and Pdyn
c                                             (usually, DEPR < 0 )
C
C  CALCULATE THE IMF-RELATED QUANTITIES:
C
       Bt=SQRT(BYIMF**2+BZIMF**2)

       IF (BYIMF.EQ.0..AND.BZIMF.EQ.0.) THEN
          THETA=0.
          GOTO 1
       ENDIF
C
       THETA=ATAN2(BYIMF,BZIMF)
       IF (THETA.LE.0.D0) THETA=THETA+6.2831853
  1    CT=COS(THETA)
       ST=SIN(THETA)
       EPS=718.5*SQRT(Pdyn)*Bt*SIN(THETA/2.)
C
       FACTEPS=EPS/EPS10-1.
       FACTPD=SQRT(PDYN/PDYN0)-1.
C
       RCAMPL=-A(1)*DEPR     !   RCAMPL is the amplitude of the ring current
c                  (positive and equal to abs.value of RC depression at origin)
C
       TAMPL2=A(2)+A(3)*FACTPD+A(4)*FACTEPS
       TAMPL3=A(5)+A(6)*FACTPD
       B1AMPL=A(7)+A(8)*FACTEPS
       B2AMPL=20.*B1AMPL  ! IT IS EQUIVALENT TO ASSUMING THAT THE TOTAL CURRENT
C                           IN THE REGION 2 SYSTEM IS 40% OF THAT IN REGION 1
       RECONN=A(9)
C
       XAPPA=(PDYN/PDYN0)**0.14
       XAPPA3=XAPPA**3
       YS=Y*CT-Z*ST
       ZS=Z*CT+Y*ST
C
       FACTIMF=EXP(X/DELIMFX-(YS/DELIMFY)**2)
C
C  CALCULATE THE "IMF" COMPONENTS OUTSIDE THE LAYER  (HENCE BEGIN WITH "O")
C
       OIMFX=0.
       OIMFY=RECONN*BYIMF*FACTIMF
       OIMFZ=RECONN*BZIMF*FACTIMF
C
       RIMFAMPL=RECONN*Bt
C
       PPS=PS
       XX=X*XAPPA
       YY=Y*XAPPA
       ZZ=Z*XAPPA
C
C  SCALE AND CALCULATE THE MAGNETOPAUSE PARAMETERS FOR THE INTERPOLATION ACROSS
C   THE BOUNDARY LAYER (THE COORDINATES XX,YY,ZZ  ARE ALREADY SCALED)
C
       X0=X00/XAPPA
       AM=AM0/XAPPA
       RHO2=Y**2+Z**2
       ASQ=AM**2
       XMXM=AM+X-X0
       IF (XMXM.LT.0.) XMXM=0. ! THE BOUNDARY IS A CYLINDER TAILWARD OF X=X0-AM
       AXX0=XMXM**2
       ARO=ASQ+RHO2
       SIGMA=SQRT((ARO+AXX0+SQRT((ARO+AXX0)**2-4.*ASQ*AXX0))/(2.*ASQ))
C
C   NOW, THERE ARE THREE POSSIBLE CASES:
C    (1) INSIDE THE MAGNETOSPHERE
C    (2) IN THE BOUNDARY LAYER
C    (3) OUTSIDE THE MAGNETOSPHERE AND B.LAYER
C       FIRST OF ALL, CONSIDER THE CASES (1) AND (2):
C
      IF (SIGMA.LT.S0+DSIG) THEN  !  CALCULATE THE T95_06 FIELD (WITH THE
C                                POTENTIAL "PENETRATED" INTERCONNECTION FIELD):

       CALL DIPSHLD(PPS,XX,YY,ZZ,CFX,CFY,CFZ)
       CALL TAILRC96(SPS,XX,YY,ZZ,BXRC,BYRC,BZRC,BXT2,BYT2,BZT2,
     *   BXT3,BYT3,BZT3)
       CALL BIRK1TOT_02(PPS,XX,YY,ZZ,R1X,R1Y,R1Z)
       CALL BIRK2TOT_02(PPS,XX,YY,ZZ,R2X,R2Y,R2Z)
       CALL INTERCON(XX,YS*XAPPA,ZS*XAPPA,RIMFX,RIMFYS,RIMFZS)
       RIMFY=RIMFYS*CT+RIMFZS*ST
       RIMFZ=RIMFZS*CT-RIMFYS*ST
C
      FX=CFX*XAPPA3+RCAMPL*BXRC +TAMPL2*BXT2+TAMPL3*BXT3
     *  +B1AMPL*R1X +B2AMPL*R2X +RIMFAMPL*RIMFX
      FY=CFY*XAPPA3+RCAMPL*BYRC +TAMPL2*BYT2+TAMPL3*BYT3
     *  +B1AMPL*R1Y +B2AMPL*R2Y +RIMFAMPL*RIMFY
      FZ=CFZ*XAPPA3+RCAMPL*BZRC +TAMPL2*BZT2+TAMPL3*BZT3
     *  +B1AMPL*R1Z +B2AMPL*R2Z +RIMFAMPL*RIMFZ
C
C  NOW, LET US CHECK WHETHER WE HAVE THE CASE (1). IF YES - WE ARE DONE:
C
       IF (SIGMA.LT.S0-DSIG) THEN
         BX=FX
         BY=FY
         BZ=FZ
                        ELSE  !  THIS IS THE MOST COMPLEX CASE: WE ARE INSIDE
C                                         THE INTERPOLATION REGION
       FINT=0.5*(1.-(SIGMA-S0)/DSIG)
       FEXT=0.5*(1.+(SIGMA-S0)/DSIG)
C
       CALL DIPOLE(PS,X,Y,Z,QX,QY,QZ)
       BX=(FX+QX)*FINT+OIMFX*FEXT -QX
       BY=(FY+QY)*FINT+OIMFY*FEXT -QY
       BZ=(FZ+QZ)*FINT+OIMFZ*FEXT -QZ
c
        ENDIF  !   THE CASES (1) AND (2) ARE EXHAUSTED; THE ONLY REMAINING
C                      POSSIBILITY IS NOW THE CASE (3):
         ELSE
                CALL DIPOLE(PS,X,Y,Z,QX,QY,QZ)
                BX=OIMFX-QX
                BY=OIMFY-QY
                BZ=OIMFZ-QZ
         ENDIF
C
       RETURN
       END
C=====================================================================

      SUBROUTINE DIPSHLD(PS,X,Y,Z,BX,BY,BZ)
C
C   CALCULATES GSM COMPONENTS OF THE EXTERNAL MAGNETIC FIELD DUE TO
C    SHIELDING OF THE EARTH'S DIPOLE ONLY
C
       IMPLICIT REAL*8 (A-H,O-Z)
       DIMENSION A1(12),A2(12)
      DATA A1 /.24777,-27.003,-.46815,7.0637,-1.5918,-.90317E-01,57.522,
     * 13.757,2.0100,10.458,4.5798,2.1695/
      DATA A2/-.65385,-18.061,-.40457,-5.0995,1.2846,.78231E-01,39.592,
     * 13.291,1.9970,10.062,4.5140,2.1558/
C
          CPS=DCOS(PS)
          SPS=DSIN(PS)
          CALL CYLHARM(A1,X,Y,Z,HX,HY,HZ)
          CALL CYLHAR1(A2,X,Y,Z,FX,FY,FZ)
C
          BX=HX*CPS+FX*SPS
          BY=HY*CPS+FY*SPS
          BZ=HZ*CPS+FZ*SPS
        RETURN
       END
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C  THIS CODE YIELDS THE SHIELDING FIELD FOR THE PERPENDICULAR DIPOLE
C
         SUBROUTINE  CYLHARM( A, X,Y,Z, BX,BY,BZ)
C
C
C   ***  N.A. Tsyganenko ***  Sept. 14-18, 1993; revised March 16, 1994 ***
C
C   An approximation for the Chapman-Ferraro field by a sum of 6 cylin-
c   drical harmonics (see pp. 97-113 in the brown GSFC notebook #1)
c
C      Description of parameters:
C
C  A   - input vector containing model parameters;
C  X,Y,Z   -  input GSM coordinates
C  BX,BY,BZ - output GSM components of the shielding field
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  The 6 linear parameters A(1)-A(6) are amplitudes of the cylindrical harmonic
c       terms.
c  The 6 nonlinear parameters A(7)-A(12) are the corresponding scale lengths
C       for each term (see GSFC brown notebook).
c
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
	 IMPLICIT  REAL * 8  (A - H, O - Z)
C
	 DIMENSION  A(12)
C
           RHO=DSQRT(Y**2+Z**2)
            IF (RHO.LT.1.D-8) THEN
               SINFI=1.D0
               COSFI=0.D0
               RHO=1.D-8
               GOTO 1
            ENDIF
C
           SINFI=Z/RHO
           COSFI=Y/RHO
  1        SINFI2=SINFI**2
           SI2CO2=SINFI2-COSFI**2
C
             BX=0.D0
             BY=0.D0
             BZ=0.D0
C
	   DO 11 I=1,3
             DZETA=RHO/A(I+6)
             XJ0=BES(DZETA,0)
             XJ1=BES(DZETA,1)
             XEXP=DEXP(X/A(I+6))
             BX=BX-A(I)*XJ1*XEXP*SINFI
             BY=BY+A(I)*(2.D0*XJ1/DZETA-XJ0)*XEXP*SINFI*COSFI
             BZ=BZ+A(I)*(XJ1/DZETA*SI2CO2-XJ0*SINFI2)*XEXP
   11        CONTINUE
c
	   DO 12 I=4,6
             DZETA=RHO/A(I+6)
             XKSI=X/A(I+6)
             XJ0=BES(DZETA,0)
             XJ1=BES(DZETA,1)
             XEXP=DEXP(XKSI)
             BRHO=(XKSI*XJ0-(DZETA**2+XKSI-1.D0)*XJ1/DZETA)*XEXP*SINFI
             BPHI=(XJ0+XJ1/DZETA*(XKSI-1.D0))*XEXP*COSFI
             BX=BX+A(I)*(DZETA*XJ0+XKSI*XJ1)*XEXP*SINFI
             BY=BY+A(I)*(BRHO*COSFI-BPHI*SINFI)
             BZ=BZ+A(I)*(BRHO*SINFI+BPHI*COSFI)
   12        CONTINUE
C
c
         RETURN
	 END
C
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
C  THIS CODE YIELDS THE SHIELDING FIELD FOR THE PARALLEL DIPOLE
C
         SUBROUTINE  CYLHAR1(A, X,Y,Z, BX,BY,BZ)
C
C
C   ***  N.A. Tsyganenko ***  Sept. 14-18, 1993; revised March 16, 1994 ***
C
C   An approximation of the Chapman-Ferraro field by a sum of 6 cylin-
c   drical harmonics (see pages 97-113 in the brown GSFC notebook #1)
c
C      Description of parameters:
C
C  A   - input vector containing model parameters;
C  X,Y,Z - input GSM coordinates,
C  BX,BY,BZ - output GSM components of the shielding field
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C      The 6 linear parameters A(1)-A(6) are amplitudes of the cylindrical
c  harmonic terms.
c      The 6 nonlinear parameters A(7)-A(12) are the corresponding scale
c  lengths for each term (see GSFC brown notebook).
c
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
	 IMPLICIT  REAL * 8  (A - H, O - Z)
C
	 DIMENSION  A(12)
C
           RHO=DSQRT(Y**2+Z**2)
            IF (RHO.LT.1.D-10) THEN
               SINFI=1.D0
               COSFI=0.D0
               GOTO 1
            ENDIF
C
           SINFI=Z/RHO
           COSFI=Y/RHO
C
   1      BX=0.D0
          BY=0.D0
          BZ=0.D0
C
             DO 11 I=1,3
             DZETA=RHO/A(I+6)
             XKSI=X/A(I+6)
             XJ0=BES(DZETA,0)
             XJ1=BES(DZETA,1)
             XEXP=DEXP(XKSI)
             BRHO=XJ1*XEXP
             BX=BX-A(I)*XJ0*XEXP
             BY=BY+A(I)*BRHO*COSFI
             BZ=BZ+A(I)*BRHO*SINFI
   11        CONTINUE
c
	   DO 12 I=4,6
             DZETA=RHO/A(I+6)
             XKSI=X/A(I+6)
             XJ0=BES(DZETA,0)
             XJ1=BES(DZETA,1)
             XEXP=DEXP(XKSI)
             BRHO=(DZETA*XJ0+XKSI*XJ1)*XEXP
             BX=BX+A(I)*(DZETA*XJ1-XJ0*(XKSI+1.D0))*XEXP
             BY=BY+A(I)*BRHO*COSFI
             BZ=BZ+A(I)*BRHO*SINFI
   12        CONTINUE
C
         RETURN
	 END

c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      DOUBLE PRECISION FUNCTION BES(X,K)
      IMPLICIT REAL*8 (A-H,O-Z)
C
      IF (K.EQ.0) THEN
        BES=BES0(X)
        RETURN
      ENDIF
C
      IF (K.EQ.1) THEN
        BES=BES1(X)
        RETURN
      ENDIF
C
      IF (X.EQ.0.D0) THEN
        BES=0.D0
        RETURN
      ENDIF
C
      G=2.D0/X
      IF (X.LE.DFLOAT(K)) GOTO 10
C
      N=1
      XJN=BES1(X)
      XJNM1=BES0(X)
C
  1   XJNP1=G*N*XJN-XJNM1
      N=N+1
      IF (N.LT.K) GOTO 2
      BES=XJNP1
      RETURN
C
 2    XJNM1=XJN
      XJN=XJNP1
      GOTO 1
C
 10   N=24
      XJN=1.D0
      XJNP1=0.D0
      SUM=0.D0
C
  3   IF (MOD(N,2).EQ.0) SUM=SUM+XJN
      XJNM1=G*N*XJN-XJNP1
      N=N-1
C
      XJNP1=XJN
      XJN=XJNM1
      IF (N.EQ.K) BES=XJN
C
      IF (DABS(XJN).GT.1.D5) THEN
        XJNP1=XJNP1*1.D-5
        XJN=XJN*1.D-5
        SUM=SUM*1.D-5
        IF (N.LE.K) BES=BES*1.D-5
      ENDIF
C
      IF (N.EQ.0) GOTO 4
      GOTO 3
C
  4   SUM=XJN+2.D0*SUM
      BES=BES/SUM
      RETURN
      END
c-------------------------------------------------------------------
c
       DOUBLE PRECISION FUNCTION BES0(X)
C
        IMPLICIT REAL*8 (A-H,O-Z)
C
        IF (DABS(X).LT.3.D0) THEN
          X32=(X/3.D0)**2
          BES0=1.D0-X32*(2.2499997D0-X32*(1.2656208D0-X32*
     *    (0.3163866D0-X32*(0.0444479D0-X32*(0.0039444D0
     *     -X32*0.00021D0)))))
        ELSE
        XD3=3.D0/X
        F0=0.79788456D0-XD3*(0.00000077D0+XD3*(0.00552740D0+XD3*
     *   (0.00009512D0-XD3*(0.00137237D0-XD3*(0.00072805D0
     *   -XD3*0.00014476D0)))))
        T0=X-0.78539816D0-XD3*(0.04166397D0+XD3*(0.00003954D0-XD3*
     *   (0.00262573D0-XD3*(0.00054125D0+XD3*(0.00029333D0
     *   -XD3*0.00013558D0)))))
        BES0=F0/DSQRT(X)*DCOS(T0)
       ENDIF
       RETURN
       END
c
c--------------------------------------------------------------------------
c
       DOUBLE PRECISION FUNCTION BES1(X)
C
        IMPLICIT REAL*8 (A-H,O-Z)
C
       IF (DABS(X).LT.3.D0) THEN
        X32=(X/3.D0)**2
        BES1XM1=0.5D0-X32*(0.56249985D0-X32*(0.21093573D0-X32*
     *  (0.03954289D0-X32*(0.00443319D0-X32*(0.00031761D0
     *  -X32*0.00001109D0)))))
         BES1=BES1XM1*X
       ELSE
        XD3=3.D0/X
        F1=0.79788456D0+XD3*(0.00000156D0+XD3*(0.01659667D0+XD3*
     *   (0.00017105D0-XD3*(0.00249511D0-XD3*(0.00113653D0
     *   -XD3*0.00020033D0)))))
        T1=X-2.35619449D0+XD3*(0.12499612D0+XD3*(0.0000565D0-XD3*
     *   (0.00637879D0-XD3*(0.00074348D0+XD3*(0.00079824D0
     *   -XD3*0.00029166D0)))))
        BES1=F1/DSQRT(X)*DCOS(T1)
       ENDIF
       RETURN
       END
C------------------------------------------------------------
C
         SUBROUTINE INTERCON(X,Y,Z,BX,BY,BZ)
C
C      Calculates the potential interconnection field inside the magnetosphere,
c  corresponding to  DELTA_X = 20Re and DELTA_Y = 10Re (NB#3, p.90, 6/6/1996).
C  The position (X,Y,Z) and field components BX,BY,BZ are given in the rotated
c   coordinate system, in which the Z-axis is always directed along the BzIMF
c   (i.e. rotated by the IMF clock angle Theta)
C   It is also assumed that the IMF Bt=1, so that the components should be
c     (i) multiplied by the actual Bt, and
c     (ii) transformed to standard GSM coords by rotating back around X axis
c              by the angle -Theta.
c
C      Description of parameters:
C
C     X,Y,Z -   GSM POSITION
C      BX,BY,BZ - INTERCONNECTION FIELD COMPONENTS INSIDE THE MAGNETOSPHERE
C        OF A STANDARD SIZE (TO TAKE INTO ACCOUNT EFFECTS OF PRESSURE CHANGES,
C         APPLY THE SCALING TRANSFORMATION)
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C     The 9 linear parameters are amplitudes of the "cartesian" harmonics
c     The 6 nonlinear parameters are the scales Pi and Ri entering
c    the arguments of exponents, sines, and cosines in the 9 "Cartesian"
c       harmonics (3+3)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
	 IMPLICIT  REAL * 8  (A - H, O - Z)
C
        DIMENSION A(15),RP(3),RR(3),P(3),R(3)
C
      DATA A/-8.411078731,5932254.951,-9073284.93,-11.68794634,
     * 6027598.824,-9218378.368,-6.508798398,-11824.42793,18015.66212,
     * 7.99754043,13.9669886,90.24475036,16.75728834,1015.645781,
     * 1553.493216/
C
        DATA M/0/
C
        IF (M.NE.0) GOTO 111
        M=1
C
         P(1)=A(10)
         P(2)=A(11)
         P(3)=A(12)
         R(1)=A(13)
         R(2)=A(14)
         R(3)=A(15)
C
C
           DO 11 I=1,3
            RP(I)=1.D0/P(I)
  11        RR(I)=1.D0/R(I)
C
  111   CONTINUE
C
            L=0
C
               BX=0.
               BY=0.
               BZ=0.
C
c        "PERPENDICULAR" KIND OF SYMMETRY ONLY
C
               DO 2 I=1,3
                  CYPI=DCOS(Y*RP(I))
                  SYPI=DSIN(Y*RP(I))
C
                DO 2 K=1,3
                   SZRK=DSIN(Z*RR(K))
                   CZRK=DCOS(Z*RR(K))
                     SQPR=DSQRT(RP(I)**2+RR(K)**2)
                      EPR=DEXP(X*SQPR)
C
                     HX=-SQPR*EPR*CYPI*SZRK
                     HY=RP(I)*EPR*SYPI*SZRK
                     HZ=-RR(K)*EPR*CYPI*CZRK
             L=L+1
c
          BX=BX+A(L)*HX
          BY=BY+A(L)*HY
          BZ=BZ+A(L)*HZ
  2   CONTINUE
C
      RETURN
      END

C~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      SUBROUTINE TAILRC96(SPS,X,Y,Z,BXRC,BYRC,BZRC,BXT2,BYT2,BZT2,
     *   BXT3,BYT3,BZT3)
c
c  COMPUTES THE COMPONENTS OF THE FIELD OF THE MODEL RING CURRENT AND THREE
c                   TAIL MODES WITH UNIT AMPLITUDES
C      (FOR THE RING CURRENT, IT MEANS THE DISTURBANCE OF Bz=-1nT AT ORIGIN,
C   AND FOR THE TAIL MODES IT MEANS MAXIMAL BX JUST ABOVE THE SHEET EQUAL 1 nT.
C
         IMPLICIT REAL*8 (A-H,O-Z)
         DIMENSION ARC(48),ATAIL2(48),ATAIL3(48)
         COMMON /WARP/ CPSS,SPSS,DPSRR,RPS,WARP,D,XS,ZS,DXSX,DXSY,DXSZ,
     *   DZSX,DZSY,DZSZ,DZETAS,DDZETADX,DDZETADY,DDZETADZ,ZSWW
C
         DATA ARC/-3.087699646,3.516259114,18.81380577,-13.95772338,
     *  -5.497076303,0.1712890838,2.392629189,-2.728020808,-14.79349936,
     *  11.08738083,4.388174084,0.2492163197E-01,0.7030375685,
     *-.7966023165,-3.835041334,2.642228681,-0.2405352424,-0.7297705678,
     * -0.3680255045,0.1333685557,2.795140897,-1.078379954,0.8014028630,
     * 0.1245825565,0.6149982835,-0.2207267314,-4.424578723,1.730471572,
     * -1.716313926,-0.2306302941,-0.2450342688,0.8617173961E-01,
     *  1.54697858,-0.6569391113,-0.6537525353,0.2079417515,12.75434981,
     *  11.37659788,636.4346279,1.752483754,3.604231143,12.83078674,
     * 7.412066636,9.434625736,676.7557193,1.701162737,3.580307144,
     *  14.64298662/
C
        DATA ATAIL2/.8747515218,-.9116821411,2.209365387,-2.159059518,
     * -7.059828867,5.924671028,-1.916935691,1.996707344,-3.877101873,
     * 3.947666061,11.38715899,-8.343210833,1.194109867,-1.244316975,
     * 3.73895491,-4.406522465,-20.66884863,3.020952989,.2189908481,
     * -.09942543549,-.927225562,.1555224669,.6994137909,-.08111721003,
     * -.7565493881,.4686588792,4.266058082,-.3717470262,-3.920787807,
     * .02298569870,.7039506341,-.5498352719,-6.675140817,.8279283559,
     * -2.234773608,-1.622656137,5.187666221,6.802472048,39.13543412,
     *  2.784722096,6.979576616,25.71716760,4.495005873,8.068408272,
     * 93.47887103,4.158030104,9.313492566,57.18240483/
C
        DATA ATAIL3/-19091.95061,-3011.613928,20582.16203,4242.918430,
     * -2377.091102,-1504.820043,19884.04650,2725.150544,-21389.04845,
     * -3990.475093,2401.610097,1548.171792,-946.5493963,490.1528941,
     * 986.9156625,-489.3265930,-67.99278499,8.711175710,-45.15734260,
     * -10.76106500,210.7927312,11.41764141,-178.0262808,.7558830028,
     *  339.3806753,9.904695974,69.50583193,-118.0271581,22.85935896,
     * 45.91014857,-425.6607164,15.47250738,118.2988915,65.58594397,
     * -201.4478068,-14.57062940,19.69877970,20.30095680,86.45407420,
     * 22.50403727,23.41617329,48.48140573,24.61031329,123.5395974,
     * 223.5367692,39.50824342,65.83385762,266.2948657/
C
       DATA RH,DR,G,D0,DELTADY/9.,4.,10.,2.,10./
C
C   TO ECONOMIZE THE CODE, WE FIRST CALCULATE COMMON VARIABLES, WHICH ARE
C      THE SAME FOR ALL MODES, AND PUT THEM IN THE COMMON-BLOCK /WARP/
C
       DR2=DR*DR
       C11=DSQRT((1.D0+RH)**2+DR2)
       C12=DSQRT((1.D0-RH)**2+DR2)
       C1=C11-C12
       SPSC1=SPS/C1
       RPS=0.5*(C11+C12)*SPS  !  THIS IS THE SHIFT OF OF THE SHEET WITH RESPECT
C                            TO GSM EQ.PLANE FOR THE 3RD (ASYMPTOTIC) TAIL MODE
C
        R=DSQRT(X*X+Y*Y+Z*Z)
        SQ1=DSQRT((R+RH)**2+DR2)
        SQ2=DSQRT((R-RH)**2+DR2)
        C=SQ1-SQ2
        CS=(R+RH)/SQ1-(R-RH)/SQ2
        SPSS=SPSC1/R*C
        CPSS=DSQRT(1.D0-SPSS**2)
        DPSRR=SPS/(R*R)*(CS*R-C)/DSQRT((R*C1)**2-(C*SPS)**2)
C
        WFAC=Y/(Y**4+1.D4)   !   WARPING
        W=WFAC*Y**3
        WS=4.D4*Y*WFAC**2
        WARP=G*SPS*W
        XS=X*CPSS-Z*SPSS
        ZSWW=Z*CPSS+X*SPSS  ! "WW" MEANS "WITHOUT Y-Z WARPING" (IN X-Z ONLY)
        ZS=ZSWW +WARP

        DXSX=CPSS-X*ZSWW*DPSRR
        DXSY=-Y*ZSWW*DPSRR
        DXSZ=-SPSS-Z*ZSWW*DPSRR
        DZSX=SPSS+X*XS*DPSRR
        DZSY=XS*Y*DPSRR  +G*SPS*WS  !  THE LAST TERM IS FOR THE Y-Z WARP
        DZSZ=CPSS+XS*Z*DPSRR        !      (TAIL MODES ONLY)

        D=D0+DELTADY*(Y/20.D0)**2   !  SHEET HALF-THICKNESS FOR THE TAIL MODES
        DDDY=DELTADY*Y*0.005D0      !  (THICKENS TO FLANKS, BUT NO VARIATION
C                                         ALONG X, IN CONTRAST TO RING CURRENT)
C
        DZETAS=DSQRT(ZS**2+D**2)  !  THIS IS THE SAME SIMPLE WAY TO SPREAD
C                                        OUT THE SHEET, AS THAT USED IN T89
        DDZETADX=ZS*DZSX/DZETAS
        DDZETADY=(ZS*DZSY+D*DDDY)/DZETAS
        DDZETADZ=ZS*DZSZ/DZETAS
C
        CALL SHLCAR3X3(ARC,X,Y,Z,SPS,WX,WY,WZ)
        CALL RINGCURR96(X,Y,Z,HX,HY,HZ)
        BXRC=WX+HX
        BYRC=WY+HY
        BZRC=WZ+HZ
C
        CALL SHLCAR3X3(ATAIL2,X,Y,Z,SPS,WX,WY,WZ)
        CALL TAILDISK(X,Y,Z,HX,HY,HZ)
        BXT2=WX+HX
        BYT2=WY+HY
        BZT2=WZ+HZ
C
        CALL SHLCAR3X3(ATAIL3,X,Y,Z,SPS,WX,WY,WZ)
        CALL TAIL87(X,Z,HX,HZ)
        BXT3=WX+HX
        BYT3=WY
        BZT3=WZ+HZ
C
        RETURN
        END
C
c********************************************************************
C
        SUBROUTINE RINGCURR96(X,Y,Z,BX,BY,BZ)
c
c       THIS SUBROUTINE COMPUTES THE COMPONENTS OF THE RING CURRENT FIELD,
C        SIMILAR TO THAT DESCRIBED BY TSYGANENKO AND PEREDO (1994).  THE
C          DIFFERENCE IS THAT NOW WE USE SPACEWARPING, AS DESCRIBED IN THE
C           PAPER ON MODELING BIRKELAND CURRENTS (TSYGANENKO AND STERN, 1996),
C            INSTEAD OF SHEARING IT IN THE SPIRIT OF THE T89 TAIL MODEL.
C
C          IN  ADDITION, INSTEAD OF 7 TERMS FOR THE RING CURRENT MODEL, WE USE
C             NOW ONLY 2 TERMS;  THIS SIMPLIFICATION ALSO GIVES RISE TO AN
C                EASTWARD RING CURRENT LOCATED EARTHWARD FROM THE MAIN ONE,
C                  IN LINE WITH WHAT IS ACTUALLY OBSERVED
C
C             FOR DETAILS, SEE NB #3, PAGES 70-73
C
        IMPLICIT REAL*8 (A-H,O-Z)
        DIMENSION F(2),BETA(2)
        COMMON /WARP/ CPSS,SPSS,DPSRR, XNEXT(3),XS,ZSWARPED,DXSX,DXSY,
     *   DXSZ,DZSX,DZSYWARPED,DZSZ,OTHER(4),ZS  !  ZS HERE IS WITHOUT Y-Z WARP
C

      DATA D0,DELTADX,XD,XLDX /2.,0.,0.,4./  !  ACHTUNG !!  THE RC IS NOW
C                                            COMPLETELY SYMMETRIC (DELTADX=0)

C
        DATA F,BETA /569.895366D0,-1603.386993D0,2.722188D0,3.766875D0/
C
C  THE ORIGINAL VALUES OF F(I) WERE MULTIPLIED BY BETA(I) (TO REDUCE THE
C     NUMBER OF MULTIPLICATIONS BELOW)  AND BY THE FACTOR -0.43, NORMALIZING
C      THE DISTURBANCE AT ORIGIN  TO  B=-1nT
C
           DZSY=XS*Y*DPSRR  ! NO WARPING IN THE Y-Z PLANE (ALONG X ONLY), AND
C                         THIS IS WHY WE DO NOT USE  DZSY FROM THE COMMON-BLOCK
           XXD=X-XD
           FDX=0.5D0*(1.D0+XXD/DSQRT(XXD**2+XLDX**2))
           DDDX=DELTADX*0.5D0*XLDX**2/DSQRT(XXD**2+XLDX**2)**3
           D=D0+DELTADX*FDX

           DZETAS=DSQRT(ZS**2+D**2)  !  THIS IS THE SAME SIMPLE WAY TO SPREAD
C                                        OUT THE SHEET, AS THAT USED IN T89
           RHOS=DSQRT(XS**2+Y**2)
           DDZETADX=(ZS*DZSX+D*DDDX)/DZETAS
           DDZETADY=ZS*DZSY/DZETAS
           DDZETADZ=ZS*DZSZ/DZETAS
         IF (RHOS.LT.1.D-5) THEN
            DRHOSDX=0.D0
            DRHOSDY=DSIGN(1.D0,Y)
            DRHOSDZ=0.D0
          ELSE
           DRHOSDX=XS*DXSX/RHOS
           DRHOSDY=(XS*DXSY+Y)/RHOS
           DRHOSDZ=XS*DXSZ/RHOS
         ENDIF
C
           BX=0.D0
           BY=0.D0
           BZ=0.D0
C
           DO 1 I=1,2
C
           BI=BETA(I)
C
           S1=DSQRT((DZETAS+BI)**2+(RHOS+BI)**2)
           S2=DSQRT((DZETAS+BI)**2+(RHOS-BI)**2)
           DS1DDZ=(DZETAS+BI)/S1
           DS2DDZ=(DZETAS+BI)/S2
           DS1DRHOS=(RHOS+BI)/S1
           DS2DRHOS=(RHOS-BI)/S2
C
           DS1DX=DS1DDZ*DDZETADX+DS1DRHOS*DRHOSDX
           DS1DY=DS1DDZ*DDZETADY+DS1DRHOS*DRHOSDY
           DS1DZ=DS1DDZ*DDZETADZ+DS1DRHOS*DRHOSDZ
C
           DS2DX=DS2DDZ*DDZETADX+DS2DRHOS*DRHOSDX
           DS2DY=DS2DDZ*DDZETADY+DS2DRHOS*DRHOSDY
           DS2DZ=DS2DDZ*DDZETADZ+DS2DRHOS*DRHOSDZ
C
           S1TS2=S1*S2
           S1PS2=S1+S2
           S1PS2SQ=S1PS2**2
           FAC1=DSQRT(S1PS2SQ-(2.D0*BI)**2)
           AS=FAC1/(S1TS2*S1PS2SQ)
           TERM1=1.D0/(S1TS2*S1PS2*FAC1)
           FAC2=AS/S1PS2SQ
           DASDS1=TERM1-FAC2/S1*(S2*S2+S1*(3.D0*S1+4.D0*S2))
           DASDS2=TERM1-FAC2/S2*(S1*S1+S2*(3.D0*S2+4.D0*S1))
C
           DASDX=DASDS1*DS1DX+DASDS2*DS2DX
           DASDY=DASDS1*DS1DY+DASDS2*DS2DY
           DASDZ=DASDS1*DS1DZ+DASDS2*DS2DZ
C
      BX=BX+F(I)*((2.D0*AS+Y*DASDY)*SPSS-XS*DASDZ
     *   +AS*DPSRR*(Y**2*CPSS+Z*ZS))
      BY=BY-F(I)*Y*(AS*DPSRR*XS+DASDZ*CPSS+DASDX*SPSS)
  1   BZ=BZ+F(I)*((2.D0*AS+Y*DASDY)*CPSS+XS*DASDX
     *   -AS*DPSRR*(X*ZS+Y**2*SPSS))
C
       RETURN
       END
C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
C
         SUBROUTINE TAILDISK(X,Y,Z,BX,BY,BZ)
C
c
c       THIS SUBROUTINE COMPUTES THE COMPONENTS OF THE TAIL CURRENT FIELD,
C        SIMILAR TO THAT DESCRIBED BY TSYGANENKO AND PEREDO (1994).  THE
C          DIFFERENCE IS THAT NOW WE USE SPACEWARPING, AS DESCRIBED IN OUR
C           PAPER ON MODELING BIRKELAND CURRENTS (TSYGANENKO AND STERN, 1996)
C            INSTEAD OF SHEARING IT IN THE SPIRIT OF T89 TAIL MODEL.
C
C          IN  ADDITION, INSTEAD OF 8 TERMS FOR THE TAIL CURRENT MODEL, WE USE
C           NOW ONLY 4 TERMS
C
C             FOR DETAILS, SEE NB #3, PAGES 74-
C
         IMPLICIT REAL*8 (A-H,O-Z)
         DIMENSION F(4),BETA(4)
         COMMON /WARP/ CPSS,SPSS,DPSRR,XNEXT(3),XS,ZS,DXSX,DXSY,DXSZ,
     *    OTHER(3),DZETAS,DDZETADX,DDZETADY,DDZETADZ,ZSWW
C
         DATA XSHIFT /4.5/
C
         DATA F,BETA
     * / -745796.7338D0,1176470.141D0,-444610.529D0,-57508.01028D0,
     *   7.9250000D0,8.0850000D0,8.4712500D0,27.89500D0/
c
c  here original F(I) are multiplied by BETA(I), to economize
c    calculations
C
           RHOS=DSQRT((XS-XSHIFT)**2+Y**2)
         IF (RHOS.LT.1.D-5) THEN
            DRHOSDX=0.D0
            DRHOSDY=DSIGN(1.D0,Y)
            DRHOSDZ=0.D0
         ELSE
           DRHOSDX=(XS-XSHIFT)*DXSX/RHOS
           DRHOSDY=((XS-XSHIFT)*DXSY+Y)/RHOS
           DRHOSDZ=(XS-XSHIFT)*DXSZ/RHOS
         ENDIF
C
           BX=0.D0
           BY=0.D0
           BZ=0.D0
C
           DO 1 I=1,4
C
           BI=BETA(I)
C
           S1=DSQRT((DZETAS+BI)**2+(RHOS+BI)**2)
           S2=DSQRT((DZETAS+BI)**2+(RHOS-BI)**2)
           DS1DDZ=(DZETAS+BI)/S1
           DS2DDZ=(DZETAS+BI)/S2
           DS1DRHOS=(RHOS+BI)/S1
           DS2DRHOS=(RHOS-BI)/S2
C
           DS1DX=DS1DDZ*DDZETADX+DS1DRHOS*DRHOSDX
           DS1DY=DS1DDZ*DDZETADY+DS1DRHOS*DRHOSDY
           DS1DZ=DS1DDZ*DDZETADZ+DS1DRHOS*DRHOSDZ
C
           DS2DX=DS2DDZ*DDZETADX+DS2DRHOS*DRHOSDX
           DS2DY=DS2DDZ*DDZETADY+DS2DRHOS*DRHOSDY
           DS2DZ=DS2DDZ*DDZETADZ+DS2DRHOS*DRHOSDZ
C
           S1TS2=S1*S2
           S1PS2=S1+S2
           S1PS2SQ=S1PS2**2
           FAC1=DSQRT(S1PS2SQ-(2.D0*BI)**2)
           AS=FAC1/(S1TS2*S1PS2SQ)
           TERM1=1.D0/(S1TS2*S1PS2*FAC1)
           FAC2=AS/S1PS2SQ
           DASDS1=TERM1-FAC2/S1*(S2*S2+S1*(3.D0*S1+4.D0*S2))
           DASDS2=TERM1-FAC2/S2*(S1*S1+S2*(3.D0*S2+4.D0*S1))
C
           DASDX=DASDS1*DS1DX+DASDS2*DS2DX
           DASDY=DASDS1*DS1DY+DASDS2*DS2DY
           DASDZ=DASDS1*DS1DZ+DASDS2*DS2DZ
C
      BX=BX+F(I)*((2.D0*AS+Y*DASDY)*SPSS-(XS-XSHIFT)*DASDZ
     *   +AS*DPSRR*(Y**2*CPSS+Z*ZSWW))
C
      BY=BY-F(I)*Y*(AS*DPSRR*XS+DASDZ*CPSS+DASDX*SPSS)
  1   BZ=BZ+F(I)*((2.D0*AS+Y*DASDY)*CPSS+(XS-XSHIFT)*DASDX
     *   -AS*DPSRR*(X*ZSWW+Y**2*SPSS))

       RETURN
       END

C-------------------------------------------------------------------------
C
      SUBROUTINE TAIL87(X,Z,BX,BZ)

      IMPLICIT REAL*8 (A-H,O-Z)

      COMMON /WARP/ FIRST(3), RPS,WARP,D, OTHER(13)
C
C      'LONG' VERSION OF THE 1987 TAIL MAGNETIC FIELD MODEL
C              (N.A.TSYGANENKO, PLANET. SPACE SCI., V.35, P.1347, 1987)
C
C      D   IS THE Y-DEPENDENT SHEET HALF-THICKNESS (INCREASING TOWARDS FLANKS)
C      RPS  IS THE TILT-DEPENDENT SHIFT OF THE SHEET IN THE Z-DIRECTION,
C           CORRESPONDING TO THE ASYMPTOTIC HINGING DISTANCE, DEFINED IN THE
C           MAIN SUBROUTINE (TAILRC96) FROM THE PARAMETERS RH AND DR OF THE
C           T96-TYPE MODULE, AND
C      WARP  IS THE BENDING OF THE SHEET FLANKS IN THE Z-DIRECTION, DIRECTED
C           OPPOSITE TO RPS, AND INCREASING WITH DIPOLE TILT AND |Y|
C

        DATA DD/3./
C
      DATA HPI,RT,XN,X1,X2,B0,B1,B2,XN21,XNR,ADLN
     * /1.5707963,40.,-10.,
     * -1.261,-0.663,0.391734,5.89715,24.6833,76.37,-0.1071,0.13238005/
C                !!!   THESE ARE NEW VALUES OF  X1, X2, B0, B1, B2,
C                       CORRESPONDING TO TSCALE=1, INSTEAD OF TSCALE=0.6
C
C  THE ABOVE QUANTITIES WERE DEFINED AS FOLLOWS:------------------------
C       HPI=PI/2
C       RT=40.      !  Z-POSITION OF UPPER AND LOWER ADDITIONAL SHEETS
C       XN=-10.     !  INNER EDGE POSITION
C
C       TSCALE=1  !  SCALING FACTOR, DEFINING THE RATE OF INCREASE OF THE
C                       CURRENT DENSITY TAILWARDS
C
c  ATTENTION !  NOW I HAVE CHANGED TSCALE TO:  TSCALE=1.0, INSTEAD OF 0.6
c                  OF THE PREVIOUS VERSION
c
C       B0=0.391734
C       B1=5.89715 *TSCALE
C       B2=24.6833 *TSCALE**2
C
C    HERE ORIGINAL VALUES OF THE MODE AMPLITUDES (P.77, NB#3) WERE NORMALIZED
C      SO THAT ASYMPTOTIC  BX=1  AT X=-200RE
C
C      X1=(4.589  -5.85) *TSCALE -(TSCALE-1.)*XN ! NONLINEAR PARAMETERS OF THE
C                                                         CURRENT FUNCTION
C      X2=(5.187  -5.85) *TSCALE -(TSCALE-1.)*XN
c
c
C      XN21=(XN-X1)**2
C      XNR=1./(XN-X2)
C      ADLN=-DLOG(XNR**2*XN21)
C
C---------------------------------------------------------------
C
      ZS=Z -RPS +WARP
      ZP=Z-RT
      ZM=Z+RT
C
      XNX=XN-X
      XNX2=XNX**2
      XC1=X-X1
      XC2=X-X2
      XC22=XC2**2
      XR2=XC2*XNR
      XC12=XC1**2
      D2=DD**2    !  SQUARE OF THE TOTAL HALFTHICKNESS (DD=3Re for this mode)
      B20=ZS**2+D2
      B2P=ZP**2+D2
      B2M=ZM**2+D2
      B=DSQRT(B20)
      BP=DSQRT(B2P)
      BM=DSQRT(B2M)
      XA1=XC12+B20
      XAP1=XC12+B2P
      XAM1=XC12+B2M
      XA2=1./(XC22+B20)
      XAP2=1./(XC22+B2P)
      XAM2=1./(XC22+B2M)
      XNA=XNX2+B20
      XNAP=XNX2+B2P
      XNAM=XNX2+B2M
      F=B20-XC22
      FP=B2P-XC22
      FM=B2M-XC22
      XLN1=DLOG(XN21/XNA)
      XLNP1=DLOG(XN21/XNAP)
      XLNM1=DLOG(XN21/XNAM)
      XLN2=XLN1+ADLN
      XLNP2=XLNP1+ADLN
      XLNM2=XLNM1+ADLN
      ALN=0.25*(XLNP1+XLNM1-2.*XLN1)
      S0=(DATAN(XNX/B)+HPI)/B
      S0P=(DATAN(XNX/BP)+HPI)/BP
      S0M=(DATAN(XNX/BM)+HPI)/BM
      S1=(XLN1*.5+XC1*S0)/XA1
      S1P=(XLNP1*.5+XC1*S0P)/XAP1
      S1M=(XLNM1*.5+XC1*S0M)/XAM1
      S2=(XC2*XA2*XLN2-XNR-F*XA2*S0)*XA2
      S2P=(XC2*XAP2*XLNP2-XNR-FP*XAP2*S0P)*XAP2
      S2M=(XC2*XAM2*XLNM2-XNR-FM*XAM2*S0M)*XAM2
      G1=(B20*S0-0.5*XC1*XLN1)/XA1
      G1P=(B2P*S0P-0.5*XC1*XLNP1)/XAP1
      G1M=(B2M*S0M-0.5*XC1*XLNM1)/XAM1
      G2=((0.5*F*XLN2+2.*S0*B20*XC2)*XA2+XR2)*XA2
      G2P=((0.5*FP*XLNP2+2.*S0P*B2P*XC2)*XAP2+XR2)*XAP2
      G2M=((0.5*FM*XLNM2+2.*S0M*B2M*XC2)*XAM2+XR2)*XAM2
      BX=B0*(ZS*S0-0.5*(ZP*S0P+ZM*S0M))
     * +B1*(ZS*S1-0.5*(ZP*S1P+ZM*S1M))+B2*(ZS*S2-0.5*(ZP*S2P+ZM*S2M))
      BZ=B0*ALN+B1*(G1-0.5*(G1P+G1M))+B2*(G2-0.5*(G2P+G2M))
C
C    CALCULATION OF THE MAGNETOTAIL CURRENT CONTRIBUTION IS FINISHED
C
      RETURN
      END

C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
C
C THIS CODE RETURNS THE SHIELDING FIELD REPRESENTED BY  2x3x3=18 "CARTESIAN"
C    HARMONICS
C
         SUBROUTINE  SHLCAR3X3(A,X,Y,Z,SPS,HX,HY,HZ)
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  The 36 coefficients enter in pairs in the amplitudes of the "cartesian"
c    harmonics (A(1)-A(36).
c  The 12 nonlinear parameters (A(37)-A(48) are the scales Pi,Ri,Qi,and Si
C   entering the arguments of exponents, sines, and cosines in each of the
C   18 "Cartesian" harmonics
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
	 IMPLICIT  REAL * 8  (A - H, O - Z)
C
         DIMENSION A(48)
C
          CPS=DSQRT(1.D0-SPS**2)
          S3PS=4.D0*CPS**2-1.D0   !  THIS IS SIN(3*PS)/SIN(PS)
C
           HX=0.D0
           HY=0.D0
           HZ=0.D0
           L=0
C
           DO 1 M=1,2     !    M=1 IS FOR THE 1ST SUM ("PERP." SYMMETRY)
C                           AND M=2 IS FOR THE SECOND SUM ("PARALL." SYMMETRY)
             DO 2 I=1,3
                  P=A(36+I)
                  Q=A(42+I)
                  CYPI=DCOS(Y/P)
                  CYQI=DCOS(Y/Q)
                  SYPI=DSIN(Y/P)
                  SYQI=DSIN(Y/Q)
C
              DO 3 K=1,3
                   R=A(39+K)
                   S=A(45+K)
                   SZRK=DSIN(Z/R)
                   CZSK=DCOS(Z/S)
                   CZRK=DCOS(Z/R)
                   SZSK=DSIN(Z/S)
                     SQPR=DSQRT(1.D0/P**2+1.D0/R**2)
                     SQQS=DSQRT(1.D0/Q**2+1.D0/S**2)
                        EPR=DEXP(X*SQPR)
                        EQS=DEXP(X*SQQS)
C
                   DO 4 N=1,2  ! N=1 IS FOR THE FIRST PART OF EACH COEFFICIENT
C                                  AND N=2 IS FOR THE SECOND ONE
C
                    L=L+1
                     IF (M.EQ.1) THEN
                       IF (N.EQ.1) THEN
                         DX=-SQPR*EPR*CYPI*SZRK
                         DY=EPR/P*SYPI*SZRK
                         DZ=-EPR/R*CYPI*CZRK
                         HX=HX+A(L)*DX
                         HY=HY+A(L)*DY
                         HZ=HZ+A(L)*DZ
                                   ELSE
                         DX=DX*CPS
                         DY=DY*CPS
                         DZ=DZ*CPS
                         HX=HX+A(L)*DX
                         HY=HY+A(L)*DY
                         HZ=HZ+A(L)*DZ
                                   ENDIF
                     ELSE
                       IF (N.EQ.1) THEN
                         DX=-SPS*SQQS*EQS*CYQI*CZSK
                         DY=SPS*EQS/Q*SYQI*CZSK
                         DZ=SPS*EQS/S*CYQI*SZSK
                         HX=HX+A(L)*DX
                         HY=HY+A(L)*DY
                         HZ=HZ+A(L)*DZ
                                   ELSE
                         DX=DX*S3PS
                         DY=DY*S3PS
                         DZ=DZ*S3PS
                         HX=HX+A(L)*DX
                         HY=HY+A(L)*DY
                         HZ=HZ+A(L)*DZ
                       ENDIF
                 ENDIF
c
  4   CONTINUE
  3   CONTINUE
  2   CONTINUE
  1   CONTINUE
C
         RETURN
	 END

C
C@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
C
       SUBROUTINE BIRK1TOT_02(PS,X,Y,Z,BX,BY,BZ)
C
C  THIS IS THE SECOND VERSION OF THE ANALYTICAL MODEL OF THE REGION 1 FIELD
C   BASED ON A SEPARATE REPRESENTATION OF THE POTENTIAL FIELD IN THE INNER AND
C   OUTER SPACE, MAPPED BY MEANS OF A SPHERO-DIPOLAR COORDINATE SYSTEM (NB #3,
C   P.91).   THE DIFFERENCE FROM THE FIRST ONE IS THAT INSTEAD OF OCTAGONAL
C   CURRENT LOOPS, CIRCULAR ONES ARE USED IN THIS VERSION FOR APPROXIMATING THE
C   FIELD IN THE OUTER REGION, WHICH IS FASTER.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      DIMENSION D1(3,26),D2(3,79),XI(4),C1(26),C2(79)

         COMMON /COORD11/ XX1(12),YY1(12)
         COMMON /RHDR/ RH,DR
         COMMON /LOOPDIP1/ TILT,XCENTRE(2),RADIUS(2), DIPX,DIPY
C
         COMMON /COORD21/ XX2(14),YY2(14),ZZ2(14)
         COMMON /DX1/ DX,SCALEIN,SCALEOUT
C
      DATA C1/-0.911582E-03,-0.376654E-02,-0.727423E-02,-0.270084E-02,
     * -0.123899E-02,-0.154387E-02,-0.340040E-02,-0.191858E-01,
     * -0.518979E-01,0.635061E-01,0.440680,-0.396570,0.561238E-02,
     *  0.160938E-02,-0.451229E-02,-0.251810E-02,-0.151599E-02,
     * -0.133665E-02,-0.962089E-03,-0.272085E-01,-0.524319E-01,
     *  0.717024E-01,0.523439,-0.405015,-89.5587,23.2806/

C
      DATA C2/6.04133,.305415,.606066E-02,.128379E-03,-.179406E-04,
     * 1.41714,-27.2586,-4.28833,-1.30675,35.5607,8.95792,.961617E-03,
     * -.801477E-03,-.782795E-03,-1.65242,-16.5242,-5.33798,.424878E-03,
     * .331787E-03,-.704305E-03,.844342E-03,.953682E-04,.886271E-03,
     * 25.1120,20.9299,5.14569,-44.1670,-51.0672,-1.87725,20.2998,
     * 48.7505,-2.97415,3.35184,-54.2921,-.838712,-10.5123,70.7594,
     * -4.94104,.106166E-03,.465791E-03,-.193719E-03,10.8439,-29.7968,
     *  8.08068,.463507E-03,-.224475E-04,.177035E-03,-.317581E-03,
     * -.264487E-03,.102075E-03,7.71390,10.1915,-4.99797,-23.1114,
     *-29.2043,12.2928,10.9542,33.6671,-9.3851,.174615E-03,-.789777E-06,
     * .686047E-03,.460104E-04,-.345216E-02,.221871E-02,.110078E-01,
     * -.661373E-02,.249201E-02,.343978E-01,-.193145E-05,.493963E-05,
     * -.535748E-04,.191833E-04,-.100496E-03,-.210103E-03,-.232195E-02,
     * .315335E-02,-.134320E-01,-.263222E-01/
c
      DATA TILT,XCENTRE,RADIUS,DIPX,DIPY /1.00891,2.28397,-5.60831,
     * 1.86106,7.83281,1.12541,0.945719/

      DATA DX,SCALEIN,SCALEOUT /-0.16D0,0.08D0,0.4D0/
      DATA XX1/-11.D0,2*-7.D0,2*-3.D0,3*1.D0,2*5.D0,2*9.D0/
      DATA YY1/2.D0,0.D0,4.D0,2.D0,6.D0,0.D0,4.D0,8.D0,2.D0,6.D0,0.D0,
     *  4.D0/
      DATA XX2/-10.D0,-7.D0,2*-4.D0,0.D0,2*4.D0,7.D0,10.D0,5*0.D0/
      DATA YY2/3.D0,6.D0,3.D0,9.D0,6.D0,3.D0,9.D0,6.D0,3.D0,5*0.D0/
      DATA ZZ2/2*20.D0,4.D0,20.D0,2*4.D0,3*20.D0,2.D0,3.D0,4.5D0,
     *  7.D0,10.D0/
C
      DATA RH,DR /9.D0,4.D0/   !  RH IS THE "HINGING DISTANCE" AND DR IS THE
C                                TRANSITION SCALE LENGTH, DEFINING THE
C                                CURVATURE  OF THE WARPING (SEE P.89, NB #2)
C
      DATA XLTDAY,XLTNGHT /78.D0,70.D0/  !  THESE ARE LATITUDES OF THE R-1 OVAL
C                                             AT NOON AND AT MIDNIGHT
      DATA DTET0 /0.034906/   !   THIS IS THE LATITUDINAL HALF-THICKNESS OF THE
C                                  R-1 OVAL (THE INTERPOLATION REGION BETWEEN
C                                    THE HIGH-LAT. AND THE PLASMA SHEET)
C
        TNOONN=(90.D0-XLTDAY)*0.01745329D0
        TNOONS=3.141592654D0-TNOONN     ! HERE WE ASSUME THAT THE POSITIONS OF
C                                          THE NORTHERN AND SOUTHERN R-1 OVALS
C                                          ARE SYMMETRIC IN THE SM-COORDINATES
        DTETDN=(XLTDAY-XLTNGHT)*0.01745329D0
        DR2=DR**2
C
      SPS=DSIN(PS)
      R2=X**2+Y**2+Z**2
      R=DSQRT(R2)
      R3=R*R2
C
      RMRH=R-RH
      RPRH=R+RH
      SQM=DSQRT(RMRH**2+DR2)
      SQP=DSQRT(RPRH**2+DR2)
      C=SQP-SQM
      Q=DSQRT((RH+1.D0)**2+DR2)-DSQRT((RH-1.D0)**2+DR2)
      SPSAS=SPS/R*C/Q
      CPSAS=DSQRT(1.D0-SPSAS**2)
       XAS = X*CPSAS-Z*SPSAS
       ZAS = X*SPSAS+Z*CPSAS
        IF (XAS.NE.0.D0.OR.Y.NE.0.D0) THEN
          PAS = DATAN2(Y,XAS)
                                      ELSE
          PAS=0.D0
        ENDIF
C
      TAS=DATAN2(DSQRT(XAS**2+Y**2),ZAS)
      STAS=DSIN(TAS)
      F=STAS/(STAS**6*(1.D0-R3)+R3)**0.1666666667D0
C
      TET0=DASIN(F)
      IF (TAS.GT.1.5707963D0) TET0=3.141592654D0-TET0
      DTET=DTETDN*DSIN(PAS*0.5D0)**2
      TETR1N=TNOONN+DTET
      TETR1S=TNOONS-DTET
C
C NOW LET'S DEFINE WHICH OF THE FOUR REGIONS (HIGH-LAT., NORTHERN PSBL,
C   PLASMA SHEET, SOUTHERN PSBL) DOES THE POINT (X,Y,Z) BELONG TO:
C
       IF (TET0.LT.TETR1N-DTET0.OR.TET0.GT.TETR1S+DTET0)  LOC=1 ! HIGH-LAT.
       IF (TET0.GT.TETR1N+DTET0.AND.TET0.LT.TETR1S-DTET0) LOC=2 ! PL.SHEET
       IF (TET0.GE.TETR1N-DTET0.AND.TET0.LE.TETR1N+DTET0) LOC=3 ! NORTH PSBL
       IF (TET0.GE.TETR1S-DTET0.AND.TET0.LE.TETR1S+DTET0) LOC=4 ! SOUTH PSBL
C
       IF (LOC.EQ.1) THEN   ! IN THE HIGH-LAT. REGION USE THE SUBROUTINE DIPOCT
C
C      print *, '  LOC=1 (HIGH-LAT)'    !  (test printout; disabled now)
         XI(1)=X
         XI(2)=Y
         XI(3)=Z
         XI(4)=PS
         CALL  DIPLOOP1(XI,D1)
          BX=0.D0
          BY=0.D0
          BZ=0.D0
            DO 1 I=1,26
              BX=BX+C1(I)*D1(1,I)
              BY=BY+C1(I)*D1(2,I)
  1           BZ=BZ+C1(I)*D1(3,I)
       ENDIF                                           !  END OF THE CASE 1
C
       IF (LOC.EQ.2) THEN
C           print *, '  LOC=2 (PLASMA SHEET)'  !  (test printout; disabled now)
C
         XI(1)=X
         XI(2)=Y
         XI(3)=Z
         XI(4)=PS
         CALL  CONDIP1(XI,D2)
          BX=0.D0
          BY=0.D0
          BZ=0.D0
            DO 2 I=1,79
              BX=BX+C2(I)*D2(1,I)
              BY=BY+C2(I)*D2(2,I)
  2           BZ=BZ+C2(I)*D2(3,I)
       ENDIF                                           !   END OF THE CASE 2
C
       IF (LOC.EQ.3) THEN
C       print *, '  LOC=3 (north PSBL)'  !  (test printout; disabled now)
C
         T01=TETR1N-DTET0
         T02=TETR1N+DTET0
          SQR=DSQRT(R)
          ST01AS=SQR/(R3+1.D0/DSIN(T01)**6-1.D0)**0.1666666667
          ST02AS=SQR/(R3+1.D0/DSIN(T02)**6-1.D0)**0.1666666667
          CT01AS=DSQRT(1.D0-ST01AS**2)
          CT02AS=DSQRT(1.D0-ST02AS**2)
         XAS1=R*ST01AS*DCOS(PAS)
         Y1=  R*ST01AS*DSIN(PAS)
         ZAS1=R*CT01AS
         X1=XAS1*CPSAS+ZAS1*SPSAS
         Z1=-XAS1*SPSAS+ZAS1*CPSAS ! X1,Y1,Z1 ARE COORDS OF THE NORTHERN
c                                                      BOUNDARY POINT
         XI(1)=X1
         XI(2)=Y1
         XI(3)=Z1
         XI(4)=PS
         CALL  DIPLOOP1(XI,D1)
          BX1=0.D0
          BY1=0.D0
          BZ1=0.D0
            DO 11 I=1,26
              BX1=BX1+C1(I)*D1(1,I) !   BX1,BY1,BZ1  ARE FIELD COMPONENTS
              BY1=BY1+C1(I)*D1(2,I)  !  IN THE NORTHERN BOUNDARY POINT
 11           BZ1=BZ1+C1(I)*D1(3,I)  !
C
         XAS2=R*ST02AS*DCOS(PAS)
         Y2=  R*ST02AS*DSIN(PAS)
         ZAS2=R*CT02AS
         X2=XAS2*CPSAS+ZAS2*SPSAS
         Z2=-XAS2*SPSAS+ZAS2*CPSAS ! X2,Y2,Z2 ARE COORDS OF THE SOUTHERN
C                                        BOUNDARY POINT
         XI(1)=X2
         XI(2)=Y2
         XI(3)=Z2
         XI(4)=PS
         CALL  CONDIP1(XI,D2)
          BX2=0.D0
          BY2=0.D0
          BZ2=0.D0
            DO 12 I=1,79
              BX2=BX2+C2(I)*D2(1,I)!  BX2,BY2,BZ2  ARE FIELD COMPONENTS
              BY2=BY2+C2(I)*D2(2,I) !  IN THE SOUTHERN BOUNDARY POINT
  12          BZ2=BZ2+C2(I)*D2(3,I)
C
C  NOW INTERPOLATE:
C
         SS=DSQRT((X2-X1)**2+(Y2-Y1)**2+(Z2-Z1)**2)
         DS=DSQRT((X-X1)**2+(Y-Y1)**2+(Z-Z1)**2)
         FRAC=DS/SS
         BX=BX1*(1.D0-FRAC)+BX2*FRAC
         BY=BY1*(1.D0-FRAC)+BY2*FRAC
         BZ=BZ1*(1.D0-FRAC)+BZ2*FRAC
C
        ENDIF                                              ! END OF THE CASE 3
C
        IF (LOC.EQ.4) THEN
C       print *, '  LOC=4 (south PSBL)'  !  (test printout; disabled now)
C
         T01=TETR1S-DTET0
         T02=TETR1S+DTET0
          SQR=DSQRT(R)
          ST01AS=SQR/(R3+1.D0/DSIN(T01)**6-1.D0)**0.1666666667
          ST02AS=SQR/(R3+1.D0/DSIN(T02)**6-1.D0)**0.1666666667
          CT01AS=-DSQRT(1.D0-ST01AS**2)
          CT02AS=-DSQRT(1.D0-ST02AS**2)
         XAS1=R*ST01AS*DCOS(PAS)
         Y1=  R*ST01AS*DSIN(PAS)
         ZAS1=R*CT01AS
         X1=XAS1*CPSAS+ZAS1*SPSAS
         Z1=-XAS1*SPSAS+ZAS1*CPSAS ! X1,Y1,Z1 ARE COORDS OF THE NORTHERN
C                                               BOUNDARY POINT
         XI(1)=X1
         XI(2)=Y1
         XI(3)=Z1
         XI(4)=PS
         CALL  CONDIP1(XI,D2)
          BX1=0.D0
          BY1=0.D0
          BZ1=0.D0
            DO 21 I=1,79
              BX1=BX1+C2(I)*D2(1,I) !  BX1,BY1,BZ1  ARE FIELD COMPONENTS
              BY1=BY1+C2(I)*D2(2,I)  !  IN THE NORTHERN BOUNDARY POINT
 21           BZ1=BZ1+C2(I)*D2(3,I)  !
C
         XAS2=R*ST02AS*DCOS(PAS)
         Y2=  R*ST02AS*DSIN(PAS)
         ZAS2=R*CT02AS
         X2=XAS2*CPSAS+ZAS2*SPSAS
         Z2=-XAS2*SPSAS+ZAS2*CPSAS ! X2,Y2,Z2 ARE COORDS OF THE SOUTHERN
C                                          BOUNDARY POINT
         XI(1)=X2
         XI(2)=Y2
         XI(3)=Z2
         XI(4)=PS
         CALL  DIPLOOP1(XI,D1)
          BX2=0.D0
          BY2=0.D0
          BZ2=0.D0
            DO 22 I=1,26
              BX2=BX2+C1(I)*D1(1,I) !  BX2,BY2,BZ2  ARE FIELD COMPONENTS
              BY2=BY2+C1(I)*D1(2,I) !     IN THE SOUTHERN BOUNDARY POINT
  22          BZ2=BZ2+C1(I)*D1(3,I)
C
C  NOW INTERPOLATE:
C
         SS=DSQRT((X2-X1)**2+(Y2-Y1)**2+(Z2-Z1)**2)
         DS=DSQRT((X-X1)**2+(Y-Y1)**2+(Z-Z1)**2)
         FRAC=DS/SS
         BX=BX1*(1.D0-FRAC)+BX2*FRAC
         BY=BY1*(1.D0-FRAC)+BY2*FRAC
         BZ=BZ1*(1.D0-FRAC)+BZ2*FRAC
C
        ENDIF                                        ! END OF THE CASE 4
C
C   NOW, LET US ADD THE SHIELDING FIELD
C
        CALL  BIRK1SHLD(PS,X,Y,Z,BSX,BSY,BSZ)
        BX=BX+BSX
        BY=BY+BSY
        BZ=BZ+BSZ
         RETURN
         END
C
C------------------------------------------------------------------------------
C
C
         SUBROUTINE  DIPLOOP1(XI,D)
C
C
C      Calculates dependent model variables and their deriva-
C  tives for given independent variables and model parame-
C  ters.  Specifies model functions with free parameters which
C  must be determined by means of least squares fits (RMS
C  minimization procedure).
C
C      Description of parameters:
C
C  XI  - input vector containing independent variables;
C  D   - output double precision vector containing
C        calculated values for derivatives of dependent
C        variables with respect to LINEAR model parameters;
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
c  The  26 coefficients are moments (Z- and X-components) of 12 dipoles placed
C    inside the  R1-shell,  PLUS amplitudes of two octagonal double loops.
C     The dipoles with nonzero  Yi appear in pairs with equal moments.
c                  (see the notebook #2, pp.102-103, for details)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c
         IMPLICIT  REAL * 8  (A - H, O - Z)
C
         COMMON /COORD11/ XX(12),YY(12)
         COMMON /LOOPDIP1/ TILT,XCENTRE(2),RADIUS(2),  DIPX,DIPY
         COMMON /RHDR/RH,DR
         DIMENSION XI(4),D(3,26)
C
           X = XI(1)
	   Y = XI(2)
	   Z = XI(3)
           PS= XI(4)
           SPS=DSIN(PS)
C
         DO 1 I=1,12
           R2=(XX(I)*DIPX)**2+(YY(I)*DIPY)**2
           R=DSQRT(R2)
             RMRH=R-RH
             RPRH=R+RH
             DR2=DR**2
             SQM=DSQRT(RMRH**2+DR2)
             SQP=DSQRT(RPRH**2+DR2)
             C=SQP-SQM
             Q=DSQRT((RH+1.D0)**2+DR2)-DSQRT((RH-1.D0)**2+DR2)
             SPSAS=SPS/R*C/Q
             CPSAS=DSQRT(1.D0-SPSAS**2)
         XD= (XX(I)*DIPX)*CPSAS
         YD= (YY(I)*DIPY)
         ZD=-(XX(I)*DIPX)*SPSAS
      CALL DIPXYZ(X-XD,Y-YD,Z-ZD,BX1X,BY1X,BZ1X,BX1Y,BY1Y,BZ1Y,
     *  BX1Z,BY1Z,BZ1Z)
        IF (DABS(YD).GT.1.D-10) THEN
      CALL DIPXYZ(X-XD,Y+YD,Z-ZD,BX2X,BY2X,BZ2X,BX2Y,BY2Y,BZ2Y,
     *  BX2Z,BY2Z,BZ2Z)
                                   ELSE
        BX2X=0.D0
        BY2X=0.D0
        BZ2X=0.D0
C
        BX2Z=0.D0
        BY2Z=0.D0
        BZ2Z=0.D0
                                   ENDIF
C
            D(1,I)=BX1Z+BX2Z
            D(2,I)=BY1Z+BY2Z
            D(3,I)=BZ1Z+BZ2Z
            D(1,I+12)=(BX1X+BX2X)*SPS
            D(2,I+12)=(BY1X+BY2X)*SPS
            D(3,I+12)=(BZ1X+BZ2X)*SPS
  1   CONTINUE
c
           R2=(XCENTRE(1)+RADIUS(1))**2
           R=DSQRT(R2)
             RMRH=R-RH
             RPRH=R+RH
             DR2=DR**2
             SQM=DSQRT(RMRH**2+DR2)
             SQP=DSQRT(RPRH**2+DR2)
             C=SQP-SQM
             Q=DSQRT((RH+1.D0)**2+DR2)-DSQRT((RH-1.D0)**2+DR2)
             SPSAS=SPS/R*C/Q
             CPSAS=DSQRT(1.D0-SPSAS**2)
         XOCT1= X*CPSAS-Z*SPSAS
         YOCT1= Y
         ZOCT1= X*SPSAS+Z*CPSAS
C
      CALL CROSSLP(XOCT1,YOCT1,ZOCT1,BXOCT1,BYOCT1,BZOCT1,XCENTRE(1),
     *        RADIUS(1),TILT)
            D(1,25)=BXOCT1*CPSAS+BZOCT1*SPSAS
            D(2,25)=BYOCT1
            D(3,25)=-BXOCT1*SPSAS+BZOCT1*CPSAS
C
           R2=(RADIUS(2)-XCENTRE(2))**2
           R=DSQRT(R2)
             RMRH=R-RH
             RPRH=R+RH
             DR2=DR**2
             SQM=DSQRT(RMRH**2+DR2)
             SQP=DSQRT(RPRH**2+DR2)
             C=SQP-SQM
             Q=DSQRT((RH+1.D0)**2+DR2)-DSQRT((RH-1.D0)**2+DR2)
             SPSAS=SPS/R*C/Q
             CPSAS=DSQRT(1.D0-SPSAS**2)
         XOCT2= X*CPSAS-Z*SPSAS -XCENTRE(2)
         YOCT2= Y
         ZOCT2= X*SPSAS+Z*CPSAS
            CALL CIRCLE(XOCT2,YOCT2,ZOCT2,RADIUS(2),BX,BY,BZ)
            D(1,26) =  BX*CPSAS+BZ*SPSAS
            D(2,26) =  BY
            D(3,26) = -BX*SPSAS+BZ*CPSAS
C
            RETURN
            END
c-------------------------------------------------------------------------
C
        SUBROUTINE CIRCLE(X,Y,Z,RL,BX,BY,BZ)
C
C  RETURNS COMPONENTS OF THE FIELD FROM A CIRCULAR CURRENT LOOP OF RADIUS RL
C  USES THE SECOND (MORE ACCURATE) APPROXIMATION GIVEN IN ABRAMOWITZ AND STEGUN

        IMPLICIT REAL*8 (A-H,O-Z)
        REAL*8 K
        DATA PI/3.141592654D0/
C
        RHO2=X*X+Y*Y
        RHO=DSQRT(RHO2)
        R22=Z*Z+(RHO+RL)**2
        R2=DSQRT(R22)
        R12=R22-4.D0*RHO*RL
        R32=0.5D0*(R12+R22)
        XK2=1.D0-R12/R22
        XK2S=1.D0-XK2
        DL=DLOG(1.D0/XK2S)
        K=1.38629436112d0+XK2S*(0.09666344259D0+XK2S*(0.03590092383+
     *     XK2S*(0.03742563713+XK2S*0.01451196212))) +DL*
     *     (0.5D0+XK2S*(0.12498593597D0+XK2S*(0.06880248576D0+
     *     XK2S*(0.03328355346D0+XK2S*0.00441787012D0))))
        E=1.D0+XK2S*(0.44325141463D0+XK2S*(0.0626060122D0+XK2S*
     *      (0.04757383546D0+XK2S*0.01736506451D0))) +DL*
     *     XK2S*(0.2499836831D0+XK2S*(0.09200180037D0+XK2S*
     *       (0.04069697526D0+XK2S*0.00526449639D0)))

        IF (RHO.GT.1.D-6) THEN
           BRHO=Z/(RHO2*R2)*(R32/R12*E-K) !  THIS IS NOT EXACTLY THE B-RHO COM-
                           ELSE           !   PONENT - NOTE THE ADDITIONAL
           BRHO=PI*RL/R2*(RL-RHO)/R12*Z/(R32-RHO2)  !      DIVISION BY RHO
        ENDIF

        BX=BRHO*X
        BY=BRHO*Y
        BZ=(K-E*(R32-2.D0*RL*RL)/R12)/R2
        RETURN
        END
C-------------------------------------------------------------
C
        SUBROUTINE CROSSLP(X,Y,Z,BX,BY,BZ,XC,RL,AL)
C
c   RETURNS FIELD COMPONENTS OF A PAIR OF LOOPS WITH A COMMON CENTER AND
C    DIAMETER,  COINCIDING WITH THE X AXIS. THE LOOPS ARE INCLINED TO THE
C    EQUATORIAL PLANE BY THE ANGLE AL (RADIANS) AND SHIFTED IN THE POSITIVE
C     X-DIRECTION BY THE DISTANCE  XC.
c
        IMPLICIT REAL*8 (A-H,O-Z)
C
            CAL=DCOS(AL)
            SAL=DSIN(AL)
C
        Y1=Y*CAL-Z*SAL
        Z1=Y*SAL+Z*CAL
        Y2=Y*CAL+Z*SAL
        Z2=-Y*SAL+Z*CAL
        CALL CIRCLE(X-XC,Y1,Z1,RL,BX1,BY1,BZ1)
        CALL CIRCLE(X-XC,Y2,Z2,RL,BX2,BY2,BZ2)
        BX=BX1+BX2
        BY= (BY1+BY2)*CAL+(BZ1-BZ2)*SAL
        BZ=-(BY1-BY2)*SAL+(BZ1+BZ2)*CAL
C
        RETURN
        END

C*******************************************************************

       SUBROUTINE DIPXYZ(X,Y,Z,BXX,BYX,BZX,BXY,BYY,BZY,BXZ,BYZ,BZZ)
C
C       RETURNS THE FIELD COMPONENTS PRODUCED BY THREE DIPOLES, EACH
C        HAVING M=Me AND ORIENTED PARALLEL TO X,Y, and Z AXIS, RESP.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      X2=X**2
      Y2=Y**2
      Z2=Z**2
      R2=X2+Y2+Z2

      XMR5=30574.D0/(R2*R2*DSQRT(R2))
      XMR53=3.D0*XMR5
      BXX=XMR5*(3.D0*X2-R2)
      BYX=XMR53*X*Y
      BZX=XMR53*X*Z
C
      BXY=BYX
      BYY=XMR5*(3.D0*Y2-R2)
      BZY=XMR53*Y*Z
C
      BXZ=BZX
      BYZ=BZY
      BZZ=XMR5*(3.D0*Z2-R2)
C
      RETURN
      END
C
C------------------------------------------------------------------------------
         SUBROUTINE  CONDIP1(XI,D)
C
C      Calculates dependent model variables and their derivatives for given
C  independent variables and model parameters.  Specifies model functions with
C  free parameters which must be determined by means of least squares fits
C  (RMS minimization procedure).
C
C      Description of parameters:
C
C  XI  - input vector containing independent variables;
C  D   - output double precision vector containing
C        calculated values for derivatives of dependent
C        variables with respect to LINEAR model parameters;
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
c  The  79 coefficients are (1) 5 amplitudes of the conical harmonics, plus
c                           (2) (9x3+5x2)x2=74 components of the dipole moments
c              (see the notebook #2, pp.113-..., for details)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c
         IMPLICIT  REAL * 8  (A - H, O - Z)
C
      COMMON /DX1/ DX,SCALEIN,SCALEOUT
      COMMON /COORD21/ XX(14),YY(14),ZZ(14)
c
         DIMENSION XI(4),D(3,79),CF(5),SF(5)
C
           X = XI(1)
	   Y = XI(2)
	   Z = XI(3)
           PS= XI(4)
           SPS=DSIN(PS)
           CPS=DCOS(PS)
C
      XSM=X*CPS-Z*SPS  - DX
      ZSM=Z*CPS+X*SPS
      RO2=XSM**2+Y**2
      RO=SQRT(RO2)
C
      CF(1)=XSM/RO
      SF(1)=Y/RO
C
      CF(2)=CF(1)**2-SF(1)**2
      SF(2)=2.*SF(1)*CF(1)
      CF(3)=CF(2)*CF(1)-SF(2)*SF(1)
      SF(3)=SF(2)*CF(1)+CF(2)*SF(1)
      CF(4)=CF(3)*CF(1)-SF(3)*SF(1)
      SF(4)=SF(3)*CF(1)+CF(3)*SF(1)
      CF(5)=CF(4)*CF(1)-SF(4)*SF(1)
      SF(5)=SF(4)*CF(1)+CF(4)*SF(1)
C
      R2=RO2+ZSM**2
      R=DSQRT(R2)
      C=ZSM/R
      S=RO/R
      CH=DSQRT(0.5D0*(1.D0+C))
      SH=DSQRT(0.5D0*(1.D0-C))
      TNH=SH/CH
      CNH=1.D0/TNH
C
      DO 1 M=1,5
       BT=M*CF(M)/(R*S)*(TNH**M+CNH**M)
       BF=-0.5D0*M*SF(M)/R*(TNH**(M-1)/CH**2-CNH**(M-1)/SH**2)
       BXSM=BT*C*CF(1)-BF*SF(1)
       BY=BT*C*SF(1)+BF*CF(1)
       BZSM=-BT*S
C
       D(1,M)=BXSM*CPS+BZSM*SPS
       D(2,M)=BY
  1    D(3,M)=-BXSM*SPS+BZSM*CPS
C
      XSM = X*CPS-Z*SPS
      ZSM = Z*CPS+X*SPS
C
        DO 2 I=1,9
C
        IF (I.EQ.3.OR.I.EQ.5.OR.I.EQ.6) THEN
                XD =  XX(I)*SCALEIN
                YD =  YY(I)*SCALEIN
                                         ELSE
                XD =  XX(I)*SCALEOUT
                YD =  YY(I)*SCALEOUT
        ENDIF
C
         ZD =  ZZ(I)
C
      CALL DIPXYZ(XSM-XD,Y-YD,ZSM-ZD,BX1X,BY1X,BZ1X,BX1Y,BY1Y,BZ1Y,
     *  BX1Z,BY1Z,BZ1Z)
      CALL DIPXYZ(XSM-XD,Y+YD,ZSM-ZD,BX2X,BY2X,BZ2X,BX2Y,BY2Y,BZ2Y,
     *  BX2Z,BY2Z,BZ2Z)
      CALL DIPXYZ(XSM-XD,Y-YD,ZSM+ZD,BX3X,BY3X,BZ3X,BX3Y,BY3Y,BZ3Y,
     *  BX3Z,BY3Z,BZ3Z)
      CALL DIPXYZ(XSM-XD,Y+YD,ZSM+ZD,BX4X,BY4X,BZ4X,BX4Y,BY4Y,BZ4Y,
     *  BX4Z,BY4Z,BZ4Z)
C
      IX=I*3+3
      IY=IX+1
      IZ=IY+1
C
      D(1,IX)=(BX1X+BX2X-BX3X-BX4X)*CPS+(BZ1X+BZ2X-BZ3X-BZ4X)*SPS
      D(2,IX)= BY1X+BY2X-BY3X-BY4X
      D(3,IX)=(BZ1X+BZ2X-BZ3X-BZ4X)*CPS-(BX1X+BX2X-BX3X-BX4X)*SPS
C
      D(1,IY)=(BX1Y-BX2Y-BX3Y+BX4Y)*CPS+(BZ1Y-BZ2Y-BZ3Y+BZ4Y)*SPS
      D(2,IY)= BY1Y-BY2Y-BY3Y+BY4Y
      D(3,IY)=(BZ1Y-BZ2Y-BZ3Y+BZ4Y)*CPS-(BX1Y-BX2Y-BX3Y+BX4Y)*SPS
C
      D(1,IZ)=(BX1Z+BX2Z+BX3Z+BX4Z)*CPS+(BZ1Z+BZ2Z+BZ3Z+BZ4Z)*SPS
      D(2,IZ)= BY1Z+BY2Z+BY3Z+BY4Z
      D(3,IZ)=(BZ1Z+BZ2Z+BZ3Z+BZ4Z)*CPS-(BX1Z+BX2Z+BX3Z+BX4Z)*SPS
C
      IX=IX+27
      IY=IY+27
      IZ=IZ+27
C
      D(1,IX)=SPS*((BX1X+BX2X+BX3X+BX4X)*CPS+(BZ1X+BZ2X+BZ3X+BZ4X)*SPS)
      D(2,IX)=SPS*(BY1X+BY2X+BY3X+BY4X)
      D(3,IX)=SPS*((BZ1X+BZ2X+BZ3X+BZ4X)*CPS-(BX1X+BX2X+BX3X+BX4X)*SPS)
C
      D(1,IY)=SPS*((BX1Y-BX2Y+BX3Y-BX4Y)*CPS+(BZ1Y-BZ2Y+BZ3Y-BZ4Y)*SPS)
      D(2,IY)=SPS*(BY1Y-BY2Y+BY3Y-BY4Y)
      D(3,IY)=SPS*((BZ1Y-BZ2Y+BZ3Y-BZ4Y)*CPS-(BX1Y-BX2Y+BX3Y-BX4Y)*SPS)
C
      D(1,IZ)=SPS*((BX1Z+BX2Z-BX3Z-BX4Z)*CPS+(BZ1Z+BZ2Z-BZ3Z-BZ4Z)*SPS)
      D(2,IZ)=SPS*(BY1Z+BY2Z-BY3Z-BY4Z)
      D(3,IZ)=SPS*((BZ1Z+BZ2Z-BZ3Z-BZ4Z)*CPS-(BX1Z+BX2Z-BX3Z-BX4Z)*SPS)
  2   CONTINUE
C
      DO 3 I=1,5
      ZD=ZZ(I+9)
      CALL DIPXYZ(XSM,Y,ZSM-ZD,BX1X,BY1X,BZ1X,BX1Y,BY1Y,BZ1Y,BX1Z,BY1Z,
     *  BZ1Z)
      CALL DIPXYZ(XSM,Y,ZSM+ZD,BX2X,BY2X,BZ2X,BX2Y,BY2Y,BZ2Y,BX2Z,BY2Z,
     *  BZ2Z)
       IX=58+I*2
       IZ=IX+1
      D(1,IX)=(BX1X-BX2X)*CPS+(BZ1X-BZ2X)*SPS
      D(2,IX)=BY1X-BY2X
      D(3,IX)=(BZ1X-BZ2X)*CPS-(BX1X-BX2X)*SPS
C
      D(1,IZ)=(BX1Z+BX2Z)*CPS+(BZ1Z+BZ2Z)*SPS
      D(2,IZ)=BY1Z+BY2Z
      D(3,IZ)=(BZ1Z+BZ2Z)*CPS-(BX1Z+BX2Z)*SPS
C
      IX=IX+10
      IZ=IZ+10
      D(1,IX)=SPS*((BX1X+BX2X)*CPS+(BZ1X+BZ2X)*SPS)
      D(2,IX)=SPS*(BY1X+BY2X)
      D(3,IX)=SPS*((BZ1X+BZ2X)*CPS-(BX1X+BX2X)*SPS)
C
      D(1,IZ)=SPS*((BX1Z-BX2Z)*CPS+(BZ1Z-BZ2Z)*SPS)
      D(2,IZ)=SPS*(BY1Z-BY2Z)
  3   D(3,IZ)=SPS*((BZ1Z-BZ2Z)*CPS-(BX1Z-BX2Z)*SPS)
C
            RETURN
            END
C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
C
         SUBROUTINE  BIRK1SHLD(PS,X,Y,Z,BX,BY,BZ)
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  The 64 linear parameters are amplitudes of the "box" harmonics.
c The 16 nonlinear parameters are the scales Pi, and Qk entering the arguments
C  of sines/cosines and exponents in each of  32 cartesian harmonics
c  N.A. Tsyganenko, Spring 1994, adjusted for the Birkeland field Aug.22, 1995
c    Revised  June 12, 1996.
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
      IMPLICIT  REAL * 8  (A - H, O - Z)
C
      DIMENSION A(80)
      DIMENSION P1(4),R1(4),Q1(4),S1(4),RP(4),RR(4),RQ(4),RS(4)
C
      EQUIVALENCE (P1(1),A(65)),(R1(1),A(69)),(Q1(1),A(73)),
     * (S1(1),A(77))
C
      DATA A/1.174198045,-1.463820502,4.840161537,-3.674506864,
     * 82.18368896,-94.94071588,-4122.331796,4670.278676,-21.54975037,
     * 26.72661293,-72.81365728,44.09887902,40.08073706,-51.23563510,
     * 1955.348537,-1940.971550,794.0496433,-982.2441344,1889.837171,
     * -558.9779727,-1260.543238,1260.063802,-293.5942373,344.7250789,
     * -773.7002492,957.0094135,-1824.143669,520.7994379,1192.484774,
     * -1192.184565,89.15537624,-98.52042999,-0.8168777675E-01,
     * 0.4255969908E-01,0.3155237661,-0.3841755213,2.494553332,
     * -0.6571440817E-01,-2.765661310,0.4331001908,0.1099181537,
     * -0.6154126980E-01,-0.3258649260,0.6698439193,-5.542735524,
     * 0.1604203535,5.854456934,-0.8323632049,3.732608869,-3.130002153,
     * 107.0972607,-32.28483411,-115.2389298,54.45064360,-0.5826853320,
     * -3.582482231,-4.046544561,3.311978102,-104.0839563,30.26401293,
     * 97.29109008,-50.62370872,-296.3734955,127.7872523,5.303648988,
     * 10.40368955,69.65230348,466.5099509,1.645049286,3.825838190,
     * 11.66675599,558.9781177,1.826531343,2.066018073,25.40971369,
     * 990.2795225,2.319489258,4.555148484,9.691185703,591.8280358/
C
         BX=0.D0
         BY=0.D0
         BZ=0.D0
         CPS=DCOS(PS)
         SPS=DSIN(PS)
         S3PS=4.D0*CPS**2-1.D0
C
         DO 11 I=1,4
          RP(I)=1.D0/P1(I)
          RR(I)=1.D0/R1(I)
          RQ(I)=1.D0/Q1(I)
 11       RS(I)=1.D0/S1(I)
C
          L=0
C
           DO 1 M=1,2     !    M=1 IS FOR THE 1ST SUM ("PERP." SYMMETRY)
C                           AND M=2 IS FOR THE SECOND SUM ("PARALL." SYMMETRY)
             DO 2 I=1,4
                  CYPI=DCOS(Y*RP(I))
                  CYQI=DCOS(Y*RQ(I))
                  SYPI=DSIN(Y*RP(I))
                  SYQI=DSIN(Y*RQ(I))
C
                DO 3 K=1,4
                   SZRK=DSIN(Z*RR(K))
                   CZSK=DCOS(Z*RS(K))
                   CZRK=DCOS(Z*RR(K))
                   SZSK=DSIN(Z*RS(K))
                     SQPR=DSQRT(RP(I)**2+RR(K)**2)
                     SQQS=DSQRT(RQ(I)**2+RS(K)**2)
                        EPR=DEXP(X*SQPR)
                        EQS=DEXP(X*SQQS)
C
                    DO 4 N=1,2  ! N=1 IS FOR THE FIRST PART OF EACH COEFFICIENT
C                                  AND N=2 IS FOR THE SECOND ONE
                     IF (M.EQ.1) THEN
                       IF (N.EQ.1) THEN
                         HX=-SQPR*EPR*CYPI*SZRK
                         HY=RP(I)*EPR*SYPI*SZRK
                         HZ=-RR(K)*EPR*CYPI*CZRK
                                   ELSE
                         HX=HX*CPS
                         HY=HY*CPS
                         HZ=HZ*CPS
                                   ENDIF
                     ELSE
                       IF (N.EQ.1) THEN
                         HX=-SPS*SQQS*EQS*CYQI*CZSK
                         HY=SPS*RQ(I)*EQS*SYQI*CZSK
                         HZ=SPS*RS(K)*EQS*CYQI*SZSK
                                   ELSE
                         HX=HX*S3PS
                         HY=HY*S3PS
                         HZ=HZ*S3PS
                       ENDIF
                 ENDIF
       L=L+1
c
       BX=BX+A(L)*HX
       BY=BY+A(L)*HY
  4    BZ=BZ+A(L)*HZ
  3   CONTINUE
  2   CONTINUE
  1   CONTINUE
C
         RETURN
	 END
C
C##########################################################################
C
         SUBROUTINE BIRK2TOT_02(PS,X,Y,Z,BX,BY,BZ)
C
          IMPLICIT REAL*8 (A-H,O-Z)
C
          CALL BIRK2SHL(X,Y,Z,PS,WX,WY,WZ)
          CALL R2_BIRK(X,Y,Z,PS,HX,HY,HZ)
         BX=WX+HX
         BY=WY+HY
         BZ=WZ+HZ
         RETURN
         END
C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
C
C THIS CODE IS FOR THE FIELD FROM  2x2x2=8 "CARTESIAN" HARMONICS
C
         SUBROUTINE  BIRK2SHL(X,Y,Z,PS,HX,HY,HZ)
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C    The model parameters are provided to this module via common-block /A/.
C  The 16 linear parameters enter in pairs in the amplitudes of the
c       "cartesian" harmonics.
c    The 8 nonlinear parameters are the scales Pi,Ri,Qi,and Si entering the
c  arguments of exponents, sines, and cosines in each of the 8 "Cartesian"
c   harmonics
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
	 IMPLICIT  REAL * 8  (A - H, O - Z)
C
         DIMENSION P(2),R(2),Q(2),S(2)
         DIMENSION A(24)
C
         EQUIVALENCE(P(1),A(17)),(R(1),A(19)),(Q(1),A(21)),(S(1),A(23))
         DATA A/-111.6371348,124.5402702,110.3735178,-122.0095905,
     * 111.9448247,-129.1957743,-110.7586562,126.5649012,-0.7865034384,
     * -0.2483462721,0.8026023894,0.2531397188,10.72890902,0.8483902118,
     * -10.96884315,-0.8583297219,13.85650567,14.90554500,10.21914434,
     * 10.09021632,6.340382460,14.40432686,12.71023437,12.83966657/
C
            CPS=DCOS(PS)
            SPS=DSIN(PS)
            S3PS=4.D0*CPS**2-1.D0   !  THIS IS SIN(3*PS)/SIN(PS)
C
           HX=0.D0
           HY=0.D0
           HZ=0.D0
           L=0
C
           DO 1 M=1,2     !    M=1 IS FOR THE 1ST SUM ("PERP." SYMMETRY)
C                           AND M=2 IS FOR THE SECOND SUM ("PARALL." SYMMETRY)
             DO 2 I=1,2
                  CYPI=DCOS(Y/P(I))
                  CYQI=DCOS(Y/Q(I))
                  SYPI=DSIN(Y/P(I))
                  SYQI=DSIN(Y/Q(I))
C
               DO 3 K=1,2
                   SZRK=DSIN(Z/R(K))
                   CZSK=DCOS(Z/S(K))
                   CZRK=DCOS(Z/R(K))
                   SZSK=DSIN(Z/S(K))
                     SQPR=DSQRT(1.D0/P(I)**2+1.D0/R(K)**2)
                     SQQS=DSQRT(1.D0/Q(I)**2+1.D0/S(K)**2)
                        EPR=DEXP(X*SQPR)
                        EQS=DEXP(X*SQQS)
C
                   DO 4 N=1,2  ! N=1 IS FOR THE FIRST PART OF EACH COEFFICIENT
C                                  AND N=2 IS FOR THE SECOND ONE
C
                    L=L+1
                     IF (M.EQ.1) THEN
                       IF (N.EQ.1) THEN
                         DX=-SQPR*EPR*CYPI*SZRK
                         DY=EPR/P(I)*SYPI*SZRK
                         DZ=-EPR/R(K)*CYPI*CZRK
                         HX=HX+A(L)*DX
                         HY=HY+A(L)*DY
                         HZ=HZ+A(L)*DZ
                                   ELSE
                         DX=DX*CPS
                         DY=DY*CPS
                         DZ=DZ*CPS
                         HX=HX+A(L)*DX
                         HY=HY+A(L)*DY
                         HZ=HZ+A(L)*DZ
                                   ENDIF
                     ELSE
                       IF (N.EQ.1) THEN
                         DX=-SPS*SQQS*EQS*CYQI*CZSK
                         DY=SPS*EQS/Q(I)*SYQI*CZSK
                         DZ=SPS*EQS/S(K)*CYQI*SZSK
                         HX=HX+A(L)*DX
                         HY=HY+A(L)*DY
                         HZ=HZ+A(L)*DZ
                                   ELSE
                         DX=DX*S3PS
                         DY=DY*S3PS
                         DZ=DZ*S3PS
                         HX=HX+A(L)*DX
                         HY=HY+A(L)*DY
                         HZ=HZ+A(L)*DZ
                       ENDIF
                 ENDIF
c
  4   CONTINUE
  3   CONTINUE
  2   CONTINUE
  1   CONTINUE
C
         RETURN
	 END

c********************************************************************
C
       SUBROUTINE R2_BIRK(X,Y,Z,PS,BX,BY,BZ)
C
C  RETURNS THE MODEL FIELD FOR THE REGION 2 BIRKELAND CURRENT/PARTIAL RC
C    (WITHOUT SHIELDING FIELD)
C
       IMPLICIT REAL*8 (A-H,O-Z)
       SAVE PSI,CPS,SPS
       DATA DELARG/0.030D0/,DELARG1/0.015D0/,PSI/10.D0/
C
       IF (DABS(PSI-PS).GT.1.D-10) THEN
         PSI=PS
         CPS=DCOS(PS)
         SPS=DSIN(PS)
       ENDIF
C
       XSM=X*CPS-Z*SPS
       ZSM=Z*CPS+X*SPS
C
       XKS=XKSI(XSM,Y,ZSM)
      IF (XKS.LT.-(DELARG+DELARG1)) THEN
        CALL R2OUTER(XSM,Y,ZSM,BXSM,BY,BZSM)
         BXSM=-BXSM*0.02      !  ALL COMPONENTS ARE MULTIPLIED BY THE
	 BY=-BY*0.02          !  FACTOR -0.02, IN ORDER TO NORMALIZE THE
         BZSM=-BZSM*0.02      !  FIELD (SO THAT Bz=-1 nT at X=-5.3 RE, Y=Z=0)
      ENDIF
      IF (XKS.GE.-(DELARG+DELARG1).AND.XKS.LT.-DELARG+DELARG1) THEN
        CALL R2OUTER(XSM,Y,ZSM,BXSM1,BY1,BZSM1)
        CALL R2SHEET(XSM,Y,ZSM,BXSM2,BY2,BZSM2)
        F2=-0.02*TKSI(XKS,-DELARG,DELARG1)
        F1=-0.02-F2
        BXSM=BXSM1*F1+BXSM2*F2
        BY=BY1*F1+BY2*F2
        BZSM=BZSM1*F1+BZSM2*F2
      ENDIF

      IF (XKS.GE.-DELARG+DELARG1.AND.XKS.LT.DELARG-DELARG1) THEN
       CALL R2SHEET(XSM,Y,ZSM,BXSM,BY,BZSM)
         BXSM=-BXSM*0.02
         BY=-BY*0.02
         BZSM=-BZSM*0.02
      ENDIF
      IF (XKS.GE.DELARG-DELARG1.AND.XKS.LT.DELARG+DELARG1) THEN
        CALL R2INNER(XSM,Y,ZSM,BXSM1,BY1,BZSM1)
        CALL R2SHEET(XSM,Y,ZSM,BXSM2,BY2,BZSM2)
        F1=-0.02*TKSI(XKS,DELARG,DELARG1)
        F2=-0.02-F1
        BXSM=BXSM1*F1+BXSM2*F2
        BY=BY1*F1+BY2*F2
        BZSM=BZSM1*F1+BZSM2*F2
      ENDIF
      IF (XKS.GE.DELARG+DELARG1) THEN
         CALL R2INNER(XSM,Y,ZSM,BXSM,BY,BZSM)
         BXSM=-BXSM*0.02
         BY=-BY*0.02
         BZSM=-BZSM*0.02
      ENDIF
C
        BX=BXSM*CPS+BZSM*SPS
        BZ=BZSM*CPS-BXSM*SPS
C
        RETURN
        END
C
C****************************************************************

c
      SUBROUTINE R2INNER (X,Y,Z,BX,BY,BZ)
C
C
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION CBX(5),CBY(5),CBZ(5)
C
      DATA PL1,PL2,PL3,PL4,PL5,PL6,PL7,PL8/154.185,-2.12446,.601735E-01,
     * -.153954E-02,.355077E-04,29.9996,262.886,99.9132/
      DATA PN1,PN2,PN3,PN4,PN5,PN6,PN7,PN8/-8.1902,6.5239,5.504,7.7815,
     * .8573,3.0986,.0774,-.038/
C
      CALL BCONIC(X,Y,Z,CBX,CBY,CBZ,5)
C
C   NOW INTRODUCE  ONE  4-LOOP SYSTEM:
C
       CALL LOOPS4(X,Y,Z,DBX8,DBY8,DBZ8,PN1,PN2,PN3,PN4,PN5,PN6)
C
       CALL DIPDISTR(X-PN7,Y,Z,DBX6,DBY6,DBZ6,0)
       CALL DIPDISTR(X-PN8,Y,Z,DBX7,DBY7,DBZ7,1)

C                           NOW COMPUTE THE FIELD COMPONENTS:

      BX=PL1*CBX(1)+PL2*CBX(2)+PL3*CBX(3)+PL4*CBX(4)+PL5*CBX(5)
     * +PL6*DBX6+PL7*DBX7+PL8*DBX8
      BY=PL1*CBY(1)+PL2*CBY(2)+PL3*CBY(3)+PL4*CBY(4)+PL5*CBY(5)
     * +PL6*DBY6+PL7*DBY7+PL8*DBY8
      BZ=PL1*CBZ(1)+PL2*CBZ(2)+PL3*CBZ(3)+PL4*CBZ(4)+PL5*CBZ(5)
     * +PL6*DBZ6+PL7*DBZ7+PL8*DBZ8
C
      RETURN
      END
C-----------------------------------------------------------------------

      SUBROUTINE BCONIC(X,Y,Z,CBX,CBY,CBZ,NMAX)
C
c   "CONICAL" HARMONICS
c
       IMPLICIT REAL*8 (A-H,O-Z)
C
       DIMENSION CBX(NMAX),CBY(NMAX),CBZ(NMAX)

       RO2=X**2+Y**2
       RO=SQRT(RO2)
C
       CF=X/RO
       SF=Y/RO
       CFM1=1.D0
       SFM1=0.D0
C
      R2=RO2+Z**2
      R=DSQRT(R2)
      C=Z/R
      S=RO/R
      CH=DSQRT(0.5D0*(1.D0+C))
      SH=DSQRT(0.5D0*(1.D0-C))
      TNHM1=1.D0
      CNHM1=1.D0
      TNH=SH/CH
      CNH=1.D0/TNH
C
      DO 1 M=1,NMAX
        CFM=CFM1*CF-SFM1*SF
        SFM=CFM1*SF+SFM1*CF
        CFM1=CFM
        SFM1=SFM
        TNHM=TNHM1*TNH
        CNHM=CNHM1*CNH
       BT=M*CFM/(R*S)*(TNHM+CNHM)
       BF=-0.5D0*M*SFM/R*(TNHM1/CH**2-CNHM1/SH**2)
         TNHM1=TNHM
         CNHM1=CNHM
       CBX(M)=BT*C*CF-BF*SF
       CBY(M)=BT*C*SF+BF*CF
  1    CBZ(M)=-BT*S
C
       RETURN
       END

C-------------------------------------------------------------------
C
       SUBROUTINE DIPDISTR(X,Y,Z,BX,BY,BZ,MODE)
C
C   RETURNS FIELD COMPONENTS FROM A LINEAR DISTRIBUTION OF DIPOLAR SOURCES
C     ON THE Z-AXIS.  THE PARAMETER MODE DEFINES HOW THE DIPOLE STRENGTH
C     VARIES ALONG THE Z-AXIS:  MODE=0 IS FOR A STEP-FUNCTION (Mx=const > 0
c         FOR Z > 0, AND Mx=-const < 0 FOR Z < 0)
C      WHILE MODE=1 IS FOR A LINEAR VARIATION OF THE DIPOLE MOMENT DENSITY
C       SEE NB#3, PAGE 53 FOR DETAILS.
C
C
C INPUT: X,Y,Z OF A POINT OF SPACE, AND MODE
C
        IMPLICIT REAL*8 (A-H,O-Z)
        X2=X*X
        RHO2=X2+Y*Y
        R2=RHO2+Z*Z
        R3=R2*DSQRT(R2)

        IF (MODE.EQ.0) THEN
         BX=Z/RHO2**2*(R2*(Y*Y-X2)-RHO2*X2)/R3
         BY=-X*Y*Z/RHO2**2*(2.D0*R2+RHO2)/R3
         BZ=X/R3
        ELSE
         BX=Z/RHO2**2*(Y*Y-X2)
         BY=-2.D0*X*Y*Z/RHO2**2
         BZ=X/RHO2
        ENDIF
         RETURN
         END

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE R2OUTER (X,Y,Z,BX,BY,BZ)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      DATA PL1,PL2,PL3,PL4,PL5/-34.105,-2.00019,628.639,73.4847,12.5162/
      DATA PN1,PN2,PN3,PN4,PN5,PN6,PN7,PN8,PN9,PN10,PN11,PN12,PN13,PN14,
     *  PN15,PN16,PN17 /.55,.694,.0031,1.55,2.8,.1375,-.7,.2,.9625,
     * -2.994,2.925,-1.775,4.3,-.275,2.7,.4312,1.55/
c
C    THREE PAIRS OF CROSSED LOOPS:
C
      CALL CROSSLP(X,Y,Z,DBX1,DBY1,DBZ1,PN1,PN2,PN3)
      CALL CROSSLP(X,Y,Z,DBX2,DBY2,DBZ2,PN4,PN5,PN6)
      CALL CROSSLP(X,Y,Z,DBX3,DBY3,DBZ3,PN7,PN8,PN9)
C
C    NOW AN EQUATORIAL LOOP ON THE NIGHTSIDE
C
      CALL CIRCLE(X-PN10,Y,Z,PN11,DBX4,DBY4,DBZ4)
c
c   NOW A 4-LOOP SYSTEM ON THE NIGHTSIDE
c

      CALL LOOPS4(X,Y,Z,DBX5,DBY5,DBZ5,PN12,PN13,PN14,PN15,PN16,PN17)

C---------------------------------------------------------------------

C                           NOW COMPUTE THE FIELD COMPONENTS:

      BX=PL1*DBX1+PL2*DBX2+PL3*DBX3+PL4*DBX4+PL5*DBX5
      BY=PL1*DBY1+PL2*DBY2+PL3*DBY3+PL4*DBY4+PL5*DBY5
      BZ=PL1*DBZ1+PL2*DBZ2+PL3*DBZ3+PL4*DBZ4+PL5*DBZ5

       RETURN
       END
C
C--------------------------------------------------------------------
C
       SUBROUTINE LOOPS4(X,Y,Z,BX,BY,BZ,XC,YC,ZC,R,THETA,PHI)
C
C   RETURNS FIELD COMPONENTS FROM A SYSTEM OF 4 CURRENT LOOPS, POSITIONED
C     SYMMETRICALLY WITH RESPECT TO NOON-MIDNIGHT MERIDIAN AND EQUATORIAL
C      PLANES.
C  INPUT: X,Y,Z OF A POINT OF SPACE
C        XC,YC,ZC (YC > 0 AND ZC > 0) - POSITION OF THE CENTER OF THE
C                                         1ST-QUADRANT LOOP
C        R - LOOP RADIUS (THE SAME FOR ALL FOUR)
C        THETA, PHI  -  SPECIFY THE ORIENTATION OF THE NORMAL OF THE 1ST LOOP
c      -----------------------------------------------------------

        IMPLICIT REAL*8 (A-H,O-Z)
C
          CT=DCOS(THETA)
          ST=DSIN(THETA)
          CP=DCOS(PHI)
          SP=DSIN(PHI)
C------------------------------------1ST QUADRANT:
        XS=(X-XC)*CP+(Y-YC)*SP
        YSS=(Y-YC)*CP-(X-XC)*SP
        ZS=Z-ZC
        XSS=XS*CT-ZS*ST
        ZSS=ZS*CT+XS*ST

        CALL CIRCLE(XSS,YSS,ZSS,R,BXSS,BYS,BZSS)
          BXS=BXSS*CT+BZSS*ST
          BZ1=BZSS*CT-BXSS*ST
          BX1=BXS*CP-BYS*SP
          BY1=BXS*SP+BYS*CP
C-------------------------------------2nd QUADRANT:
        XS=(X-XC)*CP-(Y+YC)*SP
        YSS=(Y+YC)*CP+(X-XC)*SP
        ZS=Z-ZC
        XSS=XS*CT-ZS*ST
        ZSS=ZS*CT+XS*ST

        CALL CIRCLE(XSS,YSS,ZSS,R,BXSS,BYS,BZSS)
          BXS=BXSS*CT+BZSS*ST
          BZ2=BZSS*CT-BXSS*ST
          BX2=BXS*CP+BYS*SP
          BY2=-BXS*SP+BYS*CP
C-------------------------------------3RD QUADRANT:
        XS=-(X-XC)*CP+(Y+YC)*SP
        YSS=-(Y+YC)*CP-(X-XC)*SP
        ZS=Z+ZC
        XSS=XS*CT-ZS*ST
        ZSS=ZS*CT+XS*ST

        CALL CIRCLE(XSS,YSS,ZSS,R,BXSS,BYS,BZSS)
          BXS=BXSS*CT+BZSS*ST
          BZ3=BZSS*CT-BXSS*ST
          BX3=-BXS*CP-BYS*SP
          BY3=BXS*SP-BYS*CP
C-------------------------------------4TH QUADRANT:
        XS=-(X-XC)*CP-(Y-YC)*SP
        YSS=-(Y-YC)*CP+(X-XC)*SP
        ZS=Z+ZC
        XSS=XS*CT-ZS*ST
        ZSS=ZS*CT+XS*ST

        CALL CIRCLE(XSS,YSS,ZSS,R,BXSS,BYS,BZSS)
          BXS=BXSS*CT+BZSS*ST
          BZ4=BZSS*CT-BXSS*ST
          BX4=-BXS*CP+BYS*SP
          BY4=-BXS*SP-BYS*CP

        BX=BX1+BX2+BX3+BX4
        BY=BY1+BY2+BY3+BY4
        BZ=BZ1+BZ2+BZ3+BZ4

         RETURN
         END
C
C@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
C
      SUBROUTINE R2SHEET(X,Y,Z,BX,BY,BZ)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      DATA PNONX1,PNONX2,PNONX3,PNONX4,PNONX5,PNONX6,PNONX7,PNONX8,
     *     PNONY1,PNONY2,PNONY3,PNONY4,PNONY5,PNONY6,PNONY7,PNONY8,
     *     PNONZ1,PNONZ2,PNONZ3,PNONZ4,PNONZ5,PNONZ6,PNONZ7,PNONZ8
     */-19.0969D0,-9.28828D0,-0.129687D0,5.58594D0,22.5055D0,
     *  0.483750D-01,0.396953D-01,0.579023D-01,-13.6750D0,-6.70625D0,
     *  2.31875D0,11.4062D0,20.4562D0,0.478750D-01,0.363750D-01,
     * 0.567500D-01,-16.7125D0,-16.4625D0,-0.1625D0,5.1D0,23.7125D0,
     * 0.355625D-01,0.318750D-01,0.538750D-01/
C
C
      DATA A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16,A17,
     *  A18,A19,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,A32,A33,
     *  A34,A35,A36,A37,A38,A39,A40,A41,A42,A43,A44,A45,A46,A47,A48,A49,
     *  A50,A51,A52,A53,A54,A55,A56,A57,A58,A59,A60,A61,A62,A63,A64,A65,
     *  A66,A67,A68,A69,A70,A71,A72,A73,A74,A75,A76,A77,A78,A79,A80
     * /8.07190D0,-7.39582D0,-7.62341D0,0.684671D0,-13.5672D0,11.6681D0,
     * 13.1154,-0.890217D0,7.78726D0,-5.38346D0,-8.08738D0,0.609385D0,
     * -2.70410D0, 3.53741D0,3.15549D0,-1.11069D0,-8.47555D0,0.278122D0,
     *  2.73514D0,4.55625D0,13.1134D0,1.15848D0,-3.52648D0,-8.24698D0,
     * -6.85710D0,-2.81369D0, 2.03795D0, 4.64383D0,2.49309D0,-1.22041D0,
     * -1.67432D0,-0.422526D0,-5.39796D0,7.10326D0,5.53730D0,-13.1918D0,
     *  4.67853D0,-7.60329D0,-2.53066D0, 7.76338D0, 5.60165D0,5.34816D0,
     * -4.56441D0,7.05976D0,-2.62723D0,-0.529078D0,1.42019D0,-2.93919D0,
     *  55.6338D0,-1.55181D0,39.8311D0,-80.6561D0,-46.9655D0,32.8925D0,
     * -6.32296D0,19.7841D0,124.731D0,10.4347D0,-30.7581D0,102.680D0,
     * -47.4037D0,-3.31278D0,9.37141D0,-50.0268D0,-533.319D0,110.426D0,
     *  1000.20D0,-1051.40D0, 1619.48D0,589.855D0,-1462.73D0,1087.10D0,
     *  -1994.73D0,-1654.12D0,1263.33D0,-260.210D0,1424.84D0,1255.71D0,
     *  -956.733D0, 219.946D0/
C
C
      DATA B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,
     *  B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32,B33,
     *  B34,B35,B36,B37,B38,B39,B40,B41,B42,B43,B44,B45,B46,B47,B48,B49,
     *  B50,B51,B52,B53,B54,B55,B56,B57,B58,B59,B60,B61,B62,B63,B64,B65,
     *  B66,B67,B68,B69,B70,B71,B72,B73,B74,B75,B76,B77,B78,B79,B80
     */-9.08427D0,10.6777D0,10.3288D0,-0.969987D0,6.45257D0,-8.42508D0,
     * -7.97464D0,1.41996D0,-1.92490D0,3.93575D0,2.83283D0,-1.48621D0,
     *0.244033D0,-0.757941D0,-0.386557D0,0.344566D0,9.56674D0,-2.5365D0,
     * -3.32916D0,-5.86712D0,-6.19625D0,1.83879D0,2.52772D0,4.34417D0,
     * 1.87268D0,-2.13213D0,-1.69134D0,-.176379D0,-.261359D0,.566419D0,
     * 0.3138D0,-0.134699D0,-3.83086D0,-8.4154D0,4.77005D0,-9.31479D0,
     * 37.5715D0,19.3992D0,-17.9582D0,36.4604D0,-14.9993D0,-3.1442D0,
     * 6.17409D0,-15.5519D0,2.28621D0,-0.891549D-2,-.462912D0,2.47314D0,
     * 41.7555D0,208.614D0,-45.7861D0,-77.8687D0,239.357D0,-67.9226D0,
     * 66.8743D0,238.534D0,-112.136D0,16.2069D0,-40.4706D0,-134.328D0,
     * 21.56D0,-0.201725D0,2.21D0,32.5855D0,-108.217D0,-1005.98D0,
     * 585.753D0,323.668D0,-817.056D0,235.750D0,-560.965D0,-576.892D0,
     * 684.193D0,85.0275D0,168.394D0,477.776D0,-289.253D0,-123.216D0,
     * 75.6501D0,-178.605D0/
C
      DATA C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16,C17,
     *  C18,C19,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29,C30,C31,C32,C33,
     *  C34,C35,C36,C37,C38,C39,C40,C41,C42,C43,C44,C45,C46,C47,C48,C49,
     *  C50,C51,C52,C53,C54,C55,C56,C57,C58,C59,C60,C61,C62,C63,C64,C65,
     *  C66,C67,C68,C69,C70,C71,C72,C73,C74,C75,C76,C77,C78,C79,C80
     * / 1167.61D0,-917.782D0,-1253.2D0,-274.128D0,-1538.75D0,1257.62D0,
     * 1745.07D0,113.479D0,393.326D0,-426.858D0,-641.1D0,190.833D0,
     * -29.9435D0,-1.04881D0,117.125D0,-25.7663D0,-1168.16D0,910.247D0,
     * 1239.31D0,289.515D0,1540.56D0,-1248.29D0,-1727.61D0,-131.785D0,
     * -394.577D0,426.163D0,637.422D0,-187.965D0,30.0348D0,0.221898D0,
     * -116.68D0,26.0291D0,12.6804D0,4.84091D0,1.18166D0,-2.75946D0,
     * -17.9822D0,-6.80357D0,-1.47134D0,3.02266D0,4.79648D0,0.665255D0,
     * -0.256229D0,-0.857282D-1,-0.588997D0,0.634812D-1,0.164303D0,
     * -0.15285D0,22.2524D0,-22.4376D0,-3.85595D0,6.07625D0,-105.959D0,
     * -41.6698D0,0.378615D0,1.55958D0,44.3981D0,18.8521D0,3.19466D0,
     *  5.89142D0,-8.63227D0,-2.36418D0,-1.027D0,-2.31515D0,1035.38D0,
     *  2040.66D0,-131.881D0,-744.533D0,-3274.93D0,-4845.61D0,482.438D0,
     * 1567.43D0,1354.02D0,2040.47D0,-151.653D0,-845.012D0,-111.723D0,
     * -265.343D0,-26.1171D0,216.632D0/
C
c------------------------------------------------------------------
C
       XKS=XKSI(X,Y,Z)    !  variation across the current sheet
       T1X=XKS/DSQRT(XKS**2+PNONX6**2)
       T2X=PNONX7**3/DSQRT(XKS**2+PNONX7**2)**3
       T3X=XKS/DSQRT(XKS**2+PNONX8**2)**5 *3.493856D0*PNONX8**4
C
       T1Y=XKS/DSQRT(XKS**2+PNONY6**2)
       T2Y=PNONY7**3/DSQRT(XKS**2+PNONY7**2)**3
       T3Y=XKS/DSQRT(XKS**2+PNONY8**2)**5 *3.493856D0*PNONY8**4
C
       T1Z=XKS/DSQRT(XKS**2+PNONZ6**2)
       T2Z=PNONZ7**3/DSQRT(XKS**2+PNONZ7**2)**3
       T3Z=XKS/DSQRT(XKS**2+PNONZ8**2)**5 *3.493856D0*PNONZ8**4
C
      RHO2=X*X+Y*Y
      R=DSQRT(RHO2+Z*Z)
      RHO=DSQRT(RHO2)
C
      C1P=X/RHO
      S1P=Y/RHO
      S2P=2.D0*S1P*C1P
      C2P=C1P*C1P-S1P*S1P
      S3P=S2P*C1P+C2P*S1P
      C3P=C2P*C1P-S2P*S1P
      S4P=S3P*C1P+C3P*S1P
      CT=Z/R
      ST=RHO/R
C
      S1=FEXP(CT,PNONX1)
      S2=FEXP(CT,PNONX2)
      S3=FEXP(CT,PNONX3)
      S4=FEXP(CT,PNONX4)
      S5=FEXP(CT,PNONX5)
C
C                   NOW COMPUTE THE GSM FIELD COMPONENTS:
C
C
      BX=S1*((A1+A2*T1X+A3*T2X+A4*T3X)
     *        +C1P*(A5+A6*T1X+A7*T2X+A8*T3X)
     *        +C2P*(A9+A10*T1X+A11*T2X+A12*T3X)
     *        +C3P*(A13+A14*T1X+A15*T2X+A16*T3X))
     *    +S2*((A17+A18*T1X+A19*T2X+A20*T3X)
     *        +C1P*(A21+A22*T1X+A23*T2X+A24*T3X)
     *        +C2P*(A25+A26*T1X+A27*T2X+A28*T3X)
     *        +C3P*(A29+A30*T1X+A31*T2X+A32*T3X))
     *    +S3*((A33+A34*T1X+A35*T2X+A36*T3X)
     *        +C1P*(A37+A38*T1X+A39*T2X+A40*T3X)
     *        +C2P*(A41+A42*T1X+A43*T2X+A44*T3X)
     *        +C3P*(A45+A46*T1X+A47*T2X+A48*T3X))
     *    +S4*((A49+A50*T1X+A51*T2X+A52*T3X)
     *        +C1P*(A53+A54*T1X+A55*T2X+A56*T3X)
     *        +C2P*(A57+A58*T1X+A59*T2X+A60*T3X)
     *        +C3P*(A61+A62*T1X+A63*T2X+A64*T3X))
     *    +S5*((A65+A66*T1X+A67*T2X+A68*T3X)
     *        +C1P*(A69+A70*T1X+A71*T2X+A72*T3X)
     *        +C2P*(A73+A74*T1X+A75*T2X+A76*T3X)
     *        +C3P*(A77+A78*T1X+A79*T2X+A80*T3X))
C
C
      S1=FEXP(CT,PNONY1)
      S2=FEXP(CT,PNONY2)
      S3=FEXP(CT,PNONY3)
      S4=FEXP(CT,PNONY4)
      S5=FEXP(CT,PNONY5)
C
      BY=S1*(S1P*(B1+B2*T1Y+B3*T2Y+B4*T3Y)
     *      +S2P*(B5+B6*T1Y+B7*T2Y+B8*T3Y)
     *      +S3P*(B9+B10*T1Y+B11*T2Y+B12*T3Y)
     *      +S4P*(B13+B14*T1Y+B15*T2Y+B16*T3Y))
     *  +S2*(S1P*(B17+B18*T1Y+B19*T2Y+B20*T3Y)
     *      +S2P*(B21+B22*T1Y+B23*T2Y+B24*T3Y)
     *      +S3P*(B25+B26*T1Y+B27*T2Y+B28*T3Y)
     *      +S4P*(B29+B30*T1Y+B31*T2Y+B32*T3Y))
     *  +S3*(S1P*(B33+B34*T1Y+B35*T2Y+B36*T3Y)
     *      +S2P*(B37+B38*T1Y+B39*T2Y+B40*T3Y)
     *      +S3P*(B41+B42*T1Y+B43*T2Y+B44*T3Y)
     *      +S4P*(B45+B46*T1Y+B47*T2Y+B48*T3Y))
     *  +S4*(S1P*(B49+B50*T1Y+B51*T2Y+B52*T3Y)
     *      +S2P*(B53+B54*T1Y+B55*T2Y+B56*T3Y)
     *      +S3P*(B57+B58*T1Y+B59*T2Y+B60*T3Y)
     *      +S4P*(B61+B62*T1Y+B63*T2Y+B64*T3Y))
     *  +S5*(S1P*(B65+B66*T1Y+B67*T2Y+B68*T3Y)
     *      +S2P*(B69+B70*T1Y+B71*T2Y+B72*T3Y)
     *      +S3P*(B73+B74*T1Y+B75*T2Y+B76*T3Y)
     *      +S4P*(B77+B78*T1Y+B79*T2Y+B80*T3Y))
C
      S1=FEXP1(CT,PNONZ1)
      S2=FEXP1(CT,PNONZ2)
      S3=FEXP1(CT,PNONZ3)
      S4=FEXP1(CT,PNONZ4)
      S5=FEXP1(CT,PNONZ5)
C
      BZ=S1*((C1+C2*T1Z+C3*T2Z+C4*T3Z)
     *      +C1P*(C5+C6*T1Z+C7*T2Z+C8*T3Z)
     *      +C2P*(C9+C10*T1Z+C11*T2Z+C12*T3Z)
     *      +C3P*(C13+C14*T1Z+C15*T2Z+C16*T3Z))
     *   +S2*((C17+C18*T1Z+C19*T2Z+C20*T3Z)
     *      +C1P*(C21+C22*T1Z+C23*T2Z+C24*T3Z)
     *      +C2P*(C25+C26*T1Z+C27*T2Z+C28*T3Z)
     *      +C3P*(C29+C30*T1Z+C31*T2Z+C32*T3Z))
     *   +S3*((C33+C34*T1Z+C35*T2Z+C36*T3Z)
     *      +C1P*(C37+C38*T1Z+C39*T2Z+C40*T3Z)
     *      +C2P*(C41+C42*T1Z+C43*T2Z+C44*T3Z)
     *      +C3P*(C45+C46*T1Z+C47*T2Z+C48*T3Z))
     *   +S4*((C49+C50*T1Z+C51*T2Z+C52*T3Z)
     *      +C1P*(C53+C54*T1Z+C55*T2Z+C56*T3Z)
     *      +C2P*(C57+C58*T1Z+C59*T2Z+C60*T3Z)
     *      +C3P*(C61+C62*T1Z+C63*T2Z+C64*T3Z))
     *   +S5*((C65+C66*T1Z+C67*T2Z+C68*T3Z)
     *      +C1P*(C69+C70*T1Z+C71*T2Z+C72*T3Z)
     *      +C2P*(C73+C74*T1Z+C75*T2Z+C76*T3Z)
     *      +C3P*(C77+C78*T1Z+C79*T2Z+C80*T3Z))
C
       RETURN
       END
C
C^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

      DOUBLE PRECISION FUNCTION XKSI(X,Y,Z)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
C   A11 - C72, R0, and DR below  ARE STRETCH PARAMETERS (P.26-27, NB# 3),
C
      DATA A11A12,A21A22,A41A42,A51A52,A61A62,B11B12,B21B22,C61C62,
     *  C71C72,R0,DR /0.305662,-0.383593,0.2677733,-0.097656,-0.636034,
     *  -0.359862,0.424706,-0.126366,0.292578,1.21563,7.50937/

      DATA TNOON,DTETA/0.3665191,0.09599309/ ! Correspond to noon and midnight
C                                         latitudes 69 and 63.5 degs, resp.
       DR2=DR*DR
C
       X2=X*X
       Y2=Y*Y
       Z2=Z*Z
       XY=X*Y
       XYZ=XY*Z
       R2=X2+Y2+Z2
       R=DSQRT(R2)
       R3=R2*R
       R4=R2*R2
       XR=X/R
       YR=Y/R
       ZR=Z/R
C
       IF (R.LT.R0) THEN
         PR=0.D0
       ELSE
         PR=DSQRT((R-R0)**2+DR2)-DR
       ENDIF
C
      F=X+PR*(A11A12+A21A22*XR+A41A42*XR*XR+A51A52*YR*YR+
     *        A61A62*ZR*ZR)
      G=Y+PR*(B11B12*YR+B21B22*XR*YR)
      H=Z+PR*(C61C62*ZR+C71C72*XR*ZR)
      G2=G*G
C
      FGH=F**2+G2+H**2
      FGH32=DSQRT(FGH)**3
      FCHSG2=F**2+G2

      IF (FCHSG2.LT.1.D-5) THEN
         XKSI=-1.D0               !  THIS IS JUST FOR ELIMINATING PROBLEMS
         RETURN                    !  ON THE Z-AXIS
      ENDIF

      SQFCHSG2=DSQRT(FCHSG2)
      ALPHA=FCHSG2/FGH32
      THETA=TNOON+0.5D0*DTETA*(1.D0-F/SQFCHSG2)
      PHI=DSIN(THETA)**2
C
      XKSI=ALPHA-PHI
C
      RETURN
      END
C
C--------------------------------------------------------------------
C
        FUNCTION FEXP(S,A)
         IMPLICIT REAL*8 (A-H,O-Z)
          DATA E/2.718281828459D0/
          IF (A.LT.0.D0) FEXP=DSQRT(-2.D0*A*E)*S*DEXP(A*S*S)
          IF (A.GE.0.D0) FEXP=S*DEXP(A*(S*S-1.D0))
         RETURN
         END
C
C-----------------------------------------------------------------------
        FUNCTION FEXP1(S,A)
         IMPLICIT REAL*8 (A-H,O-Z)
         IF (A.LE.0.D0) FEXP1=DEXP(A*S*S)
         IF (A.GT.0.D0) FEXP1=DEXP(A*(S*S-1.D0))
         RETURN
         END
C
C************************************************************************
C
         DOUBLE PRECISION FUNCTION TKSI(XKSI,XKS0,DXKSI)
         IMPLICIT REAL*8 (A-H,O-Z)
         SAVE M,TDZ3
         DATA M/0/
C
         IF (M.EQ.0) THEN
         TDZ3=2.*DXKSI**3
         M=1
         ENDIF
C
         IF (XKSI-XKS0.LT.-DXKSI) TKSII=0.
         IF (XKSI-XKS0.GE.DXKSI)  TKSII=1.
C
         IF (XKSI.GE.XKS0-DXKSI.AND.XKSI.LT.XKS0) THEN
           BR3=(XKSI-XKS0+DXKSI)**3
           TKSII=1.5*BR3/(TDZ3+BR3)
         ENDIF
C
         IF (XKSI.GE.XKS0.AND.XKSI.LT.XKS0+DXKSI) THEN
           BR3=(XKSI-XKS0-DXKSI)**3
           TKSII=1.+1.5*BR3/(TDZ3-BR3)
         ENDIF
           TKSI=TKSII
         END
C
C~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
c
       SUBROUTINE DIPOLE(PS,X,Y,Z,BX,BY,BZ)
C
C  CALCULATES GSM COMPONENTS OF GEODIPOLE FIELD WITH THE DIPOLE MOMENT
C  CORRESPONDING TO THE EPOCH OF 1980.
C------------INPUT PARAMETERS:
C   PS - GEODIPOLE TILT ANGLE IN RADIANS, X,Y,Z - GSM COORDINATES IN RE
C------------OUTPUT PARAMETERS:
C   BX,BY,BZ - FIELD COMPONENTS IN GSM SYSTEM, IN NANOTESLA.
C
C
C                   AUTHOR: NIKOLAI A. TSYGANENKO
C                           INSTITUTE OF PHYSICS
C                           ST.-PETERSBURG STATE UNIVERSITY
C                           STARY PETERGOF 198904
C                           ST.-PETERSBURG
C                           RUSSIA
C
      IMPLICIT NONE
C
      REAL PS,X,Y,Z,BX,BY,BZ,PSI,SPS,CPS,P,U,V,T,Q
      INTEGER M

      DATA M,PSI/0,5./
      IF(M.EQ.1.AND.ABS(PS-PSI).LT.1.E-5) GOTO 1
      SPS=SIN(PS)
      CPS=COS(PS)
      PSI=PS
      M=1
  1   P=X**2
      U=Z**2
      V=3.*Z*X
      T=Y**2
      Q=30574./SQRT(P+T+U)**5
      BX=Q*((T+U-2.*P)*SPS-V*CPS)
      BY=-3.*Y*Q*(X*SPS+Z*CPS)
      BZ=Q*((P+T-2.*U)*CPS-V*SPS)
      RETURN
      END










c----------------------------------------------------------------------------------
c----------------------------------------------------------------------------------
c----------------------------------------------------------------------------------
c----------------------------------------------------------------------------------
c----------------------------------------------------------------------------------
c----------------------------------------------------------------------------------
c----------------------------------------------------------------------------------
c                GEOPACK
c----------------------------------------------------------------------------------
c----------------------------------------------------------------------------------
c----------------------------------------------------------------------------------
c----------------------------------------------------------------------------------
c----------------------------------------------------------------------------------
c----------------------------------------------------------------------------------
c----------------------------------------------------------------------------------


c----------------------------------------------------------------------------------
c
      SUBROUTINE IGRF_GSM (XGSM,YGSM,ZGSM,HXGSM,HYGSM,HZGSM)
c
C  CALCULATES COMPONENTS OF THE MAIN (INTERNAL) GEOMAGNETIC FIELD IN THE GEOCENTRIC SOLAR
C  MAGNETOSPHERIC COORDINATE SYSTEM, USING IAGA INTERNATIONAL GEOMAGNETIC REFERENCE MODEL
C  COEFFICIENTS (e.g., http://www.ngdc.noaa.gov/IAGA/vmod/igrf.html Revised: 22 March, 2005)
c
C
C  BEFORE THE FIRST CALL OF THIS SUBROUTINE, OR IF THE DATE/TIME (IYEAR,IDAY,IHOUR,MIN,ISEC)
C  WAS CHANGED, THE MODEL COEFFICIENTS AND GEO-GSM ROTATION MATRIX ELEMENTS SHOULD BE UPDATED
c  BY CALLING THE SUBROUTINE RECALC
C
C-----INPUT PARAMETERS:
C
C     XGSM,YGSM,ZGSM - CARTESIAN GSM COORDINATES (IN UNITS RE=6371.2 KM)
C
C-----OUTPUT PARAMETERS:
C
C     HXGSM,HYGSM,HZGSM - CARTESIAN GSM COMPONENTS OF THE MAIN GEOMAGNETIC FIELD IN NANOTESLA
C
C     LAST MODIFICATION:  MAY 4, 2005.
C     THIS VERSION OF THE CODE ACCEPTS DATES FROM 1965 THROUGH 2010.
c
C     AUTHOR: N. A. TSYGANENKO
C
C
      COMMON /GEOPACK2/ G(105),H(105),REC(105)

      DIMENSION A(14),B(14)

      CALL GEOGSM (XGEO,YGEO,ZGEO,XGSM,YGSM,ZGSM,-1)
      RHO2=XGEO**2+YGEO**2
      R=SQRT(RHO2+ZGEO**2)
      C=ZGEO/R
      RHO=SQRT(RHO2)
      S=RHO/R
      IF (S.LT.1.E-5) THEN
        CF=1.
        SF=0.
      ELSE
        CF=XGEO/RHO
        SF=YGEO/RHO
      ENDIF
C
      PP=1./R
      P=PP
C
C  IN THIS NEW VERSION, THE OPTIMAL VALUE OF THE PARAMETER NM (MAXIMAL ORDER OF THE SPHERICAL
C    HARMONIC EXPANSION) IS NOT USER-PRESCRIBED, BUT CALCULATED INSIDE THE SUBROUTINE, BASED
C      ON THE VALUE OF THE RADIAL DISTANCE R:
C
      IRP3=R+2
      NM=3+30/IRP3
      IF (NM.GT.13) NM=13

      K=NM+1
      DO 150 N=1,K
         P=P*PP
         A(N)=P
150      B(N)=P*N

      P=1.
      D=0.
      BBR=0.
      BBT=0.
      BBF=0.

      DO 200 M=1,K
         IF(M.EQ.1) GOTO 160
         MM=M-1
         W=X
         X=W*CF+Y*SF
         Y=Y*CF-W*SF
         GOTO 170
160      X=0.
         Y=1.
170      Q=P
         Z=D
         BI=0.
         P2=0.
         D2=0.
         DO 190 N=M,K
            AN=A(N)
            MN=N*(N-1)/2+M
            E=G(MN)
            HH=H(MN)
            W=E*Y+HH*X
            BBR=BBR+B(N)*W*Q
            BBT=BBT-AN*W*Z
            IF(M.EQ.1) GOTO 180
            QQ=Q
            IF(S.LT.1.E-5) QQ=Z
            BI=BI+AN*(E*X-HH*Y)*QQ
180         XK=REC(MN)
            DP=C*Z-S*Q-XK*D2
            PM=C*Q-XK*P2
            D2=Z
            P2=Q
            Z=DP
190        Q=PM
         D=S*D+C*P
         P=S*P
         IF(M.EQ.1) GOTO 200
         BI=BI*MM
         BBF=BBF+BI
200   CONTINUE
C
      BR=BBR
      BT=BBT
      IF(S.LT.1.E-5) GOTO 210
      BF=BBF/S
      GOTO 211
210   IF(C.LT.0.) BBF=-BBF
      BF=BBF

211   HE=BR*S+BT*C
      HXGEO=HE*CF-BF*SF
      HYGEO=HE*SF+BF*CF
      HZGEO=BR*C-BT*S

      CALL GEOGSM (HXGEO,HYGEO,HZGEO,HXGSM,HYGSM,HZGSM,1)

      RETURN
      END
C
c==========================================================================================
C
c
      SUBROUTINE IGRF_GEO (R,THETA,PHI,BR,BTHETA,BPHI)
c
C  CALCULATES COMPONENTS OF THE MAIN (INTERNAL) GEOMAGNETIC FIELD IN THE SPHERICAL GEOGRAPHIC
C  (GEOCENTRIC) COORDINATE SYSTEM, USING IAGA INTERNATIONAL GEOMAGNETIC REFERENCE MODEL
C  COEFFICIENTS  (e.g., http://www.ngdc.noaa.gov/IAGA/vmod/igrf.html, revised: 22 March, 2005)
C
C  BEFORE THE FIRST CALL OF THIS SUBROUTINE, OR IF THE DATE (IYEAR AND IDAY) WAS CHANGED,
C  THE MODEL COEFFICIENTS SHOULD BE UPDATED BY CALLING THE SUBROUTINE RECALC
C
C-----INPUT PARAMETERS:
C
C   R, THETA, PHI - SPHERICAL GEOGRAPHIC (GEOCENTRIC) COORDINATES:
C   RADIAL DISTANCE R IN UNITS RE=6371.2 KM, COLATITUDE THETA AND LONGITUDE PHI IN RADIANS
C
C-----OUTPUT PARAMETERS:
C
C     BR, BTHETA, BPHI - SPHERICAL COMPONENTS OF THE MAIN GEOMAGNETIC FIELD IN NANOTESLA
C      (POSITIVE BR OUTWARD, BTHETA SOUTHWARD, BPHI EASTWARD)
C
C     LAST MODIFICATION:  MAY 4, 2005.
C     THIS VERSION OF THE  CODE ACCEPTS DATES FROM 1965 THROUGH 2010.
c
C     AUTHOR: N. A. TSYGANENKO
C
C
      COMMON /GEOPACK2/ G(105),H(105),REC(105)

      DIMENSION A(14),B(14)

      C=COS(THETA)
      S=SIN(THETA)
      CF=COS(PHI)
      SF=SIN(PHI)
C
      PP=1./R
      P=PP
C
C  IN THIS NEW VERSION, THE OPTIMAL VALUE OF THE PARAMETER NM (MAXIMAL ORDER OF THE SPHERICAL
C    HARMONIC EXPANSION) IS NOT USER-PRESCRIBED, BUT CALCULATED INSIDE THE SUBROUTINE, BASED
C      ON THE VALUE OF THE RADIAL DISTANCE R:
C
      IRP3=R+2
      NM=3+30/IRP3
      IF (NM.GT.13) NM=13

      K=NM+1
      DO 150 N=1,K
         P=P*PP
         A(N)=P
150      B(N)=P*N

      P=1.
      D=0.
      BBR=0.
      BBT=0.
      BBF=0.

      DO 200 M=1,K
         IF(M.EQ.1) GOTO 160
         MM=M-1
         W=X
         X=W*CF+Y*SF
         Y=Y*CF-W*SF
         GOTO 170
160      X=0.
         Y=1.
170      Q=P
         Z=D
         BI=0.
         P2=0.
         D2=0.
         DO 190 N=M,K
            AN=A(N)
            MN=N*(N-1)/2+M
            E=G(MN)
            HH=H(MN)
            W=E*Y+HH*X
            BBR=BBR+B(N)*W*Q
            BBT=BBT-AN*W*Z
            IF(M.EQ.1) GOTO 180
            QQ=Q
            IF(S.LT.1.E-5) QQ=Z
            BI=BI+AN*(E*X-HH*Y)*QQ
180         XK=REC(MN)
            DP=C*Z-S*Q-XK*D2
            PM=C*Q-XK*P2
            D2=Z
            P2=Q
            Z=DP
190        Q=PM
         D=S*D+C*P
         P=S*P
         IF(M.EQ.1) GOTO 200
         BI=BI*MM
         BBF=BBF+BI
200   CONTINUE
C
      BR=BBR
      BTHETA=BBT
      IF(S.LT.1.E-5) GOTO 210
      BPHI=BBF/S
      RETURN
210   IF(C.LT.0.) BBF=-BBF
      BPHI=BBF

      RETURN
      END
C
c==========================================================================================
c
       SUBROUTINE DIP (XGSM,YGSM,ZGSM,BXGSM,BYGSM,BZGSM)
C
C  CALCULATES GSM COMPONENTS OF A GEODIPOLE FIELD WITH THE DIPOLE MOMENT
C  CORRESPONDING TO THE EPOCH, SPECIFIED BY CALLING SUBROUTINE RECALC (SHOULD BE
C  INVOKED BEFORE THE FIRST USE OF THIS ONE AND IN CASE THE DATE/TIME WAS CHANGED).
C
C--INPUT PARAMETERS: XGSM,YGSM,ZGSM - GSM COORDINATES IN RE (1 RE = 6371.2 km)
C
C--OUTPUT PARAMETERS: BXGSM,BYGSM,BZGSM - FIELD COMPONENTS IN GSM SYSTEM, IN NANOTESLA.
C
C  LAST MODIFICATION: MAY 4, 2005
C
C  AUTHOR: N. A. TSYGANENKO
C
      COMMON /GEOPACK1/ AAA(10),SPS,CPS,BBB(23)
      COMMON /GEOPACK2/ G(105),H(105),REC(105)

      DIPMOM=SQRT(G(2)**2+G(3)**2+H(3)**2)

      P=XGSM**2
      U=ZGSM**2
      V=3.*ZGSM*XGSM
      T=YGSM**2
      Q=DIPMOM/SQRT(P+T+U)**5
      BXGSM=Q*((T+U-2.*P)*SPS-V*CPS)
      BYGSM=-3.*YGSM*Q*(XGSM*SPS+ZGSM*CPS)
      BZGSM=Q*((P+T-2.*U)*CPS-V*SPS)
      RETURN
      END

C*******************************************************************
c
      SUBROUTINE SUN (IYEAR,IDAY,IHOUR,MIN,ISEC,GST,SLONG,SRASN,SDEC)
C
C  CALCULATES FOUR QUANTITIES NECESSARY FOR COORDINATE TRANSFORMATIONS
C  WHICH DEPEND ON SUN POSITION (AND, HENCE, ON UNIVERSAL TIME AND SEASON)
C
C-------  INPUT PARAMETERS:
C  IYR,IDAY,IHOUR,MIN,ISEC -  YEAR, DAY, AND UNIVERSAL TIME IN HOURS, MINUTES,
C    AND SECONDS  (IDAY=1 CORRESPONDS TO JANUARY 1).
C
C-------  OUTPUT PARAMETERS:
C  GST - GREENWICH MEAN SIDEREAL TIME, SLONG - LONGITUDE ALONG ECLIPTIC
C  SRASN - RIGHT ASCENSION,  SDEC - DECLINATION  OF THE SUN (RADIANS)
C  ORIGINAL VERSION OF THIS SUBROUTINE HAS BEEN COMPILED FROM:
C  RUSSELL, C.T., COSMIC ELECTRODYNAMICS, 1971, V.2, PP.184-196.
C
C  LAST MODIFICATION:  MARCH 31, 2003 (ONLY SOME NOTATION CHANGES)
C
C     ORIGINAL VERSION WRITTEN BY:    Gilbert D. Mead
C
      DOUBLE PRECISION DJ,FDAY
      DATA RAD/57.295779513/
C
      IF(IYEAR.LT.1901.OR.IYEAR.GT.2099) RETURN
      FDAY=DFLOAT(IHOUR*3600+MIN*60+ISEC)/86400.D0
      DJ=365*(IYEAR-1900)+(IYEAR-1901)/4+IDAY-0.5D0+FDAY
      T=DJ/36525.
      VL=DMOD(279.696678+0.9856473354*DJ,360.D0)
      GST=DMOD(279.690983+.9856473354*DJ+360.*FDAY+180.,360.D0)/RAD
      G=DMOD(358.475845+0.985600267*DJ,360.D0)/RAD
      SLONG=(VL+(1.91946-0.004789*T)*SIN(G)+0.020094*SIN(2.*G))/RAD
      IF(SLONG.GT.6.2831853) SLONG=SLONG-6.2831853
      IF (SLONG.LT.0.) SLONG=SLONG+6.2831853
      OBLIQ=(23.45229-0.0130125*T)/RAD
      SOB=SIN(OBLIQ)
      SLP=SLONG-9.924E-5
C
C   THE LAST CONSTANT IS A CORRECTION FOR THE ANGULAR ABERRATION  DUE TO
C   THE ORBITAL MOTION OF THE EARTH
C
      SIND=SOB*SIN(SLP)
      COSD=SQRT(1.-SIND**2)
      SC=SIND/COSD
      SDEC=ATAN(SC)
      SRASN=3.141592654-ATAN2(COS(OBLIQ)/SOB*SC,-COS(SLP)/COSD)
      RETURN
      END
C
C================================================================================
c
      SUBROUTINE SPHCAR (R,THETA,PHI,X,Y,Z,J)
C
C   CONVERTS SPHERICAL COORDS INTO CARTESIAN ONES AND VICA VERSA
C    (THETA AND PHI IN RADIANS).
C
C                  J>0            J<0
C-----INPUT:   J,R,THETA,PHI     J,X,Y,Z
C----OUTPUT:      X,Y,Z        R,THETA,PHI
C
C  NOTE: AT THE POLES (X=0 AND Y=0) WE ASSUME PHI=0 (WHEN CONVERTING
C        FROM CARTESIAN TO SPHERICAL COORDS, I.E., FOR J<0)
C
C   LAST MOFIFICATION:  APRIL 1, 2003 (ONLY SOME NOTATION CHANGES AND MORE
C                         COMMENTS ADDED)
C
C   AUTHOR:  N. A. TSYGANENKO
C
      IF(J.GT.0) GOTO 3
      SQ=X**2+Y**2
      R=SQRT(SQ+Z**2)
      IF (SQ.NE.0.) GOTO 2
      PHI=0.
      IF (Z.LT.0.) GOTO 1
      THETA=0.
      RETURN
  1   THETA=3.141592654
      RETURN
  2   SQ=SQRT(SQ)
      PHI=ATAN2(Y,X)
      THETA=ATAN2(SQ,Z)
      IF (PHI.LT.0.) PHI=PHI+6.28318531
      RETURN
  3   SQ=R*SIN(THETA)
      X=SQ*COS(PHI)
      Y=SQ*SIN(PHI)
      Z=R*COS(THETA)
      RETURN
      END
C
C===========================================================================
c
      SUBROUTINE BSPCAR (THETA,PHI,BR,BTHETA,BPHI,BX,BY,BZ)
C
C   CALCULATES CARTESIAN FIELD COMPONENTS FROM SPHERICAL ONES
C-----INPUT:   THETA,PHI - SPHERICAL ANGLES OF THE POINT IN RADIANS
C              BR,BTHETA,BPHI -  SPHERICAL COMPONENTS OF THE FIELD
C-----OUTPUT:  BX,BY,BZ - CARTESIAN COMPONENTS OF THE FIELD
C
C   LAST MOFIFICATION:  APRIL 1, 2003 (ONLY SOME NOTATION CHANGES)
C
C   WRITTEN BY:  N. A. TSYGANENKO
C
      S=SIN(THETA)
      C=COS(THETA)
      SF=SIN(PHI)
      CF=COS(PHI)
      BE=BR*S+BTHETA*C
      BX=BE*CF-BPHI*SF
      BY=BE*SF+BPHI*CF
      BZ=BR*C-BTHETA*S
      RETURN
      END
c
C==============================================================================
C
      SUBROUTINE BCARSP (X,Y,Z,BX,BY,BZ,BR,BTHETA,BPHI)
C
CALCULATES SPHERICAL FIELD COMPONENTS FROM THOSE IN CARTESIAN SYSTEM
C
C-----INPUT:   X,Y,Z  - CARTESIAN COMPONENTS OF THE POSITION VECTOR
C              BX,BY,BZ - CARTESIAN COMPONENTS OF THE FIELD VECTOR
C-----OUTPUT:  BR,BTHETA,BPHI - SPHERICAL COMPONENTS OF THE FIELD VECTOR
C
C  NOTE: AT THE POLES (THETA=0 OR THETA=PI) WE ASSUME PHI=0,
C        AND HENCE BTHETA=BX, BPHI=BY
C
C   WRITTEN AND ADDED TO THIS PACKAGE:  APRIL 1, 2003,
C   AUTHOR:   N. A. TSYGANENKO
C
      RHO2=X**2+Y**2
      R=SQRT(RHO2+Z**2)
      RHO=SQRT(RHO2)

      IF (RHO.NE.0.) THEN
        CPHI=X/RHO
        SPHI=Y/RHO
       ELSE
        CPHI=1.
        SPHI=0.
      ENDIF

      CT=Z/R
      ST=RHO/R

      BR=(X*BX+Y*BY+Z*BZ)/R
      BTHETA=(BX*CPHI+BY*SPHI)*CT-BZ*ST
      BPHI=BY*CPHI-BX*SPHI

      RETURN
      END
C
c=====================================================================================
C
      SUBROUTINE RECALC (IYEAR,IDAY,IHOUR,MIN,ISEC)
C
C  1. PREPARES ELEMENTS OF ROTATION MATRICES FOR TRANSFORMATIONS OF VECTORS BETWEEN
C     SEVERAL COORDINATE SYSTEMS, MOST FREQUENTLY USED IN SPACE PHYSICS.
C
C  2. PREPARES COEFFICIENTS USED IN THE CALCULATION OF THE MAIN GEOMAGNETIC FIELD
C      (IGRF MODEL)
C
C  THIS SUBROUTINE SHOULD BE INVOKED BEFORE USING THE FOLLOWING SUBROUTINES:
C    IGRF_GEO, IGRF_GSM, DIP, GEOMAG, GEOGSM, MAGSM, SMGSM, GSMGSE, GEIGEO.
C
C  THERE IS NO NEED TO REPEATEDLY INVOKE RECALC, IF MULTIPLE CALCULATIONS ARE MADE
C    FOR THE SAME DATE AND TIME.
C
C-----INPUT PARAMETERS:
C
C     IYEAR   -  YEAR NUMBER (FOUR DIGITS)
C     IDAY  -  DAY OF YEAR (DAY 1 = JAN 1)
C     IHOUR -  HOUR OF DAY (00 TO 23)
C     MIN   -  MINUTE OF HOUR (00 TO 59)
C     ISEC  -  SECONDS OF MINUTE (00 TO 59)
C
C-----OUTPUT PARAMETERS:   NONE (ALL OUTPUT QUANTITIES ARE PLACED
C                         INTO THE COMMON BLOCKS /GEOPACK1/ AND /GEOPACK2/)
C
C    OTHER SUBROUTINES CALLED BY THIS ONE: SUN
C
C    AUTHOR:  N.A. TSYGANENKO
C    DATE:    DEC.1, 1991
c
c    CORRECTION OF MAY 9, 2006:  INTERPOLATION OF THE COEFFICIENTS (BETWEEN
C     LABELS 50 AND 105) IS NOW MADE THROUGH THE LAST ELEMENT OF THE ARRAYS
C     G(105)  AND H(105) (PREVIOUSLY MADE ONLY THROUGH N=66, WHICH IN SOME
C     CASES CAUSED RUNTIME ERRORS)
c
C    REVISION OF MAY 3, 2005:
C     The table of IGRF coefficients was extended to include those for the epoch 2005
c       the maximal order of spherical harmonics was also increased up to 13
c         (for details, see http://www.ngdc.noaa.gov/IAGA/vmod/igrf.html)
c
C    REVISION OF APRIL 3, 2003:
c     The code now includes preparation of the model coefficients for the subroutines
c       IGRF and GEOMAG. This eliminates the need for the SAVE statements, used in the
c        old versions, making the codes easier and more compiler-independent.
C
      COMMON /GEOPACK1/ ST0,CT0,SL0,CL0,CTCL,STCL,CTSL,STSL,SFI,CFI,SPS,
     * CPS,SHI,CHI,HI,PSI,XMUT,A11,A21,A31,A12,A22,A32,A13,A23,A33,DS3,
     * CGST,SGST,BA(6)
C
C  THE COMMON BLOCK /GEOPACK1/ CONTAINS ELEMENTS OF THE ROTATION MATRICES AND OTHER
C   PARAMETERS RELATED TO THE COORDINATE TRANSFORMATIONS PERFORMED BY THIS PACKAGE
C
      COMMON /GEOPACK2/ G(105),H(105),REC(105)
C
C  THE COMMON BLOCK /GEOPACK2/ CONTAINS COEFFICIENTS OF THE IGRF FIELD MODEL, CALCULATED
C    FOR A GIVEN YEAR AND DAY FROM THEIR STANDARD EPOCH VALUES. THE ARRAY REC CONTAINS
C    COEFFICIENTS USED IN THE RECURSION RELATIONS FOR LEGENDRE ASSOCIATE POLYNOMIALS.
C
      DIMENSION G65(105),H65(105),G70(105),H70(105),G75(105),H75(105),
     + G80(105),H80(105),G85(105),H85(105),G90(105),H90(105),G95(105),
     + H95(105),G00(105),H00(105),G05(105),H05(105),
     + G10a(105),H10a(105),DG10(45),DH10(45)
c
      DATA G65/0.,-30334.,-2119.,-1662.,2997.,1594.,1297.,-2038.,1292.,
     *856.,957.,804.,479.,-390.,252.,-219.,358.,254.,-31.,-157.,-62.,
     *45.,61.,8.,-228.,4.,1.,-111.,75.,-57.,4.,13.,-26.,-6.,13.,1.,13.,
     *5.,-4.,-14.,0.,8.,-1.,11.,4.,8.,10.,2.,-13.,10.,-1.,-1.,5.,1.,-2.,
     *-2.,-3.,2.,-5.,-2.,4.,4.,0.,2.,2.,0.,39*0./
      DATA H65/0.,0.,5776.,0.,-2016.,114.,0.,-404.,240.,-165.,0.,148.,
     *-269.,13.,-269.,0.,19.,128.,-126.,-97.,81.,0.,-11.,100.,68.,-32.,
     *-8.,-7.,0.,-61.,-27.,-2.,6.,26.,-23.,-12.,0.,7.,-12.,9.,-16.,4.,
     *24.,-3.,-17.,0.,-22.,15.,7.,-4.,-5.,10.,10.,-4.,1.,0.,2.,1.,2.,
     *6.,-4.,0.,-2.,3.,0.,-6.,39*0./
c
      DATA G70/0.,-30220.,-2068.,-1781.,3000.,1611.,1287.,-2091.,1278.,
     *838.,952.,800.,461.,-395.,234.,-216.,359.,262.,-42.,-160.,-56.,
     *43.,64.,15.,-212.,2.,3.,-112.,72.,-57.,1.,14.,-22.,-2.,13.,-2.,
     *14.,6.,-2.,-13.,-3.,5.,0.,11.,3.,8.,10.,2.,-12.,10.,-1.,0.,3.,
     *1.,-1.,-3.,-3.,2.,-5.,-1.,6.,4.,1.,0.,3.,-1.,39*0./
      DATA H70/0.,0.,5737.,0.,-2047.,25.,0.,-366.,251.,-196.,0.,167.,
     *-266.,26.,-279.,0.,26.,139.,-139.,-91.,83.,0.,-12.,100.,72.,-37.,
     *-6.,1.,0.,-70.,-27.,-4.,8.,23.,-23.,-11.,0.,7.,-15.,6.,-17.,6.,
     *21.,-6.,-16.,0.,-21.,16.,6.,-4.,-5.,10.,11.,-2.,1.,0.,1.,1.,3.,
     *4.,-4.,0.,-1.,3.,1.,-4.,39*0./
c
      DATA G75/0.,-30100.,-2013.,-1902.,3010.,1632.,1276.,-2144.,1260.,
     *830.,946.,791.,438.,-405.,216.,-218.,356.,264.,-59.,-159.,-49.,
     *45.,66.,28.,-198.,1.,6.,-111.,71.,-56.,1.,16.,-14.,0.,12.,-5.,
     *14.,6.,-1.,-12.,-8.,4.,0.,10.,1.,7.,10.,2.,-12.,10.,-1.,-1.,4.,
     *1.,-2.,-3.,-3.,2.,-5.,-2.,5.,4.,1.,0.,3.,-1.,39*0./
      DATA H75/0.,0.,5675.,0.,-2067.,-68.,0.,-333.,262.,-223.,0.,191.,
     *-265.,39.,-288.,0.,31.,148.,-152.,-83.,88.,0.,-13.,99.,75.,-41.,
     *-4.,11.,0.,-77.,-26.,-5.,10.,22.,-23.,-12.,0.,6.,-16.,4.,-19.,6.,
     *18.,-10.,-17.,0.,-21.,16.,7.,-4.,-5.,10.,11.,-3.,1.,0.,1.,1.,3.,
     *4.,-4.,-1.,-1.,3.,1.,-5.,39*0./
c
      DATA G80/0.,-29992.,-1956.,-1997.,3027.,1663.,1281.,-2180.,1251.,
     *833.,938.,782.,398.,-419.,199.,-218.,357.,261.,-74.,-162.,-48.,
     *48.,66.,42.,-192.,4.,14.,-108.,72.,-59.,2.,21.,-12.,1.,11.,-2.,
     *18.,6.,0.,-11.,-7.,4.,3.,6.,-1.,5.,10.,1.,-12.,9.,-3.,-1.,7.,2.,
     *-5.,-4.,-4.,2.,-5.,-2.,5.,3.,1.,2.,3.,0.,39*0./
      DATA H80/0.,0.,5604.,0.,-2129.,-200.,0.,-336.,271.,-252.,0.,212.,
     *-257.,53.,-297.,0.,46.,150.,-151.,-78.,92.,0.,-15.,93.,71.,-43.,
     *-2.,17.,0.,-82.,-27.,-5.,16.,18.,-23.,-10.,0.,7.,-18.,4.,-22.,9.,
     *16.,-13.,-15.,0.,-21.,16.,9.,-5.,-6.,9.,10.,-6.,2.,0.,1.,0.,3.,
     *6.,-4.,0.,-1.,4.,0.,-6.,39*0./
c
      DATA G85/0.,-29873.,-1905.,-2072.,3044.,1687.,1296.,-2208.,1247.,
     *829.,936.,780.,361.,-424.,170.,-214.,355.,253.,-93.,-164.,-46.,
     *53.,65.,51.,-185.,4.,16.,-102.,74.,-62.,3.,24.,-6.,4.,10.,0.,21.,
     *6.,0.,-11.,-9.,4.,4.,4.,-4.,5.,10.,1.,-12.,9.,-3.,-1.,7.,1.,-5.,
     *-4.,-4.,3.,-5.,-2.,5.,3.,1.,2.,3.,0.,39*0./
      DATA H85/0.,0.,5500.,0.,-2197.,-306.,0.,-310.,284.,-297.,0.,232.,
     *-249.,69.,-297.,0.,47.,150.,-154.,-75.,95.,0.,-16.,88.,69.,-48.,
     *-1.,21.,0.,-83.,-27.,-2.,20.,17.,-23.,-7.,0.,8.,-19.,5.,-23.,11.,
     *14.,-15.,-11.,0.,-21.,15.,9.,-6.,-6.,9.,9.,-7.,2.,0.,1.,0.,3.,
     *6.,-4.,0.,-1.,4.,0.,-6.,39*0./
c
      DATA G90/0., -29775.,  -1848.,  -2131.,   3059.,   1686.,   1314.,
     *     -2239.,   1248.,    802.,    939.,    780.,    325.,   -423.,
     *       141.,   -214.,    353.,    245.,   -109.,   -165.,    -36.,
     *        61.,     65.,     59.,   -178.,      3.,     18.,    -96.,
     *        77.,    -64.,      2.,     26.,     -1.,      5.,      9.,
     *         0.,     23.,      5.,     -1.,    -10.,    -12.,      3.,
     *         4.,      2.,     -6.,      4.,      9.,      1.,    -12.,
     *         9.,     -4.,     -2.,      7.,      1.,     -6.,     -3.,
     *        -4.,      2.,     -5.,     -2.,      4.,      3.,      1.,
     *         3.,      3.,      0.,  39*0./

      DATA H90/0.,      0.,   5406.,      0.,  -2279.,   -373.,      0.,
     *      -284.,    293.,   -352.,      0.,    247.,   -240.,     84.,
     *      -299.,      0.,     46.,    154.,   -153.,    -69.,     97.,
     *         0.,    -16.,     82.,     69.,    -52.,      1.,     24.,
     *         0.,    -80.,    -26.,      0.,     21.,     17.,    -23.,
     *        -4.,      0.,     10.,    -19.,      6.,    -22.,     12.,
     *        12.,    -16.,    -10.,      0.,    -20.,     15.,     11.,
     *        -7.,     -7.,      9.,      8.,     -7.,      2.,      0.,
     *         2.,      1.,      3.,      6.,     -4.,      0.,     -2.,
     *         3.,     -1.,     -6.,   39*0./

      DATA G95/0., -29692.,  -1784.,  -2200.,   3070.,   1681.,   1335.,
     *     -2267.,   1249.,    759.,    940.,    780.,    290.,   -418.,
     *       122.,   -214.,    352.,    235.,   -118.,   -166.,    -17.,
     *        68.,     67.,     68.,   -170.,     -1.,     19.,    -93.,
     *        77.,    -72.,      1.,     28.,      5.,      4.,      8.,
     *        -2.,     25.,      6.,     -6.,     -9.,    -14.,      9.,
     *         6.,     -5.,     -7.,      4.,      9.,      3.,    -10.,
     *         8.,     -8.,     -1.,     10.,     -2.,     -8.,     -3.,
     *        -6.,      2.,     -4.,     -1.,      4.,      2.,      2.,
     *         5.,      1.,      0.,    39*0./

      DATA H95/0.,      0.,   5306.,      0.,  -2366.,   -413.,      0.,
     *      -262.,    302.,   -427.,      0.,    262.,   -236.,     97.,
     *      -306.,      0.,     46.,    165.,   -143.,    -55.,    107.,
     *         0.,    -17.,     72.,     67.,    -58.,      1.,     36.,
     *         0.,    -69.,    -25.,      4.,     24.,     17.,    -24.,
     *        -6.,      0.,     11.,    -21.,      8.,    -23.,     15.,
     *        11.,    -16.,    -4.,      0.,    -20.,     15.,     12.,
     *        -6.,     -8.,      8.,      5.,     -8.,      3.,      0.,
     *         1.,      0.,      4.,      5.,     -5.,     -1.,     -2.,
     *         1.,     -2.,     -7.,    39*0./


      DATA G00/0.,-29619.4, -1728.2, -2267.7,  3068.4,  1670.9,  1339.6,
     *     -2288.,  1252.1,   714.5,   932.3,   786.8,    250.,   -403.,
     *      111.3,  -218.8,   351.4,   222.3,  -130.4,  -168.6,   -12.9,
     *       72.3,    68.2,    74.2,  -160.9,    -5.9,    16.9,   -90.4,
     *       79.0,   -74.0,      0.,    33.3,     9.1,     6.9,     7.3,
     *       -1.2,    24.4,     6.6,    -9.2,    -7.9,   -16.6,     9.1,
     *        7.0,    -7.9,     -7.,      5.,     9.4,      3.,   - 8.4,
     *        6.3,    -8.9,    -1.5,     9.3,    -4.3,    -8.2,    -2.6,
     *        -6.,     1.7,    -3.1,    -0.5,     3.7,      1.,      2.,
     *        4.2,     0.3,    -1.1,     2.7,    -1.7,    -1.9,     1.5,
     *       -0.1,     0.1,    -0.7,     0.7,     1.7,     0.1,     1.2,
     *        4.0,    -2.2,    -0.3,     0.2,     0.9,    -0.2,     0.9,
     *       -0.5,     0.3,    -0.3,    -0.4,    -0.1,    -0.2,    -0.4,
     *       -0.2,    -0.9,     0.3,     0.1,    -0.4,     1.3,    -0.4,
     *        0.7,    -0.4,     0.3,    -0.1,     0.4,      0.,     0.1/


      DATA H00/0.,      0.,  5186.1,      0., -2481.6,  -458.0,      0.,
     *     -227.6,   293.4,  -491.1,      0.,   272.6,  -231.9,   119.8,
     *     -303.8,      0.,    43.8,   171.9,  -133.1,   -39.3,   106.3,
     *         0.,   -17.4,    63.7,    65.1,   -61.2,     0.7,    43.8,
     *         0.,   -64.6,   -24.2,     6.2,     24.,    14.8,   -25.4,
     *       -5.8,     0.0,    11.9,   -21.5,     8.5,   -21.5,    15.5,
     *        8.9,   -14.9,    -2.1,     0.0,   -19.7,    13.4,    12.5,
     *       -6.2,    -8.4,     8.4,     3.8,    -8.2,     4.8,     0.0,
     *        1.7,     0.0,     4.0,     4.9,    -5.9,    -1.2,    -2.9,
     *        0.2,    -2.2,    -7.4,     0.0,     0.1,     1.3,    -0.9,
     *       -2.6,     0.9,    -0.7,    -2.8,    -0.9,    -1.2,    -1.9,
     *       -0.9,     0.0,    -0.4,     0.3,     2.5,    -2.6,     0.7,
     *        0.3,     0.0,     0.0,     0.3,    -0.9,    -0.4,     0.8,
     *        0.0,    -0.9,     0.2,     1.8,    -0.4,    -1.0,    -0.1,
     *        0.7,     0.3,     0.6,     0.3,    -0.2,    -0.5,    -0.9/

      DATA G05/0.,-29556.8, -1671.8, -2340.5,   3047.,  1656.9,  1335.7,
     *    -2305.3,  1246.8,   674.4,   919.8,   798.2,   211.5,  -379.5,
     *      100.2,  -227.6,   354.4,   208.8,  -136.6,  -168.3,   -14.1,
     *       72.9,    69.6,    76.6,  -151.1,   -15.0,    14.7,   -86.4,
     *       79.8,   -74.4,    -1.4,    38.6,    12.3,     9.4,     5.5,
     *        2.0,    24.8,     7.7,   -11.4,    -6.8,   -18.0,    10.0,
     *        9.4,   -11.4,    -5.0,     5.6,     9.8,     3.6,    -7.0,
     *        5.0,   -10.8,    -1.3,     8.7,    -6.7,    -9.2,    -2.2,
     *       -6.3,     1.6,    -2.5,    -0.1,     3.0,     0.3,     2.1,
     *        3.9,    -0.1,    -2.2,     2.9,    -1.6,    -1.7,     1.5,
     *       -0.2,     0.2,    -0.7,     0.5,     1.8,     0.1,     1.0,
     *        4.1,    -2.2,    -0.3,     0.3,     0.9,    -0.4,     1.0,
     *       -0.4,     0.5,    -0.3,    -0.4,     0.0,    -0.4,     0.0,
     *       -0.2,    -0.9,     0.3,     0.3,    -0.4,     1.2,    -0.4,
     *        0.7,    -0.3,     0.4,    -0.1,     0.4,    -0.1,    -0.3/

      DATA H05/0.,     0.0,  5080.0,     0.0, -2594.9,  -516.7,     0.0,
     *     -200.4,   269.3,  -524.5,     0.0,   281.4,  -225.8,   145.7,
     *     -304.7,     0.0,    42.7,   179.8,  -123.0,   -19.5,   103.6,
     *        0.0,   -20.2,    54.7,    63.7,   -63.4,     0.0,    50.3,
     *        0.0,   -61.4,   -22.5,     6.9,    25.4,    10.9,   -26.4,
     *       -4.8,     0.0,    11.2,   -21.0,     9.7,   -19.8,    16.1,
     *        7.7,   -12.8,    -0.1,     0.0,   -20.1,    12.9,    12.7,
     *       -6.7,    -8.1,     8.1,     2.9,    -7.9,     5.9,     0.0,
     *        2.4,     0.2,     4.4,     4.7,    -6.5,    -1.0,    -3.4,
     *       -0.9,    -2.3,    -8.0,     0.0,     0.3,     1.4,    -0.7,
     *       -2.4,     0.9,    -0.6,    -2.7,    -1.0,    -1.5,    -2.0,
     *       -1.4,     0.0,    -0.5,     0.3,     2.3,    -2.7,     0.6,
     *        0.4,     0.0,     0.0,     0.3,    -0.8,    -0.4,     1.0,
     *        0.0,    -0.7,     0.3,     1.7,    -0.5,    -1.0,     0.0,
     *        0.7,     0.2,     0.6,     0.4,    -0.2,    -0.5,    -1.0/


C - added/modified 16.1. 2012 - from Davide's geopack08_dp.f
C
      DATA G10a/0.,-29496.5, -1585.9, -2396.6, 3026.0,1668.6,
     *     1339.7, -2326.3,  1231.7,   634.2,  912.6, 809.0,
     *      166.6,  -357.1,    89.7,  -231.1,  357.2, 200.3,
     *     -141.2,  -163.1,    -7.7,    72.8,   68.6,  76.0,
     *     -141.4,   -22.9,    13.1,   -77.9,   80.4, -75.0,
     *       -4.7,    45.3,    14.0,    10.4,    1.6,   4.9,
     *       24.3,     8.2,   -14.5,    -5.7,  -19.3,  11.6,
     *       10.9,   -14.1,    -3.7,     5.4,     9.4,  3.4,
     *       -5.3,     3.1,   -12.4,    -0.8,     8.4, -8.4,
     *      -10.1,    -2.0,    -6.3,     0.9,    -1.1, -0.2,
     *        2.5,    -0.3,     2.2,     3.1,    -1.0, -2.8,
     *        3.0,    -1.5,    -2.1,     1.6,    -0.5,  0.5,
     *       -0.8,     0.4,     1.8,     0.2,     0.8,  3.8,
     *       -2.1,    -0.2,     0.3,     1.0,    -0.7,  0.9,
     *       -0.1,     0.5,    -0.4,    -0.4,     0.2, -0.8,
     *        0.0,    -0.2,    -0.9,     0.3,     0.4, -0.4,
     *        1.1,    -0.3,     0.8,    -0.2,     0.4,  0.0,
     *        0.4,    -0.3,    -0.3/
C
      DATA H10a/0.0,  0.0,4945.1, 0.0,-2707.7,-575.4,  0.0,
     *      -160.5,251.7,-536.8,  0.0, 286.4,-211.2,164.4,
     *      -309.2,  0.0,  44.7,188.9,-118.1,   0.1,100.9,
     *         0.0,-20.8,  44.2, 61.5, -66.3,   3.1, 54.9,
     *         0.0,-57.8, -21.2,  6.6,  24.9,   7.0,-27.7,
     *        -3.4,  0.0,  10.9,-20.0,  11.9, -17.4, 16.7,
     *         7.1,-10.8,   1.7,  0.0, -20.5,  11.6, 12.8,
     *        -7.2, -7.4,   8.0,  2.2,  -6.1,   7.0,  0.0,
     *         2.8, -0.1,   4.7,  4.4,  -7.2,  -1.0, -4.0,
     *        -2.0, -2.0,  -8.3,  0.0,   0.1,   1.7, -0.6,
     *        -1.8,  0.9,  -0.4, -2.5,  -1.3,  -2.1, -1.9,
     *        -1.8,  0.0,  -0.8,  0.3,   2.2,  -2.5,  0.5,
     *         0.6,  0.0,   0.1,  0.3,  -0.9,  -0.2,  0.8,
     *         0.0, -0.8,   0.3,  1.7,  -0.6,  -1.2, -0.1,
     *         0.5,  0.1,   0.5,  0.4,  -0.2,  -0.5, -0.8/
C
      DATA DG10/0.0,11.4,16.7,-11.3,-3.9, 2.7, 1.3,-3.9,
     *         -2.9,-8.1,-1.4,  2.0,-8.9, 4.4,-2.3,-0.5,
     *          0.5,-1.5,-0.7,  1.3, 1.4,-0.3,-0.3,-0.3,
     *          1.9,-1.6,-0.2,  1.8, 0.2,-0.1,-0.6, 1.4,
     *          0.3, 0.1,-0.8,  0.4,-0.1, 0.1,-0.5, 0.3,
     *         -0.3, 0.3, 0.2, -0.5, 0.2/
C
      DATA DH10/0.0, 0.0,-28.8,0.0,-23.0,-12.9, 0.0,8.6,
     *         -2.9,-2.1,  0.0,0.4,  3.2,  3.6,-0.8,0.0,
     *          0.5, 1.5,  0.9,3.7, -0.6, 0.0,-0.1,-2.1,
     *         -0.4,-0.5,  0.8,0.5,  0.0, 0.6, 0.3,-0.2,
     *         -0.1,-0.8, -0.3,0.2,  0.0, 0.0, 0.2, 0.5,
     *          0.4, 0.1, -0.1,0.4,  0.4/
C



C  - comented  during coef. update 13. 1. 2012


C
C
      IY=IYEAR
C
C  WE ARE RESTRICTED BY THE INTERVAL 1965-2010, FOR WHICH THE IGRF COEFFICIENTS
c    ARE KNOWN; IF IYEAR IS OUTSIDE THIS INTERVAL, THEN THE SUBROUTINE USES THE
C      NEAREST LIMITING VALUE AND PRINTS A WARNING:
C
      IF(IY.LT.1965) THEN
       IY=1965
c       WRITE (*,10) IYEAR,IY       zmena nov. 2011
      ENDIF

      IF(IY.GT.2015) THEN
       IY=2015
c       WRITE (*,10) IYEAR,IY         zmena jan. 2012
      ENDIF

C
C  CALCULATE THE ARRAY REC, CONTAINING COEFFICIENTS FOR THE RECURSION RELATIONS,
C  USED IN THE IGRF SUBROUTINE FOR CALCULATING THE ASSOCIATE LEGENDRE POLYNOMIALS
C  AND THEIR DERIVATIVES:
c
      DO 20 N=1,14
         N2=2*N-1
         N2=N2*(N2-2)
         DO 20 M=1,N
            MN=N*(N-1)/2+M
20    REC(MN)=FLOAT((N-M)*(N+M-2))/FLOAT(N2)
C
      IF (IY.LT.1970) GOTO 50          !INTERPOLATE BETWEEN 1965 - 1970
      IF (IY.LT.1975) GOTO 60          !INTERPOLATE BETWEEN 1970 - 1975
      IF (IY.LT.1980) GOTO 70          !INTERPOLATE BETWEEN 1975 - 1980
      IF (IY.LT.1985) GOTO 80          !INTERPOLATE BETWEEN 1980 - 1985
      IF (IY.LT.1990) GOTO 90          !INTERPOLATE BETWEEN 1985 - 1990
      IF (IY.LT.1995) GOTO 100         !INTERPOLATE BETWEEN 1990 - 1995
      IF (IY.LT.2000) GOTO 110         !INTERPOLATE BETWEEN 1995 - 2000
      IF (IY.LT.2005) GOTO 120         !INTERPOLATE BETWEEN 2000 - 2005
      IF (IY.LT.2010) GOTO 121         !INTERPOLATE BETWEEN 2005 - 2010
C
C       EXTRAPOLATE BEYOND 2010:
C

      DT=FLOAT(IY)+FLOAT(IDAY-1)/365.25-2005.
      DO 40 N=1,105
         G(N)=G10a(N)
         H(N)=H10a(N)
         IF (N.GT.45) GOTO 40
         G(N)=G(N)+DG10(N)*DT
         H(N)=H(N)+DH10(N)*DT
40    CONTINUE
      GOTO 300
C
C       INTERPOLATE BETWEEEN 1965 - 1970:
C
50    F2=(FLOAT(IY)+FLOAT(IDAY-1)/365.25-1965)/5.
      F1=1.-F2
      DO 55 N=1,105
         G(N)=G65(N)*F1+G70(N)*F2
55       H(N)=H65(N)*F1+H70(N)*F2
      GOTO 300
C
C       INTERPOLATE BETWEEN 1970 - 1975:
C
60    F2=(FLOAT(IY)+FLOAT(IDAY-1)/365.25-1970)/5.
      F1=1.-F2
      DO 65 N=1,105
         G(N)=G70(N)*F1+G75(N)*F2
65       H(N)=H70(N)*F1+H75(N)*F2
      GOTO 300
C
C       INTERPOLATE BETWEEN 1975 - 1980:
C
70    F2=(FLOAT(IY)+FLOAT(IDAY-1)/365.25-1975)/5.
      F1=1.-F2
      DO 75 N=1,105
         G(N)=G75(N)*F1+G80(N)*F2
75       H(N)=H75(N)*F1+H80(N)*F2
      GOTO 300
C
C       INTERPOLATE BETWEEN 1980 - 1985:
C
80    F2=(FLOAT(IY)+FLOAT(IDAY-1)/365.25-1980)/5.
      F1=1.-F2
      DO 85 N=1,105
         G(N)=G80(N)*F1+G85(N)*F2
85       H(N)=H80(N)*F1+H85(N)*F2
      GOTO 300
C
C       INTERPOLATE BETWEEN 1985 - 1990:
C
90    F2=(FLOAT(IY)+FLOAT(IDAY-1)/365.25-1985)/5.
      F1=1.-F2
      DO 95 N=1,105
         G(N)=G85(N)*F1+G90(N)*F2
95       H(N)=H85(N)*F1+H90(N)*F2
      GOTO 300
C
C       INTERPOLATE BETWEEN 1990 - 1995:
C
100   F2=(FLOAT(IY)+FLOAT(IDAY-1)/365.25-1990)/5.
      F1=1.-F2
      DO 105 N=1,105
         G(N)=G90(N)*F1+G95(N)*F2
105      H(N)=H90(N)*F1+H95(N)*F2
      GOTO 300
C
C       INTERPOLATE BETWEEN 1995 - 2000:
C
110   F2=(FLOAT(IY)+FLOAT(IDAY-1)/365.25-1995)/5.
      F1=1.-F2
      DO 115 N=1,105   !  THE 2000 COEFFICIENTS (G00) GO THROUGH THE ORDER 13, NOT 10
         G(N)=G95(N)*F1+G00(N)*F2
115      H(N)=H95(N)*F1+H00(N)*F2
      GOTO 300
C
C       INTERPOLATE BETWEEN 2000 - 2005:
C
120   F2=(FLOAT(IY)+FLOAT(IDAY-1)/365.25-2000)/5.
      F1=1.-F2
      DO 125 N=1,105
         G(N)=G00(N)*F1+G05(N)*F2
125      H(N)=H00(N)*F1+H05(N)*F2
      GOTO 300


C - added 13.1. 2012
C       INTERPOLATE BETWEEN 2005 - 2010:
C
121   F2=(FLOAT(IY)+FLOAT(IDAY-1)/365.25-2000)/5.
      F1=1.-F2
      DO 126 N=1,105
         G(N)=G05(N)*F1+G10a(N)*F2
126      H(N)=H05(N)*F1+H10a(N)*F2
      GOTO 300


C
C   COEFFICIENTS FOR A GIVEN YEAR HAVE BEEN CALCULATED; NOW MULTIPLY
C   THEM BY SCHMIDT NORMALIZATION FACTORS:
C
300   S=1.
      DO 130 N=2,14
         MN=N*(N-1)/2+1
         S=S*FLOAT(2*N-3)/FLOAT(N-1)
         G(MN)=G(MN)*S
         H(MN)=H(MN)*S
         P=S
         DO 130 M=2,N
            AA=1.
            IF (M.EQ.2) AA=2.
            P=P*SQRT(AA*FLOAT(N-M+1)/FLOAT(N+M-2))
            MNN=MN+M-1
            G(MNN)=G(MNN)*P
130         H(MNN)=H(MNN)*P

           G10=-G(2)
           G11= G(3)
           H11= H(3)
C
C  NOW CALCULATE THE COMPONENTS OF THE UNIT VECTOR EzMAG IN GEO COORD.SYSTEM:
C   SIN(TETA0)*COS(LAMBDA0), SIN(TETA0)*SIN(LAMBDA0), AND COS(TETA0)
C         ST0 * CL0                ST0 * SL0                CT0
C
      SQ=G11**2+H11**2
      SQQ=SQRT(SQ)
      SQR=SQRT(G10**2+SQ)
      SL0=-H11/SQQ
      CL0=-G11/SQQ
      ST0=SQQ/SQR
      CT0=G10/SQR
      STCL=ST0*CL0
      STSL=ST0*SL0
      CTSL=CT0*SL0
      CTCL=CT0*CL0
C
      CALL SUN (IY,IDAY,IHOUR,MIN,ISEC,GST,SLONG,SRASN,SDEC)
C
C  S1,S2, AND S3 ARE THE COMPONENTS OF THE UNIT VECTOR EXGSM=EXGSE IN THE
C   SYSTEM GEI POINTING FROM THE EARTH'S CENTER TO THE SUN:
C
      S1=COS(SRASN)*COS(SDEC)
      S2=SIN(SRASN)*COS(SDEC)
      S3=SIN(SDEC)
      CGST=COS(GST)
      SGST=SIN(GST)
C
C  DIP1, DIP2, AND DIP3 ARE THE COMPONENTS OF THE UNIT VECTOR EZSM=EZMAG
C   IN THE SYSTEM GEI:
C
      DIP1=STCL*CGST-STSL*SGST
      DIP2=STCL*SGST+STSL*CGST
      DIP3=CT0
C
C  NOW CALCULATE THE COMPONENTS OF THE UNIT VECTOR EYGSM IN THE SYSTEM GEI
C   BY TAKING THE VECTOR PRODUCT D x S AND NORMALIZING IT TO UNIT LENGTH:
C
      Y1=DIP2*S3-DIP3*S2
      Y2=DIP3*S1-DIP1*S3
      Y3=DIP1*S2-DIP2*S1
      Y=SQRT(Y1*Y1+Y2*Y2+Y3*Y3)
      Y1=Y1/Y
      Y2=Y2/Y
      Y3=Y3/Y
C
C   THEN IN THE GEI SYSTEM THE UNIT VECTOR Z = EZGSM = EXGSM x EYGSM = S x Y
C    HAS THE COMPONENTS:
C
      Z1=S2*Y3-S3*Y2
      Z2=S3*Y1-S1*Y3
      Z3=S1*Y2-S2*Y1
C
C    THE VECTOR EZGSE (HERE DZ) IN GEI HAS THE COMPONENTS (0,-SIN(DELTA),
C     COS(DELTA)) = (0.,-0.397823,0.917462); HERE DELTA = 23.44214 DEG FOR
C   THE EPOCH 1978 (SEE THE BOOK BY GUREVICH OR OTHER ASTRONOMICAL HANDBOOKS).
C    HERE THE MOST ACCURATE TIME-DEPENDENT FORMULA IS USED:
C
      DJ=FLOAT(365*(IY-1900)+(IY-1901)/4 +IDAY)
     * -0.5+FLOAT(IHOUR*3600+MIN*60+ISEC)/86400.
      T=DJ/36525.
      OBLIQ=(23.45229-0.0130125*T)/57.2957795
      DZ1=0.
      DZ2=-SIN(OBLIQ)
      DZ3=COS(OBLIQ)
C
C  THEN THE UNIT VECTOR EYGSE IN GEI SYSTEM IS THE VECTOR PRODUCT DZ x S :
C
      DY1=DZ2*S3-DZ3*S2
      DY2=DZ3*S1-DZ1*S3
      DY3=DZ1*S2-DZ2*S1
C
C   THE ELEMENTS OF THE MATRIX GSE TO GSM ARE THE SCALAR PRODUCTS:
C   CHI=EM22=(EYGSM,EYGSE), SHI=EM23=(EYGSM,EZGSE), EM32=(EZGSM,EYGSE)=-EM23,
C     AND EM33=(EZGSM,EZGSE)=EM22
C
      CHI=Y1*DY1+Y2*DY2+Y3*DY3
      SHI=Y1*DZ1+Y2*DZ2+Y3*DZ3
      HI=ASIN(SHI)
C
C    TILT ANGLE: PSI=ARCSIN(DIP,EXGSM)
C
      SPS=DIP1*S1+DIP2*S2+DIP3*S3
      CPS=SQRT(1.-SPS**2)
      PSI=ASIN(SPS)
C
C    THE ELEMENTS OF THE MATRIX MAG TO SM ARE THE SCALAR PRODUCTS:
C CFI=GM22=(EYSM,EYMAG), SFI=GM23=(EYSM,EXMAG); THEY CAN BE DERIVED AS FOLLOWS:
C
C IN GEO THE VECTORS EXMAG AND EYMAG HAVE THE COMPONENTS (CT0*CL0,CT0*SL0,-ST0)
C  AND (-SL0,CL0,0), RESPECTIVELY.    HENCE, IN GEI THE COMPONENTS ARE:
C  EXMAG:    CT0*CL0*COS(GST)-CT0*SL0*SIN(GST)
C            CT0*CL0*SIN(GST)+CT0*SL0*COS(GST)
C            -ST0
C  EYMAG:    -SL0*COS(GST)-CL0*SIN(GST)
C            -SL0*SIN(GST)+CL0*COS(GST)
C             0
C  THE COMPONENTS OF EYSM IN GEI WERE FOUND ABOVE AS Y1, Y2, AND Y3;
C  NOW WE ONLY HAVE TO COMBINE THE QUANTITIES INTO SCALAR PRODUCTS:
C
      EXMAGX=CT0*(CL0*CGST-SL0*SGST)
      EXMAGY=CT0*(CL0*SGST+SL0*CGST)
      EXMAGZ=-ST0
      EYMAGX=-(SL0*CGST+CL0*SGST)
      EYMAGY=-(SL0*SGST-CL0*CGST)
      CFI=Y1*EYMAGX+Y2*EYMAGY
      SFI=Y1*EXMAGX+Y2*EXMAGY+Y3*EXMAGZ
C
      XMUT=(ATAN2(SFI,CFI)+3.1415926536)*3.8197186342
C
C  THE ELEMENTS OF THE MATRIX GEO TO GSM ARE THE SCALAR PRODUCTS:
C
C   A11=(EXGEO,EXGSM), A12=(EYGEO,EXGSM), A13=(EZGEO,EXGSM),
C   A21=(EXGEO,EYGSM), A22=(EYGEO,EYGSM), A23=(EZGEO,EYGSM),
C   A31=(EXGEO,EZGSM), A32=(EYGEO,EZGSM), A33=(EZGEO,EZGSM),
C
C   ALL THE UNIT VECTORS IN BRACKETS ARE ALREADY DEFINED IN GEI:
C
C  EXGEO=(CGST,SGST,0), EYGEO=(-SGST,CGST,0), EZGEO=(0,0,1)
C  EXGSM=(S1,S2,S3),  EYGSM=(Y1,Y2,Y3),   EZGSM=(Z1,Z2,Z3)
C                                                           AND  THEREFORE:
C
      A11=S1*CGST+S2*SGST
      A12=-S1*SGST+S2*CGST
      A13=S3
      A21=Y1*CGST+Y2*SGST
      A22=-Y1*SGST+Y2*CGST
      A23=Y3
      A31=Z1*CGST+Z2*SGST
      A32=-Z1*SGST+Z2*CGST
      A33=Z3
C
 10   FORMAT(//1X,
     *'**** RECALC WARNS: YEAR IS OUT OF INTERVAL 1965-2010: IYEAR=',I4,
     * /,6X,'CALCULATIONS WILL BE DONE FOR IYEAR=',I4,/)
      RETURN
      END
c
c====================================================================
C
      SUBROUTINE GEOMAG (XGEO,YGEO,ZGEO,XMAG,YMAG,ZMAG,J)
C
C    CONVERTS GEOGRAPHIC (GEO) TO DIPOLE (MAG) COORDINATES OR VICA VERSA.
C
C                    J>0                       J<0
C-----INPUT:  J,XGEO,YGEO,ZGEO           J,XMAG,YMAG,ZMAG
C-----OUTPUT:    XMAG,YMAG,ZMAG           XGEO,YGEO,ZGEO
C
C
C  ATTENTION:  SUBROUTINE  RECALC  MUST BE INVOKED BEFORE GEOMAG IN TWO CASES:
C     /A/  BEFORE THE FIRST TRANSFORMATION OF COORDINATES
C     /B/  IF THE VALUES OF IYEAR AND/OR IDAY HAVE BEEN CHANGED
C
C
C   LAST MOFIFICATION:  MARCH 30, 2003 (INVOCATION OF RECALC INSIDE THIS S/R WAS REMOVED)
C
C   AUTHOR:  N. A. TSYGANENKO
C
      COMMON /GEOPACK1/ ST0,CT0,SL0,CL0,CTCL,STCL,CTSL,STSL,AB(19),BB(8)

      IF(J.GT.0) THEN
       XMAG=XGEO*CTCL+YGEO*CTSL-ZGEO*ST0
       YMAG=YGEO*CL0-XGEO*SL0
       ZMAG=XGEO*STCL+YGEO*STSL+ZGEO*CT0
      ELSE
       XGEO=XMAG*CTCL-YMAG*SL0+ZMAG*STCL
       YGEO=XMAG*CTSL+YMAG*CL0+ZMAG*STSL
       ZGEO=ZMAG*CT0-XMAG*ST0
      ENDIF

      RETURN
      END
c
c=========================================================================================
c
      SUBROUTINE GEIGEO (XGEI,YGEI,ZGEI,XGEO,YGEO,ZGEO,J)
C
C   CONVERTS EQUATORIAL INERTIAL (GEI) TO GEOGRAPHICAL (GEO) COORDS
C   OR VICA VERSA.
C                    J>0                J<0
C----INPUT:  J,XGEI,YGEI,ZGEI    J,XGEO,YGEO,ZGEO
C----OUTPUT:   XGEO,YGEO,ZGEO      XGEI,YGEI,ZGEI
C
C  ATTENTION:  SUBROUTINE  RECALC  MUST BE INVOKED BEFORE GEIGEO IN TWO CASES:
C     /A/  BEFORE THE FIRST TRANSFORMATION OF COORDINATES
C     /B/  IF THE CURRENT VALUES OF IYEAR,IDAY,IHOUR,MIN,ISEC HAVE BEEN CHANGED
C
C     LAST MODIFICATION:  MARCH 31, 2003

C     AUTHOR:  N. A. TSYGANENKO
C
      COMMON /GEOPACK1/ A(27),CGST,SGST,B(6)
C
      IF(J.GT.0) THEN
       XGEO=XGEI*CGST+YGEI*SGST
       YGEO=YGEI*CGST-XGEI*SGST
       ZGEO=ZGEI
      ELSE
       XGEI=XGEO*CGST-YGEO*SGST
       YGEI=YGEO*CGST+XGEO*SGST
       ZGEI=ZGEO
      ENDIF

      RETURN
      END
C
C=======================================================================================
C
      SUBROUTINE MAGSM (XMAG,YMAG,ZMAG,XSM,YSM,ZSM,J)
C
C  CONVERTS DIPOLE (MAG) TO SOLAR MAGNETIC (SM) COORDINATES OR VICA VERSA
C
C                    J>0              J<0
C----INPUT: J,XMAG,YMAG,ZMAG     J,XSM,YSM,ZSM
C----OUTPUT:    XSM,YSM,ZSM       XMAG,YMAG,ZMAG
C
C  ATTENTION:  SUBROUTINE  RECALC  MUST BE INVOKED BEFORE MAGSM IN TWO CASES:
C     /A/  BEFORE THE FIRST TRANSFORMATION OF COORDINATES
C     /B/  IF THE VALUES OF IYEAR,IDAY,IHOUR,MIN,ISEC HAVE BEEN CHANGED
C
C     LAST MODIFICATION:  MARCH 31, 2003
C
C     AUTHOR:  N. A. TSYGANENKO
C
      COMMON /GEOPACK1/ A(8),SFI,CFI,B(7),AB(10),BA(8)
C
      IF (J.GT.0) THEN
       XSM=XMAG*CFI-YMAG*SFI
       YSM=XMAG*SFI+YMAG*CFI
       ZSM=ZMAG
      ELSE
       XMAG=XSM*CFI+YSM*SFI
       YMAG=YSM*CFI-XSM*SFI
       ZMAG=ZSM
      ENDIF

      RETURN
      END
C
C=======================================================================================
C
       SUBROUTINE GSMGSE (XGSM,YGSM,ZGSM,XGSE,YGSE,ZGSE,J)
C
C CONVERTS GEOCENTRIC SOLAR MAGNETOSPHERIC (GSM) COORDS TO SOLAR ECLIPTIC (GSE) ONES
C   OR VICA VERSA.
C                    J>0                J<0
C-----INPUT: J,XGSM,YGSM,ZGSM    J,XGSE,YGSE,ZGSE
C----OUTPUT:   XGSE,YGSE,ZGSE      XGSM,YGSM,ZGSM
C
C  ATTENTION:  SUBROUTINE  RECALC  MUST BE INVOKED BEFORE GSMGSE IN TWO CASES:
C     /A/  BEFORE THE FIRST TRANSFORMATION OF COORDINATES
C     /B/  IF THE VALUES OF IYEAR,IDAY,IHOUR,MIN,ISEC HAVE BEEN CHANGED
C
C     LAST MODIFICATION:  MARCH 31, 2003
C
C     AUTHOR:  N. A. TSYGANENKO
C
      COMMON /GEOPACK1/ A(12),SHI,CHI,AB(13),BA(8)
C
      IF (J.GT.0) THEN
       XGSE=XGSM
       YGSE=YGSM*CHI-ZGSM*SHI
       ZGSE=YGSM*SHI+ZGSM*CHI
      ELSE
       XGSM=XGSE
       YGSM=YGSE*CHI+ZGSE*SHI
       ZGSM=ZGSE*CHI-YGSE*SHI
      ENDIF

      RETURN
      END
C
C=====================================================================================
C
       SUBROUTINE SMGSM (XSM,YSM,ZSM,XGSM,YGSM,ZGSM,J)
C
C CONVERTS SOLAR MAGNETIC (SM) TO GEOCENTRIC SOLAR MAGNETOSPHERIC
C   (GSM) COORDINATES OR VICA VERSA.
C                  J>0                 J<0
C-----INPUT: J,XSM,YSM,ZSM        J,XGSM,YGSM,ZGSM
C----OUTPUT:  XGSM,YGSM,ZGSM       XSM,YSM,ZSM
C
C  ATTENTION:  SUBROUTINE RECALC  MUST BE INVOKED BEFORE SMGSM IN TWO CASES:
C     /A/  BEFORE THE FIRST TRANSFORMATION OF COORDINATES
C     /B/  IF THE VALUES OF IYEAR,IDAY,IHOUR,MIN,ISEC HAVE BEEN CHANGED
C
C     LAST MODIFICATION:  MARCH 31, 2003
C
C     AUTHOR:  N. A. TSYGANENKO
C
      COMMON /GEOPACK1/ A(10),SPS,CPS,B(15),AB(8)

      IF (J.GT.0) THEN
       XGSM=XSM*CPS+ZSM*SPS
       YGSM=YSM
       ZGSM=ZSM*CPS-XSM*SPS
      ELSE
       XSM=XGSM*CPS-ZGSM*SPS
       YSM=YGSM
       ZSM=XGSM*SPS+ZGSM*CPS
      ENDIF

      RETURN
      END
C
C==========================================================================================
C
      SUBROUTINE GEOGSM (XGEO,YGEO,ZGEO,XGSM,YGSM,ZGSM,J)
C
C CONVERTS GEOGRAPHIC (GEO) TO GEOCENTRIC SOLAR MAGNETOSPHERIC (GSM) COORDINATES
C   OR VICA VERSA.
C
C                   J>0                   J<0
C----- INPUT:  J,XGEO,YGEO,ZGEO    J,XGSM,YGSM,ZGSM
C---- OUTPUT:    XGSM,YGSM,ZGSM      XGEO,YGEO,ZGEO
C
C  ATTENTION:  SUBROUTINE  RECALC  MUST BE INVOKED BEFORE GEOGSM IN TWO CASES:
C     /A/  BEFORE THE FIRST TRANSFORMATION OF COORDINATES
C     /B/  IF THE VALUES OF IYEAR,IDAY,IHOUR,MIN,ISEC  HAVE BEEN CHANGED
C
C     LAST MODIFICATION: MARCH 31, 2003
C
C     AUTHOR:  N. A. TSYGANENKO
C
      COMMON /GEOPACK1/AA(17),A11,A21,A31,A12,A22,A32,A13,A23,A33,D,B(8)
C
      IF (J.GT.0) THEN
       XGSM=A11*XGEO+A12*YGEO+A13*ZGEO
       YGSM=A21*XGEO+A22*YGEO+A23*ZGEO
       ZGSM=A31*XGEO+A32*YGEO+A33*ZGEO
      ELSE
       XGEO=A11*XGSM+A21*YGSM+A31*ZGSM
       YGEO=A12*XGSM+A22*YGSM+A32*ZGSM
       ZGEO=A13*XGSM+A23*YGSM+A33*ZGSM
      ENDIF

      RETURN
      END
C
C=====================================================================================
C
      SUBROUTINE RHAND (X,Y,Z,R1,R2,R3,IOPT,PARMOD,EXNAME,INNAME)
C
C  CALCULATES THE COMPONENTS OF THE RIGHT HAND SIDE VECTOR IN THE GEOMAGNETIC FIELD
C    LINE EQUATION  (a subsidiary subroutine for the subroutine STEP)
C
C     LAST MODIFICATION:  MARCH 31, 2003
C
C     AUTHOR:  N. A. TSYGANENKO
C
      DIMENSION PARMOD(10)
C
C     EXNAME AND INNAME ARE NAMES OF SUBROUTINES FOR THE EXTERNAL AND INTERNAL
C     PARTS OF THE TOTAL FIELD
C
      COMMON /GEOPACK1/ A(15),PSI,AA(10),DS3,BB(8)

      CALL EXNAME (IOPT,PARMOD,PSI,X,Y,Z,BXGSM,BYGSM,BZGSM)
      CALL INNAME (X,Y,Z,HXGSM,HYGSM,HZGSM)

      BX=BXGSM+HXGSM
      BY=BYGSM+HYGSM
      BZ=BZGSM+HZGSM
      B=DS3/SQRT(BX**2+BY**2+BZ**2)
      R1=BX*B
      R2=BY*B
      R3=BZ*B
      RETURN
      END
C
C===================================================================================
C
      SUBROUTINE STEP (X,Y,Z,DS,ERRIN,IOPT,PARMOD,EXNAME,INNAME)
C
C   RE-CALCULATES {X,Y,Z}, MAKING A STEP ALONG A FIELD LINE.
C   DS IS THE STEP SIZE, ERRIN IS PERMISSIBLE ERROR VALUE, IOPT SPECIFIES THE EXTERNAL
C   MODEL VERSION, THE ARRAY PARMOD CONTAINS INPUT PARAMETERS FOR THAT MODEL
C   EXNAME IS THE NAME OF THE EXTERNAL FIELD SUBROUTINE
C   INNAME IS THE NAME OF THE INTERNAL FIELD SUBROUTINE (EITHER DIP OR IGRF)
C
C   ALL THE PARAMETERS ARE INPUT ONES; OUTPUT IS THE RENEWED TRIPLET X,Y,Z
C
C     LAST MODIFICATION:  MARCH 31, 2003
C
C     AUTHOR:  N. A. TSYGANENKO
C
      DIMENSION PARMOD(10)
      COMMON /GEOPACK1/ A(26),DS3,B(8)
      EXTERNAL EXNAME,INNAME

  1   DS3=-DS/3.
      CALL RHAND (X,Y,Z,R11,R12,R13,IOPT,PARMOD,EXNAME,INNAME)
      CALL RHAND (X+R11,Y+R12,Z+R13,R21,R22,R23,IOPT,PARMOD,EXNAME,
     * INNAME)
      CALL RHAND (X+.5*(R11+R21),Y+.5*(R12+R22),Z+.5*
     *(R13+R23),R31,R32,R33,IOPT,PARMOD,EXNAME,INNAME)
      CALL RHAND (X+.375*(R11+3.*R31),Y+.375*(R12+3.*R32
     *),Z+.375*(R13+3.*R33),R41,R42,R43,IOPT,PARMOD,EXNAME,INNAME)
      CALL RHAND (X+1.5*(R11-3.*R31+4.*R41),Y+1.5*(R12-
     *3.*R32+4.*R42),Z+1.5*(R13-3.*R33+4.*R43),
     *R51,R52,R53,IOPT,PARMOD,EXNAME,INNAME)
      ERRCUR=ABS(R11-4.5*R31+4.*R41-.5*R51)+ABS(R12-4.5*R32+4.*R42-.5*
     *R52)+ABS(R13-4.5*R33+4.*R43-.5*R53)
      IF (ERRCUR.LT.ERRIN) GOTO 2
      DS=DS*.5
      GOTO 1
  2   X=X+.5*(R11+4.*R41+R51)
      Y=Y+.5*(R12+4.*R42+R52)
      Z=Z+.5*(R13+4.*R43+R53)
      IF(ERRCUR.LT.ERRIN*.04.AND.ABS(DS).LT.1.33) DS=DS*1.5
      RETURN
      END
C
C==============================================================================
C
      SUBROUTINE TRACE (XI,YI,ZI,DIR,RLIM,R0,IOPT,PARMOD,EXNAME,INNAME,
     *XF,YF,ZF,XX,YY,ZZ,L)
C
C  TRACES A FIELD LINE FROM AN ARBITRARY POINT OF SPACE TO THE EARTH'S
C  SURFACE OR TO A MODEL LIMITING BOUNDARY.
C
C  THE HIGHEST ORDER OF SPHERICAL HARMONICS IN THE MAIN FIELD EXPANSION USED
C  IN THE MAPPING IS CALCULATED AUTOMATICALLY. IF INNAME=IGRF_GSM, THEN AN IGRF MODEL
C  FIELD WILL BE USED, AND IF INNAME=DIP, A PURE DIPOLE FIELD WILL BE USED.

C  IN ANY CASE, BEFORE CALLING TRACE, ONE SHOULD INVOKE RECALC, TO CALCULATE CORRECT
C  VALUES OF THE IGRF COEFFICIENTS AND ALL QUANTITIES NEEDED FOR TRANSFORMATIONS
C  BETWEEN COORDINATE SYSTEMS INVOLVED IN THIS CALCULATIONS.
C
C  ALTERNATIVELY, THE SUBROUTINE RECALC CAN BE INVOKED WITH THE DESIRED VALUES OF
C  IYEAR AND IDAY (TO SPECIFY THE DIPOLE MOMENT), WHILE THE VALUES OF THE DIPOLE
C  TILT ANGLE PSI (IN RADIANS) AND ITS SINE (SPS) AND COSINE (CPS) CAN BE EXPLICITLY
C  SPECIFIED AND FORWARDED TO THE COMMON BLOCK GEOPACK1 (11th, 12th, AND 16th ELEMENTS, RESP.)
C
C------------- INPUT PARAMETERS:
C
C   XI,YI,ZI - GSM COORDS OF INITIAL POINT (IN EARTH RADII, 1 RE = 6371.2 km),
C
C   DIR - SIGN OF THE TRACING DIRECTION: IF DIR=1.0 THEN WE MOVE ANTIPARALLEL TO THE
C     FIELD VECTOR (E.G. FROM NORTHERN TO SOUTHERN CONJUGATE POINT),
C     AND IF DIR=-1.0 THEN THE TRACING GOES IN THE OPPOSITE DIRECTION.
C
C   R0 -  RADIUS OF A SPHERE (IN RE) FOR WHICH THE FIELD LINE ENDPOINT COORDINATES
C     XF,YF,ZF  SHOULD BE CALCULATED.
C
C   RLIM - UPPER LIMIT OF THE GEOCENTRIC DISTANCE, WHERE THE TRACING IS TERMINATED.
C
C   IOPT - A MODEL INDEX; CAN BE USED FOR SPECIFYING AN OPTION OF THE EXTERNAL FIELD
C       MODEL (E.G., INTERVAL OF THE KP-INDEX). ALTERNATIVELY, ONE CAN USE THE ARRAY
C       PARMOD FOR THAT PURPOSE (SEE BELOW); IN THAT CASE IOPT IS JUST A DUMMY PARAMETER.
C
C   PARMOD -  A 10-ELEMENT ARRAY CONTAINING MODEL PARAMETERS, NEEDED FOR A UNIQUE
C      SPECIFICATION OF THE EXTERNAL FIELD. THE CONCRETE MEANING OF THE COMPONENTS
C      OF PARMOD DEPENDS ON A SPECIFIC VERSION OF THE EXTERNAL FIELD MODEL.
C
C   EXNAME - NAME OF A SUBROUTINE PROVIDING COMPONENTS OF THE EXTERNAL MAGNETIC FIELD
C    (E.G., T96_01).
C   INNAME - NAME OF A SUBROUTINE PROVIDING COMPONENTS OF THE INTERNAL MAGNETIC FIELD
C    (EITHER DIP OR IGRF_GSM).
C
C-------------- OUTPUT PARAMETERS:
C
C   XF,YF,ZF - GSM COORDS OF THE LAST CALCULATED POINT OF A FIELD LINE
C   XX,YY,ZZ - ARRAYS, CONTAINING COORDS OF FIELD LINE POINTS. HERE THEIR MAXIMAL LENGTH WAS
C      ASSUMED EQUAL TO 999.
C   L - ACTUAL NUMBER OF THE CALCULATED FIELD LINE POINTS. IF L EXCEEDS 999, TRACING
C     TERMINATES, AND A WARNING IS DISPLAYED.
C
C
C     LAST MODIFICATION:  MARCH 31, 2003.
C
C     AUTHOR:  N. A. TSYGANENKO
C
      DIMENSION XX(1000),YY(1000),ZZ(1000), PARMOD(10)
      COMMON /GEOPACK1/ AA(26),DD,BB(8)
      EXTERNAL EXNAME,INNAME
C
      ERR=0.0001
      L=0
      DS=0.5*DIR
      X=XI
      Y=YI
      Z=ZI
      DD=DIR
      AL=0.
c
c  here we call RHAND just to find out the sign of the radial component of the field
c   vector, and to determine the initial direction of the tracing (i.e., either away
c   or towards Earth):
c
      CALL RHAND (X,Y,Z,R1,R2,R3,IOPT,PARMOD,EXNAME,INNAME)
      AD=0.01
      IF (X*R1+Y*R2+Z*R3.LT.0.) AD=-0.01
C
c     |AD|=0.01 and its sign follows the rule:
c (1) if DIR=1 (tracing antiparallel to B vector) then the sign of AD is the same as of Br
c (2) if DIR=-1 (tracing parallel to B vector) then the sign of AD is opposite to that of Br
c     AD is defined in order to initialize the value of RR (radial distance at previous step):

      RR=SQRT(X**2+Y**2+Z**2)+AD
  1   L=L+1
      IF(L.GT.999) GOTO 7
      XX(L)=X
      YY(L)=Y
      ZZ(L)=Z
      RYZ=Y**2+Z**2
      R2=X**2+RYZ
      R=SQRT(R2)

c  check if the line hit the outer tracing boundary; if yes, then terminate
c   the tracing (label 8):

      IF (R.GT.RLIM.OR.RYZ.GT.1600.D0.OR.X.GT.20.D0) GOTO 8
c
c  check whether or not the inner tracing boundary was crossed from outside,
c  if yes, then calculate the footpoint position by interpolation (go to label 6):
c
      IF (R.LT.R0.AND.RR.GT.R) GOTO 6

c  check if (i) we are moving outward, or (ii) we are still sufficiently
c    far from Earth (beyond R=5Re); if yes, proceed further:
c
      IF (R.GE.RR.OR.R.GT.5.) GOTO 5

c  now we moved closer inward (between R=3 and R=5); go to 3 and begin logging
c  previous values of X,Y,Z, to be used in the interpolation (after having
c  crossed the inner tracing boundary):

      IF (R.GE.3.) GOTO 3
c
c  we entered inside the sphere R=3: to avoid too large steps (and hence inaccurate
c  interpolated position of the footpoint), enforce the progressively smaller
c  stepsize values as we approach the inner boundary R=R0:
c
      FC=0.2
      IF(R-R0.LT.0.05) FC=0.05
      AL=FC*(R-R0+0.2)
      DS=DIR*AL
      GOTO 4
  3   DS=DIR
  4   XR=X
      YR=Y
      ZR=Z
  5   RR=R
      CALL STEP (X,Y,Z,DS,ERR,IOPT,PARMOD,EXNAME,INNAME)
      GOTO 1
c
c  find the footpoint position by interpolating between the current and previous
c   field line points:
c
  6   R1=(R0-R)/(RR-R)
      X=X-(X-XR)*R1
      Y=Y-(Y-YR)*R1
      Z=Z-(Z-ZR)*R1
      GOTO 8
  7   WRITE (*,10)
      L=999
  8   XF=X
      YF=Y
      ZF=Z
      RETURN
 10   FORMAT(//,1X,'**** COMPUTATIONS IN THE SUBROUTINE TRACE ARE',
     *' TERMINATED: THE CURRENT NUMBER OF POINTS EXCEEDED 1000 ****'//)
      END
c
C====================================================================================
C
      SUBROUTINE SHUETAL_MGNP(XN_PD,VEL,BZIMF,XGSM,YGSM,ZGSM,
     *  XMGNP,YMGNP,ZMGNP,DIST,ID)
C
C  FOR ANY POINT OF SPACE WITH COORDINATES (XGSM,YGSM,ZGSM) AND SPECIFIED CONDITIONS
C  IN THE INCOMING SOLAR WIND, THIS SUBROUTINE:
C
C (1) DETERMINES IF THE POINT (XGSM,YGSM,ZGSM) LIES INSIDE OR OUTSIDE THE
C      MODEL MAGNETOPAUSE OF SHUE ET AL. (JGR-A, V.103, P. 17691, 1998).
C
C (2) CALCULATES THE GSM POSITION OF A POINT {XMGNP,YMGNP,ZMGNP}, LYING AT THE MODEL
C      MAGNETOPAUSE AND ASYMPTOTICALLY TENDING TO THE NEAREST BOUNDARY POINT WITH
C      RESPECT TO THE OBSERVATION POINT {XGSM,YGSM,ZGSM}, AS IT APPROACHES THE MAGNETO-
C      PAUSE.
C
C  INPUT: XN_PD - EITHER SOLAR WIND PROTON NUMBER DENSITY (PER C.C.) (IF VEL>0)
C                    OR THE SOLAR WIND RAM PRESSURE IN NANOPASCALS   (IF VEL<0)
C         BZIMF - IMF BZ IN NANOTESLAS
C
C         VEL - EITHER SOLAR WIND VELOCITY (KM/SEC)
C                  OR ANY NEGATIVE NUMBER, WHICH INDICATES THAT XN_PD STANDS
C                     FOR THE SOLAR WIND PRESSURE, RATHER THAN FOR THE DENSITY
C
C         XGSM,YGSM,ZGSM - GSM POSITION OF THE OBSERVATION POINT IN EARTH RADII
C
C  OUTPUT: XMGNP,YMGNP,ZMGNP - GSM POSITION OF THE BOUNDARY POINT
C          DIST - DISTANCE (IN RE) BETWEEN THE OBSERVATION POINT (XGSM,YGSM,ZGSM)
C                 AND THE MODEL NAGNETOPAUSE
C          ID -  POSITION FLAG:  ID=+1 (-1) MEANS THAT THE OBSERVATION POINT
C          LIES INSIDE (OUTSIDE) OF THE MODEL MAGNETOPAUSE, RESPECTIVELY.
C
C  OTHER SUBROUTINES USED: T96_MGNP
C
c          AUTHOR:  N.A. TSYGANENKO,
C          DATE:    APRIL 4, 2003.
C
      IF (VEL.LT.0.) THEN
        PD=XN_PD
      ELSE
        PD=1.94E-6*XN_PD*VEL**2  ! PD IS THE SOLAR WIND DYNAMIC PRESSURE (IN nPa)
      ENDIF

c
c  DEFINE THE ANGLE PHI, MEASURED DUSKWARD FROM THE NOON-MIDNIGHT MERIDIAN PLANE;
C  IF THE OBSERVATION POINT LIES ON THE X AXIS, THE ANGLE PHI CANNOT BE UNIQUELY
C  DEFINED, AND WE SET IT AT ZERO:
c
      IF (YGSM.NE.0..OR.ZGSM.NE.0.) THEN
         PHI=ATAN2(YGSM,ZGSM)
      ELSE
         PHI=0.
      ENDIF
C
C  FIRST, FIND OUT IF THE OBSERVATION POINT LIES INSIDE THE SHUE ET AL BDRY
C  AND SET THE VALUE OF THE ID FLAG:
C
      ID=-1
      R0=(10.22+1.29*TANH(0.184*(BZIMF+8.14)))*PD**(-.15151515)
      ALPHA=(0.58-0.007*BZIMF)*(1.+0.024*ALOG(PD))
      R=SQRT(XGSM**2+YGSM**2+ZGSM**2)
      RM=R0*(2./(1.+XGSM/R))**ALPHA
      IF (R.LE.RM) ID=+1
C
C  NOW, FIND THE CORRESPONDING T96 MAGNETOPAUSE POSITION, TO BE USED AS
C  A STARTING APPROXIMATION IN THE SEARCH OF A CORRESPONDING SHUE ET AL.
C  BOUNDARY POINT:
C
      CALL T96_MGNP (PD,-1.,XGSM,YGSM,ZGSM,XMT96,YMT96,ZMT96,DIST,ID96)
C
      RHO2=YMT96**2+ZMT96**2
      R=SQRT(RHO2+XMT96**2)
      ST=SQRT(RHO2)/R
      CT=XMT96/R
C
C  NOW, USE NEWTON'S ITERATIVE METHOD TO FIND THE NEAREST POINT AT THE
C   SHUE ET AL.'S BOUNDARY:
C
      NIT=0

  1   T=ATAN2(ST,CT)
      RM=R0*(2./(1.+CT))**ALPHA

      F=R-RM
      GRADF_R=1.
      GRADF_T=-ALPHA/R*RM*ST/(1.+CT)
      GRADF=SQRT(GRADF_R**2+GRADF_T**2)

      DR=-F/GRADF**2
      DT= DR/R*GRADF_T

      R=R+DR
      T=T+DT
      ST=SIN(T)
      CT=COS(T)

      DS=SQRT(DR**2+(R*DT)**2)

      NIT=NIT+1

      IF (NIT.GT.1000) THEN
         PRINT *,
     *' BOUNDARY POINT COULD NOT BE FOUND; ITERATIONS DO NOT CONVERGE'
      ENDIF

      IF (DS.GT.1.E-4) GOTO 1

      XMGNP=R*COS(T)
      RHO=  R*SIN(T)

      YMGNP=RHO*SIN(PHI)
      ZMGNP=RHO*COS(PHI)

      DIST=SQRT((XGSM-XMGNP)**2+(YGSM-YMGNP)**2+(ZGSM-ZMGNP)**2)

      RETURN
      END
C
C=======================================================================================
C
      SUBROUTINE T96_MGNP (XN_PD,VEL,XGSM,YGSM,ZGSM,XMGNP,YMGNP,ZMGNP,
     * DIST,ID)
C
C  FOR ANY POINT OF SPACE WITH GIVEN COORDINATES (XGSM,YGSM,ZGSM), THIS SUBROUTINE DEFINES
C  THE POSITION OF A POINT (XMGNP,YMGNP,ZMGNP) AT THE T96 MODEL MAGNETOPAUSE, HAVING THE
C  SAME VALUE OF THE ELLIPSOIDAL TAU-COORDINATE, AND THE DISTANCE BETWEEN THEM.  THIS IS
C  NOT THE SHORTEST DISTANCE D_MIN TO THE BOUNDARY, BUT DIST ASYMPTOTICALLY TENDS TO D_MIN,
C  AS THE OBSERVATION POINT GETS CLOSER TO THE MAGNETOPAUSE.
C
C  INPUT: XN_PD - EITHER SOLAR WIND PROTON NUMBER DENSITY (PER C.C.) (IF VEL>0)
C                    OR THE SOLAR WIND RAM PRESSURE IN NANOPASCALS   (IF VEL<0)
C         VEL - EITHER SOLAR WIND VELOCITY (KM/SEC)
C                  OR ANY NEGATIVE NUMBER, WHICH INDICATES THAT XN_PD STANDS
C                     FOR THE SOLAR WIND PRESSURE, RATHER THAN FOR THE DENSITY
C
C         XGSM,YGSM,ZGSM - COORDINATES OF THE OBSERVATION POINT IN EARTH RADII
C
C  OUTPUT: XMGNP,YMGNP,ZMGNP - GSM POSITION OF THE BOUNDARY POINT, HAVING THE SAME
C          VALUE OF TAU-COORDINATE AS THE OBSERVATION POINT (XGSM,YGSM,ZGSM)
C          DIST -  THE DISTANCE BETWEEN THE TWO POINTS, IN RE,
C          ID -    POSITION FLAG; ID=+1 (-1) MEANS THAT THE POINT (XGSM,YGSM,ZGSM)
C          LIES INSIDE (OUTSIDE) THE MODEL MAGNETOPAUSE, RESPECTIVELY.
C
C  THE PRESSURE-DEPENDENT MAGNETOPAUSE IS THAT USED IN THE T96_01 MODEL
C  (TSYGANENKO, JGR, V.100, P.5599, 1995; ESA SP-389, P.181, OCT. 1996)
C
c   AUTHOR:  N.A. TSYGANENKO
C   DATE:    AUG.1, 1995, REVISED APRIL 3, 2003.
C
C
C  DEFINE SOLAR WIND DYNAMIC PRESSURE (NANOPASCALS, ASSUMING 4% OF ALPHA-PARTICLES),
C   IF NOT EXPLICITLY SPECIFIED IN THE INPUT:

      IF (VEL.LT.0.) THEN
       PD=XN_PD
      ELSE
       PD=1.94E-6*XN_PD*VEL**2
C
      ENDIF
C
C  RATIO OF PD TO THE AVERAGE PRESSURE, ASSUMED EQUAL TO 2 nPa:

      RAT=PD/2.0
      RAT16=RAT**0.14

C (THE POWER INDEX 0.14 IN THE SCALING FACTOR IS THE BEST-FIT VALUE OBTAINED FROM DATA
C    AND USED IN THE T96_01 VERSION)
C
C  VALUES OF THE MAGNETOPAUSE PARAMETERS FOR  PD = 2 nPa:
C
      A0=70.
      S00=1.08
      X00=5.48
C
C   VALUES OF THE MAGNETOPAUSE PARAMETERS, SCALED BY THE ACTUAL PRESSURE:
C
      A=A0/RAT16
      S0=S00
      X0=X00/RAT16
      XM=X0-A
C
C  (XM IS THE X-COORDINATE OF THE "SEAM" BETWEEN THE ELLIPSOID AND THE CYLINDER)
C
C     (FOR DETAILS ON THE ELLIPSOIDAL COORDINATES, SEE THE PAPER:
C      N.A.TSYGANENKO, SOLUTION OF CHAPMAN-FERRARO PROBLEM FOR AN
C      ELLIPSOIDAL MAGNETOPAUSE, PLANET.SPACE SCI., V.37, P.1037, 1989).
C
       IF (YGSM.NE.0..OR.ZGSM.NE.0.) THEN
          PHI=ATAN2(YGSM,ZGSM)
       ELSE
          PHI=0.
       ENDIF
C
       RHO=SQRT(YGSM**2+ZGSM**2)
C
       IF (XGSM.LT.XM) THEN
           XMGNP=XGSM
           RHOMGNP=A*SQRT(S0**2-1)
           YMGNP=RHOMGNP*SIN(PHI)
           ZMGNP=RHOMGNP*COS(PHI)
           DIST=SQRT((XGSM-XMGNP)**2+(YGSM-YMGNP)**2+(ZGSM-ZMGNP)**2)
           IF (RHOMGNP.GT.RHO) ID=+1
           IF (RHOMGNP.LE.RHO) ID=-1
           RETURN
       ENDIF
C
          XKSI=(XGSM-X0)/A+1.
          XDZT=RHO/A
          SQ1=SQRT((1.+XKSI)**2+XDZT**2)
          SQ2=SQRT((1.-XKSI)**2+XDZT**2)
          SIGMA=0.5*(SQ1+SQ2)
          TAU=0.5*(SQ1-SQ2)
C
C  NOW CALCULATE (X,Y,Z) FOR THE CLOSEST POINT AT THE MAGNETOPAUSE
C
          XMGNP=X0-A*(1.-S0*TAU)
          ARG=(S0**2-1.)*(1.-TAU**2)
          IF (ARG.LT.0.) ARG=0.
          RHOMGNP=A*SQRT(ARG)
          YMGNP=RHOMGNP*SIN(PHI)
          ZMGNP=RHOMGNP*COS(PHI)
C
C  NOW CALCULATE THE DISTANCE BETWEEN THE POINTS {XGSM,YGSM,ZGSM} AND {XMGNP,YMGNP,ZMGNP}:
C   (IN GENERAL, THIS IS NOT THE SHORTEST DISTANCE D_MIN, BUT DIST ASYMPTOTICALLY TENDS
C    TO D_MIN, AS WE ARE GETTING CLOSER TO THE MAGNETOPAUSE):
C
      DIST=SQRT((XGSM-XMGNP)**2+(YGSM-YMGNP)**2+(ZGSM-ZMGNP)**2)
C
      IF (SIGMA.GT.S0) ID=-1   !  ID=-1 MEANS THAT THE POINT LIES OUTSIDE
      IF (SIGMA.LE.S0) ID=+1   !  ID=+1 MEANS THAT THE POINT LIES INSIDE
C                                           THE MAGNETOSPHERE
      RETURN
      END
C
C===================================================================================