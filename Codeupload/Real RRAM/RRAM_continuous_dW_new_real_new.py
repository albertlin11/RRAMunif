# -*- coding: utf-8 -*-
"""
Created on Thu Jul 15 13:55:15 2021

@author: qaz85
"""

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

# training data
df = pd.read_csv(r'.\input data\IV_RRAM_TriD_35_1_real_new_dw.csv')
w_train = np.array(df.iloc[:,0]).reshape(-1,1).astype(float)
w_train_0 = np.concatenate((np.array(df.iloc[:1,0]),np.array(df.iloc[:-1,0])), axis=0).reshape(-1,1).astype(float)
v_train = np.array(df.iloc[:,1]).reshape(-1,1)
y_train = np.array(df.iloc[:,2]).reshape(-1,1)
dw_train = np.array(df.iloc[:,3]).reshape(-1,1)

scaler1 = MinMaxScaler()
scaler2 = MinMaxScaler()

v_train = scaler1.fit_transform(v_train)
y_train = scaler2.fit_transform(y_train)

# testing data
df1 = pd.read_csv(r'.\input data\IV_RRAM_TriD_35_1_real_new_dw.csv')
w_test = np.array(df1.iloc[:,0]).reshape(-1,1).astype(float)
w_test_0 = np.concatenate((np.array(df1.iloc[:1,0]),np.array(df1.iloc[:-1,0])), axis=0).reshape(-1,1).astype(float)
v_test = np.array(df1.iloc[:,1]).reshape(-1,1)
y_test = np.array(df1.iloc[:,2]).reshape(-1,1)
dw_test = np.array(df1.iloc[:,3]).reshape(-1,1)

v_test = scaler1.transform(v_test)
y_test = scaler2.transform(y_test)

delta = np.array([1.0],dtype='float32').reshape(1,1)

# build model
# dw/dt
v_next = tf.keras.Input(shape=(1,),name="Voltage")
w_init = tf.keras.Input(shape=(1,),name="State")
w_v_init = tf.keras.layers.Concatenate(axis=1)([v_next, w_init]) 
dw_next = tf.keras.layers.Dense(units = 20, activation='relu')(w_v_init)
# dw_next = tf.keras.layers.Dense(units = 10, activation='relu')(dw_next)
dw_next = tf.keras.layers.Dense(units = 1,name='output_w')(dw_next)
w_next = w_init + tf.multiply(dw_next,delta)
w_v_next = tf.keras.layers.Concatenate(axis=1)([v_next, w_next]) 
y_next = tf.keras.layers.Dense(units = 20, activation='relu')(w_v_next)
# y_next = tf.keras.layers.Dense(units = 10, activation='relu')(y_next)
y_next = tf.keras.layers.Dense(units = 1,name='output_y')(y_next)


model = tf.keras.Model(inputs=[v_next,w_init], outputs=[dw_next,y_next])
model.compile(optimizer='adam', loss=['mse', 'mse'],loss_weights=[0.5,0.5])
callback =tf.keras.callbacks.EarlyStopping(monitor='loss', mode='min', patience=300, verbose=1,restore_best_weights=True)
hist = model.fit(x=[v_train,w_train_0], y=[dw_train, y_train],batch_size = 32,epochs=100000,shuffle=True,verbose=1,callbacks=[callback])
model.summary()
weights = model.get_weights() 

# predict and unnormalization_training
train_predict = model.predict([v_train,w_train_0])
dw_train_predict = train_predict[0]
y_train_predict = train_predict[1]

v_train = scaler1.inverse_transform(v_train)
y_train = scaler2.inverse_transform(y_train)

y_train_predict = scaler2.inverse_transform(y_train_predict)

w_train_predict = []
for w,dw in zip(w_train_0,dw_train_predict):
    h = w + dw*delta
    w_train_predict.append(h)
w_train_predict = np.array(w_train_predict).reshape(-1,1)

# predict and unnormalization_testing
# dw/dt
delta = np.array([1.0],dtype='float32').reshape(1,1)

w_test_predict = []
y_test_predict = []
w = w_test_0[0]
for v in v_test:
    test_predict = model.predict([v,w])
    dw = test_predict[0]
    y = test_predict[1]
    w = w + dw*delta
    w_test_predict.append(w)
    y_test_predict.append(y)
w_test_predict = np.array(w_test_predict).reshape(-1,1)
y_test_predict = np.array(y_test_predict).reshape(-1,1)
v_test = scaler1.inverse_transform(v_test)
y_test = scaler2.inverse_transform(y_test)
y_test_predict = scaler2.inverse_transform(y_test_predict)

# accuracy and mse
from sklearn.metrics import mean_squared_error, r2_score
acc_w_train = r2_score(w_train,w_train_predict)
acc_y_train = r2_score(y_train,y_train_predict)
mse_w_train = mean_squared_error(w_train,w_train_predict)
mse_y_train = mean_squared_error(y_train,y_train_predict)
acc_w_test = r2_score(w_test,w_test_predict)
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

# csv
# # regression
# df = pd.DataFrame(np.concatenate((v_train,w_train,w_train_predict,y_train,y_train_predict),axis=1))
# filepath= r'.\csv\continuous dWdt\train_TriD_real_new.csv'
# df.to_csv(filepath,header=['Voltage_V','State','State_pred','Current_A','Current_pred_A'],index=False)

# df = pd.DataFrame(np.concatenate((v_test,w_test,w_test_predict,y_test,y_test_predict),axis=1))
# filepath1= r'.\csv\continuous dWdt\test_TriD_real_new.csv'
# df.to_csv(filepath1,header=['Voltage_V','State','State_pred','Current_A','Current_pred_A'],index=False)
