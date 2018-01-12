%DERIVA


der_vid=xav(length(xav)-l_frame:length(xav));
der_aud=xa_cleaned(length(xav)-l_frame:length(xav));

[corr,lag] = xcorr(der_vid,der_aud);
    [~,I] = max(abs(corr));
    deriva= lag(I);
    samples_aud=floor(length(xav)/abs(deriva));
    
    if deriva<0 %togliere all' audio
    
        
    else        %aggiungere all' audio
      
    end
    