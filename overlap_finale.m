sec=input('inserire durata frame in s per analisi ');
l_frame=freq*sec;
p=0;

xa_cleaned = xa_trasl;

a=0; % contatore per riempire y
y=[]; % 
silence=[];
step_silence=0;
while p+l_frame<l
    fprintf('p = %d\n', p);
    xav_frame=xav(p+1:p+l_frame);
    xa_frame=xa_cleaned(p+1:p+l_frame);
%     figure
%     plot(xav_frame)
%     figure
%     plot(xa_frame)
    [corr,lag]=xcorr(xav_frame,xa_frame);
    [~,I]=max(abs(corr));
    lagDiff=lag(I);
    rit=lagDiff/freq;
    
    if abs(rit)<=0.5 %no silenzio
        fprintf('no silenzio\n');
        y(a+1:a+l_frame)=xa_frame;
        a=a+l_frame;
    end
    
    if abs(rit)>=0.5 %silenzio aggiunto, raffiniamo il frame
        
         overlap=0.5*freq;
         delay = [];
         i=0;
         k=0;
         epsilon = 0.1;
         while i+overlap < 2*l_frame
              aud=xa_cleaned(p-l_frame+1+i+1:p+i+overlap);
              vid=xav(p-l_frame+1+i+1:p+i+overlap);
              [corr,lag]=xcorr(aud,vid);
              [~,I]=max(abs(corr));
              lagDiff=lag(I);
              delay(k+1)=lagDiff/freq;
              fprintf('delay = %d\n', delay);
              if k>0 && abs(delay(k)-delay(k+1)) > epsilon
                  xa_cleaned = cat(1, xa_cleaned(1 : p+i+overlap-lagDiff), xa_cleaned(p+i+overlap+1 : end));
                  silence = cat(1, silence, xa_cleaned(p+i+overlap-lagDiff+1 : p+i+overlap));
                  fprintf('---------removed delay\n');
              end
              
              i=i+overlap;
              k = k + 1;
         end
        
    end
    p = p + l_frame;
end