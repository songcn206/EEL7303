*version 9.1 881284506
lib "E:\Analog\SchResurection\Examples\Digsim\FRQCHK\frqchkx.slb" 1466458732
u 2984
U? 7
IN? 3
? 24
V? 2
D? 4
R? 10
@libraries
frqchkx  [.slb,.plb]
@analysis
.TRAN 1 0 0 0
+0 1us
+1 1000us
.OPT 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0
DIGINITSTATE 0
DIGMNTYMX 2
.PROBE 0 0 1 1 0 2
.LIB frqchkx.lib
.INC frqchk.stm
@targets
t 1;1:"picd";1;5: a 0 s 0 0 0 0 hln 100 PKGREF=U6
t 1;1:"picd";1;5: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;1:"picd";1;5: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;1:"picd";1;75: a 0 s 0 0 0 0 hln 100 PKGREF=U7
t 1;1:"picd";1;75: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;1:"picd";1;75: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;1:"picd";1;553: a 0 s 0 0 0 0 hln 100 PKGREF=U8
t 1;1:"picd";1;553: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;1:"picd";1;553: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;1:"picd";1;1: a 0 s 0 0 0 0 hln 100 PKGREF=U9
t 1;1:"picd";1;1: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;1:"picd";1;1: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;1:"picd";1;2: a 0 s 0 0 0 0 hln 100 PKGREF=U9
t 1;1:"picd";1;2: a 0 s 0 0 0 0 hln 100 GATE=B
t 1;1:"picd";1;2: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;1:"picd";1;3: a 0 s 0 0 0 0 hln 100 PKGREF=U10
t 1;1:"picd";1;3: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;1:"picd";1;3: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;1:"picd";1;4: a 0 s 0 0 0 0 hln 100 PKGREF=U10
t 1;1:"picd";1;4: a 0 s 0 0 0 0 hln 100 GATE=B
t 1;1:"picd";1;4: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;3:"picd";1;5: a 0 s 0 0 0 0 hln 100 PKGREF=U6
t 1;3:"picd";1;5: a 0 s 0 0 0 0 hln 100 GATE=B
t 1;3:"picd";1;5: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;3:"picd";1;75: a 0 s 0 0 0 0 hln 100 PKGREF=U7
t 1;3:"picd";1;75: a 0 s 0 0 0 0 hln 100 GATE=B
t 1;3:"picd";1;75: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;3:"picd";1;553: a 0 s 0 0 0 0 hln 100 PKGREF=U8
t 1;3:"picd";1;553: a 0 s 0 0 0 0 hln 100 GATE=B
t 1;3:"picd";1;553: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;3:"picd";1;1: a 0 s 0 0 0 0 hln 100 PKGREF=U11
t 1;3:"picd";1;1: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;3:"picd";1;1: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;3:"picd";1;2: a 0 s 0 0 0 0 hln 100 PKGREF=U11
t 1;3:"picd";1;2: a 0 s 0 0 0 0 hln 100 GATE=B
t 1;3:"picd";1;2: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;3:"picd";1;3: a 0 s 0 0 0 0 hln 100 PKGREF=U12
t 1;3:"picd";1;3: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;3:"picd";1;3: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;3:"picd";1;4: a 0 s 0 0 0 0 hln 100 PKGREF=U12
t 1;3:"picd";1;4: a 0 s 0 0 0 0 hln 100 GATE=B
t 1;3:"picd";1;4: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;1467:"sdlxle";1;341: a 0 s 0 0 0 0 hln 100 PKGREF=U1
t 1;1467:"sdlxle";1;341: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP24
t 1;1467:"sdlxle";1;350: a 0 s 0 0 0 0 hln 100 PKGREF=U2
t 1;1467:"sdlxle";1;350: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP24
t 1;1467:"sdlxle";1;1493: a 0 s 0 0 0 0 hln 100 PKGREF=U3
t 1;1467:"sdlxle";1;1493: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP16
t 1;1467:"sdlxle";1;1732: a 0 s 0 0 0 0 hln 100 PKGREF=U4
t 1;2:"picd";1;5: a 0 s 0 0 0 0 hln 100 PKGREF=U6
t 1;2:"picd";1;5: a 0 s 0 0 0 0 hln 100 GATE=C
t 1;2:"picd";1;5: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2:"picd";1;75: a 0 s 0 0 0 0 hln 100 PKGREF=U7
t 1;2:"picd";1;75: a 0 s 0 0 0 0 hln 100 GATE=C
t 1;2:"picd";1;75: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2:"picd";1;553: a 0 s 0 0 0 0 hln 100 PKGREF=U8
t 1;2:"picd";1;553: a 0 s 0 0 0 0 hln 100 GATE=C
t 1;2:"picd";1;553: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2:"picd";1;1: a 0 s 0 0 0 0 hln 100 PKGREF=U13
t 1;2:"picd";1;1: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;2:"picd";1;1: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2:"picd";1;2: a 0 s 0 0 0 0 hln 100 PKGREF=U13
t 1;2:"picd";1;2: a 0 s 0 0 0 0 hln 100 GATE=B
t 1;2:"picd";1;2: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2:"picd";1;3: a 0 s 0 0 0 0 hln 100 PKGREF=U14
t 1;2:"picd";1;3: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;2:"picd";1;3: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2:"picd";1;4: a 0 s 0 0 0 0 hln 100 PKGREF=U14
t 1;2:"picd";1;4: a 0 s 0 0 0 0 hln 100 GATE=B
t 1;2:"picd";1;4: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2109:"edlx";1;225: a 0 s 0 0 0 0 hln 100 PKGREF=U15
t 1;2109:"edlx";1;225: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;2109:"edlx";1;225: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP16
t 1;2109:"edlx";1;226: a 0 s 0 0 0 0 hln 100 PKGREF=U15
t 1;2109:"edlx";1;226: a 0 s 0 0 0 0 hln 100 GATE=B
t 1;2109:"edlx";1;226: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP16
t 1;2109:"edlx";1;227: a 0 s 0 0 0 0 hln 100 PKGREF=U16
t 1;2109:"edlx";1;227: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;2109:"edlx";1;227: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP16
t 1;2109:"edlx";1;228: a 0 s 0 0 0 0 hln 100 PKGREF=U17
t 1;2109:"edlx";1;228: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;2109:"edlx";1;228: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2109:"edlx";1;229: a 0 s 0 0 0 0 hln 100 PKGREF=U18
t 1;2109:"edlx";1;229: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;2109:"edlx";1;229: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2109:"edlx";1;230: a 0 s 0 0 0 0 hln 100 PKGREF=U16
t 1;2109:"edlx";1;230: a 0 s 0 0 0 0 hln 100 GATE=B
t 1;2109:"edlx";1;230: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP16
t 1;2109:"edlx";1;231: a 0 s 0 0 0 0 hln 100 PKGREF=U19
t 1;2109:"edlx";1;231: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;2109:"edlx";1;231: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2109:"edlx";1;664: a 0 s 0 0 0 0 hln 100 PKGREF=U19
t 1;2109:"edlx";1;664: a 0 s 0 0 0 0 hln 100 GATE=B
t 1;2109:"edlx";1;664: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2109:"edlx";1;665: a 0 s 0 0 0 0 hln 100 PKGREF=U5
t 1;2109:"edlx";1;665: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP16
t 1;2543:"init";1;719: a 0 s 0 0 0 0 hln 100 PKGREF=U7
t 1;2543:"init";1;719: a 0 s 0 0 0 0 hln 100 GATE=D
t 1;2543:"init";1;719: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2543:"init";1;720: a 0 s 0 0 0 0 hln 100 PKGREF=U19
t 1;2543:"init";1;720: a 0 s 0 0 0 0 hln 100 GATE=C
t 1;2543:"init";1;720: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2543:"init";1;721: a 0 s 0 0 0 0 hln 100 PKGREF=U7
t 1;2543:"init";1;721: a 0 s 0 0 0 0 hln 100 GATE=E
t 1;2543:"init";1;721: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2543:"init";1;722: a 0 s 0 0 0 0 hln 100 PKGREF=U8
t 1;2543:"init";1;722: a 0 s 0 0 0 0 hln 100 GATE=D
t 1;2543:"init";1;722: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2543:"init";1;723: a 0 s 0 0 0 0 hln 100 PKGREF=U19
t 1;2543:"init";1;723: a 0 s 0 0 0 0 hln 100 GATE=D
t 1;2543:"init";1;723: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2543:"init";1;724: a 0 s 0 0 0 0 hln 100 PKGREF=U20
t 1;2543:"init";1;724: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;2543:"init";1;724: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP16
t 1;2543:"init";1;725: a 0 s 0 0 0 0 hln 100 PKGREF=U21
t 1;2543:"init";1;725: a 0 s 0 0 0 0 hln 100 GATE=A
t 1;2543:"init";1;725: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;2543:"init";1;726: a 0 s 0 0 0 0 hln 100 PKGREF=U7
t 1;2543:"init";1;726: a 0 s 0 0 0 0 hln 100 GATE=F
t 1;2543:"init";1;726: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP14
t 1;1467:"sdlxle";1;1732: a 0 s 0 0 0 0 hln 100 PKGTYPE=DIP20
@attributes
@translators
a 0 u 13 0 0 0 hln 100 PCBOARDS=PCB
a 0 u 13 0 0 0 hln 100 PSPICE=DEFAULT
a 0 u 13 0 0 0 hln 100 XILINX=XILINX
a 0 u 13 0 0 0 hln 100 CADSTAR=PCB
a 0 u 13 0 0 0 hln 100 EDIF=PCB
a 0 u 13 0 0 0 hln 100 ORCAD=PCB
a 0 u 13 0 0 0 hln 100 PADS=PCB
a 0 u 13 0 0 0 hln 100 PCAD=PCB
a 0 u 13 0 0 0 hln 100 PROTEL=PCB
a 0 u 13 0 0 0 hln 100 TANGO=PCB
a 0 u 13 0 0 0 hln 100 SCICARDS=PCB
a 0 u 13 0 0 0 hln 100 POLARIS=PCB
@setup
unconnectedPins 0
connectViaLabel 0
connectViaLocalLabels 0
NoStim4ExtIFPortsWarnings 1
AutoGenStim4ExtIFPorts 1
@index
pageloc 1 0 12873 
@status
n 0 99:07:13:14:41:01;934580461 e 
s 2832 99:07:13:14:41:06;934580466 e 
a 0 93:01:18:08:44:27;730053867 e 
p 0 95:02:29:09:25:48;796497948 e 
i PCBOARDS 95:02:29:09:25:52;796497952 e 0 
c 99:07:13:14:06:14;934578374
*page 1 0 970 720 iA
@ports
port 5 GLOBAL 70 120 h
a 14 x 3 0 15 8 hcn 100 LABEL=REFL
port 6 GLOBAL 70 180 h
a 14 x 3 0 15 8 hcn 100 LABEL=REFH
port 7 GLOBAL 70 200 h
a 14 x 3 0 15 8 hcn 100 LABEL=FTEST
port 180 GLOBAL 70 310 h
a 14 x 3 0 15 8 hcn 100 LABEL=INIT
port 181 GLOBAL 70 290 h
a 14 x 3 0 15 8 hcn 100 LABEL=RUN
port 492 global 590 160 h
a 14 x 3 0 15 8 hcn 100 LABEL=Mode
port 1527 GLOBAL 760 160 u
a 1 x 3 0 17 6 hcn 100 LABEL=FAST
port 1528 GLOBAL 760 180 u
a 1 x 3 0 19 8 hcn 100 LABEL=OK
port 1529 GLOBAL 760 200 u
a 1 x 3 0 19 6 hcn 100 LABEL=SLOW
port 71 OFFPAGE 130 30 u
a 1 x 3 0 23 8 hcn 100 LABEL=N2
port 72 OFFPAGE 240 30 u
a 1 x 3 0 23 8 hcn 100 LABEL=N1
port 73 OFFPAGE 350 30 u
a 1 x 3 0 23 8 hcn 100 LABEL=N0
port 266 OFFPAGE 80 140 h
a 1 x 3 0 23 8 hcn 100 LABEL=CLEAR
port 1490 OFFPAGE 600 50 h
a 1 x 3 0 23 8 hcn 100 LABEL=N2
port 1491 OFFPAGE 600 40 h
a 1 x 3 0 23 8 hcn 100 LABEL=N1
port 1492 OFFPAGE 600 30 h
a 1 x 3 0 23 8 hcn 100 LABEL=N0
port 1514 OFFPAGE 600 140 h
a 1 x 3 0 23 8 hcn 100 LABEL=RUNL
port 2021 OFFPAGE 80 160 h
a 1 x 3 0 23 8 hcn 100 LABEL=RUN
port 2122 GLOBAL 760 290 u
a 14 x 3 0 17 6 hcn 100 LABEL=ERROR
port 2123 OFFPAGE 620 260 h
a 1 x 3 0 23 8 hcn 100 LABEL=FAST
port 2124 OFFPAGE 620 280 h
a 1 x 3 0 23 8 hcn 100 LABEL=OK
port 2125 OFFPAGE 620 300 h
a 1 x 3 0 23 8 hcn 100 LABEL=SLOW
port 2126 OFFPAGE 620 320 h
a 1 x 3 0 23 8 hcn 100 LABEL=INIT2
port 2537 offpage 600 60 h
a 1 x 3 0 23 8 hcn 100 LABEL=N3
port 2564 offpage 280 270 u
a 1 x 3 0 23 8 hcn 100 LABEL=CYCLE
port 2565 offpage 280 290 u
a 1 x 3 0 23 8 hcn 100 LABEL=RUNL
port 2566 offpage 280 330 u
a 1 x 3 0 23 8 hcn 100 LABEL=INIT2
port 2573 offpage 620 340 h
a 1 x 3 0 23 8 hcn 100 LABEL=RUN
port 2578 offpage 600 180 h
a 1 x 3 0 23 8 hcn 100 LABEL=CYCLE
port 2581 offpage 280 310 u
a 1 x 3 0 23 8 hcn 100 LABEL=CLEAR
port 2584 offpage 750 270 u
a 1 x 3 0 25 6 hcn 100 LABEL=DONE
port 2587 offpage 80 330 h
a 1 x 3 0 23 8 hcn 100 LABEL=DONE
port 2829 GLOBAL 610 360 h
a 1 x 3 0 23 8 hcn 100 LABEL=REFL
port 2866 GLOBAL 70 270 h
a 14 x 3 0 15 8 hcn 100 LABEL=SYSCLK
port 2869 GLOBAL 770 30 u
a 14 x 3 0 15 8 hcn 100 LABEL=C0
port 2870 GLOBAL 770 40 u
a 14 x 3 0 15 8 hcn 100 LABEL=C1
port 2871 GLOBAL 770 50 u
a 14 x 3 0 15 8 hcn 100 LABEL=C2
port 2872 GLOBAL 770 60 u
a 14 x 3 0 15 8 hcn 100 LABEL=C3
@parts
block 1 blocksym0 90 20 h
a 0 ap 9 0 0 0 hln 100 REFDES=U1
a 0 a 0 0 0 0 hln 100 PKGREF=U1
*symbol blocksym1
d 
@type p
@attributes
a 0 sp 9 0 0 0 hln 100 REFDES=U?
a 0 s 0 0 0 0 hln 100 PART=
@views
a 0 u 13 0 0 0 hln 100 DEFAULT=picd
@pins
p 2 20 100 hcb 100 1 l 20 100 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 85 hlb 100 2 l 0 80 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 38 15 hrb 100 3 l 40 10 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 30 100 hcb 100 4 l 30 100 d
a 0 u 0 0 0 0 hln 100 float=r
@graphics 40 100 0 0 10
r 0 0 0 40 100
*end blocksym
block 3 blocksym0 310 20 h
a 0 ap 9 0 0 0 hln 100 REFDES=U2
a 0 a 0 0 0 0 hln 100 PKGREF=U2
*symbol blocksym3
d 
@type p
@attributes
a 0 sp 9 0 0 0 hln 100 REFDES=U?
a 0 s 0 0 0 0 hln 100 PART=
@views
a 0 u 13 0 0 0 hln 100 DEFAULT=picd
@pins
p 2 20 100 hcb 100 1 l 20 100 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 85 hlb 100 2 l 0 80 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 38 15 hrb 100 3 l 40 10 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 30 100 hcb 100 4 l 30 100 d
a 0 u 0 0 0 0 hln 100 float=r
@graphics 40 100 0 0 10
r 0 0 0 40 100
*end blocksym
block 1467 blocksym0 660 110 h
a 0 ap 9 0 0 0 hln 100 REFDES=U3
a 0 a 0 0 0 0 hln 100 PKGREF=U3
*symbol blocksym1467
d 
@type p
@attributes
a 0 sp 9 0 0 0 hln 100 REFDES=U?
a 0 s 0 0 0 0 hln 100 PART=
@views
a 0 u 13 0 0 0 hln 100 DEFAULT=sdlxle
a 0 u 13 0 0 0 hln 100 PAL-IMPL=sdlpx
a 0 s 0 0 0 0 hln 100 GATE=sdlx
@pins
p 2 2 15 hlb 100 N[3-0] l 0 10 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 35 hlb 100 1 l 0 30 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 38 55 hrb 100 4 l 40 50 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 55 hlb 100 2 l 0 50 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 38 75 hrb 100 5 l 40 70 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 38 95 hrb 100 6 l 40 90 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 38 25 hrb 100 C[3-0] l 40 20 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 75 hlb 100 3 l 0 70 d
a 0 u 0 0 0 0 hln 100 float=r
@graphics 40 100 0 0 10
r 0 0 0 40 100
*end blocksym
block 2 blocksym0 200 20 h
a 0 ap 9 0 0 0 hln 100 REFDES=U4
a 0 a 0 0 0 0 hln 100 PKGREF=U4
*symbol blocksym2
d 
@type p
@attributes
a 0 sp 9 0 0 0 hln 100 REFDES=U?
a 0 s 0 0 0 0 hln 100 PART=
@views
a 0 u 13 0 0 0 hln 100 DEFAULT=picd
@pins
p 2 20 100 hcb 100 1 l 20 100 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 85 hlb 100 2 l 0 80 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 38 15 hrb 100 3 l 40 10 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 30 100 hcb 100 4 l 30 100 d
a 0 u 0 0 0 0 hln 100 float=r
@graphics 40 100 0 0 10
r 0 0 0 40 100
*end blocksym
block 2109 blocksym0 660 250 h
a 0 ap 9 0 0 0 hln 100 REFDES=U5
a 0 a 0 0 0 0 hln 100 PKGREF=U5
*symbol blocksym2109
d 
@type p
@attributes
a 0 sp 9 0 0 0 hln 100 REFDES=U?
a 0 s 0 0 0 0 hln 100 PART=
@views
a 0 u 13 0 0 0 hln 100 DEFAULT=edlx
@pins
p 2 38 25 hrb 100 7 l 40 20 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 35 hlb 100 2 l 0 30 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 15 hlb 100 1 l 0 10 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 95 hlb 100 5 l 0 90 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 75 hlb 100 4 l 0 70 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 55 hlb 100 3 l 0 50 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 38 45 hrb 100 8 l 40 40 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 115 hlb 100 6 l 0 110 d
a 0 u 0 0 0 0 hln 100 float=r
@graphics 40 140 0 0 10
r 0 0 0 40 140
*end blocksym
block 2543 blocksym0 200 260 h
a 0 ap 9 0 0 0 hln 100 REFDES=U6
a 0 a 0 0 0 0 hln 100 PKGREF=U6
*symbol blocksym2543
d 
@type p
@attributes
a 0 sp 9 0 0 0 hln 100 REFDES=U?
a 0 s 0 0 0 0 hln 100 PART=
@views
a 0 u 13 0 0 0 hln 100 DEFAULT=init
@pins
p 2 38 55 hrb 100 7 l 40 50 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 15 hlb 100 1 l 0 10 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 35 hlb 100 2 l 0 30 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 55 hlb 100 3 l 0 50 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 38 75 hrb 100 8 l 40 70 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 38 35 hrb 100 6 l 40 30 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 38 15 hrb 100 5 l 40 10 d
a 0 u 0 0 0 0 hln 100 float=r
p 2 2 75 hlb 100 4 l 0 70 d
a 0 u 0 0 0 0 hln 100 float=r
@graphics 40 100 0 0 10
r 0 0 0 40 100
*end blocksym
part 2983 readme 420 210 h
a 0 u 3 0 22 34 hln 100 filename=frqchkx.rdm
a 0 sp 0 0 17 20 hln 200 PART=readme
a 0 a 0 0 0 0 hln 100 PKGREF=
part 2905 nodeMarker 760 160 h
a 0 a 0 0 4 22 hlb 100 LABEL=7
part 2906 nodeMarker 760 180 h
a 0 a 0 0 4 22 hlb 100 LABEL=8
part 2907 nodeMarker 760 200 h
a 0 a 0 0 4 22 hlb 100 LABEL=9
part 2908 nodeMarker 70 270 h
a 0 a 0 0 4 22 hlb 100 LABEL=10
part 2909 nodeMarker 70 120 v
a 0 a 0 0 4 22 hlb 100 LABEL=11
part 2910 nodeMarker 70 200 h
a 0 a 0 0 4 22 hlb 100 LABEL=12
part 2911 nodeMarker 70 180 h
a 0 a 0 0 4 22 hlb 100 LABEL=13
part 2980 nodeMarker 720 130 h
a 0 a 0 0 4 22 hlb 100 LABEL=22
part 2981 nodeMarker 640 70 h
a 0 a 0 0 4 22 hlb 100 LABEL=23
@conn
w 9
s 110 140 110 120 10
s 220 140 220 120 44
s 330 140 330 120 50
s 110 140 220 140 54
s 220 140 330 140 56
s 80 140 110 140 2491
w 26
s 190 100 200 100 48
s 190 180 190 100 57
s 70 180 190 180 2060
w 53
s 300 100 310 100 52
s 300 100 300 200 68
s 70 200 300 200 2062
w 2023
s 340 160 340 120 2024
s 120 160 120 120 2032
s 230 160 230 120 2029
s 120 160 230 160 2046
s 230 160 340 160 2048
s 80 160 120 160 2489
w 2041
s 70 120 70 100 2040
s 70 100 90 100 2042
w 2545
s 70 270 200 270 2552
w 2547
s 70 290 200 290 2554
w 2563
s 70 310 200 310 2562
w 2568
s 280 330 240 330 2567
w 2570
s 280 290 240 290 2569
w 2572
s 280 270 240 270 2571
w 2583
s 280 310 240 310 2582
w 2589
s 80 330 200 330 2588
w 2689
s 620 280 660 280 2688
w 2733
a 0 s 3 0 620 28 hln 100 LABEL=N0
s 600 30 640 30 2732
a 0 s 3 0 620 28 hln 100 LABEL=N0
w 2735
a 0 s 3 0 620 38 hln 100 LABEL=N1
s 600 40 640 40 2734
a 0 s 3 0 620 38 hln 100 LABEL=N1
w 2737
a 0 s 3 0 620 48 hln 100 LABEL=N2
s 600 50 640 50 2736
a 0 s 3 0 620 48 hln 100 LABEL=N2
w 2739
s 600 140 660 140 2738
w 2747
a 0 s 3 0 620 58 hln 100 LABEL=N3
s 600 60 640 60 2746
a 0 s 3 0 620 58 hln 100 LABEL=N3
w 2749
s 590 160 660 160 2810
w 2766
s 700 160 760 160 2804
w 2768
s 700 180 760 180 2806
w 2770
s 700 200 760 200 2808
w 2813
s 620 260 660 260 2812
w 2815
s 620 340 660 340 2814
w 2817
s 620 320 660 320 2816
w 2819
s 620 300 660 300 2818
w 2827
s 600 180 660 180 2826
w 2841
s 700 290 760 290 2840
w 2843
s 700 270 750 270 2842
w 2885
s 610 360 660 360 2884
w 2889
a 0 s 0 0 745 28 hln 100 LABEL=C0
s 720 30 770 30 2888
a 0 s 3 0 745 28 hln 100 LABEL=C0
w 2891
a 0 s 0 0 745 38 hln 100 LABEL=C1
s 770 40 720 40 2890
a 0 s 3 0 745 38 hln 100 LABEL=C1
w 2894
a 0 s 0 0 745 48 hln 100 LABEL=C2
s 720 50 770 50 2893
a 0 s 3 0 745 48 hln 100 LABEL=C2
w 2897
a 0 s 0 0 745 58 hln 100 LABEL=C3
s 770 60 720 60 2896
a 0 s 3 0 745 58 hln 100 LABEL=C3
b 2755
a 0 s 3 0 642 90 hln 100 LABEL=N[3-0]
s 640 70 640 120 2982
a 0 s 3 0 642 90 hln 100 LABEL=N[3-0]
a 0 s 3 0 642 90 hln 100 LABEL=N[3-0]
s 640 60 640 70 2764
s 640 120 660 120 2754
s 640 30 640 40 2760
s 640 40 640 50 2762
s 640 50 640 60 2763
b 2864
a 0 s 3 0 694 91 hln 100 LABEL=C[3-0]
s 720 40 720 30 2892
a 0 s 3 0 694 91 hln 100 LABEL=C[3-0]
s 700 130 720 130 2771
s 720 130 720 60 2886
s 720 50 720 40 2895
s 720 60 720 50 2898
@junction
j 110 120
+ p 1 1
+ w 9
j 330 120
+ p 3 1
+ w 9
j 310 100
+ p 3 2
+ w 53
j 220 140
+ w 9
+ w 9
j 70 180
+ s 6
+ w 26
j 70 200
+ s 7
+ w 53
j 130 30
+ s 71
+ p 1 3
j 350 30
+ s 73
+ p 3 3
j 340 120
+ p 3 4
+ w 2023
j 120 120
+ p 1 4
+ w 2023
j 240 30
+ p 2 3
+ s 72
j 220 120
+ p 2 1
+ w 9
j 200 100
+ p 2 2
+ w 26
j 230 120
+ p 2 4
+ w 2023
j 70 120
+ s 5
+ w 2041
j 90 100
+ p 1 2
+ w 2041
j 230 160
+ w 2023
+ w 2023
j 80 160
+ s 2021
+ w 2023
j 120 160
+ w 2023
+ w 2023
j 80 140
+ s 266
+ w 9
j 110 140
+ w 9
+ w 9
j 70 290
+ s 181
+ w 2547
j 70 310
+ s 180
+ w 2563
j 280 330
+ s 2566
+ w 2568
j 280 290
+ s 2565
+ w 2570
j 280 270
+ s 2564
+ w 2572
j 280 310
+ s 2581
+ w 2583
j 80 330
+ s 2587
+ w 2589
j 660 280
+ p 2109 2
+ w 2689
j 620 280
+ s 2124
+ w 2689
j 600 30
+ s 1492
+ w 2733
j 600 40
+ s 1491
+ w 2735
j 600 50
+ s 1490
+ w 2737
j 660 140
+ p 1467 1
+ w 2739
j 600 140
+ s 1514
+ w 2739
j 600 60
+ s 2537
+ w 2747
j 660 160
+ p 1467 2
+ w 2749
j 640 30
+ w 2733
+ b 2755
N[0]
j 640 40
+ w 2735
+ b 2755
N[1]
j 660 120
+ P 1467 N[3-0]
N[3]
N[2]
N[1]
N[0]
+ b 2755
N[3]
N[2]
N[1]
N[0]
j 640 50
+ w 2737
+ b 2755
N[2]
j 640 60
+ w 2747
+ b 2755
N[3]
j 200 270
+ p 2543 1
+ w 2545
j 200 290
+ p 2543 2
+ w 2547
j 200 310
+ p 2543 3
+ w 2563
j 240 330
+ p 2543 8
+ w 2568
j 240 290
+ p 2543 6
+ w 2570
j 240 270
+ p 2543 5
+ w 2572
j 240 310
+ p 2543 7
+ w 2583
j 200 330
+ p 2543 4
+ w 2589
j 700 160
+ p 1467 4
+ w 2766
j 700 180
+ p 1467 5
+ w 2768
j 700 200
+ p 1467 6
+ w 2770
j 700 130
+ P 1467 C[3-0]
C[3]
C[2]
C[1]
C[0]
+ b 2864
C[3]
C[2]
C[1]
C[0]
j 760 160
+ s 1527
+ w 2766
j 760 180
+ s 1528
+ w 2768
j 760 200
+ s 1529
+ w 2770
j 590 160
+ s 492
+ w 2749
j 660 260
+ p 2109 1
+ w 2813
j 620 260
+ s 2123
+ w 2813
j 660 340
+ p 2109 5
+ w 2815
j 620 340
+ s 2573
+ w 2815
j 660 320
+ p 2109 4
+ w 2817
j 620 320
+ s 2126
+ w 2817
j 660 300
+ p 2109 3
+ w 2819
j 620 300
+ s 2125
+ w 2819
j 660 180
+ p 1467 3
+ w 2827
j 600 180
+ s 2578
+ w 2827
j 700 290
+ p 2109 8
+ w 2841
j 760 290
+ s 2122
+ w 2841
j 700 270
+ p 2109 7
+ w 2843
j 750 270
+ s 2584
+ w 2843
j 70 270
+ s 2866
+ w 2545
j 660 360
+ p 2109 6
+ w 2885
j 610 360
+ s 2829
+ w 2885
j 770 30
+ s 2869
+ w 2889
j 720 30
+ w 2889
+ b 2864
C[0]
j 770 40
+ s 2870
+ w 2891
j 720 40
+ w 2891
+ b 2864
C[1]
j 770 50
+ s 2871
+ w 2894
j 720 50
+ w 2894
+ b 2864
C[2]
j 770 60
+ s 2872
+ w 2897
j 720 60
+ w 2897
+ b 2864
C[3]
j 760 160
+ p 2905 pin1
+ s 1527
j 760 160
+ p 2905 pin1
+ w 2766
j 760 180
+ p 2906 pin1
+ s 1528
j 760 180
+ p 2906 pin1
+ w 2768
j 760 200
+ p 2907 pin1
+ s 1529
j 760 200
+ p 2907 pin1
+ w 2770
j 70 270
+ p 2908 pin1
+ s 2866
j 70 270
+ p 2908 pin1
+ w 2545
j 70 120
+ p 2909 pin1
+ s 5
j 70 120
+ p 2909 pin1
+ w 2041
j 70 200
+ p 2910 pin1
+ s 7
j 70 200
+ p 2910 pin1
+ w 53
j 70 180
+ p 2911 pin1
+ s 6
j 70 180
+ p 2911 pin1
+ w 26
j 720 130
+ p 2980 pin1
+ b 2864
j 640 70
+ p 2981 pin1
+ b 2755
@attributes
a 0 s 0 0 0 0 hln 100 PAGETITLE=
a 0 s 0 0 0 0 hln 100 PAGENO=1
a 0 s 0 0 0 0 hln 100 PAGESIZE=A
a 0 s 0 0 0 0 hln 100 PAGECOUNT=1
@text
s 5 100 60 hln 100 PICD
s 5 210 60 hln 100 PICD
s 5 320 60 hln 100 PICD
s 5 670 160 hln 100 SDL
s 5 590 100 hln 100 NEXT State
s 5 670 300 hln 100 EDL
s 5 390 180 hln 200 FRQCHKX.SCH
s 5 640 220 hln 100 State Decode Logic
s 5 650 420 hln 100 Error Detect Logic
s 5 90 210 hln 100 Phase-Independent Cycle Detectors
s 5 210 350 hln 100 INIT
s 5 150 380 hln 100 Initialization/Reset Logic
s 5 730 100 hln 100 CURRENT State
