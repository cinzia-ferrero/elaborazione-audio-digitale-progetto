# Progetto per il corso di Elaborazione dell'audio digitale

## Descrizione

Lo script Main serve a sincronizzare un audio estratto da un video con un'altra traccia audio registrata da un secondo dispositivo. In particolare lo script è pensato per sincronizzare uno screen recording e una registrazione eseguita da uno smartphone.
Nel dettaglio lo script è composto da 3 funzioni che eseguono gli step fondamentali per il raggiungimento del nostro scopo:
* sync_audio_to_video: questa funzione serve ad allineare l'inizio del video all'audio (tagliando la parte iniziale superflua dell'audio)
* remove_unrelated_pieces: questa funzione serve a rimuovere eventuali pezzi estranei aggiunti dallo smartphone nella traccia audio
* remove_drift: questa funzione serve a correggere l'eventuale errore di deriva che si ha tra le due tracce dovuto alla differenza di clock dei due dispositivi
Il risultato finale è la traccia audio dello smartphone adattata e sincronizzata con quella del video.

## Esempio

Il corpo del Main sono le seguenti righe di codice. In particolare le prime due definiscono le variabili con i nomi dei file da processare e le restanti chiamano le funzioni sopra descritte.

    video_file_name = 'path_to_video_file';
    audio_file_name = 'path_to_audio_file';

    [xav, xa, freq] = load_files(video_file_name, audio_file_name);
    [xa_trasl, shift] = sync_audio_to_video(freq, xav, xa, flag_plot, l_frame);
    [xa_cleaned, silence_indexes] = remove_unrelated_pieces(freq, xav, xa_trasl, flag_plot, l_frame);
    [xa_no_drift, drift, track_length] = remove_drift(xav, xa_cleaned, flag_plot, l_frame);
    xa_final = xa_no_drift(1 : track_length);
    audiowrite('xa_final.wav', xa_final, freq);

Il risultato restituito è il file "xa_final.wav".

## Installazione

Per eseguire gli script è necessario avere Matlab installato. Gli script sono stati testati dalla versione 2014b in poi.
Toolbox utilizzati: Signal Processing

Una volta scaricati gli script, bisogna sostituire il file path del video e dell'audio rispettivamente nelle due variabili "video_file_name" e "audio_file_name" nello script Main.

Dopodiché è sufficiente eseguire lo script Main (Run).
