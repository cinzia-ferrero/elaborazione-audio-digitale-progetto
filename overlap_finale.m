%suddividere intervalli
%pezzo giusto silenzio?

audio_length = length(xa_trasl);
video_length = length(xav);
maxlength = max(audio_length,video_length);

if maxlength == audio_length
    xav = [xav', zeros(maxlength - video_length, 1)'];
    xav = xav';
end
if maxlength == video_length
    xa_trasl = [xa_trasl', zeros(maxlength - audio_length, 1)'];
    xa_trasl = xa_trasl';
end

sec=input('inserire durata frame in s per analisi ');
l_frame=freq*sec; % lunghezza frame per ciclo while esterno
p=0; % contatore ciclo while esterno

xa_cleaned = xa_trasl;
silence=[];

for p=0:l_frame:maxlength
    
    if maxlength-p<l_frame
        xav_frame=xav(p+1:end);
        xa_frame=xa_cleaned(p+1:end);
    else
        xav_frame=xav(p+1:p+l_frame);
        xa_frame=xa_cleaned(p+1:p+l_frame);
    end
    
    fprintf('p = %d\n', p);
    
    [corr,lag]=xcorr(xav_frame,xa_frame);
    [~,I]=max(abs(corr));
    lagDiff=lag(I);
    rit=lagDiff/freq;
    
    if abs(rit)>=0.5 %silenzio aggiunto, raffiniamo il frame
        
         overlap=0.5*freq;
         delay = [];
         i=0;
         k=0;
         epsilon = 0.1;
         while i+overlap < 2*l_frame
              aud=xa_cleaned(p-l_frame+1+i:p+i);
              vid=xav(p-l_frame+i+1:p+i);
              [corr,lag]=xcorr(aud,vid);
              [~,I]=max(abs(corr));
              lagDiff=lag(I);
              delay(k+1)=lagDiff/freq;
              fprintf('delay = %d\n', delay(k+1));
              if k>0 && abs(delay(k)-delay(k+1)) > epsilon
                  xa_cleaned = cat(1, xa_cleaned(1 : p+i-lagDiff), xa_cleaned(p+i+1 : end));
                  silence = cat(1, silence, xa_cleaned(p+i-lagDiff+1 : p+i));
                  fprintf('---------removed delay\n');
              end
              
              i=i+overlap;
              k = k + 1;
         end
        
    end
end