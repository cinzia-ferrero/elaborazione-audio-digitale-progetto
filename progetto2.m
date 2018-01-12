% clc
% clear all;
% close all;
% 
% [xav,freq]= audioread('EAD18-20171025A.mp4');
% % plot(xav);
% xa = audioread('EAD18-20171025A.3gpp');
% % plot(xa);
% fprintf('files read\n');

% RITARDO tramite la cross-correlation

frame_dim = freq*60*1; %dimensione del frame audio-video

xav_frame = xav(1:frame_dim);

cont = 0; %serve per capire quando troviamo convergenza
i = 0;

while cont<8
    
    xa_frame = xa(1:0.5*frame_dim*(i+1));
    
    [corr,lag] = xcorr(xav_frame,xa_frame);
    [~,I] = max(abs(corr));
    lagDiff = lag(I);
    lagTime(i+1) = lagDiff/freq;
    
    if i>1
        if abs(lagTime(i+1)-lagTime(i))<=eps
            cont = cont + 1;
        else
        %if abs(lagTime(i+1)-lagTime(i))>=eps
            cont = 0;
        end
    end
    i = i + 1;
end

% Trasliamo il segnale audio
xa_trasl = xa(-lagDiff:end);
figure
plot(xa_trasl,'b')
figure
plot(xav,'r')
% corr=xcorr(xa_trasl,xav);
% figure
% plot(corr)
fprintf('******* DONE sync *******\n');

% audiowrite('xav.wav', xav, freq);
% audiowrite('xa_trasl.wav', xa_trasl, freq);

% Analisi per frame (silenzi e deriva)

% l1=length(xa_trasl);
% l2=length(xav);
% l=max(l1,l2);
% 
% if l==l1
% xav=[xav',zeros(l-l2,1)'];
% xav=xav';
% end
% if l==l2
% xa_trasl=[xa_trasl',zeros(l-l1,1)'];
% xa_trasl=xa_trasl';
% end

% [xa_no_silence, silence] = clean_silence(xav, xa_trasl, 60*freq, freq);
% fprintf('++++++++++++++++++end++++++++++++++++++++++\n');
% audiowrite('prova y.wav', xa_no_silence, freq);
% audiowrite('silence.wav', silence, freq);
