function [result, silence] = clean_silence(video, audio, sub_width, freq)
    fprintf('call function sub_width/freq = %d\n', sub_width/freq);
    
    epsilon = 0.01; % tolleranza
    threshold = 0.8; % al di sotto di 0.8s il ritardo non viene considerato
    result = [];
    silence = [];
    
    fprintf('length(video)/sub_width = %d\n', length(video)/sub_width);
    
    % calcolo il numero di iterazioni del ciclo for
    num_of_iterations = floor(length(video)/sub_width);
    if (length(video)/sub_width)-num_of_iterations > 0
        num_of_iterations = num_of_iterations + 1;
        last_is_incomplete = true;
    end
    
    for i = 0 : (num_of_iterations-1)
        
        if i == (num_of_iterations-1) && last_is_incomplete
            fprintf('--- last incomplete frame ---\n');
            xav_frame = video(num_of_iterations*sub_width : length(video));
            xa_frame = audio(num_of_iterations*sub_width : length(video));
        else
            xav_frame = video((i*sub_width)+1 : (i*sub_width)+sub_width);
            xa_frame = audio((i*sub_width)+1 : (i*sub_width)+sub_width);
        end

        [corr,lag] = xcorr(xav_frame, xa_frame);
        [~,I] = max(abs(corr));
        lagDiff = lag(I);
        delay = lagDiff/freq;
        
        if abs(delay) > threshold & abs( abs(delay) - sub_width/freq ) <= epsilon
            silence = cat(1, silence, xa_frame);
        end
        
        if abs(delay) <= threshold
            % nessun ritardo considerevole, salviamo il frame
            result = cat(1, result, xa_frame);
            
        elseif abs( abs(delay) - sub_width/freq ) > epsilon
            % c'è un ritardo ed è diverso da quello precedente (sub_width),
            % a meno di una tolleranza --> quindi continua a suddividere
            fprintf('delay = %d\n', delay);
            [z, s] = clean_silence(xav_frame, xa_frame, round(abs(delay)*freq), freq);
            result = cat(1, result, z);
            silence = cat(1, silence, s);
            
        end
        
    end
end

