function [result] = clean_silence(video, audio, sub_width, freq, y)
    fprintf('call function sub_width/freq = %d\n', sub_width/freq);
    
    i = 0;
    epsilon = 0.2; % tolleranza
    threshold = 0.5; % al di sotto di 0.5s il ritardo non viene considerato
    result = [];
   
    while (i + sub_width) < length(video)
    
        xav_frame = video(i+1:i+sub_width);
        xa_frame = audio(i+1:i+sub_width);

        [corr,lag] = xcorr(xav_frame, xa_frame);
        [~,I] = max(abs(corr));
        lagDiff = lag(I);
        delay = lagDiff/freq;
        
        if abs(delay) <= threshold
            % nessun ritardo considerevole
            result = cat(1, result, xa_frame);
            
        elseif abs( abs(delay) - sub_width/freq ) > epsilon 
            % c'è un ritardo ed è diverso da quello precedente (sub_width),
            % a meno di una tolleranza --> quindi continua a suddividere
            fprintf('delay = %d\n', delay);
            z = clean_silence(xav_frame, xa_frame, round(abs(delay)*freq), freq, y);
            result = cat(1, result, z);
            
        end
        
        i = i + sub_width;
    end
end

