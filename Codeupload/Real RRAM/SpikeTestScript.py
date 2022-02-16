# -*- coding: utf-8 -*-


vvv=np.arange(-1.5,1.2,0.005,dtype=float).reshape((-1,1))
iw = model.predict([scaler1.transform(vvv),np.zeros((vvv.shape[0],1))])
ww=iw[0]
iii=iw[1]
iii=scaler2.inverse_transform(iii)
iii=log_inv_trans(vvv,iii)
plt.figure()
plt.plot(vvv,iii)
plt.figure()
plt.plot(vvv,ww[:,0])
plt.plot(vvv,ww[:,1])