function [result] = clean_silence(video,audio,sub_width,freq,y)
    fprintf('call function lenght video = %d, sub_width = %d\n', length(video), sub_width);
    
    len = length(video);
    p = 0;
    epsilon = 0.2;   % tolleranza
    result = [];
   
    while p+sub_width<len
    
        xav_frame=video(p+1:p+sub_width);
        xa_frame=audio(p+1:p+sub_width);

        [corr,lag]=xcorr(xav_frame,xa_frame);
        [~,I]=max(abs(corr));
        lagDiff=lag(I);
        rit=lagDiff/freq;
        % sub_width/freq e' il ritardo di prima
        % continua a cercare finche' il ritardo e' sopra la tolleranza di 0.2 secondi
        
        if abs(rit)<=0.5 %no silenzio          
            %fprintf('len+1:len+sub_width=%d:%d\n', length(result)+1, length(result)+sub_width);
            result = cat(1, result, xa_frame);
            %result(length(result)+1:length(result)+sub_width)=xa_frame;
            
        elseif abs(abs(rit)-sub_width/freq) > epsilon
            fprintf('rit = %d\n', rit);
            z = clean_silence(xav_frame,xa_frame, round(abs(rit)*freq), freq, y);
            %fprintf('length result 1 = %d\n', length(result));
            result = cat(1, result, z);
            fprintf('length result 2 = %d\n', length(result));
            %result(length(result)+1:length(result)+length(z)) = z;
        end
        p=p+sub_width;
    end
end

