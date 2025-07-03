function funchub = func_in_calendar
    funchub.cal_E = @cal_E;
    funchub.cal_me = @cal_me;
    funchub.find_m = @find_m;
end

function E = cal_E(theta,e)
    if theta <=180
        t1 = tan(deg2rad(theta)/2);
        t2 = ((1-e)/(1+e))*t1^2;
        t3 = 2*atan(sqrt(t2));
    elseif theta >180
        t1 = tan(deg2rad(theta)/2);
        t2 = ((1-e)/(1+e))*t1^2;
        t3 = 2*(pi-atan(sqrt(t2)));
    end
    E = t3;
end

function Me = cal_me(E,e)
    t1 = E-e*sin(deg2rad(E));
    Me = t1;
end

function M_in_fix = find_m(day,trend_c)
    [~,idx] = min(abs(trend_c-day));
    if day>=trend_c(idx)
        M_in_fix = idx;
    elseif day<trend_c(idx)
        M_in_fix = idx-1;
    end
    if M_in_fix == 0
        M_in_fix = 12;
    end
end