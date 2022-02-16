clc;
close all;
clear all;
% Generation of IV %
Vset=[1.1,1.3,1.5];
Vreset=[-1.1,-1.3,-1.5];
%HRS%
m_h = [0.11,0.13,0.15];
for i=1:3
    v_h{i,1} = Vreset(i):0.0001:Vset(i);
    a = v_h{i,1};
    c_h{i,1} = m_h(i)*a;
end
%LRS%
m_l = [1.1,1.3,1.5];
for i=1:3
    v_l{i,1} = Vset(i):-0.0001:Vreset(i);
    a = v_l{i,1};
    c_l{i,1} = m_l(i)*a;
end
%all%
for i=1:3
    v_all{i,1} = cat(2,v_h{i,1},v_l{i,1},v_h{i,1}(1));
    c_all{i,1} = cat(2,c_h{i,1},c_l{i,1},c_h{i,1}(1));
end
for i=1:3
    plot(v_all{i,1},c_all{i,1});
    hold on
end
set(gca,'FontSize', 12, 'LineWidth', 2);
xlabel('Voltage (V)');
ylabel('Current (mA)');
title('IV generated using Straight Line Equation');
xlim([-2.0 2.0]);
ylim([-2.5 2.5]);
% Voltage Signal Generation%
%read pluse%
Vmax=1.7;
Vmin=-1.7;
Vread = 0.8;
v1 = repelem([0.0],150);
v2 = 0:0.01:Vmax;
v3 = repelem([Vmax],150);
v4 = Vmax:-0.01:0;
vv_set = cat(2,v1,v2,v3,v4);
v1 = repelem([0.0],150);
v2 = 0:-0.01:Vmin;
v3 = repelem([Vmin],150);
v4 = Vmin:0.01:0;
vv_reset = cat(2,v1,v2,v3,v4);
v1 = repelem([0.0],150);
v2 = 0:0.01:Vread;
v3 = repelem([Vread],150);
v4 = Vread:-0.01:0;
vv_read = cat(2,v1,v2,v3,v4);
v = cat(2,vv_set,vv_set,vv_read,vv_reset,vv_reset,vv_read);
deltat = [0.01,0.005,0.001];
for i =1:3
    v_sig{i,1} = v;
end
t_sig{1,1} = 0:0.01:34.91;
t_sig{2,1} = 0:0.005:17.455;
t_sig{3,1} = 0:0.001:3.491;
for i=1:3
    figure;
    plot(t_sig{i,1},v_sig{i,1});
    set(gca,'FontSize', 12, 'LineWidth', 2);
    title('Voltage Signal');
end
%random read pluse%
% vv_1 = [vv_read,vv_set];
% vv_2 = [vv_read,vv_reset];
% vv = {vv_1;vv_2};
% v = [];
% for n =1:10
% %     r = Vmin+(Vmax-Vmin)*rand(1);
%     r = randi([1,2],1,1);
%     v = [v,vv{r}];
% end
% for i =1:3
%     v_sig{i,1} = v;
% end
% deltat = [0.01,0.005,0.001];
% t_sig{1,1} = 0:0.01:110.39;
% t_sig{2,1} = 0:0.005:55.195;
% t_sig{3,1} = 0:0.001:11.039;
% for i=1:3
%     figure;
%     plot(t_sig{i,1},v_sig{i,1});
%     set(gca,'FontSize', 12, 'LineWidth', 2);
%     title('Voltage Signal');
% end
%discrete state Calculation%
for j =1:3
    for i = 1:length(v_sig{j,1})
        if v_sig{j,1}(i)>Vset(j)
            state{j,1}(i)=0;
        elseif v_sig{j,1}(i)< Vreset(j)
            state{j,1}(i)=1;
        else
            if i==1
                state{j,1}(i)=1;
            else
                state{j,1}(i)=state{j,1}(i-1);
            end
        end
        if state{j,1}(i)==1 % HRS
            I_sig{j,1}(i)=interp1(v_h{j,1},c_h{j,1},v_sig{j,1}(i),'linear','extrap');
        else % LRS
            I_sig{j,1}(i)=interp1(v_l{j,1},c_l{j,1},v_sig{j,1}(i),'linear','extrap');
        end
    end
end
figure;
for i=1:3
    plot(t_sig{i,1},state{i,1});
    hold on
end
set(gca,'FontSize', 12, 'LineWidth', 2);
ylim([-0.1,1.1]);
title('Discrete State');
figure;
for i=1:3
    plot(t_sig{i,1},I_sig{i,1});
    hold on
end
set(gca,'FontSize', 12, 'LineWidth', 2);
title('Current')
figure;
for i=1:3
    plot(v_sig{i,1},I_sig{i,1});
    hold on
end
set(gca,'FontSize', 12, 'LineWidth', 2);
title('IV for RRAM')
for i=1:3
    b{i,1} = size(state{i,1});
    state{i,1} = reshape(state{i,1},b{i,1}(2),1);
    v_sig{i,1} = reshape(v_sig{i,1},b{i,1}(2),1);
    I_sig{i,1} = reshape(I_sig{i,1},b{i,1}(2),1);
    t_sig{i,1} = reshape(t_sig{i,1},b{i,1}(2),1);
end
%% 
%csv file%
% same points%
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', cellstr('Time=0.01'),'A1:A1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', cellstr('State_0.01'),'B1:B1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', cellstr('Voltage_0.01'),'C1:C1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', cellstr('Current_0.01'),'D1:D1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', t_sig{1,1},'A2:A481');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', state{1,1},'B2:B481');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', v_sig{1,1},'C2:C481');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', I_sig{1,1},'D2:D481');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', cellstr('Time=0.005'),'E1:E1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', cellstr('State_0.005'),'F1:F1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', cellstr('Voltage_0.005'),'G1:G1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', cellstr('Current_0.005'),'H1:H1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', t_sig{2,1},'E2:E481');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', state{2,1},'F2:F481');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', v_sig{2,1},'G2:G481');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', I_sig{2,1},'H2:H481');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', cellstr('Time=0.001'),'I1:I1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', cellstr('State_0.001'),'J1:J1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', cellstr('Voltage_0.001'),'K1:K1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', cellstr('Current_0.001'),'L1:L1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', t_sig{3,1},'I2:I481');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', state{3,1},'J2:J481');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', v_sig{3,1},'K2:K481');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP.csv', I_sig{3,1},'L2:L481');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', cellstr('Time=0.01'),'A1:A1');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', cellstr('State_0.01'),'B1:B1');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', cellstr('Voltage_0.01'),'C1:C1');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', cellstr('Current_0.01'),'D1:D1');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', t_sig{1,1},'A2:A1541');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', state{1,1},'B2:B1541');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', v_sig{1,1},'C2:C1541');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', I_sig{1,1},'D2:D1541');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', cellstr('Time=0.005'),'E1:E1');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', cellstr('State_0.005'),'F1:F1');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', cellstr('Voltage_0.005'),'G1:G1');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', cellstr('Current_0.005'),'H1:H1');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', t_sig{2,1},'E2:E1541');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', state{2,1},'F2:F1541');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', v_sig{2,1},'G2:G1541');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', I_sig{2,1},'H2:H1541');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', cellstr('Time=0.001'),'I1:I1');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', cellstr('State_0.001'),'J1:J1');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', cellstr('Voltage_0.001'),'K1:K1');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', cellstr('Current_0.001'),'L1:L1');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', t_sig{3,1},'I2:I1541');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', state{3,1},'J2:J1541');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', v_sig{3,1},'K2:K1541');
% xlswrite('IV_RRAM_RanD_17_1_SWEEP.csv', I_sig{3,1},'L2:L1541');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', cellstr('Time=0.01'),'A1:A1');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', cellstr('State_0.01'),'B1:B1');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', cellstr('Voltage_0.01'),'C1:C1');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', cellstr('Current_0.01'),'D1:D1');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', t_sig{1,1},'A2:A3493');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', state{1,1},'B2:B3493');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', v_sig{1,1},'C2:C3493');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', I_sig{1,1},'D2:D3493');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', cellstr('Time=0.005'),'E1:E1');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', cellstr('State_0.005'),'F1:F1');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', cellstr('Voltage_0.005'),'G1:G1');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', cellstr('Current_0.005'),'H1:H1');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', t_sig{2,1},'E2:E3493');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', state{2,1},'F2:F3493');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', v_sig{2,1},'G2:G3493');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', I_sig{2,1},'H2:H3493');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', cellstr('Time=0.001'),'I1:I1');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', cellstr('State_0.001'),'J1:J1');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', cellstr('Voltage_0.001'),'K1:K1');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', cellstr('Current_0.001'),'L1:L1');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', t_sig{3,1},'I2:I3493');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', state{3,1},'J2:J3493');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', v_sig{3,1},'K2:K3493');
% xlswrite('IV_RRAM_TriD_17_2_SWEEP.csv', I_sig{3,1},'L2:L3493');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', cellstr('Time=0.01'),'A1:A1');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', cellstr('State_0.01'),'B1:B1');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', cellstr('Voltage_0.01'),'C1:C1');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', cellstr('Current_0.01'),'D1:D1');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', t_sig{1,1},'A2:A11041');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', state{1,1},'B2:B11041');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', v_sig{1,1},'C2:C11041');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', I_sig{1,1},'D2:D11041');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', cellstr('Time=0.005'),'E1:E1');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', cellstr('State_0.005'),'F1:F1');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', cellstr('Voltage_0.005'),'G1:G1');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', cellstr('Current_0.005'),'H1:H1');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', t_sig{2,1},'E2:E11041');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', state{2,1},'F2:F11041');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', v_sig{2,1},'G2:G11041');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', I_sig{2,1},'H2:H11041');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', cellstr('Time=0.001'),'I1:I1');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', cellstr('State_0.001'),'J1:J1');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', cellstr('Voltage_0.001'),'K1:K1');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', cellstr('Current_0.001'),'L1:L1');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', t_sig{3,1},'I2:I11041');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', state{3,1},'J2:J11041');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', v_sig{3,1},'K2:K11041');
% xlswrite('IV_RRAM_RanD_17_2_SWEEP.csv', I_sig{3,1},'L2:L11041');
% one second%
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', cellstr('Time=0.01'),'A1:A1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', cellstr('State_0.01'),'B1:B1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', cellstr('Voltage_0.01'),'C1:C1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', cellstr('Current_0.01'),'D1:D1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', t_sig{1,1},'A2:A102');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', state{1,1},'B2:B102');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', v_sig{1,1},'C2:C102');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', I_sig{1,1},'D2:D102');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', cellstr('Time=0.005'),'E1:E1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', cellstr('State_0.005'),'F1:F1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', cellstr('Voltage_0.005'),'G1:G1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', cellstr('Current_0.005'),'H1:H1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', t_sig{2,1},'E2:E202');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', state{2,1},'F2:F202');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', v_sig{2,1},'G2:G202');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', I_sig{2,1},'H2:H202');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', cellstr('Time=0.001'),'I1:I1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', cellstr('State_0.001'),'J1:J1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', cellstr('Voltage_0.001'),'K1:K1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', cellstr('Current_0.001'),'L1:L1');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', t_sig{3,1},'I2:I1002');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', state{3,1},'J2:J1002');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', v_sig{3,1},'K2:K1002');
% xlswrite('IV_RRAM_TriD_17_1_SWEEP_1.csv', I_sig{3,1},'L2:L1002');