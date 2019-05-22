*version 9.1 566953070
lib "E:\Analog\SchResurection\Examples\MIXSIM\OSC\OSC.slb" 3269009323
u 270
U? 7
R? 2
C? 2
PRINT? 1
V? 1
? 6
DSTM? 2
@libraries
"OSC" [.slb]
@analysis
.AC 0 1 0
+0 10
+1 1.00K
+2 101
.DC 0 0 0 0 1 1
.TRAN 1 0 0 0
+0 10NS
+1 10us
.SAVEBIAS 0 0 0 0 0
.LOADBIAS 0 
.OPT 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
.STEP 0 1 1
.TEMP 0 27
.PROBE 0 0 1 1 0 2
.STMLIB Osc.stl
@targets
@attributes
@translators
a 0 u 13 0 0 0 hln 100 PCBOARDS=PCB
a 0 u 13 0 0 0 hln 100 PSPICE=DEFAULT
a 0 u 13 0 0 0 hln 100 XILINX=XILINX
a 0 u 13 0 0 0 hln 100 PCAD=PCB
a 0 u 13 0 0 0 hln 100 CADSTAR=PCB
a 0 u 13 0 0 0 hln 100 EDIF=PCB
a 0 u 13 0 0 0 hln 100 ORCAD=PCB
a 0 u 13 0 0 0 hln 100 PADS=PCB
a 0 u 13 0 0 0 hln 100 PROTEL=PCB
a 0 u 13 0 0 0 hln 100 TANGO=PCB
a 0 u 13 0 0 0 hln 100 SCICARDS=PCB
a 0 u 13 0 0 0 hln 100 POLARIS=PCB
a 0 u 13 0 0 0 hln 100 PRINT=DEFAULT
@setup
unconnectedPins 0
connectViaLabel 0
connectViaLocalLabels 0
NoStim4ExtIFPortsWarnings 1
AutoGenStim4ExtIFPorts 1
@index
pageloc 1 0 5282 
@status
n 0 99:07:13:14:11:39;934578699 e 
s 2832 99:07:13:14:11:39;934578699 e 
*page 1 0 1520 970 iA
@ports
port 67 GLOBAL 490 100 u
a 1 s 13 0 13 23 hcn 100 LABEL=OUT
a 0 sp 0 0 0 0 hln 100 PART=GLOBAL
port 68 GLOBAL 490 120 u
a 1 s 13 0 20 -5 hcn 100 LABEL=OUTBAR
a 0 sp 0 0 0 0 hln 100 PART=GLOBAL
port 189 HI 400 90 h
a 1 s 0 0 1 14 hln 100 LABEL=$D_HI
@parts
part 1 7405 130 180 v
a 0 s 13 0 20 7 hln 100 PART=7405
a 0 ap 9 0 34 15 hln 100 REFDES=U1
a 0 s 0 0 0 0 hln 100 PKGREF=U1
part 2 7414 180 110 h
a 0 s 13 0 30 40 hln 100 PART=7414
a 0 ap 9 0 31 8 hln 100 REFDES=U2
a 0 u 0 0 0 0 hln 100 IO_LEVEL=3
a 0 s 0 0 0 0 hln 100 PKGREF=U2
part 4 7404 250 190 h
a 0 s 13 0 36 41 hln 100 PART=7404
a 0 ap 9 0 40 10 hln 100 REFDES=U3
a 0 s 0 0 0 0 hln 100 PKGREF=U3
part 5 R 250 100 v
a 0 sp 0 0 0 0 hln 100 PART=R
a 0 ap 9 0 32 32 hcn 100 REFDES=R1
a 0 u 13 0 16 33 hcn 100 value=750
a 0 s 0 0 0 0 hln 100 PKGREF=R1
part 6 C 300 50 h
a 0 sp 0 0 0 0 hln 100 PART=C
a 0 ap 9 0 15 0 hcn 100 REFDES=C1
a 0 u 13 0 15 25 hcn 100 value=400pF
a 0 s 0 0 0 0 hln 100 PKGREF=C1
part 150 7414 280 110 h
a 0 s 13 0 30 40 hln 100 PART=7414
a 0 ap 9 0 31 8 hln 100 REFDES=U5
a 0 u 0 0 0 0 hln 100 IO_LEVEL=3
a 0 s 0 0 0 0 hln 100 PKGREF=U5
part 160 74107 410 90 h
a 0 s 11 0 40 80 hln 100 PART=74107
a 1 ap 9 0 40 -2 hln 100 REFDES=U6
a 0 s 0 0 0 0 hln 100 PKGREF=U6
part 263 DigStim 90 190 h
a 0 s 13 13 4 19 hln 70 STIMULUS=Reset
a 0 a 0 0 0 0 hln 100 PKGREF=DSTM1
a 1 ap 9 0 13 -1 hcn 100 REFDES=DSTM1
part 262 readme 160 230 h
a 0 u 3 0 22 34 hln 100 filename=osc.rdm
a 0 sp 0 0 17 20 hln 200 PART=readme
a 0 a 0 0 0 0 hln 100 PKGREF=
part 261 nodeMarker 490 100 h
a 0 s 0 0 0 0 hln 100 PROBEVAR=
a 0 a 0 0 4 22 hlb 100 LABEL=5
part 260 nodeMarker 90 190 h
a 0 s 0 0 0 0 hln 100 PROBEVAR=
a 0 a 0 0 4 22 hlb 100 LABEL=4
part 259 nodeMarker 130 110 d
a 0 s 0 0 0 0 hln 100 PROBEVAR=
a 0 a 0 0 4 22 hlb 100 LABEL=3
part 258 nodeMarker 250 110 d
a 0 s 0 0 0 0 hln 100 PROBEVAR=
a 0 a 0 0 4 22 hlb 100 LABEL=2
part 257 nodeMarker 350 110 d
a 0 s 0 0 0 0 hln 100 PROBEVAR=
a 0 a 0 0 4 22 hlb 100 LABEL=1
@conn
w 13
a 0 up 0:33 0 0 0 hln 100 Lvl=
s 440 190 440 160 175
s 300 190 440 190 186
a 0 up 33 0 370 189 hct 100 Lvl=
w 179
a 0 up 0:33 0 0 0 hln 100 Lvl=
s 470 100 490 100 178
a 0 up 33 0 480 99 hct 100 Lvl=
w 183
a 0 up 0:33 0 0 0 hln 100 Lvl=
s 470 120 490 120 182
a 0 up 33 0 480 119 hct 100 Lvl=
w 191
a 0 up 0:33 0 0 0 hln 100 Lvl=
s 400 90 410 90 195
s 400 130 400 90 202
a 0 up 33 0 402 110 hlt 100 Lvl=
s 400 130 410 130 198
w 22
a 0 sr 3 0 155 108 hln 100 LABEL=1
a 0 up 0:33 0 0 0 hln 100 V=
s 130 110 180 110 267
a 0 sr 3 0 155 108 hln 100 LABEL=1
a 0 up 33 0 155 109 hlt 100 V=
s 130 50 250 50 23
s 130 130 130 110 154
s 250 50 300 50 234
s 250 50 250 60 230
s 130 110 130 50 245
w 44
a 0 sr 3 0 265 108 hln 100 LABEL=2
a 0 up 0:33 0 0 0 hln 100 V=
s 250 110 280 110 265
a 0 sr 3 0 265 108 hln 100 LABEL=2
a 0 up 33 0 265 109 hlt 100 V=
s 250 110 250 100 238
s 230 110 250 110 268
w 132
a 0 sr 3 0 375 108 hln 100 LABEL=3
a 0 up 0:33 0 0 0 hln 100 V=
s 350 110 410 110 264
a 0 sr 3 0 375 108 hln 100 LABEL=3
a 0 up 33 0 375 109 hlt 100 V=
s 330 50 350 50 31
s 350 50 350 110 219
s 330 110 350 110 269
w 10
a 0 sp 0 0 0 0 hln 100 LABEL=RESET
a 0 up 0:33 0 0 0 hln 100 Lvl=
s 130 190 250 190 137
a 0 sp 3 0 190 188 hln 100 LABEL=RESET
a 0 up 33 0 190 189 hlt 100 Lvl=
s 90 190 130 190 88
s 130 190 130 180 16
@junction
j 250 190
+ p 4 A
+ w 10
j 300 190
+ p 4 Y
+ w 13
j 130 180
+ p 1 A
+ w 10
j 130 130
+ p 1 Y
+ w 22
j 300 50
+ p 6 1
+ w 22
j 330 50
+ p 6 2
+ w 132
j 130 190
+ w 10
+ w 10
j 490 100
+ s 67
+ w 179
j 490 120
+ s 68
+ w 183
j 350 110
+ w 132
+ w 132
j 250 60
+ p 5 2
+ w 22
j 250 50
+ w 22
+ w 22
j 230 110
+ p 2 Y
+ w 44
j 250 100
+ p 5 1
+ w 44
j 180 110
+ p 2 A
+ w 22
j 130 110
+ w 22
+ w 22
j 280 110
+ p 150 A
+ w 44
j 250 110
+ w 44
+ w 44
j 330 110
+ p 150 Y
+ w 132
j 400 90
+ s 189
+ w 191
j 90 190
+ p 260 pin1
+ w 10
j 490 100
+ p 261 pin1
+ s 67
j 490 100
+ p 261 pin1
+ w 179
j 440 160
+ p 160 \CLR\
+ w 13
j 410 110
+ p 160 CLK
+ w 132
j 470 100
+ p 160 Q
+ w 179
j 470 120
+ p 160 \Q\
+ w 183
j 410 90
+ p 160 J
+ w 191
j 410 130
+ p 160 K
+ w 191
j 90 190
+ p 263 *OUT
+ p 260 pin1
j 90 190
+ p 263 *OUT
+ w 10
j 130 110
+ p 259 pin1
+ w 22
j 250 110
+ p 258 pin1
+ w 44
j 350 110
+ p 257 pin1
+ w 132
@attributes
a 0 sp 0 0 0 0 hln 100 PAGETITLE=
a 0 sp 0 0 0 0 hln 100 PAGETITLE=
a 0 sp 0 0 0 0 hln 100 PAGETITLE=
a 0 sp 0 0 0 0 hln 100 PAGETITLE=
a 0 sp 0 0 0 0 hln 100 PAGETITLE=
a 0 sp 0 0 0 0 hln 100 PAGETITLE=
a 0 sp 0 0 0 0 hln 100 PAGETITLE=
a 0 sp 0 0 0 0 hln 100 PAGETITLE=
a 0 sp 0 0 0 0 hln 100 PAGETITLE=
a 0 sp 0 0 0 0 hln 100 PAGETITLE=
a 0 sp 0 0 0 0 hln 100 PAGENO=1
a 0 sp 0 0 0 0 hln 100 PAGESIZE=A
a 0 sp 0 0 0 0 hln 100 PAGENO=1
a 0 sp 0 0 0 0 hln 100 PAGESIZE=1
a 0 sp 0 0 0 0 hln 100 PAGENO=1
a 0 sp 0 0 0 0 hln 100 PAGESIZE=1
a 0 sp 0 0 0 0 hln 100 PAGENO=1
a 0 sp 0 0 0 0 hln 100 PAGESIZE=1
a 0 sp 0 0 0 0 hln 100 PAGENO=1
a 0 sp 0 0 0 0 hln 100 PAGESIZE=1
a 0 sp 0 0 0 0 hln 100 PAGENO=1
a 0 sp 0 0 0 0 hln 100 PAGESIZE=1
a 0 sp 0 0 0 0 hln 100 PAGENO=1
a 0 sp 0 0 0 0 hln 100 PAGESIZE=1
a 0 sp 0 0 0 0 hln 100 PAGENO=1
a 0 sp 0 0 0 0 hln 100 PAGESIZE=1
a 0 sp 0 0 0 0 hln 100 PAGENO=1
a 0 sp 0 0 0 0 hln 100 PAGESIZE=1
a 0 sp 0 0 0 0 hln 100 PAGENO=1
a 0 sp 0 0 0 0 hln 100 PAGESIZE=1
@graphics
