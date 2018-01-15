# Progetto per il corso di Elaborazione dell'audio digitale

## Descrizione

Lo script Main serve a sincronizzare un audio estratto da un video con un'altra traccia audio registrata da un secondo dispositivo. In particolare lo script è pensato per sincronizzare uno screen recording e una registrazione eseguita da uno smartphone.
Nel dettaglio lo script è composto da 3 funzioni che eseguono gli step fondamentali per il raggiungimento del nostro scopo:
* sync_audio_to_video: questa funzione serve ad allineare l'inizio del video all'audio (tagliando la parte iniziale superflua dell'audio)
* remove_unrelated_pieces: questa funzione serve a rimuovere eventuali pezzi estranei aggiunti dallo smartphone nella traccia audio
* remove_drift: questa funzione serve a correggere l'eventuale errore di deriva che si ha tra le due tracce dovuto alla differenza di clock dei due dispositivi
Il risultato finale è la traccia audio dello smartphone adattata e sincronizzata con quella del video.

## Esempio

## Installazione

