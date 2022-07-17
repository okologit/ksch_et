% =========================================================================
% %CESIUM% ATOMIC BEAM TUBE
% =========================================================================


function [ output_args ] = ALT( i )

clc;
close all;


%--------------------------------------------------------------------------
% ��������� ������
%--------------------------------------------------------------------------
l = 0.01; % ����� ������� ��������������, �
L = 0.15; % ����� ���������� ������������, �
v_opt = 216; % ����������� �������� ������, �/�
% v = v_opt; % �������� ������, �/�
dv = 3;
f_00 = 9192631770; % ������� �������� �������� �������� (0-0), ��
Cn = 2;
n = 3;


%--------------------------------------------------------------------------
% ���������
%--------------------------------------------------------------------------
h = 6.62607015e-34; % ���������� ������
g_j = 2; % ��������� (g-������) �����
mu_0 = 1.25663706212e-6; %927.400968e-26; % ��������� ������������� �������
mu_b = 5.05e-24; % ������� �������� ����

i = 0;
k = 0;
j = 0;


%--------------------------------------------------------------------------
% ���������
%--------------------------------------------------------------------------
% ���������
a_res = 0.023; % ������ ����������� ������� ������������ ���������� a, �
b_res = 0.01; % ������ ����������� ������� ������������ ���������� b, �
Q_res = 1.3e3; % ����������� ����������
Z_0 = 376.73; % �������� ������������� ������� (� ����������), ��
S = a_res * b_res; % ������� ����������� ������� ������������ ����������, �^2
%--------------------------------------------------------------------------
% �������� ������
% v = v_opt;
% dv = 10; v_step = 0.01;
v_step = 1;
v_min = 30;
v_max = 220;
%--------------------------------------------------------------------------
% �������� ������� �����������
% P_opt = 0.00012;
P_step = 0.0000001; %6.1500e-05;%0.00001;
P_max = 0.001;
%--------------------------------------------------------------------------
% �������� ����������� ������������ �������
% b_opt = 0.5 * pi * v_opt / l;
% b_step = 10;
% db = 5000;
%--------------------------------------------------------------------------
f_step = 20; %0.001;
df = 80; % 1e5 - ������ �������, % 1e2 - 3 ��������
N_samples = 20000001;


%--------------------------------------------------------------------------
% ������
%--------------------------------------------------------------------------

j = 0;

for f_res = f_00:f_step:(f_00+df)

f_res
j = j + 1;
i = 0;

    for P_in = 0 : P_step : P_max %; (P_opt - 2*dP)

    i = i + 1;
    v = v_opt;
    P_in_plot(i) = P_in;
        
    %----------------------------------------------------------------------
    % ���������
    %----------------------------------------------------------------------
    P_res = P_in * Q_res; % �������� � ����������
    H = sqrt ( (2 * P_res) / (Z_0*S) ); %Z_0* %Q_res
    B = H * mu_0;
    b = (g_j*mu_b*B)/(h);


    %----------------------------------------------------------------------
    % ��������� ����� � ����� �������������
    %----------------------------------------------------------------------
    t = l / v;
    T = L / v;


    %----------------------------------------------------------------------
    % ����������� �������� �������� ��������
    %----------------------------------------------------------------------
    % ����, �����, ������ ("Controlling the microwave"), Xi ("A linewidth")
    %----------------------------------------------------------------------
    w_00 = 2*pi*f_00; % ������� ������� �������� ��������
    w_res = 2*pi*f_res; % ������� ������� ������� �����������
    dw = w_res - w_00; % ���������� ������� ������� ������� �����������

    rabi_gen = sqrt(b.^2 + dw.^2); % ���������� ������� ����
    ot2 = rabi_gen.*t/2;
    o0T2 = (dw.*T)/2;

    p_temp1 = 4*((b./rabi_gen).^2) .* (sin(ot2).^2);
    p_temp2 = cos(ot2) .* cos(o0T2);
    p_temp3 = (-dw./rabi_gen) .* sin(ot2) .* sin(o0T2);
    p(i,j) = p_temp1 .* ((p_temp2 - p_temp3) .^ 2);


    end
    


end


%--------------------------------------------------------------------------
% �������
%--------------------------------------------------------------------------


    figure(2);
    hold on; grid on;
    plot(P_in_plot, p);




end

