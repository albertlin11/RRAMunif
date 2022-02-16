# Not finished yet

import tensorflow as tf
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import random
import os
from sklearn.preprocessing import MinMaxScaler

seed_value= 1
os.environ['PYTHONHASHSEED']=str(seed_value)
random.seed(seed_value)
np.random.seed(seed_value)
tf.random.set_seed(seed_value)

plt.close("all")



def swCalc_IW(i,w):
    swii=np.ones((i.shape[0],))
    swww=np.ones((w.shape[0],))
    for ii in range(i.shape[0]):
        if np.absolute(i[ii])>8e-6:
             swii[ii]=2
                
        if np.absolute(i[ii])>1.75e-4:
             swii[ii]=36
        if np.absolute(i[ii])>7e-4:
             swii[ii]=138
        #sww[ii]=1/np.absolute(a[ii])
    for ii in range(w.shape[0]-1):
        kk=38
        
        if w[ii] != w[ii+1]:
             swww[ii]=138
             swww[ii-1]=kk
             swww[ii-2]=kk
             swww[ii+1]=kk
             swww[ii+2]=kk
             #swii[ii]=1000
             #swii[ii-1]=kk
             #swii[ii-2]=kk
             #swii[ii+1]=kk
             #swii[ii+2]=kk
    return swww.reshape((-1,)),swii.reshape((-1,))


def logtrans(a):
    for ii in range(a.shape[0]):
        if a[ii]>=0:
            a[ii]=np.log10(a[ii])
        else:
            a[ii]=np.log10(-a[ii])
    return a

def log_inv_trans(v,a):
    for ii in range(a.shape[0]):
        if v[ii]>=0:
            a[ii]=np.power(10,a[ii])
        else:
            a[ii]=-1*np.power(10,a[ii])
    return a

# training data
df = pd.read_csv('./input data/IV_RRAM_TriD_35_1_real_new2.csv')
w_train = np.array(df.iloc[:,0]).reshape(-1,1).astype(float)
w_train_0 = np.concatenate((np.array(df.iloc[:1,0]),np.array(df.iloc[:-1,0])), axis=0).reshape(-1,1).astype(float)
v_train = np.array(df.iloc[:,1]).reshape(-1,1)
y_train = np.array(df.iloc[:,2]).reshape(-1,1)


#SPICE supplement
for ind in range(w_train_0.shape[0]):
    if v_train[ind,0] > 0.8 or v_train[ind,0] < -1.2:
        v_train=np.concatenate((v_train,v_train[ind,0].reshape((-1,1))), axis=0)
        w_train_0=np.concatenate((w_train_0,1-w_train_0[ind,0].reshape((-1,1))), axis=0)
        y_train=np.concatenate((y_train,y_train[ind,0].reshape((-1,1))), axis=0)
        w_train=np.concatenate((w_train,w_train[ind,0].reshape((-1,1))), axis=0)

########

sww,swi=swCalc_IW(y_train,w_train_0)

y_train=logtrans(y_train)

scaler1 = MinMaxScaler()
scaler2 = MinMaxScaler()


v_train = scaler1.fit_transform(v_train)
y_train = scaler2.fit_transform(y_train)

# testing data
df1 = pd.read_csv(r'.\input data\IV_RRAM_RanD_35_1_real_new2.csv')
w_test = np.array(df1.iloc[:,0]).reshape(-1,1).astype(float)
w_test_0 = np.concatenate((np.array(df1.iloc[:1,0]),np.array(df1.iloc[:-1,0])), axis=0).reshape(-1,1).astype(float)
v_test = np.array(df1.iloc[:,1]).reshape(-1,1)
y_test = np.array(df1.iloc[:,2]).reshape(-1,1)

y_test=logtrans(y_test)

v_test = scaler1.transform(v_test)
y_test = scaler2.transform(y_test)

# build model
# classification
v_next = tf.keras.Input(shape=(1,),name="Voltage")
w_init = tf.keras.Input(shape=(1,),name="State")
w_v_init = tf.keras.layers.Concatenate(axis=1)([v_next, w_init]) 
w_v_init = tf.keras.layers.Dense(units = 20, activation='relu')(w_v_init)
w_next = tf.keras.layers.Dense(units = 20, activation='relu')(w_v_init)
w_next = tf.keras.layers.Dense(units = 2, activation='sigmoid',name='output_w')(w_next)
w_v_next = tf.keras.layers.Concatenate(axis=1)([v_next, w_next]) 
w_v_next = tf.keras.layers.Dense(units = 20, activation='relu')(w_v_next)
y_next = tf.keras.layers.Dense(units = 20, activation='relu')(w_v_next)
y_next = tf.keras.layers.Dense(units = 1,name='output_y')(y_next)

binary_loss = tf.keras.losses.BinaryCrossentropy(from_logits=False)
model = tf.keras.Model(inputs=[v_next,w_init], outputs=[w_next,y_next])
model.compile(optimizer='adam', loss=['sparse_categorical_crossentropy', 'mse'],loss_weights=[0.5,0.5],metrics=['accuracy','mse'])
callback =tf.keras.callbacks.EarlyStopping(monitor='loss', mode='min', patience=300000, verbose=1,restore_best_weights=True)
hist = model.fit(x=[v_train,w_train_0], y=[w_train, y_train],
                sample_weight=[sww,swi]  ,batch_size = 32,epochs=10000,shuffle=True,verbose=1,callbacks=[callback])
model.summary()
weights = model.get_weights() 
#for ind in [0,1,3,4,5,6,7,9,10,11]:
#    np.savetxt('test'+ str(ind)+'.txt', weights[ind], delimiter=',') 



    
# predict and unnormalization_training
train_predict = model.predict([v_train,w_train_0])
w_train_predict = train_predict[0]
w_train_predict = np.argmax(w_train_predict,axis=1).reshape(-1,1).astype(float)
y_train_predict = train_predict[1]

v_train = scaler1.inverse_transform(v_train)
y_train = scaler2.inverse_transform(y_train)
y_train=log_inv_trans(v_train,y_train)

y_train_predict = scaler2.inverse_transform(y_train_predict)
y_train_predict=log_inv_trans(v_train,y_train_predict)
# predict and unnormalization_testing
# classification
w_test_predict = []
y_test_predict = []
w = w_test_0[0]
for v in v_test:
    test_predict = model.predict([v,w])
    w = test_predict[0]
    w = np.argmax(w).astype(float)
    w = np.array([w])
    y = test_predict[1]
    w_test_predict.append(w)
    y_test_predict.append(y)
w_test_predict = np.array(w_test_predict).reshape(-1,1)
y_test_predict = np.array(y_test_predict).reshape(-1,1)
v_test = scaler1.inverse_transform(v_test)
y_test = scaler2.inverse_transform(y_test)
y_test=log_inv_trans(v_test, y_test)
y_test_predict = scaler2.inverse_transform(y_test_predict)
y_test_predict=log_inv_trans(v_test, y_test_predict)

# accuracy and mse
from sklearn.metrics import mean_squared_error, r2_score, accuracy_score
acc_w_train = accuracy_score(w_train,w_train_predict)
acc_y_train = r2_score(y_train,y_train_predict)
mse_w_train = mean_squared_error(w_train,w_train_predict)
mse_y_train = mean_squared_error(y_train,y_train_predict)
acc_w_test = accuracy_score(w_test,w_test_predict)
acc_y_test = r2_score(y_test,y_test_predict)
mse_w_test = mean_squared_error(w_test,w_test_predict)
mse_y_test = mean_squared_error(y_test,y_test_predict)

# figure
plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('current in train data')
plt.plot(y_train,c='b',label='true data')
plt.plot(y_train_predict,c='orange',label='predict data')
plt.xlabel('Time (nsec)')
plt.ylabel('Current (A)')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('current in test data')
plt.plot(y_test,c='b',label='true data')
plt.plot(y_test_predict,c='orange',label='predict data')
plt.xlabel('Time (nsec)')
plt.ylabel('Current (A)')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('voltage in train data')
plt.plot(v_train,c='b',label='true data')
plt.xlabel('Time (nsec)')
plt.ylabel('Voltage')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('voltage in test data')
plt.plot(v_test,c='b',label='true data')
plt.xlabel('Time (nsec)')
plt.ylabel('Voltage')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('state in train data')
plt.plot(w_train,c='b',label='true data')
plt.plot(w_train_predict,c='orange',label='predict data')
plt.xlabel('Time (nsec)')
plt.ylabel('State')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('state in test data')
plt.plot(w_test,c='b',label='true data')
plt.plot(w_test_predict,c='orange',label='predict data')
plt.xlabel('Time (nsec)')
plt.ylabel('State')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('IV in train data')
plt.plot(v_train,y_train,c='b',label='true data')
plt.scatter(v_train,y_train_predict,c='orange',label='predict data',s=25)
plt.xlabel('Voltage (V)')
plt.ylabel('Current (A)')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('IV in test data')
plt.plot(v_test,y_test,c='b',label='true data')
plt.scatter(v_test,y_test_predict,c='orange',label='predict data',s=25)
plt.xlabel('Voltage (V)')
plt.ylabel('Current (A)')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('IV in test data')
plt.plot(v_test,np.log10(np.absolute(y_test)),'rs-',label='true data')
plt.plot(v_test,np.log10(np.absolute(y_test_predict)),'bo-',label='predict data')
plt.xlabel('Voltage (V)')
plt.ylabel('Log Current (A)')
# csv
# classification
# df = pd.DataFrame(np.concatenate((v_train,w_train,w_train_predict,y_train,y_train_predict),axis=1))
# filepath= r'.\csv\discrete\classification\train_TriD_real_new.csv'
# df.to_csv(filepath,header=['Voltage_V','State','State_pred','Current_A','Current_pred_A'],index=False)

df = pd.DataFrame(np.concatenate((v_test,w_test,w_test_predict,y_test,y_test_predict),axis=1))
filepath1= r'.\csv\discrete\classification\test_RanD_real_new2.csv'
df.to_csv(filepath1,header=['Voltage_V','State','State_pred','Current_A','Current_pred_A'],index=False)
