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
f_00 = 9192631770; % ������� �������� �������� �������� (0-0), ��


%--------------------------------------------------------------------------
% ���������
%--------------------------------------------------------------------------
h = 6.62607015e-34; % ���������� ������
g_j = 2; % ��������� (g-������) �����
mu_0 = 1.25663706212e-6; %927.400968e-26; % ��������� ������������� �������
mu_b = 5.05e-24; % ������� �������� ����
k = 1.380649e-23; % ���������� ���������
m = 132.90545193324 * 1.660539066605e-27; % ����� ����� ����� (������� �.�.�. � ��)


%--------------------------------------------------------------------------
% ���������
%--------------------------------------------------------------------------
% ���������
a_res = 0.023; % ������ ����������� ������� ������������ ���������� a, �
b_res = 0.01; % ������ ����������� ������� ������������ ���������� b, �
Q_res = 1e3; % ����������� ����������
Z_0 = 376.73; % �������� ������������� ������� (� ����������), ��
S = a_res * b_res; % ������� ����������� ������� ������������ ����������, �^2
%--------------------------------------------------------------------------
% �������� ������
% v = v_opt;
v_step = 1;
v_min = 150;
v_max = 290;
%--------------------------------------------------------------------------
% �������� ������� �����������
% P_opt = 0.00012;
P_step = 1e-6;
P_min = 0; %0.4e-4;
P_max = 5e-4; %2.7e-4;
%--------------------------------------------------------------------------
f_step = 25; %0.001;
df = 200; % 1e5 - ������ �������, % 1e2 - 3 ��������
N_samples = 20000001;
T_K_opt = 375; % ������� �����������, �

n_1 = 1;
n_2 = 2;
n_3 = 3;
C_n_1 = 2;
C_n_2 = 4/sqrt(pi);
C_n_3 = 2;


%--------------------------------------------------------------------------
% �������� �������� �����
%--------------------------------------------------------------------------
v_opt = sqrt ( 2*k*T_K_opt/m );

for i = 1:v_max
    v_v(i) = i;
%     fv_1(i) = (C_n_1/v_opt) * (v_opt/i)^(n_2+2) * exp( -1*(v_opt^2) / (i^2) );
%     fv_2(i) = (C_n_2/v_opt) * (v_opt/i)^(n_2+2) * exp( -1*(v_opt^2) / (i^2) );
    fv_2(i) = (C_n_2/v_opt) * (i/v_opt)^(n_2) * exp( -1*(i^2) / (v_opt^2) );
    fv_3(i) = (C_n_3/v_opt) * (i/v_opt)^(n_2) * exp( -1*(i^2) / (v_opt^2) );
end

fv_22 = fv_3.';

xCDF = v_v;
yCDF = cumsum(fv_2) / sum(fv_2);   % Generate CDF
x1 = rand(v_max, 1);               % Generate uniform random variable
[yCDF, index] = unique(yCDF);
x = interp1(yCDF, xCDF(index), x1);     % �������� �������������� 
% x = x.';


%--------------------------------------------------------------------------
% ������
%--------------------------------------------------------------------------
i = 0;
j = 0;
k = 0;


% f_res = f_00;

for f_res = (f_00+f_step) : f_step : (f_00+df);
    k = k + 1;
    i = 0;


for P_in = P_min : P_step : P_max %; (P_opt - 2*dP)
% for P_in = (P_opt - 15*P_step) : P_step : (P_opt + 15*P_step)
% P_in = (P_opt - dP) : P_step : (P_opt + dP);
% P_in = P_opt;
%     v = v_opt;
%     j = j + 1;


i = i + 1;
P_x(i) = P_in;
p_P_sum(i) = 0;


    for v = v_min:v_step:v_max

%     j = j + 1;
    j = ((v/v_step)); %int32
    v = j;%v_opt;
        
    %----------------------------------------------------------------------
    % ���������
    %----------------------------------------------------------------------
    P_res = P_in * Q_res;
    H = sqrt ( (2*P_res) / (Z_0*S) );
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
    w_00 = 2*pi*f_00; % ������� ������� �������� ��������
    w_res = 2*pi*f_res; % ������� ������� ������� �����������
    dw = w_res - w_00; % ���������� ������� ������� ������� �����������
    rabi_gen = sqrt(b.^2 + dw.^2); % ���������� ������� ����
    ot2 = rabi_gen.*t/2;
    o0T2 = (dw.*T)/2;

    p_temp1 = 4*((b./rabi_gen).^2) .* (sin(ot2).^2);
    p_temp2 = cos(ot2) .* cos(o0T2);
    p_temp3 = (-dw./rabi_gen) .* sin(ot2) .* sin(o0T2);
    p(i, j) = p_temp1 .* ((p_temp2 - p_temp3) .^ 2);
    
    p_v(i, j) = p(i, j) * fv_22(j);
    p_P_sum(i) = p_P_sum(i) + p_v(i, j);
    
    p_out(k, i) = p_P_sum(i)*2;


%     p_derivative = diff(p);

    end


%     figure(1);
%     hold on; grid on;
%     plot(v, p);

end


end



%--------------------------------------------------------------------------
% ��������
%--------------------------------------------------------------------------
% detector_step = 1e4;
% k = 1;
% for i = 1:detector_step:(N_samples-detector_step)
%     k = k + 1;
%     out(k) = mean(p(i:i+detector_step-1));
% end

% p_P_sum = sum (p_v, 2);
% p_P_prod = prod (p_v, 2);


%--------------------------------------------------------------------------
% ����������
%--------------------------------------------------------------------------
% p_std = movstd(p,50);


%--------------------------------------------------------------------------
% �������
%--------------------------------------------------------------------------

% figure(1);
% hold on; grid on;
% % plot(f_res, p); plot(p_std); % plot(v); % plot(P_in, p);
% x_axis = [0 v_max];
% y_axis = [0 P_max];
% imagesc(x_axis, y_axis, p);
% colorbar;


figure(2);
hold on; grid on;
plot(P_x, p_out);


% figure(3);
% hold on; grid on;
% plot(P_x, p_P_prod);


end

