% =========================================================================
% ������� ����
%--------------------------------------------------------------------------
% v - �������� ��������� ��������
% dT_K - ��� ������� ����������� ����
% =========================================================================


function v = source ( dT_K )


%--------------------------------------------------------------------------
% ����������
%--------------------------------------------------------------------------
k = 1.380649e-23; % ���������� ���������
T_K_opt = 375; % ������� �����������, �
m = 132.90545193324 * 1.660539066605e-27; % ����� ����� (������� �.�.�. � ��)
L = 0.15;
l = 0.01;
n_1 = 1;
n_2 = 2;
n_3 = 3;
C_n_1 = 2;
C_n_2 = 4/sqrt(pi);
C_n_3 = 2;


%--------------------------------------------------------------------------
% ������
%--------------------------------------------------------------------------
T_K = T_K_opt; %+ dT_K;
v = sqrt (2*k*T_K/m);
% dv = 1;
t_0 = l/v;


for i = 1:3000
    v_v(i) = i;% - 750;
%     v_x(i) = v_v(i) + v;
    
    
    t(i) = (i) * 1e-7;
%     t_x(i) = t(i);
    
    
    %----------------------------------------------------------------------
    % ���� (���. 152)
    %----------------------------------------------------------------------
%     p_temp1(i) = 1 / (sqrt(pi)*v);
%     p_temp2(i) = exp ( (-1) * (v_v(i)/v)^2 );
%     p(i) = p_temp1(i) * p_temp2(i);


    %----------------------------------------------------------------------
    % Xie "Linewidth locking method" & "Research on Main Kinds of Frequency
    % Biases"
    %----------------------------------------------------------------------
    ft_exp(i) = exp( -1*(t_0^2) / (t(i)^2) );
    ft_n1(i) = (t_0/t(i))^(n_1+2);
    ft_n2(i) = (t_0/t(i))^(n_2+2);
    ft_n3(i) = (t_0/t(i))^(n_3+2);
    fv_1(i) = (C_n_1/t_0) * ft_n1(i) * ft_exp(i);
    fv_2(i) = (C_n_2/t_0) * ft_n2(i) * ft_exp(i);
    fv_3(i) = (C_n_3/t_0) * ft_n3(i) * ft_exp(i);

%     fv_1(i) = 1 / (sqrt(pi*v)) * exp( (-1) * ((v/v_v(i))^2) );
%     fv_1(i) = (C_n_1/v) * (v/v_v(i))^(n_1+2) * exp( (-1) * ((v/v_v(i))^2) );
%     fv_2(i) = (C_n_2/v) * (v/v_v(i))^(n_2+2) * exp( (-1) * ((v/v_v(i))^2) );
%     fv_3(i) = (C_n_3/v) * (v/v_v(i))^(n_3+2) * exp( (-1) * ((v/v_v(i))^2) );

    % fv_1_sum = sum (fv_1)
    % fv_2_sum = sum (fv_2)
    % fv_3_sum = sum (fv_3)


end


xCDF = t;%v_v;

% Generate CDF
yCDF1 = cumsum(fv_1)/sum(fv_1);
yCDF2 = cumsum(fv_2)/sum(fv_2);
yCDF3 = cumsum(fv_3)/sum(fv_3);

% Generate uniform random variable
x1_1 = rand(1e5,1);

[yCDF1, index] = unique(yCDF1);
[yCDF2, index] = unique(yCDF2);
[yCDF3, index] = unique(yCDF3);

% Inverse transform
x1 = interp1(yCDF1, xCDF(index), x1_1);
x2 = interp1(yCDF2, xCDF(index), x1_1);
x3 = interp1(yCDF3, xCDF(index), x1_1);



% figure(1);
% hold on; grid on;
% plot(x);

figure(1);
hold on; grid on;
% hist(x1, 100, 'w');
plot(fv_1, 'r'); %*(0.2e3)
% plot(yCDF1, 'g');

% figure(2);
% hold on; grid on;
% hist(x2, 100);
plot(fv_2, 'g');

% figure(3);
% hold on; grid on;
% hist(x3, 100);
plot(fv_3, 'b');


end