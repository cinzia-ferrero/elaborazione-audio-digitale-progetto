maxlength = max(length(xa_trasl),length(xav));

frame_len = freq*60;
p = 0;
global_delay = [];
i = 0;

while p+frame_len < maxlength
    
    audio_frame = xa_trasl(p+1 : p+frame_len);
    video_frame = xav(p+1 : p+frame_len);
    
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