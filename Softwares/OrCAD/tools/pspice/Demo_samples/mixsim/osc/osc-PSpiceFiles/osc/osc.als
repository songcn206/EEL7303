.ALIASES
X_U4A           U4A(A=RESET Y=N00041 VCC=$G_DPWR GND=$G_DGND ) CN @OSC.Osc(sch_1):I00001@7400.7404.Normal(chips)
X_U2A           U2A(A=RESET Y=N00112 VCC=$G_DPWR GND=$G_DGND ) CN @OSC.Osc(sch_1):I00005@7400.7405.Normal(chips)
X_U3A           U3A(A=N00112 Y=N00050 VCC=$G_DPWR GND=$G_DGND ) CN @OSC.Osc(sch_1):I00007@7400.7414.Normal(chips)
X_U3B           U3B(A=N00050 Y=N00075 VCC=$G_DPWR GND=$G_DGND ) CN @OSC.Osc(sch_1):I00009@7400.7414.Normal(chips)
X_U1A           U1A(CLK=N00075 CLRbar=N00041 J=$D_HI K=$D_HI Q=OUT Qbar=OUTBAR VCC=$G_DPWR GND=$G_DGND ) CN
+@OSC.Osc(sch_1):I00011@7400.74107.Normal(chips)
R_R1            R1(1=N00050 2=N00112 ) CN @OSC.Osc(sch_1):I00048@ANALOG.R.Normal(chips)
C_C1            C1(1=N00112 2=N00075 ) CN @OSC.Osc(sch_1):I00066@ANALOG.C.Normal(chips)
U_DSTM1          DSTM1(VCC=$G_DPWR GND=$G_DGND OUT=RESET ) CN @OSC.Osc(sch_1):I16604@SOURCSTM.DigStim1.Normal(chips)
_    _(OUTBAR=OUTBAR)
_    _(OUT=OUT)
_    _(RESET=RESET)
.ENDALIASES
