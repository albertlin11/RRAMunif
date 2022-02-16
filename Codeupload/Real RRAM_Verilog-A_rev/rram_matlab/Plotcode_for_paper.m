% clc;
% close all;
% clear all;
% % Signal%
% file = readtable(['.\Signal\100cycles.txt']);
% figure('units','centimeter','position',[2, 2, 13, 13]);
% plot(file{:,1},file{:,2}, 'LineWidth', 1.5);
% set(gca,'YScale', 'log','FontSize', 28, 'LineWidth', 6);
% xlim([-4,4]);
% yticks([1e-10 1e-8 1e-6 1e-4 1e-2]);
% ylim([1e-10 1e-2]);
% xlabel('\bfVoltage (V)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);
% 
% file = readtable(['.\Signal\IV_RRAM_TriD_35_1_real_new.csv']);
% figure('units','centimeter','position',[2, 2, 13, 13.55]);
% plot(file{:,2},file{:,3}, 'LineWidth', 4);
% set(gca,'FontSize', 28, 'LineWidth', 6);
% xlim([-4,4]);
% yticks([-0.02 -0.01 0 0.005]);
% ylim([-0.022 0.007]);
% xlabel('\bfVoltage (V)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);
% 
% file = readtable(['.\Signal\retention.csv']);
% figure('units','centimeter','position',[2, 2, 13, 13]);
% scatter(file{:,1},file{:,2},50,'filled','o','LineWidth',1.0);
% hold on;
% scatter(file{:,1},file{:,3},50,'filled','o','k','LineWidth',1.0);
% hold off;
% set(gca,'YScale', 'log','FontSize', 28, 'LineWidth', 6);
% xticks([0 500 1000]);
% xlim([-100,1100]);
% yticks([1e3 1e4 1e5]);
% ylim([1e3 1e5]);
% box on;
% xlabel('\bfTime (sec)', 'FontSize',28), ylabel('\bfResistance (\Omega)', 'FontSize',28);
% legend({'\bfHRS','\bfLRS'},'FontSize',24, 'Location','northeast','Box','off')
% 
% file = readtable(['.\Signal\endurance.csv']);
% figure('units','centimeter','position',[2, 2, 13, 13]);
% for i = 1:length(file{:,1})
%     v(i) = i;
% end
% scatter(v,file{:,1},50,'filled','o','LineWidth',1.0);
% hold on;
% scatter(v,file{:,2},50,'filled','o','k','LineWidth',1.0);
% hold off;
% set(gca,'YScale', 'log','FontSize', 28, 'LineWidth', 6);
% xlim([0,100]);
% yticks([1e3 1e4 1e5]);
% ylim([1e3 1e5]);
% box on;
% xlabel('\bfCycle (N)', 'FontSize',28), ylabel('\bfResistance (\Omega)', 'FontSize',28);
% legend({'\bfHRS','\bfLRS'},'FontSize',24, 'Location','northeast','Box','off')
% 
% file = readtable(['.\Signal\IV_RRAM_TriD_17_2_SWEEP.csv']);
% figure('units','centimeter','position',[2, 2, 12.4, 13]);
% plot(file{:,11},file{:,12}, 'LineWidth', 4);
% set(gca,'FontSize', 28, 'LineWidth', 6);
% xlim([-2.0,2.0]);
% ylim([-3 3]);
% xlabel('\bfVoltage (V)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);
% 
% file = readtable(['.\Signal\IV_RRAM_TriD_17_2_SWEEP.csv']);
% figure('units','centimeter','position',[2, 2, 12.4, 13]);
% plot(file{:,3},file{:,4}, 'LineWidth', 4);
% hold on;
% plot(file{:,7},file{:,8}, 'LineWidth', 4);
% hold on;
% plot(file{:,11},file{:,12}, 'LineWidth', 4);
% hold off;
% set(gca,'FontSize', 28, 'LineWidth', 6);
% xlim([-2.0,2.0]);
% ylim([-3 3]);
% xlabel('\bfVoltage (V)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);
% legend({'\bfrate=1','\bfrate=2','\bfrate=10'},'FontSize',24, 'Location','northwest','Box','off');
% % Discrete state variable classification%
% test = readtable(['.\Real RRAM\csv\discrete\classification\test_RanD_real_new.csv']);
% figure('units','centimeter','position',[2, 2, 30, 8]);
% plot(test{:,1}, 'LineWidth', 4,'color','k');
% set(gca,'FontSize', 28, 'LineWidth', 6);
% yticks([-3.0 0 1.7 3.5]);
% ylim([-3.5,3.8]);
% xlim([0, 2200]);
% xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);
% 
% figure('units','centimeter','position',[2, 2, 30, 8.9]);
% plot(test{:,4}, 'LineWidth', 4,'color','k');
% hold on;
% j = 1:1:length(test{:,5});
% scatter(j,test{:,5},25,'o','b','LineWidth',1.0);
% hold off;
% set(gca,'FontSize', 28, 'LineWidth', 6);
% yticks([-0.02 0 0.005]);
% ylim([-0.025 0.007]);
% xlim([0, 2200]);
% xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);
% legend({'\bfreal value','\bfpredict value'},'FontSize',24, 'Location','southeast','Box','off');
% % Discrete state variable classification for sweeping speed%
% a=1;b=11040;
% test = readtable(['.\Ideal RRAM_discrete classification sweep\csv\test_RanD.csv']);
% figure('units','centimeter','position',[2, 2, 30, 8]);
% plot(test{a:b,1},test{a:b,2}, 'LineWidth', 4,'color','k');
% set(gca,'FontSize', 28, 'LineWidth', 6);
% yticks([-1.7 -0.8 0 0.8 1.7]);
% ylim([-2.0,2.0]);
% xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);
% 
% figure('units','centimeter','position',[2, 2, 30, 8]);
% plot(test{a:b,1},test{a:b,5}, 'LineWidth', 4,'color','k');
% hold on;
% scatter(test{a:b,1},test{a:b,6},25,'o','b','LineWidth',1.0);
% hold off;
% set(gca,'FontSize', 28, 'LineWidth', 6);
% yticks([ -2.5 0 2.5]);
% ylim([-3, 3]);
% xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);
% legend({'\bfreal value','\bfpredict value'},'FontSize',22, 'Location','southeast','Box','off');
% 
% a=11041;b=22080;
% figure('units','centimeter','position',[2, 2, 30, 8]);
% plot(test{a:b,1},test{a:b,2}, 'LineWidth', 4,'color','k');
% set(gca,'FontSize', 28, 'LineWidth', 6);
% yticks([-1.7 -0.8 0 0.8 1.7]);
% ylim([-2.0,2.0]);
% xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);
% 
% figure('units','centimeter','position',[2, 2, 30, 8]);
% plot(test{a:b,1},test{a:b,5}, 'LineWidth', 4,'color','k');
% hold on;
% scatter(test{a:b,1},test{a:b,6},25,'o','b','LineWidth',1.0);
% hold off;
% set(gca,'FontSize', 28, 'LineWidth', 6);
% yticks([ -2.5 0 2.5]);
% ylim([-3, 3]);
% xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);
% legend({'\bfreal value','\bfpredict value'},'FontSize',22, 'Location','southeast','Box','off');
% 
% a=22081;b=33120;
% figure('units','centimeter','position',[2, 2, 30, 8]);
% plot(test{a:b,1},test{a:b,2}, 'LineWidth', 4,'color','k');
% set(gca,'FontSize', 28, 'LineWidth', 6);
% yticks([-1.7 -0.8 0 0.8 1.7]);
% ylim([-2.0,2.0]);
% xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);

% figure('units','centimeter','position',[2, 2, 30, 8]);
% plot(test{a:b,1},test{a:b,5}, 'LineWidth', 4,'color','k');
% hold on;
% scatter(test{a:b,1},test{a:b,6},25,'o','b','LineWidth',1.0);
% hold off;
% set(gca,'FontSize', 28, 'LineWidth', 6);
% yticks([ -2.5 0 2.5]);
% ylim([-3, 3]);
% xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);
% legend({'\bfreal value','\bfpredict value'},'FontSize',22, 'Location','southeast','Box','off');
% Discrete state variable classification in Verilog-A%
test = readtable(['Voltage.csv']);
figure('units','centimeter','position',[2, 2, 30, 8]);
plot( 1e9*test{:,1}, test{:,2}, 'db-', 'Linewidth', 4, 'Markersize', 3, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b')
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([-1.9 0 1.2 1.9]);
ylim([-1.9,1.9]);
xlim([0, 1730]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);

test = readtable(['Current.csv']);
figure('units','centimeter','position',[2, 2, 30, 8.9]);
plot( 1e9*test{:,1}, test{:,2}, 'db-', 'Linewidth', 4, 'Markersize', 3, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b')
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([-0.0007 0 0.001]);
ylim([-0.0013 0.0015]);
xlim([0, 1730]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);


% Discrete state variable classification in Verilog-A for 1T1R%
test = readtable(['WL.csv']);
figure('units','centimeter','position',[2, 2, 30, 8]);
plot( 1e9*test{:,1}, test{:,2}, 'db-', 'Linewidth', 4, 'Markersize', 3, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b')
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([0 1.0 2.0]);
ylim([0,2]);
xlim([0,400]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);

test = readtable(['BL.csv']);
figure('units','centimeter','position',[2, 2, 30, 8]);
plot( 1e9*test{:,1}, test{:,2}, 'db-', 'Linewidth', 4, 'Markersize', 3, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b')
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([-1.5 0 0.7 1.5]);
ylim([-1.8,1.5]);
xlim([0,400]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfVoltage (V)', 'FontSize',28);

test = readtable(['I.csv']);
figure('units','centimeter','position',[2, 2, 30, 8.9]);
plot( 1e9*test{:,1}, test{:,2}, 'db-', 'Linewidth', 4, 'Markersize', 3, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b')
set(gca,'FontSize', 28, 'LineWidth', 6);
yticks([-0.0009 0 0.002]);
ylim([-0.0013 0.003]);
xlim([0, 400]);
xlabel('\bfTime (nsec)', 'FontSize',28), ylabel('\bfCurrent (A)', 'FontSize',28);