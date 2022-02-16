****Pulse Operation

.hdl "rram.va"

**BSIM-SOI
.hdl "bsimsoi.va"
.include "modelcard.nmos"
.include "modelcard.pmos"

.options post
.option maxstep = 50n

* --- Voltage Sources ---

vs source 0 dc 0



vdd vd 0 pwl(0n 0V 23n 0V 47n 1.2V 70n 1.2V 94n 0V 117n 0V 141n 0.5V 164n 0.5V 188n 0V 211n 0V 235n -1.5V 258n -1.5V 282n 0V 305n 0V 329n 0.5V 352n 0.5V 376n 0V 399n 0V,R 0)
vg gate 0 pwl(0n 0V 15n 0V 39n 1.5V 78n 1.5V 102n 0V 109n 0V 132n 1.5V 172n 1.5V 196n 0V 203n 0V 227n 1.5V 266n 1.5V 290n 0V 297n 0V 321n 1.5V 360n 1.5V 384n 0V 399n 0V,R 0)





x1 drain gate source 0 nmos1 W=100u L=0.18u
X2 vd drain linear  time_step=50n




.tran 1ns 399ns 

.end
