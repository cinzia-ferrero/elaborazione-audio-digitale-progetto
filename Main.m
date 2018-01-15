clc
clear all;
close all;

video_file_name = 'EAD18-20171025A.mp4';
audio_file_name = 'EAD18-20171025A.3gpp';
[xav, xa, freq] = load_files(video_file_name, audio_file_name);

tic;

l_frame = freq*60; % lunghezza frame in campioni per l'analisi

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