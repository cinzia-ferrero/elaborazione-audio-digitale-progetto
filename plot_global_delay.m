function [] = plot_global_delay(freq, xav, xa, l_frame)
    fprintf('Starting to plot....\n');
    
    xav_plot = xav;
    xa_plot = xa;
    
    l1=length(xa);
    l2=length(xav);
    maxlength = max(l1,l2);

    if maxlength==l1
        xav_plot=[xav_plot',zeros(maxlength-l2,1)'];
        xav_plot=xav_plot';
    end
    if maxlength==l2
        xa_plot=[xa_plot',zeros(maxlength-l1,1)'];
        xa_plot=xa_plot';
    end

    global_delay = [];
    i = 0;
    x = [];

    for p = 0 : l_frame : maxlength

        if maxlength-p < l_frame
            video_frame = xav_plot(p+1 : end);
            audio_frame = xa_plot(p+1 : end);
        else
            video_frame = xav_plot(p+1 : p+l_frame);
            audio_frame = xa_plot(p+1 : p+l_frame);
        end

        [corr,lag] = xcorr(audio_frame, video_frame);
        [~,I] = max(abs(corr));
        lagDiff = lag(I);

        global_delay(i+1) = lagDiff/freq;
        
        x(i+1) = p/freq;
        i = i + 1;
    end
    
    figure
    plot(x, global_delay)
    xlabel('Time (s)');
    ylabel('Delay (s)');
    title('Global delay');
    
    fprintf('****   END plot   ****\n');
end