function [xav, xa, freq] = load_files(video_file_name, audio_file_name)
    fprintf('Starting to read files....\n');

    [xav,freq] = audioread(video_file_name);
    xa = audioread(audio_file_name);
    
    fprintf('****   END loading   ****\n');
end