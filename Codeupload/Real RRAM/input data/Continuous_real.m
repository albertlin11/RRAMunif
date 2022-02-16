clc;
close all;
clear all;
% IV %
file = readtable('.\RRAM.csv');
Vset=2.6;
Vreset=-3;
%HRS%
v_h = file{1:87,1};
c_h = file{1:87,2};
v_sh = Vreset:0.01:Vset;
s_h = 1.5:-1/560:0.5;
%LRS%
v_l = file{:,3};
c_l = file{:,4};
v_sl = Vset:-0.01:Vreset;
s_l = flip(s_h)*-1;
%all%
v_all = cat(1,v_h,v_l);
c_all = cat(1,c_h,c_l);
% figure;
% plot(v_all,c_all);
% set(gca,'FontSize', 12, 'LineWidth', 2);
% xlabel('Voltage (V)');
% ylabel('Current (A)');
% title('Real IV');
% xlim([-3.5 3.5]);
% % ylim([-2.5 2.5]);
% Voltage Signal Generation%
%read pluse%
Vmax=3.5;
Vmin=-3.0;
Vread = 1.7;
v1 = repelem([0.0],24);
v2 = 0:0.1:Vmax;
v3 = repelem([Vmax],24);
v4 = Vmax:-0.1:0;
vv_set = cat(2,v1,v2,v3,v4);
v1 = repelem([0.0],24);
v2 = 0:-0.1:Vmin;
v3 = repelem([Vmin],24);
v4 = Vmin:0.1:0;
vv_reset = cat(2,v1,v2,v3,v4);
v1 = repelem([0.0],24);
v2 = 0:0.1:Vread;
v3 = repelem([Vread],24);
v4 = Vread:-0.1:0;
vv_read = cat(2,v1,v2,v3,v4);
% v_sig = cat(2,vv_set,vv_set,vv_read,vv_reset,vv_reset,vv_read);
% figure;
% plot(v_sig);
% set(gca,'FontSize', 12, 'LineWidth', 2);
% title('Voltage Signal')
%random read pluse%
vv_1 = [vv_read,vv_set];
vv_2 = [vv_read,vv_reset];
vv = {vv_1;vv_2};
v_sig = [];
for n =1:10
%     r = Vmin+(Vmax-Vmin)*rand(1);
    r = randi([1,2],1,1);
    v_sig = [v_sig,vv{r}];
end
figure;
plot(v_sig);
set(gca,'FontSize', 12, 'LineWidth', 2);
title('Voltage Signal')
%continuous state Calculation%
for i = 1:length(v_sig)
    if v_sig(i)>=Vset
        I_sig(i)=interp1(v_l,c_l,v_sig(i),'linear','extrap');
        state(i)=interp1(v_sl,s_l,v_sig(i),'linear','extrap');
    elseif v_sig(i)<= Vreset
        I_sig(i)=interp1(v_h,c_h,v_sig(i),'linear','extrap');
        state(i)=interp1(v_sh,s_h,v_sig(i),'linear','extrap');
    else
        if i==1
            state(i)=1;
        else
            state(i)=state(i-1);
        end
    end
    if state(i)>0 % HRS
        I_sig(i)=interp1(v_h,c_h,v_sig(i),'linear','extrap');
        state(i)=interp1(v_sh,s_h,v_sig(i),'linear','extrap');
    else % LRS
        I_sig(i)=interp1(v_l,c_l,v_sig(i),'linear','extrap');
        state(i)=interp1(v_sl,s_l,v_sig(i),'linear','extrap');
    end
end
figure;
plot(I_sig);
set(gca,'FontSize', 12, 'LineWidth', 2);
title('Current')
figure
plot(state);
set(gca,'FontSize', 12, 'LineWidth', 2);
ylim([-1.6,1.6]);
title('Continuous State');
a = size(state);
state = reshape(state,a(2),1);
v_sig = reshape(v_sig,a(2),1);
I_sig = reshape(I_sig,a(2),1);
IV=cat(2,state,v_sig,I_sig);
%% 
%csv file%
% xlswrite('IV_RRAM_TriD_35_1_real_new_cont.csv', cellstr('State'),'A1:A1');
% xlswrite('IV_RRAM_TriD_35_1_real_new_cont.csv', cellstr('Voltage(V)'),'B1:B1');
% xlswrite('IV_RRAM_TriD_35_1_real_new_cont.csv', cellstr('Current(A)'),'C1:C1');
% xlswrite('IV_RRAM_TriD_35_1_real_new_cont.csv', IV,'A2:C629'); 
% xlswrite('IV_RRAM_RanD_35_1_real_new_cont.csv', cellstr('State'),'A1:A1');
% xlswrite('IV_RRAM_RanD_35_1_real_new_cont.csv', cellstr('Voltage(V)'),'B1:B1');
% xlswrite('IV_RRAM_RanD_35_1_real_new_cont.csv', cellstr('Current(A)'),'C1:C1');
% xlswrite('IV_RRAM_RanD_35_1_real_new_cont.csv', IV, 'A2:C1981'); 