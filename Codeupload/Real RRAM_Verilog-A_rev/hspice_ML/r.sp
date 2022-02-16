****** ra
.hdl "rram.va"


.options post




.option maxstep = 5n
.param set=1.2
.param reset=-1.5



**Vg node0 0 pwl(0n 0V 25n 0V 49n 1.2V 74n 1.2V 98n 0V 123n 0V 133n 0.5V 158n 0.5V 168n 0V 193n 0V 223n -1.5V 248n -1.5V 278n 0V 303n 0V 313n 0.5V 338n 0.5V 348n 0V,R 0)
**Vg node0 0 pwl(0n 0V 25n 0V 27.4n 1.2V 52.4n 1.2V 54.8n 0V 79.8n 0V 80.8n 0.5V 105.8n 0.5V 106.8n 0V 131.8n 0V 134.8n -1.5V 159.8n -1.5V 162.8n 0V 187.8n 0V 188.8n 0.5V 213.8n 0.5V 214.8n 0V,R 0)
**Vg node0 0 pwl(0n 0V 25n 0V 265n 1.2V 290n 1.2V 530n 0V 555n 0V 655n 0.5V 680n 0.5V 780n 0V 805n 0V 1105n -1.5V 1130n -1.5V 1430n 0V 1455n 0V 1555n 0.5V 1580n 0.5V 1680n 0V,R 0)
**Vg node0 0 pwl(0n 0V 0.25n 0V 24.25n 1.2V 24.5n 1.2V 48.5n 0V 48.75n 0V 58.75n 0.5V 59n 0.5V 69n 0V 69.25n 0V 99.25n -1.5V 99.5n -1.5V 129.5n 0V 129.75n 0V 139.75n 0.5V 140n 0.5V 150n 0V,R 0)
**Vg node0 0 pwl(0n 0V 250n 0V 274n 1.2V 524n 1.2V 548n 0V 798n 0V 808n 0.5V 1058n 0.5V 1068n 0V 1318n 0V 1348n -1.5V 1598n -1.5V 1628n 0V 1878n 0V 1888n 0.5V 2138n 0.5V 2148n 0V,R 0)

**Vg node0 0 SIN(-0.2V 1.1V 0.1g 0ns)

Vg node0 0 pwl(0n 0V 25n 0V 35n 0.5V 60n 0.5V 70n 0V 95n 0V 125n reset 150n reset 180n 0V 205n 0V 215n 0.5V 240n 0.5V 250n 0V 275n 0V 299n set 324n set 348n 0V 373n 0V 383n 0.5V 408n 0.5V 418n 0V 443n 0V 473n reset 498n reset 528n 0V 553n 0V 563n 0.5V 588n 0.5V 598n 0V 623n 0V 647n set 672n set 696n 0V 721n 0V 731n 0.5V 756n 0.5V 766n 0V 791n 0V 821n reset 846n reset 876n 0V 901n 0V 911n 0.5V 936n 0.5V 946n 0V 971n 0V 995n set 1020n set 1044n 0V 1069n 0V 1079n 0.5V 1104n 0.5V 1114n 0V 1139n 0V 1163n set 1188n set 1212n 0V 1237n 0V 1247n 0.5V 1272n 0.5V 1282n 0V 1307n 0V 1331n set 1356n set 1380n 0V 1405n 0V 1415n 0.5V 1440n 0.5V 1450n 0V 1475n 0V 1505n reset 1530n reset 1560n 0V 1585n 0V 1595n 0.5V 1620n 0.5V 1630n 0V 1655n 0V 1679n set 1704n set 1728n 0V,R 0)






Va node1 0 dc 0


x1 node0 node1 linear  time_step=5n

.op
**.TRAN 1ns 60ns
.TRAN 1ns 1728ns
**.TRAN 1ns 2148ns
.end
