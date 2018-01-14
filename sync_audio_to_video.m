function [xa_trasl, shift] = sync_audio_to_video(freq, xav, xa, flag_plot, l_frame)
    fprintf('Starting to sync....\n');

    xav_frame = xav(1:l_frame);
    cont = 0; %serve per capire quando troviamo convergenza
    i = 0;

    while cont<8

        xa_frame = xa(1:0.5*l_frame*(i+1));

        [corr,lag] = xcorr(xav_frame,xa_frame);
        [~,I] = max(abs(corr));
        lagDiff = lag(I);
        lagTime(i+1) = lagDiff/freq;

        if i>1
            if abs(lagTime(i+1)-lagTime(i))<=eps
                cont = cont + 1;
            else
            %if abs(lagTime(i+1)-lagTime(i))>=eps
                cont = 0;
            end
        end
        i = i + 1;
    end

    % Trasliamo il segnale audio
    shift = lagTime(end);
    xa_trasl = xa(-lagDiff:end);
    
    if flag_plot == 1
        figure
        plot(xa_trasl,'b')
        figure
        plot(xav,'r')
    end
    
    fprintf('****   END syncing   ****\n');

end