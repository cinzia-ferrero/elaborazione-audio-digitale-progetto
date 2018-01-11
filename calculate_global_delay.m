l_frame = freq*60;
p = 0;
global_delay = [];
i = 0;
%x4=xa_trasl(1:floor(length(xa_trasl)/4));
%y4=xav(1:floor(length(xav)/4));

while p+l_frame < l
    
    audio_frame = xa_trasl(p+1 : p+l_frame);
    video_frame = xav(p+1 : p+l_frame);
    
    [corr,lag] = xcorr(audio_frame, video_frame);
    [~,I] = max(abs(corr));
    lagDiff = lag(I);
    
    global_delay(i+1) = lagDiff/freq;
    
    fprintf('p = %d\n', p);
    i = i + 1;
    p = p + 0.5*freq;
end

figure
plot(global_delay)