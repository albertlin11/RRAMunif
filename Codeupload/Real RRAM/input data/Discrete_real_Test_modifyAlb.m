clc;
close all;
clear all;
% IV %
file = readtable('.\RRAM_modifyAlb_TaNPlasmap25.csv');
%HRS%
v_h = file{1:85,1};
c_h = file{1:85,2};
%LRS%
v_l = file{:,3};
c_l = file{:,4};
%all%
v_all = cat(1,v_h,v_l);
c_all = cat(1,c_h,c_l);
% plot(v_all,c_all);
% set(gca,'FontSize', 12, 'LineWidth', 2);
% xlabel('Voltage (V)');
% ylabel('Current (A)');
% title('Real IV');
% xlim([-3.0 3.5]);
% % ylim([-2.5 2.5]);
% Voltage Signal Generation%
Vset=0.816;
Vreset=-1.2;
Vmax=1.2;
Vmin=-1.5;
Vread = 0.5;
%read pluse%
dvv=0.025
v1 = repelem([0.0],24);
v2 = 0:dvv:Vmax;
v3 = repelem([Vmax],24);
v4 = Vmax:-dvv:0;
vv_set = cat(2,v1,v2,v3,v4);
v1 = repelem([0.0],24);
v2 = 0:-dvv:Vmin;
v3 = repelem([Vmin],24);
v4 = Vmin:dvv:0;
vv_reset = cat(2,v1,v2,v3,v4);
v1 = repelem([0.0],24);
v2 = 0:dvv:Vread;
v3 = repelem([Vread],24);
v4 = Vread:-dvv:0;
vv_read = cat(2,v1,v2,v3,v4);
v_sig = cat(2,vv_set,vv_set,vv_read,vv_reset,vv_reset,vv_read);
a = size(v_sig);
v_sig = reshape(v_sig,a(2),1);
figure;
plot(v_sig);
set(gca,'FontSize', 12, 'LineWidth', 2);
title('Voltage Signal')
%random read pluse%
vv_1 = [vv_read,vv_set];
vv_2 = [vv_read,vv_reset];
vv = {vv_1;vv_2};
v_sig = [];
rlist=[2  1 2 1 2 1  1 1 2 1];
for n =1:10
    %r = randi([1,2],1,1);
    r=rlist(n);
    v_sig = [v_sig,vv{r}];
end
a = size(v_sig);
v_sig = reshape(v_sig,a(2),1);
figure;
plot(v_sig);
set(gca,'FontSize', 12, 'LineWidth', 2);
title('Voltage Signal')
%discrete state Calculation%
for i = 1:length(v_sig)
    if v_sig(i)>Vset
        state(i)=0;
    elseif v_sig(i)< Vreset
        state(i)=1;
    else
        if i==1
            state(i)=1;
        else
            state(i)=state(i-1);
        end
    end
    if state(i)==1 % HRS
        I_sig(i)=interp1(v_h,c_h,v_sig(i),'linear','extrap');
    else % LRS
        I_sig(i)=interp1(v_l,c_l,v_sig(i),'linear','extrap');
    end
end
figure
plot(I_sig);
set(gca,'FontSize', 12, 'LineWidth', 2);
title('Current')
figure
plot(state);
set(gca,'FontSize', 12, 'LineWidth', 2);
ylim([-0.1,1.1]);
title('Discrete State');
figure
plot(v_sig,I_sig,'db-');
set(gca,'FontSize', 12, 'LineWidth', 2);
title('RRAM IV');
state = reshape(state,a(2),1);
I_sig = reshape(I_sig,a(2),1);
IV=cat(2,state,v_sig,I_sig);
%%
%csv file%

%xlswrite('IV_RRAM_TriD_35_1_real_new2.csv', cellstr('State'),'A1:A1');
%xlswrite('IV_RRAM_TriD_35_1_real_new2.csv', cellstr('Voltage(V)'),'B1:B1');
%xlswrite('IV_RRAM_TriD_35_1_real_new2.csv', cellstr('Current(A)'),'C1:C1');
%xlswrite('IV_RRAM_TriD_35_1_real_new2.csv', IV,'A2:C54');
%csvwrite('IV_RRAM_TriD_35_1_real_new2.csv', IV,1,0);

%xlswrite('IV_RRAM_RanD_35_1_real_new2.csv', cellstr('State'),'A1:A1');
%xlswrite('IV_RRAM_RanD_35_1_real_new2.csv', cellstr('Voltage(V)'),'B1:B1');
%xlswrite('IV_RRAM_RanD_35_1_real_new2.csv', cellstr('Current(A)'),'C1:C1');
%xlswrite('IV_RRAM_RanD_35_1_real_new2.csv', IV, 'A2:C1971');
csvwrite('IV_RRAM_RanD_35_1_real_new2.csv', IV,1,0);