% per input sec di 30 si rompe




% clc
% clear all;
% close all;

tic;

% [xav,freq] = audioread('EAD18-20171025A.mp4');
% xa = audioread('EAD18-20171025A.3gpp');
% fprintf('files read\n');

sec = input('Inserire durata frame in s per analisi ');
l_frame = freq*sec; % lunghezza frame per ciclo while esterno

flag_plot = input('Inserisci 1 per plottare tracce, 0 altrimenti ');
[xa_trasl, shift] = sync_audio_to_video(freq, xav, xa, flag_plot, l_frame);

plot_global_delay(freq, xav, xa_trasl, l_frame);

[xa_cleaned, silence_indexes] = remove_unrelated_pieces(freq, xav, xa_trasl, flag_plot, l_frame);

plot_global_delay(freq, xav, xa_cleaned, l_frame);

[xa_no_drift, drift, track_length] = remove_drift(xav, xa_cleaned, flag_plot, l_frame);

plot_global_delay(freq, xav, xa_no_drift, l_frame);

xa_final = xa_no_drift(1 : track_length);
audiowrite('xa_final.wav', xa_final, freq);

toc;