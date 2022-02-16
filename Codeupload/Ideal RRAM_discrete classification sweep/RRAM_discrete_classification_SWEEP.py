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
df = pd.read_csv(r'.\input data\IV_RRAM_TriD_17_2_SWEEP.csv')
t_train_1 = np.array(df.iloc[:,0]).reshape(-1,1)
w_train_1 = np.array(df.iloc[:,1]).reshape(-1,1).astype(float)
w_train_01 = np.concatenate((np.array(df.iloc[:1,1]),np.array(df.iloc[:-1,1])), axis=0).reshape(-1,1).astype(float)
v_train_1 = np.array(df.iloc[:,2]).reshape(-1,1)
y_train_1 = np.array(df.iloc[:,3]).reshape(-1,1)
r_train_1 = np.repeat(1,df.shape[0]).reshape(-1,1).astype(float)
t_train_2 = np.array(df.iloc[:,4]).reshape(-1,1)
w_train_2 = np.array(df.iloc[:,5]).reshape(-1,1).astype(float)
w_train_02 = np.concatenate((np.array(df.iloc[:1,5]),np.array(df.iloc[:-1,5])), axis=0).reshape(-1,1).astype(float)
v_train_2 = np.array(df.iloc[:,6]).reshape(-1,1)
y_train_2 = np.array(df.iloc[:,7]).reshape(-1,1)
r_train_2 = np.repeat(2,df.shape[0]).reshape(-1,1).astype(float)
t_train_3 = np.array(df.iloc[:,8]).reshape(-1,1)
w_train_3 = np.array(df.iloc[:,9]).reshape(-1,1).astype(float)
w_train_03 = np.concatenate((np.array(df.iloc[:1,9]),np.array(df.iloc[:-1,9])), axis=0).reshape(-1,1).astype(float)
v_train_3 = np.array(df.iloc[:,10]).reshape(-1,1)
y_train_3 = np.array(df.iloc[:,11]).reshape(-1,1)
r_train_3 = np.repeat(10,df.shape[0]).reshape(-1,1).astype(float)

t_train = np.concatenate((t_train_1,t_train_2,t_train_3), axis = 0)
w_train = np.concatenate((w_train_1,w_train_2,w_train_3), axis = 0)
w_train_0 = np.concatenate((w_train_01,w_train_02,w_train_03), axis = 0)
v_train = np.concatenate((v_train_1,v_train_2,v_train_3), axis = 0)
y_train = np.concatenate((y_train_1,y_train_2,y_train_3), axis = 0)
r_train = np.concatenate((r_train_1,r_train_2,r_train_3), axis = 0)

scaler1 = MinMaxScaler()
scaler2 = MinMaxScaler()
scaler3 = MinMaxScaler()

v_train = scaler1.fit_transform(v_train)
y_train = scaler2.fit_transform(y_train)
r_train = scaler3.fit_transform(r_train)

# testing data
df = pd.read_csv(r'.\input data\IV_RRAM_TriD_17_2_SWEEP.csv')
t_test_1 = np.array(df.iloc[:,0]).reshape(-1,1)
w_test_1 = np.array(df.iloc[:,1]).reshape(-1,1).astype(float)
w_test_01 = np.concatenate((np.array(df.iloc[:1,1]),np.array(df.iloc[:-1,1])), axis=0).reshape(-1,1).astype(float)
v_test_1 = np.array(df.iloc[:,2]).reshape(-1,1)
y_test_1 = np.array(df.iloc[:,3]).reshape(-1,1)
r_test_1 = np.repeat(1,df.shape[0]).reshape(-1,1).astype(float)
t_test_2 = np.array(df.iloc[:,4]).reshape(-1,1)
w_test_2 = np.array(df.iloc[:,5]).reshape(-1,1).astype(float)
w_test_02 = np.concatenate((np.array(df.iloc[:1,5]),np.array(df.iloc[:-1,5])), axis=0).reshape(-1,1).astype(float)
v_test_2 = np.array(df.iloc[:,6]).reshape(-1,1)
y_test_2 = np.array(df.iloc[:,7]).reshape(-1,1)
r_test_2 = np.repeat(2,df.shape[0]).reshape(-1,1).astype(float)
t_test_3 = np.array(df.iloc[:,8]).reshape(-1,1)
w_test_3 = np.array(df.iloc[:,9]).reshape(-1,1).astype(float)
w_test_03 = np.concatenate((np.array(df.iloc[:1,9]),np.array(df.iloc[:-1,9])), axis=0).reshape(-1,1).astype(float)
v_test_3 = np.array(df.iloc[:,10]).reshape(-1,1)
y_test_3 = np.array(df.iloc[:,11]).reshape(-1,1)
r_test_3 = np.repeat(10,df.shape[0]).reshape(-1,1).astype(float)

t_test = np.concatenate((t_test_1,t_test_2,t_test_3), axis = 0)
w_test = np.concatenate((w_test_1,w_test_2,w_test_3), axis = 0)
w_test_0 = np.concatenate((w_test_01,w_test_02,w_test_03), axis = 0)
v_test = np.concatenate((v_test_1,v_test_2,v_test_3), axis = 0)
y_test = np.concatenate((y_test_1,y_test_2,y_test_3), axis = 0)
r_test = np.concatenate((r_test_1,r_test_2,r_test_3), axis = 0)

v_test = scaler1.transform(v_test)
y_test = scaler2.transform(y_test)
r_test = scaler3.transform(r_test)

# build model
# classification
v_next = tf.keras.Input(shape=(1,),name="Voltage")
w_init = tf.keras.Input(shape=(1,),name="State")
r = tf.keras.Input(shape=(1,),name="Time")
w_v_init = tf.keras.layers.Concatenate(axis=1)([v_next, w_init, r]) 
w_next = tf.keras.layers.Dense(units = 10, activation='relu')(w_v_init)
w_next = tf.keras.layers.Dense(units = 10, activation='relu')(w_next)
w_next = tf.keras.layers.Dense(units = 2, activation='sigmoid',name='output_w')(w_next)
w_v_next = tf.keras.layers.Concatenate(axis=1)([v_next, w_next, r]) 
y_next = tf.keras.layers.Dense(units = 10, activation='relu')(w_v_next)
y_next = tf.keras.layers.Dense(units = 10, activation='relu')(y_next)
y_next = tf.keras.layers.Dense(units = 1,name='output_y')(y_next)

model = tf.keras.Model(inputs=[v_next,w_init, r], outputs=[w_next,y_next])
model.compile(optimizer='adam', loss=['sparse_categorical_crossentropy', 'mse'],loss_weights=[0.5,0.5],metrics=['accuracy','mse'])
callback =tf.keras.callbacks.EarlyStopping(monitor='loss', mode='min', patience=300, verbose=1,restore_best_weights=True)
hist = model.fit(x=[v_train,w_train_0,r_train], y=[w_train, y_train],batch_size = 32,epochs=100000,shuffle=True,verbose=1,callbacks=[callback])
model.summary()
weights = model.get_weights() 

# predict and unnormalization_training
train_predict = model.predict([v_train,w_train_0,r_train])
w_train_predict = train_predict[0]
w_train_predict = np.argmax(w_train_predict,axis=1).reshape(-1,1).astype(float)
y_train_predict = train_predict[1]

v_train = scaler1.inverse_transform(v_train)
y_train = scaler2.inverse_transform(y_train)
r_train = scaler3.inverse_transform(r_train)
y_train_predict = scaler2.inverse_transform(y_train_predict)

# predict and unnormalization_testing
# classification
w_test_predict = []
y_test_predict = []
w = w_test_0[0]
for v,r in zip(v_test,r_test):
    test_predict = model.predict([v,w,r])
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
r_test = scaler3.inverse_transform(r_test)
y_test_predict = scaler2.inverse_transform(y_test_predict)

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
plt.xlabel('Time (sec)')
plt.ylabel('Current (A)')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('current in test data')
plt.plot(y_test,c='b',label='true data')
plt.plot(y_test_predict,c='orange',label='predict data')
plt.xlabel('Time (sec)')
plt.ylabel('Current (A)')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('voltage in train data')
plt.plot(v_train,c='b',label='true data')
plt.xlabel('Time (sec)')
plt.ylabel('Voltage')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('voltage in test data')
plt.plot(v_test,c='b',label='true data')
plt.xlabel('Time (sec)')
plt.ylabel('Voltage')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('state in train data')
plt.plot(w_train,c='b',label='true data')
plt.plot(w_train_predict,c='orange',label='predict data')
plt.xlabel('Time (sec)')
plt.ylabel('State')

plt.figure(figsize=(10,10))
plt.rcParams["font.size"] = 14
plt.title('state in test data')
plt.plot(w_test,c='b',label='true data')
plt.plot(w_test_predict,c='orange',label='predict data')
plt.xlabel('Time (sec)')
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
# classification
# df = pd.DataFrame(np.concatenate((t_train,v_train,w_train,w_train_predict,y_train,y_train_predict,r_train),axis=1))
# filepath= r'.\csv\train_TriD.csv'
# df.to_csv(filepath,header=['Time_sec','Voltage_V','State','State_pred','Current_A','Current_pred_A','rate'],index=False)

# df = pd.DataFrame(np.concatenate((t_test,v_test,w_test,w_test_predict,y_test,y_test_predict,r_test),axis=1))
# filepath1= r'.\csv\test_TriD.csv'
# df.to_csv(filepath1,header=['Time_sec','Voltage_V','State','State_pred','Current_A','Current_pred_A','rate'],index=False)
