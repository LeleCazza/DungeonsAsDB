# DungeonsAsDB

## REQUISITI
- PostgreSQL: https://www.postgresql.org/
- XAMPP: https://www.apachefriends.org/it/index.html
> configurare XAMPP e PostgreSQL per poter dialogare tra loro

## INSTALLAZIONE APPLICAZIONE
- Copiare il file dump.sql nella cartella "bin" presente nel percorso di installazione di PostgreSQL
- Sempre nella cartella "bin", aprire un terminale e lanciare il comando:" psql -U postgres -d postgres -f dump.sql "
- Copiare il contenuto della cartella htdocs nella cartella "htdocs"  presente nel percorso di installazione di XAMPP
- Avviare il Browser e scrivere nella barra degli indirizzi "localhost"
- Verrà visualizzata la pagina principale del sito web.

## ISTRUZIONI D’USO
- Inizialmente è necessario iscriversi ed effettuare il Log In.
- Una volta effettuato il login bisognerà seguire le istruzioni per creare il personaggio,bisognerà quindi lanciare 5 volte il dado, scartare un valore a scelta tra quelli ottenuti ed inserire i valori correttamente nei diversi campi proposti.
- Infine premere su INIZIA IL GIOCO.
- Nella home del gioco ci sarà la possibilità di aggiornare la descrizione del proprio personaggio, iniziare a giocare o effettuare il Log Out.
- Per iniziare a giocare ci sono due vie:
  - Premendo il pulsante Gioca in basso
  - Premendo il pulsante Gioca tra le opzioni nel menù in alto
- Basterà quindi premere su INIZIA UNA NUOVA AVVENTURA per iniziare a giocare.
- Nel menù in alto si disporrà di tre opzioni:
  - Equipaggiamento: qui sarà possibile vedere gli oggetti equipaggiati e le caratteristiche in quel momento del personaggio ( all’inizio sarà equipaggiata nessun arma e nessun armatura )
  - Oggetti Posseduti: qui sarà possibile equipaggiare nuovi oggetti o cambiare il proprio equipaggiamento semplicemente premendo su EQUIPAGGIA ( gli oggetti disponibili inizialmente saranno una spada e una razione di cibo)
  - Log Out per uscire dal gioco
- Di fianco al menù verrà visualizzata la vita attuale del personaggio.
- Per iniziare l’avventura bisognerà cliccare su ENTRA NELLA PRIMA STANZA
- A questo punto verranno visualizzati:
  - Gli oggetti trovati nella stanza che potranno essere controllati su Oggetti posseduti
  - I nemici che potranno essere attaccati con i pulsanti ATTACCA
  - Le stanze visibili in cui ci si può rifugiare
(se sfortunati, potrebbero non esserci ne’ oggetti ne’ stanze visibili)
- Se si clicca su ATTACCA bisognerà seguire la procedura di attacco (ricordarsi di attaccare con un’arma equipaggiata, se no l’attacco anche se avrà effetto non toglierà pf al nemico)
- Se si clicca su una stanza si tenterà la fuga in un’altra stanza.
- Se verranno eliminati tutti i nemici presenti nella stanza si avrà la possibilità di spendere 1 pf per cercare oggetti nascosti o passaggi segreti attraverso il pulsante CERCA.
- Per riuscire nella ricerca bisognerà ottenere, lanciando il dado, un punteggio inferiore alla propria PER ( non verrà visualizzato il punteggio del dado).
- Se si arriva nella stanza finale il gioco finisce in modo positivo e verrà visualizzata l’esperienza ottenuta, si potrà quindi tornare alla home per vedere l’esperienza totale del personaggio e/o iniziare una nuova avventura.
- Se i pf del personaggio arrivano a zero il gioco finisce in modo negativo e si potrà tornare nella home per eventualmente provarci di nuovo.
