clear
close all
funchub = func_in_calendar;
%参数输入
% 规则：输入偏心率e、cesm显示的岁差角度d_cesm，即可将no_leap的格里高利年
% 的每一天，转换到fix_angle对应的月份中。
e = 0.04988;
d_cesm = 49.17;

alpha = mod(90-d_cesm,360);
T = 365;

%编排no_leap日历里每个月份的长度，开始的日期
lenth_month = [31,28,31,30,31,30,31,31,30,31,30,31];
end_day_tag = cumsum(lenth_month);
start_day_tag = [0,cumsum(lenth_month(1:11))];

%编排fix_angle日历里每个月的起始和结束角度
degree_start = mod(alpha+90-80,360); %fix_angle里，一月一日对应的角度
delta_angle = [degree_start,30,30,30,30,30,30,30,30,30,30,30];
degree_angle_start = cumsum(delta_angle);
degree_angle_end = degree_angle_start+30;
degree_angle_start = mod(degree_angle_start,360);
degree_angle_end = mod(degree_angle_end,360);

% no_leap里365天每天对应的角度是多少
% 春分是第80天对应上边的alpha+90(定义为theta)
% 首先计算春分对应的t
theta = mod(alpha+90,360);
E_theta = funchub.cal_E(theta,e);
Me_theta = funchub.cal_me(E_theta,e);
t_theta = Me_theta*T/(2*pi);

% 计算fix_angle日历里每个月开始结束对应的t
degree_angle_start_CORR_t = zeros(1,12);
degree_angle_end_CORR_t = zeros(1,12);

for temp_i = 1:12
    temp = degree_angle_start(temp_i);
    temp = mod(temp,360);
    temp_E = funchub.cal_E(temp,e);
    temp_Me = funchub.cal_me(temp_E,e);
    temp_t = temp_Me*T/(2*pi);
    degree_angle_start_CORR_t(temp_i) = temp_t;
end

for temp_i = 1:12
    temp = degree_angle_end(temp_i);
    temp = mod(temp,360);
    temp_E = funchub.cal_E(temp,e);
    temp_Me = funchub.cal_me(temp_E,e);
    temp_t = temp_Me*T/(2*pi);
    degree_angle_end_CORR_t(temp_i) = temp_t;
end

start_day_t = mod(start_day_tag+t_theta-80,365);
end_day_t = mod(end_day_tag+t_theta-80,365);

mon_in_fix_angle = zeros(1,365);
for day_i_tmp = 0:364
    day_i_t = mod(start_day_t(1)+day_i_tmp,365);
    mon_in_fix_angle(day_i_tmp+1) = funchub.find_m(day_i_t,degree_angle_start_CORR_t);
end