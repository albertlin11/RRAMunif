# -*- coding: utf-8 -*-
"""
Created on Thu Dec  2 11:12:15 2021

@author: HP ED-800
"""

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