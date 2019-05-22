*version 9.1 502998002
u 168
R? 6
Q? 5
V? 5
C? 2
? 3
@libraries
@analysis
.AC 0 3 1
+0 10
+1 100K
+2 10G
+3 V(OUT2)
+4 V1
+5 30
.DC 0 0 0 0 1 1
+ 0 0 V1
+ 0 4 -0.125
+ 0 5 0.125
+ 0 6 0.005
.TRAN 1 0 0 1
+0 20ns
+1 1000ns
+4 1Meg
+5 V(OUT2)
.TEMP 1 35
.TF 0 V(OUT2) V1
.PROBE 0 0 1 1 0 2
@targets
t 1;1: a 0 s 0 0 0 0 hln 100 PKGTYPE=RC05
t 1;2: a 0 s 0 0 0 0 hln 100 PKGTYPE=RC05
t 1;3: a 0 s 0 0 0 0 hln 100 PKGTYPE=RC05
t 1;4: a 0 s 0 0 0 0 hln 100 PKGTYPE=RC05
t 1;5: a 0 s 0 0 0 0 hln 100 PKGTYPE=RC05
t 1;11: a 0 s 0 0 0 0 hln 100 PKGTYPE=CK05
t 1;6: a 0 s 0 0 0 0 hln 100 PKGREF=Q1
t 1;8: a 0 s 0 0 0 0 hln 100 PKGREF=Q2
t 1;9: a 0 s 0 0 0 0 hln 100 PKGREF=Q3
t 1;7: a 0 s 0 0 0 0 hln 100 PKGREF=Q4
@attributes
@translators
a 0 u 13 0 0 0 hln 100 PCBOARDS=PCB
a 0 u 13 0 0 0 hln 100 PSPICE=DEFAULT
a 0 u 13 0 0 0 hln 100 XILINX=XILINX
a 0 u 13 0 0 0 hln 100 TANGO=PCB
a 0 u 13 0 0 0 hln 100 SCICARDS=PCB
a 0 u 13 0 0 0 hln 100 PROTEL=PCB
a 0 u 13 0 0 0 hln 100 PCAD=PCB
a 0 u 13 0 0 0 hln 100 PADS=PCB
a 0 u 13 0 0 0 hln 100 ORCAD=PCB
a 0 u 13 0 0 0 hln 100 EDIF=PCB
a 0 u 13 0 0 0 hln 100 CADSTAR=PCB
a 0 u 13 0 0 0 hln 100 POLARIS=PCB
@setup
unconnectedPins 1
connectViaLabel 0
connectViaLocalLabels 0
NoStim4ExtIFPortsWarnings 1
AutoGenStim4ExtIFPorts 1
@index
pageloc 1 0 6312 
@status
n 0 99:07:13:13:46:53;934577213 e 
s 2832 99:07:13:13:46:53;934577213 e 
c 99:07:13:13:45:18;934577118
p 2453 97:01:14:10:56:31;855946591 e 
*page 1 0 1520 970 iA
@ports
port 12 agnd 590 250 h
port 13 agnd 510 360 h
port 17 agnd 290 260 h
port 18 offpage 170 80 h
a 1 x 3 0 23 8 hcn 100 LABEL=VDD
port 19 offpage 170 390 h
a 1 x 3 0 23 8 hcn 100 LABEL=VEE
port 20 offpage 610 320 H
a 1 x 3 0 23 8 hcn 100 LABEL=VDD
port 21 offpage 610 350 H
a 1 x 3 0 23 8 hcn 100 LABEL=VEE
@parts
part 1 r 210 170 v
a 0 u 13 0 5 -7 hln 100 VALUE=20k
a 0 sp 0 0 0 10 hlb 100 PART=r
a 0 x 0 0 0 0 hln 100 PKGREF=RBIAS
a 0 xp 9 0 23 0 hln 100 REFDES=RBIAS
part 2 r 370 170 v
a 0 u 13 0 9 -3 hln 100 VALUE=10k
a 0 sp 0 0 0 10 hlb 100 PART=r
a 0 x 0 0 0 0 hln 100 PKGREF=RC1
a 0 xp 9 0 23 -2 hln 100 REFDES=RC1
part 4 r 530 210 h
a 0 u 13 0 15 25 hln 100 VALUE=1k
a 0 sp 0 0 0 10 hlb 100 PART=r
a 0 x 0 0 0 0 hln 100 PKGREF=RS2
a 0 xp 9 0 11 -2 hln 100 REFDES=RS2
part 5 r 300 210 h
a 0 sp 0 0 0 10 hlb 100 PART=r
a 0 x 0 0 0 0 hln 100 PKGREF=RS1
a 0 xp 9 0 15 0 hln 100 REFDES=RS1
part 11 c 400 180 h
a 0 u 13 0 9 25 hln 100 VALUE=5p
a 0 sp 0 0 0 10 hlb 100 PART=c
a 0 x 0 0 0 0 hln 100 PKGREF=CLOAD
a 0 xp 9 0 1 -2 hln 100 REFDES=CLOAD
part 14 vsrc 570 350 V
a 0 a 0 0 0 0 hln 100 PKGREF=V3
a 1 ap 9 0 20 22 hcn 100 REFDES=V3
a 1 u 0 0 0 0 hcn 100 DC=-12
part 15 vsrc 570 320 V
a 0 a 0 0 0 0 hln 100 PKGREF=V2
a 1 ap 9 0 20 22 hcn 100 REFDES=V2
a 1 u 0 0 0 0 hcn 100 DC=+12
part 16 vsin 290 220 h
a 0 a 0 0 0 0 hln 100 PKGREF=V1
a 1 ap 9 0 20 10 hcn 100 REFDES=V1
a 1 u 0 0 0 0 hcn 100 voff=0v
a 1 u 0 0 0 0 hcn 100 vampl=0.1v
a 1 u 0 0 0 0 hcn 100 freq=5Meg
a 1 u 0 0 0 0 hcn 100 DC=.125
a 1 u 0 0 0 0 hcn 100 AC=1
part 6 q2n2222 230 310 H
a 0 sp 11 0 25 28 hln 100 PART=q2n2222
a 0 s 0 0 0 0 hln 100 GATE=
a 0 x 0 0 0 0 hln 100 PKGTYPE=TO-206AA
a 0 ap 9 0 31 7 hln 100 REFDES=Q1
a 0 a 0 0 0 0 hln 100 PKGREF=Q3
part 8 q2n2222 350 210 h
a 0 sp 11 0 25 34 hln 100 PART=q2n2222
a 0 s 0 0 0 0 hln 100 GATE=
a 0 x 0 0 0 0 hln 100 PKGTYPE=TO-206AA
a 0 ap 9 0 25 17 hln 100 REFDES=Q2
a 0 a 0 0 0 0 hln 100 PKGREF=Q1
part 9 q2n2222 480 210 H
a 0 sp 11 0 -37 36 hln 100 PART=q2n2222
a 0 s 0 0 0 0 hln 100 GATE=
a 0 x 0 0 0 0 hln 100 PKGTYPE=TO-206AA
a 0 ap 9 0 -9 11 hln 100 REFDES=Q3
a 0 a 0 0 0 0 hln 100 PKGREF=Q2
part 7 q2n2222 350 310 h
a 0 sp 11 0 25 32 hln 100 PART=q2n2222
a 0 s 0 0 0 0 hln 100 GATE=
a 0 xp 9 0 29 11 hln 100 REFDES=Q4
a 0 x 0 0 0 0 hln 100 PKGTYPE=TO-206AA
a 0 a 0 0 0 0 hln 100 PKGREF=Q4
part 3 r 460 170 v
a 0 sp 0 0 0 10 hlb 100 PART=r
a 0 x 0 0 0 0 hln 100 PKGREF=RC2
a 0 xp 9 0 25 42 hln 100 REFDES=RC2
a 0 u 13 0 11 41 hln 100 VALUE=10.1k
part 166 readme 550 120 h
a 0 u 3 0 22 34 hln 100 filename=example.rdm
a 0 sp 0 0 17 20 hln 200 PART=readme
a 0 a 0 0 0 0 hln 100 PKGREF=
part 167 titleblk 970 720 h
a 1 s 13 0 350 10 hcn 100 PAGESIZE=A
a 1 s 13 0 180 60 hcn 100 PAGETITLE=
a 1 u 13 0 116 95 hln 100 Date=January 1, 2000
a 1 s 13 0 340 95 hrn 100 PAGECOUNT=1
a 1 s 13 0 300 95 hrn 100 PAGENO=1
part 162 nodeMarker 380 180 h
a 0 s 0 0 0 0 hln 100 PROBEVAR=
a 0 a 0 0 4 22 hlb 100 LABEL=1
part 164 nodeMarker 440 180 h
a 0 s 0 0 0 0 hln 100 PROBEVAR=
a 0 a 0 0 4 22 hlb 100 LABEL=2
@conn
w 34
a 0 up 0:33 0 0 0 hln 100 V=
s 210 290 210 280 135
s 250 310 250 280 137
s 350 310 250 310 139
s 250 310 230 310 141
s 250 280 210 280 143
s 210 280 210 170 158
a 0 up 33 0 212 225 hlt 100 V=
w 44
a 0 up 0:33 0 0 0 hln 100 V=
s 210 130 210 100 43
s 210 100 250 100 45
s 370 100 370 130 47
s 370 100 460 100 49
s 460 100 460 130 51
s 170 80 250 80 53
s 250 100 370 100 57
a 0 up 33 0 310 99 hct 100 V=
s 250 80 250 100 55
w 59
a 0 s 0 0 372 185 hln 100 LABEL=OUT1
a 0 up 0:33 0 0 0 hln 100 V=
s 370 180 370 190 105
a 0 s 3 0 340 181 hln 100 LABEL=OUT1
a 0 up 33 0 340 182 hlt 100 V=
s 370 170 370 180 58
s 370 180 380 180 103
s 380 180 400 180 163
w 61
a 0 up 0:33 0 0 0 hln 100 V=
s 350 210 340 210 60
a 0 up 33 0 345 209 hct 100 V=
w 63
a 0 up 0:33 0 0 0 hln 100 V=
s 300 210 290 210 62
s 290 210 290 220 64
a 0 up 33 0 292 215 hlt 100 V=
w 67
a 0 up 0:33 0 0 0 hln 100 V=
s 460 230 460 250 112
s 370 250 370 230 116
s 460 250 370 250 114
a 0 up 33 0 415 249 hct 100 V=
s 370 290 370 250 160
w 107
a 0 s 0 0 462 185 hln 100 LABEL=OUT2
a 0 up 0:33 0 0 0 hln 100 V=
s 460 180 460 190 110
a 0 s 3 0 466 181 hln 100 LABEL=OUT2
a 0 up 33 0 466 182 hlt 100 V=
s 430 180 440 180 106
s 460 180 460 170 108
s 440 180 460 180 165
w 118
a 0 up 0:33 0 0 0 hln 100 V=
s 480 210 530 210 117
a 0 up 33 0 505 209 hct 100 V=
w 120
a 0 up 0:33 0 0 0 hln 100 V=
s 570 210 590 210 119
s 590 210 590 250 121
a 0 up 33 0 592 230 hlt 100 V=
w 124
a 0 up 0:33 0 0 0 hln 100 V=
s 570 320 610 320 123
a 0 up 33 0 590 319 hct 100 V=
w 126
a 0 up 0:33 0 0 0 hln 100 V=
s 570 350 610 350 125
a 0 up 33 0 590 349 hct 100 V=
w 128
s 530 320 510 320 127
s 510 320 510 350 129
s 510 350 510 360 133
s 530 350 510 350 131
w 146
a 0 up 0:33 0 0 0 hln 100 V=
s 210 330 210 370 145
s 370 370 370 330 147
s 210 370 250 370 153
s 170 390 250 390 151
s 250 370 370 370 157
a 0 up 33 0 310 369 hct 100 V=
s 250 390 250 370 155
@junction
j 290 260
+ s 17
+ p 16 -
j 210 170
+ p 1 1
+ w 34
j 210 130
+ p 1 2
+ w 44
j 370 130
+ p 2 2
+ w 44
j 370 100
+ w 44
+ w 44
j 460 130
+ p 3 2
+ w 44
j 170 80
+ s 18
+ w 44
j 250 100
+ w 44
+ w 44
j 370 170
+ p 2 1
+ w 59
j 370 190
+ p 8 c
+ w 59
j 340 210
+ p 5 2
+ w 61
j 350 210
+ p 8 b
+ w 61
j 300 210
+ p 5 1
+ w 63
j 290 220
+ p 16 +
+ w 63
j 370 230
+ p 8 e
+ w 67
j 400 180
+ p 11 1
+ w 59
j 370 180
+ w 59
+ w 59
j 430 180
+ p 11 2
+ w 107
j 460 170
+ p 3 1
+ w 107
j 460 190
+ p 9 c
+ w 107
j 460 180
+ w 107
+ w 107
j 460 230
+ p 9 e
+ w 67
j 370 250
+ w 67
+ w 67
j 530 210
+ p 4 1
+ w 118
j 480 210
+ p 9 b
+ w 118
j 570 210
+ p 4 2
+ w 120
j 590 250
+ s 12
+ w 120
j 610 320
+ s 20
+ w 124
j 610 350
+ s 21
+ w 126
j 510 360
+ s 13
+ w 128
j 510 350
+ w 128
+ w 128
j 570 320
+ p 15 +
+ w 124
j 530 320
+ p 15 -
+ w 128
j 570 350
+ p 14 +
+ w 126
j 530 350
+ p 14 -
+ w 128
j 210 290
+ p 6 c
+ w 34
j 350 310
+ p 7 b
+ w 34
j 230 310
+ p 6 b
+ w 34
j 210 330
+ p 6 e
+ w 146
j 370 330
+ p 7 e
+ w 146
j 170 390
+ s 19
+ w 146
j 250 370
+ w 146
+ w 146
j 250 310
+ w 34
+ w 34
j 210 280
+ w 34
+ w 34
j 370 290
+ p 7 c
+ w 67
j 380 180
+ p 162 pin1
+ w 59
j 440 180
+ p 164 pin1
+ w 107
@attributes
a 0 s 0 0 0 0 hln 100 PAGETITLE=
a 0 s 0 0 0 0 hln 100 PAGENO=1
a 0 s 0 0 0 0 hln 100 PAGESIZE=A
a 0 s 0 0 0 0 hln 100 PAGECOUNT=1
@graphics
