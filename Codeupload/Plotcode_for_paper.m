clc;
close all;
clear all;
% Signal%

file = readtable(['.\Signal\IV_RRAM_TriD_35_1_real_new.csv']);
figure('units','centimeter','position',[2, 2, 13, 13.55]);
plot(file{:,2},((file{:,3})), 'LineWidth', 4);
set(gca,'FontSize', 28, 'LineWidth', 6);
%xlim([-4,4]);
%yticks([-0.02 -0.01 0 0.005]);
%ylim([-0.022 0.007]);
xlabel('\bfVoltage (V)', 'FontSize',28), ylabel('\bf Current (A)', 'FontSize',28);

file = readtable(['.\Signal\IV_RRAM_TriD_17_2_SWEEP.csv']);
figure('units','centimeter','position',[2, 2, 12.4, 13]);
plot(file{:,11},file{:,12}, 'LineWidth', 4);
set(gca,'FontSize', 28, 'LineWidth', 6);
xlim([-2.0,2.0]);
ylim([-3 3]);
xlabel('\bfVoltage (V)', 'FontSize',28), ylabel('\bfCurrent (mA)', 'FontSize',28);

file = readtable(['.\Signal\IV_RRAM_TriD_17_2_SWEEP.csv']);
figure('units','centimeter','position',[2, 2, 12.4, 13]);
plot(file{:,3},file{:,4}, 'LineWidth', 4);
hold on;
plot(file{:,7},file{:,8}, 'LineWidth', 4);
hold on;
plot(file{:,11},file{:,12}, 'LineWidth', 4);
hold off;
set(gca,'FontSize', 28, 'LineWidth', 6);
xlim([-2.0,2.0]);
ylim([-3 3]);
xlabel('\bfVoltage (V)', 'FontSize',28), ylabel('\bfCurrent (mA)', 'FontSize',28);
legend({'\bfrate=1','\bfrate=2','\bfrate=10'},'FontSize',24, 'Location','northwest','Box','off');
% Discrete state variable classification%
%time recalc
% Voltage Signal Generation%
Vset=0.816;
Vreset=-1.2;
Vmax=1.2;
Vmin=-1.5;
Vread = 0.5;
%read pluse%
dvv=0.025;
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
%v_sig = cat(2,vv_set,vv_set,vv_read,vv_reset,vv_reset,vv_read);

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
t(1)=0.5;
for ii=1:length(v_sig)-1
    if v_sig(ii)~= v_sig(ii+1)
        t(ii+1)=t(ii)+0.5;
    else
        t(ii+1)=t(ii)+1;
    end
end    
%%%%%%%%%%%%%%%%%%%
test = readtable(['.\Real RRAM\csv\discrete\classification\test_RanD_real_new2.csv']);
figure('units','centimeter','position',[2, 2, 30, 8]);
plot(t,test{:,1}, 'LineWidth', 4,'color','k');
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([-3.0 0 1.7 3.5]);
ylim([-3.5,3.8]);
xlim([0, 2200]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);

figure('units','centimeter','position',[2, 2, 30, 8.9]);
plot(t,test{:,4}*1e3, 'LineWidth', 4,'color','k');
hold on;
j = 1:1:length(test{:,5}*1e3);
scatter(t,test{:,5}*1e3,25,'o','b','LineWidth',1.0);
hold off;
set(gca,'FontSize', 28, 'LineWidth', 6);
%yticks([-0.02 0 0.005]);
%ylim([-0.025 0.007]);
%xlim([0, 2200]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfCurrent (mA)', 'FontSize',28);
legend({'\bfreal','\bfpredict'},'FontSize',24, 'Location','southeast','Box','off');

figure;
plot(test{:,1},(test{:,4}), 'LineWidth', 4); hold on;
plot(test{:,1},(test{:,5}), 'LineWidth', 4);
set(gca,'FontSize', 28, 'LineWidth', 6);
%xlim([-4,4]);
%yticks([-0.02 -0.01 0 0.005]);
%ylim([-0.022 0.007]);
xlabel('\bfVoltage (V)', 'FontSize',28), ylabel('\bf Current (A)', 'FontSize',28);

% Discrete state variable classification for sweeping speed%
a=1;b=11040;
test = readtable(['.\Ideal RRAM_discrete classification sweep\csv\test_RanD.csv']);
figure('units','centimeter','position',[2, 2, 30, 8]);
plot(test{a:b,1},test{a:b,2}, 'LineWidth', 4,'color','k');
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([-1.7 -0.8 0 0.8 1.7]);
ylim([-2.0,2.0]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);

figure('units','centimeter','position',[2, 2, 30, 8]);
plot(test{a:b,1},test{a:b,5}, 'LineWidth', 4,'color','k');
hold on;
scatter(test{a:b,1},test{a:b,6},25,'o','b','LineWidth',1.0);
hold off;
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([ -2.5 0 2.5]);
ylim([-3, 3]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);
legend({'\bfreal value','\bfpredict value'},'FontSize',22, 'Location','southeast','Box','off');

a=11041;b=22080;
figure('units','centimeter','position',[2, 2, 30, 8]);
plot(test{a:b,1},test{a:b,2}, 'LineWidth', 4,'color','k');
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([-1.7 -0.8 0 0.8 1.7]);
ylim([-2.0,2.0]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);

figure('units','centimeter','position',[2, 2, 30, 8]);
plot(test{a:b,1},test{a:b,5}, 'LineWidth', 4,'color','k');
hold on;
scatter(test{a:b,1},test{a:b,6},25,'o','b','LineWidth',1.0);
hold off;
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([ -2.5 0 2.5]);
ylim([-3, 3]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);
legend({'\bfreal value','\bfpredict value'},'FontSize',22, 'Location','southeast','Box','off');

a=22081;b=33120;
figure('units','centimeter','position',[2, 2, 30, 8]);
plot(test{a:b,1},test{a:b,2}, 'LineWidth', 4,'color','k');
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([-1.7 -0.8 0 0.8 1.7]);
ylim([-2.0,2.0]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);

figure('units','centimeter','position',[2, 2, 30, 8]);
plot(test{a:b,1},test{a:b,5}, 'LineWidth', 4,'color','k');
hold on;
scatter(test{a:b,1},test{a:b,6},25,'o','b','LineWidth',1.0);
hold off;
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([ -2.5 0 2.5]);
ylim([-3, 3]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);
legend({'\bfreal value','\bfpredict value'},'FontSize',22, 'Location','southeast','Box','off');
% Discrete state variable classification in Verilog-A%
test = readtable(['.\Real RRAM_Verilog-A\discrete classification_random pulse\csv\V.csv']);
figure('units','centimeter','position',[2, 2, 30, 8]);
plot( 1e9*test{:,1}, test{:,2}, 'db-', 'Linewidth', 4, 'Markersize', 3, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b')
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([-3.0 0 1.7 3.5]);
ylim([-3.5,3.8]);
xlim([0, 1000]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);

test = readtable(['.\Real RRAM_Verilog-A\discrete classification_random pulse\csv\I.csv']);
figure('units','centimeter','position',[2, 2, 30, 8.9]);
plot( 1e9*test{:,1}, test{:,2}, 'db-', 'Linewidth', 4, 'Markersize', 3, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b')
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([-0.02 0 0.005]);
ylim([-0.025 0.007]);
xlim([0, 1000]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);
% Discrete state variable classification in Verilog-A for 1T1R%
test = readtable(['.\Real RRAM_Verilog-A\discrete classification_1T1R\csv\WL.csv']);
figure('units','centimeter','position',[2, 2, 30, 8]);
plot( 1e9*test{:,1}, test{:,2}, 'db-', 'Linewidth', 4, 'Markersize', 3, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b')
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([0 1.0 2.0]);
ylim([0,2]);
xlim([0,1800]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);

test = readtable(['.\Real RRAM_Verilog-A\discrete classification_1T1R\csv\BL.csv']);
figure('units','centimeter','position',[2, 2, 30, 8]);
plot( 1e9*test{:,1}, test{:,2}, 'db-', 'Linewidth', 4, 'Markersize', 3, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b')
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([-3.2 0 1.7 3.5]);
ylim([-3.2,3.5]);
xlim([0,1800]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);

test = readtable(['.\Real RRAM_Verilog-A\discrete classification_1T1R\csv\I.csv']);
figure('units','centimeter','position',[2, 2, 30, 8.9]);
plot( 1e9*test{:,1}, test{:,2}, 'db-', 'Linewidth', 4, 'Markersize', 3, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b')
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([-0.02 0 0.005]);
ylim([-0.025 0.007]);
xlim([0, 1800]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);