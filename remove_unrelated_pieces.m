function [xa_cleaned, silence_indexes] = remove_unrelated_pieces(freq, xav, xa_trasl, flag_plot, l_frame)
    fprintf('Starting to remove unrelated pieces....\n');

    xa_cleaned = xa_trasl;
    silence = [];
    num_silence = 0;  %contatore silenzi
    silence_indexes = [];
    maxlength = max(length(xav), length(xa_cleaned));

    for p = 0 : l_frame : maxlength

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

        [corr,lag] = xcorr(xav_frame,xa_frame);
        [~,I] = max(abs(corr));
        lagDiff = lag(I);
        rit = lagDiff/freq;

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

                  if k > 0  &&  abs(delay(k)-delay(k+1)) > epsilon
                      % trovato il frame con il silenzio

                      lagDiff = lagDiff - delay(k)*freq; % correzione del ritardo per non togliere la deriva
                      fs = p-l_frame+i+1;
                      fe = p+i-lagDiff;
                      overlap = 0.5;
                      shift = round(lagDiff*overlap);
                      
                      scalare = [];
                      removed_aud = [];
                      j = 0;
                      while -j*shift < l_frame

                          if j == 0
                              removed_aud = xa_cleaned(fs-lagDiff : fe);
                          else
                              removed_aud = [xa_cleaned(fs : fs-j*shift)' xa_cleaned(fs-(j+1/overlap)*shift : fe)'];
                          end

                          % normalizzazione
                          removed_aud = removed_aud/max(abs(removed_aud));

                          % sogliatura
                          soglia = 0.02;
                          thresh_aud = zeros(length(removed_aud),1);
                          thresh_vid = zeros(length(vid),1);

                          for m = 1 : length(removed_aud)
                              if abs(removed_aud(m)) > soglia
                                  thresh_aud(m) = 1;
                              end
                              if abs(vid(m)) > soglia
                                  thresh_vid(m) = 1;
                              end
                          end

                          % calcolo prodotto scalare
                          scalare(j+1) = dot(thresh_aud, thresh_vid);
                          j = j+1;
                      end

                      [~,ind] = max(scalare);

                      silence = [silence xa_cleaned(fs+1-(ind-1)*shift : (fs-1)-(ind-1+1/overlap)*shift)'];
                      num_silence = num_silence+1;
                      fprintf('silenzi tolti = %d\n', num_silence);
                      silence_indexes(num_silence, :) = [fs-(ind-1)*shift, (fs-1)-(ind-1+1/overlap)*shift];

                      xa_cleaned = [xa_cleaned(1 : fs-(ind-1)*shift)' xa_cleaned(fs-(ind-1+1/overlap)*shift : end)'];

                      maxlength = max(length(xav), length(xa_cleaned));
                      i = 2*l_frame; % break while

                  end

                  i = i+overlap;
                  k = k + 1;

             end
        end
    end
    
    if flag_plot == 1
        figure
        plot(xa_cleaned,'b')
        title('Audio without unrelated pieces');
        figure
        plot(silence, 'g')
        title('Removed unrelated pieces');
    end
    
    fprintf('****   END removal   ****\n');
end