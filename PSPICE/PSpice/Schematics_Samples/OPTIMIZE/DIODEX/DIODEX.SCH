*version 7.1 2657411777
u 23
V? 2
D? 2
R? 2
PM? 3
@libraries
@analysis
.DC 1 0 3 0 1 1
+ 0 0 v1
+ 0 7 5v
.OP 0 
@targets
@attributes
@translators
a 0 u 13 0 0 0 hln 100 PCBOARDS=PCB
a 0 u 13 0 0 0 hln 100 CADSTAR=PCB
a 0 u 13 0 0 0 hln 100 EDIF=PCB
a 0 u 13 0 0 0 hln 100 ORCAD=PCB
a 0 u 13 0 0 0 hln 100 PADS=PCB
a 0 u 13 0 0 0 hln 100 PCAD=PCB
a 0 u 13 0 0 0 hln 100 PROTEL=PCB
a 0 u 13 0 0 0 hln 100 TANGO=PCB
a 0 u 13 0 0 0 hln 100 SCICARDS=PCB
a 0 u 13 0 0 0 hln 100 PSPICE=PSPICE
a 0 u 13 0 0 0 hln 100 XILINX=XILINX
a 0 u 13 0 0 0 hln 100 POLARIS=PCB
@setup
unconnectedPins 1
connectViaLabel 0
connectViaLocalLabels 0
NoStim4ExtIFPortsWarnings 1
AutoGenStim4ExtIFPorts 1
@index
pageloc 1 0 1531 
@status
n 0 96:02:15:09:38:47;826911527 e 
s 8033 96:02:15:05:57:07;826898227 e 
c 96:09:02:11:34:33;844281273
*page 1 0 1520 970 iA
@ports
port 18 agnd 170 140 h
@parts
part 1 vsrc 140 90 h
a 1 u 0 0 0 0 hcn 100 DC=5v
a 0 a 0 0 0 0 hln 100 PKGREF=V1
a 1 ap 9 0 20 10 hcn 100 REFDES=V1
part 2 d1n914 210 90 d
a 0 sp 11 0 30 5 hln 100 PART=d1n914
a 0 a 0 0 0 0 hln 100 PKGREF=D1
a 0 s 0 0 0 0 hln 100 PKGTYPE=DO35
a 0 s 0 0 0 0 hln 100 GATE=
a 0 ap 9 0 15 0 hln 100 refdes=D1
part 3 r 160 80 h
a 0 u 13 0 15 25 hln 100 VALUE={r1}
a 0 sp 0 0 0 10 hlb 100 PART=r
a 0 a 0 0 0 0 hln 100 PKGREF=R1
a 0 ap 9 0 15 0 hln 100 REFDES=R1
part 21 optparam 280 50 h
a 0 s 0 0 0 10 hlb 100 PART=optparam
a 0 x 0 0 0 0 hln 100 PKGREF=PM1
a 0 u 13 0 0 28 hln 100 NAME1=r1
a 0 u 13 0 50 30 hlb 100 INITVAL1=5k
a 0 u 13 0 90 30 hlb 100 CURVAL1=5k
a 0 up 0 0 0 10 hlb 100 LOVAL1=100
a 0 up 0 0 0 10 hlb 100 HIVAL1=10k
a 0 up 0 0 0 10 hlb 100 TOL1=10%
a 1 xp 0 0 10 -2 hcn 100 refdes=PM1
part 22 titleblk 970 720 h
a 1 s 13 0 180 60 hcn 100 PageTitle=
a 1 s 13 0 340 95 hrn 100 PageCount=1
a 1 s 13 0 300 95 hrn 100 PageNO=1
a 1 s 13 0 350 10 hcn 100 PageSize=A
@conn
w 5
s 140 90 140 80 4
s 140 80 160 80 6
w 9
s 200 80 210 80 8
s 210 80 210 90 10
w 13
s 210 120 210 140 12
s 210 140 170 140 14
s 140 140 140 130 16
s 170 140 140 140 19
@junction
j 140 90
+ p 1 +
+ w 5
j 160 80
+ p 3 1
+ w 5
j 200 80
+ p 3 2
+ w 9
j 210 90
+ p 2 1
+ w 9
j 210 120
+ p 2 2
+ w 13
j 140 130
+ p 1 -
+ w 13
j 170 140
+ s 18
+ w 13
@attributes
a 0 s 0 0 0 0 hln 100 PAGETITLE=
a 0 s 0 0 0 0 hln 100 PAGENO=1
a 0 s 0 0 0 0 hln 100 PAGESIZE=A
a 0 s 0 0 0 0 hln 100 PAGECOUNT=1
@text
