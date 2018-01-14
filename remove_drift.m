function [xa_fin, deriva, length_analysis] = remove_drift(xav, xa_cleaned, l_frame)
    fprintf('Starting to remove drift....\n');

    length_analysis = min(length(xav),length(xa_cleaned));

    der_vid = xav(length_analysis-l_frame : length_analysis);
    der_aud = xa_cleaned(length_analysis-l_frame : length_analysis);

    [corr,lag] = xcorr(der_vid,der_aud);
    [~,I] = max(abs(corr));
    deriva = lag(I);
    samples_aud = floor(length_analysis/abs(deriva));

    xa_fin=[];
    k=0;
    i=0;

    for j=0:samples_aud:length_analysis
        i=i+1;

        if length_analysis-j<samples_aud %se siamo alla fine vedo quanti campioni rimangono ( sono sicuramente meno di samples_aud)

            if length_analysis-j>0.7*samples_aud %se pero' sono "abbastanza" tolgo comunque 1 campione altrimenti no

                temp=xa_cleaned(j+1:length_analysis);
                index = 0;
                while index < 2 || index > length(temp)-1
                    index=randi(length(temp)); %selezione un indice random di temp
                end

                if deriva < 0 %togliere all' audio
                    xa_fin(k+1:k+samples_aud-1)=[temp(1:index-1) temp(index+1:end)];
                    k=k+samples_aud-1;
                else %aggiungere all' audio
                    new_sample = (temp(index-1)+temp(index))/2;
                    xa_fin(k+1:k+samples_aud+1) = [temp(1:index-1)' new_sample temp(index:end)'];
                    k=k+samples_aud+1;
                end

            else % se i campioni che rimangono sono pochi, non togliamo nessun campione
                if deriva <0
                       xa_fin = [xa_fin xa_cleaned(j+1:length(xa_cleaned))];
                else
                       xa_fin = [xa_fin xa_cleaned(j+1:length(xa_cleaned))'];
                end
            end
            

        else % tutte le iterazioni meno l'ultima

               temp = xa_cleaned(j+1:j+samples_aud);
               index = 0;
               while index < 2 || index > length(temp)-1
                  index = randi(length(temp)); %selezione un indice random di temp
               end
               
               if deriva < 0 %togliere all' audio
                   xa_fin(k+1:k+samples_aud-1)=[temp(1:index-1) temp(index+1:end)];
                   k=k+samples_aud-1;
               else %aggiungere all' audio
                   new_sample = (temp(index-1)+temp(index))/2;
                   xa_fin(k+1:k+samples_aud+1) = [temp(1:index-1)' new_sample temp(index:end)'];
                   k=k+samples_aud+1;
               end
        end
    end
    
    fprintf('****   END removal   ****\n');
end
    