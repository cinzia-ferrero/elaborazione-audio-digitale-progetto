% clc
% clear all;
% close all;
% 
% [xav,freq]= audioread('EAD18-20171025A.mp4');
% % plot(xav);
% xa = audioread('EAD18-20171025A.3gpp');
% % plot(xa);
% fprintf('files read\n');
% 
% % RITARDO tramite la cross-correlation
% 
% frame_dim1 = freq*60*1; %dimensione del frame audio-video di 
% 
% xav_frame = xav(1:frame_dim1);
% 
% cont=0; %serve per capire quando troviamo convergenza
% i=0;
% 
% while cont<8
%     xa_frame = xa(1:0.5*frame_dim1*(i+1));
%     [acor,lag] = xcorr(xav_frame,xa_frame);
%     [~,I] = max(abs(acor));
%     lagDiff = lag(I);
%     lagTime(i+1) = lagDiff/freq;
%     
%     if i>1
%         if abs(lagTime(i+1)-lagTime(i))<=eps
%             cont = cont + 1;
%         else
%         %if abs(lagTime(i+1)-lagTime(i))>=eps
%             cont = 0;
%         end
%     end
%     i = i + 1;
% end
% 
% % Trasliamo il segnale audio
% xa_trasl = xa(-lagDiff:end);
% figure
% plot(xa_trasl,'b')
% figure
% plot(xav,'r')
% % corr=xcorr(xa_trasl,xav);
% % figure
% % plot(corr)
% fprintf('******* DONE sync *******\n');
% 
% % Analisi per frame (silenzi e deriva)
% 
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

y = [];
xa_no_silence = clean_silence(xav,xa_trasl,60*freq,freq,y);
fprintf('++++++++++++++++++end++++++++++++++++++++++\n');
audiowrite('prova y.wav', xa_no_silence, freq);

% sec=60;
% l_frame=freq*sec;
% overlap=1/3;
% p=0;
% 
% while p+l_frame<l
%     
%     xav_frame=xav(p+1:p+l_frame);
%     xa_frame=xa_trasl(p+1:p+l_frame);
% %     figure
% %     plot(xav_frame)
% %     figure
% %     plot(xa_frame)
%     [corr,lag]=xcorr(xav_frame,xa_frame);
%     [~,I]=max(abs(corr));
%     lagDiff=lag(I);
%     rit=lagDiff/freq;
%     
%     if abs(rit)<=0.5 %no silenzio
%         
%         y(p+1:p+l_frame)=xa_frame;
%     end
%     
%     if abs(rit)>=0.5 %silenzio aggiunto o deriva
%         
%         
%     end
%     
%     
%     p=p+overlap*l_frame;
% end
% 
