function [result] = clean_silence(video, audio, sub_width, freq)
    fprintf('call function sub_width/freq = %d\n', sub_width/freq);
    
    epsilon = 0.2; % tolleranza
    threshold = 0.5; % al di sotto di 0.5s il ritardo non viene considerato
    result = [];
    
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
        
        if abs(delay) <= threshold
            % nessun ritardo considerevole
            result = cat(1, result, xa_frame);
            
        elseif abs( abs(delay) - sub_width/freq ) > epsilon
            % c'è un ritardo ed è diverso da quello precedente (sub_width),
            % a meno di una tolleranza --> quindi continua a suddividere
            fprintf('delay = %d\n', delay);
            z = clean_silence(xav_frame, xa_frame, round(abs(delay)*freq), freq);
            result = cat(1, result, z);
            
        end
        
    end
end

