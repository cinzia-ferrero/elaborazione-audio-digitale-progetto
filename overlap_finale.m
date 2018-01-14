sec = input('inserire durata frame in s per analisi ');
l_frame = freq*sec; % lunghezza frame per ciclo while esterno
p = 0; % contatore ciclo while esterno

xa_cleaned = xa_trasl;
silence = [];
num_silence = 0;  %contatore silenzi
maxlength = max(length(xav), length(xa_cleaned));

for p=0:l_frame:maxlength
    
    if maxlength-p < l_frame
        xav_frame = xav(p+1 : end);
        xa_frame = xa_cleaned(p+1 : end);
    else
        xav_frame = xav(p+1 : p+l_frame);
        xa_frame = xa_cleaned(p+1 : p+l_frame);
    end
    
    % normalizzazione
    xav_frame = xav_frame/max(abs(xav_frame));
    xa_frame = xa_frame/max(abs(xa_frame));
    fprintf('p = %d\n', p);
    
    [corr,lag] = xcorr(xav_frame,xa_frame);
    [~,I] = max(abs(corr));
    lagDiff = lag(I);
    rit = lagDiff/freq;
    fprintf('rit = %d\n', rit);
    
    if abs(rit) >= 0.5 %silenzio aggiunto, raffiniamo il frame
        
         overlap = 0.5*freq;
         delay = [];
         i = 0;
         k = 0;
         epsilon = 0.1;
         
         while i+overlap < 2*l_frame % cerchiamo il frame con il silenzio 
                                      % e partiamo da quello precedente 
              aud = xa_cleaned(p-l_frame+i+1 : p+i);
              vid = xav(p-l_frame+i+1 : p+i);
              
              % normalizzazione
              aud = aud/max(abs(aud));
              vid = vid/max(abs(vid));
              
              [corr,lag] = xcorr(vid, aud);
              [~,I] = max(abs(corr));
              lagDiff = lag(I);
              delay(k+1) = lagDiff/freq;
              fprintf('delay = %d\n', delay(k+1));
              
              if k>0 && abs(delay(k)-delay(k+1)) > epsilon
                  % trovato il frame con il silenzio
                  
                  lagDiff = lagDiff - delay(k)*freq; % correzione del ritardo per non togliere la deriva
                  
                  scalare = [];
                  removed_aud = [];
                  j = 0;
                  while -j*lagDiff < l_frame
                      
                      if j == 0
                         removed_aud = xa_cleaned(p-l_frame+i+1-lagDiff:p+i-lagDiff);
                      else
                          removed_aud = [xa_cleaned(p-l_frame+i+1:p-l_frame+i-j*lagDiff)' xa_cleaned(p-l_frame+i+1-(j+1)*lagDiff:p+i-lagDiff)'];
                      end
                      
                      % normalizzazione
                      removed_aud = removed_aud/max(abs(removed_aud));
                      
                      % sogliatura
                      soglia=0.02;
                      thresh_aud=zeros(length(removed_aud),1);
                      thresh_vid=zeros(length(vid),1);
                      
                      for m = 1 : length(removed_aud)
                          if abs(removed_aud(m))>soglia
                              thresh_aud(m)=1;
                          end
                           if abs(vid(m))>soglia
                               
                               thresh_vid(m)=1;
                          end
                      end
                      
                      % calcolo prodotto scalare
                      scalare(j+1) = dot(thresh_aud, thresh_vid);
                      j = j+1;
                  end
                  
                  [~,ind] = max(scalare);
                  
                  silence = [silence' xa_cleaned(p-l_frame+i+1-(ind-1)*lagDiff : p-l_frame+i-ind*lagDiff)'];
                  num_silence = num_silence+1;
                  fprintf('silenzi tolti = %d\n', num_silence);
                  
                  xa_cleaned = [xa_cleaned(1:p-l_frame+i-(ind-1)*lagDiff)' xa_cleaned(p-l_frame+i+1-ind*lagDiff:end)'];
                  
                  maxlength = max(length(xav), length(xa_cleaned));
                  i = 2*l_frame; % break while
                 
              end
              
              i = i+overlap;
              k = k + 1;
             
         end
    end
end

audiowrite('xa_cleaned.wav', xa_cleaned, freq);