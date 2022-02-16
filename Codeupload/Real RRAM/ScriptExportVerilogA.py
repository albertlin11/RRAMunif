

# write for verilogA
############################### shape (20,1)
temp=''
for ind in range(weights[4].shape[1]):
    s=str((weights[4][:,ind]).tolist() ).replace('[','{')
    s=s.replace( ']','}')
    temp=temp+'real E'+str(ind)+'[0:19]='+s+';\n'
with open("test4.txt", "w") as text_file:
    text_file.write(temp)

temp=''
for ind in range(weights[10].shape[1]):
    s=str((weights[10][:,ind]).tolist() ).replace('[','{')
    s=s.replace( ']','}')
    temp=temp+'real K'+str(ind)+'[0:19]='+s+';\n'
with open("test10.txt", "w") as text_file:
    text_file.write(temp)
##################################################### bias shape (20,)


s=str((weights[1][:]).tolist() ).replace('[','{')
s=s.replace( ']','}')
temp='real B0'+'[0:19]='+s+';\n'
with open("test1.txt", "w") as text_file:
    text_file.write(temp)
    

s=str((weights[3][:]).tolist() ).replace('[','{')
s=s.replace( ']','}')
temp='real D0'+'[0:19]='+s+';\n'
with open("test3.txt", "w") as text_file:
    text_file.write(temp)
    

s=str((weights[5][:]).tolist() ).replace('[','{')
s=s.replace( ']','}')
temp='real F0'+'[0:2]='+s+';\n'
with open("test5.txt", "w") as text_file:
    text_file.write(temp)
    
    
s=str((weights[7][:]).tolist() ).replace('[','{')
s=s.replace( ']','}')
temp='real H0'+'[0:19]='+s+';\n'
with open("test7.txt", "w") as text_file:
    text_file.write(temp)
    
s=str((weights[9][:]).tolist() ).replace('[','{')
s=s.replace( ']','}')
temp='real J0'+'[0:19]='+s+';\n'
with open("test9.txt", "w") as text_file:
    text_file.write(temp)
    
    
s=str((weights[11][:]).tolist() ).replace('[','{')
s=s.replace( ']','}')
temp='real L0='  +s+';\n'
with open("test11.txt", "w") as text_file:
    text_file.write(temp)
    #########################shape (2,20) or (20,20)
temp=''
for ind in range(len(weights[0])):
    s=str((weights[0][ind,:]).tolist() ).replace('[','{')
    s=s.replace( ']','}')
    temp=temp+'real A'+str(ind)+'[0:19]='+s+';\n'
with open("test0.txt", "w") as text_file:
    text_file.write(temp)
    
temp=''
for ind in range(len(weights[2])):
    s=str((weights[2][ind,:]).tolist() ).replace('[',' ')
    s=s.replace( ']',' ')
    temp=temp+'real C'+str(ind)+'[0:19]='+s+';\n'
with open("test2.txt", "w") as text_file:
    text_file.write(temp)

temp=''
for ind in range(len(weights[6])):
    s=str((weights[6][ind,:]).tolist() ).replace('[','{')
    s=s.replace( ']','}')
    temp=temp+'real G'+str(ind)+'[0:19]='+s+';\n'
with open("test6.txt", "w") as text_file:
    text_file.write(temp)   
    
temp=''
for ind in range(len(weights[8])):
    s=str((weights[8][ind,:]).tolist() ).replace('[','{')
    s=s.replace( ']','}')
    temp=temp+'real I'+str(ind)+'[0:19]='+s+';\n'
with open("test8.txt", "w") as text_file:
    text_file.write(temp)


    