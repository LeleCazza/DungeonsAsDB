CREATE TABLE utente (
	id SERIAL NOT NULL,
	email VARCHAR(50) NOT NULL, 
  	password CHAR(8) NOT NULL, 
  	nome VARCHAR(20),
  	PRIMARY KEY(id)
);


CREATE TABLE tre_dadi (
	id INT NOT NULL, 
  	numero_lancio INT NOT NULL, 
  	valore INT NOT NULL,
  	PRIMARY KEY(id,numero_lancio),
  	FOREIGN KEY(id) REFERENCES Utente(id) ON DELETE CASCADE
); 


CREATE TABLE personaggio (
	id INT NOT NULL,
	nome VARCHAR(15) NOT NULL,
	descrizione VARCHAR(500),
	PE INT NOT NULL,
	FORZ INT NOT NULL,
	INT INT NOT NULL,
	AGI INT NOT NULL,
	COS INT NOT NULL,
	PF INT NOT NULL,
	PER INT NOT NULL,
	ATT INT NOT NULL,
	DIF INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES Utente(id) ON DELETE CASCADE
);


CREATE TABLE oggetto (
	nome VARCHAR(20) NOT NULL,
	pf INT,
	per INT NOT NULL,
	att INT NOT NULL,
	dif INT NOT NULL,
	tipo VARCHAR(15) NOT NULL,
	PRIMARY KEY(nome)
);

INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('nessun arma',0,0,0,0,'attacco');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('spada',4,2,2,-1,'attacco');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('spada a due mani',6,-1,3,-3,'attacco');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('lancia',5,2,3,1,'attacco');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('ascia',7,-2,4,-1,'attacco');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('balestra',3,5,5,-1,'attacco');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('arco',2,8,2,-3,'attacco');

INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('nessun armatura',0,0,0,0,'difesa');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('scudo',0,-5,1,4,'difesa');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('armatura leggera',0,0,-2,2,'difesa');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('armatura pesante',0,-3,-4,6,'difesa');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('elmo',0,3,0,1,'difesa');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('barriera magica',0,-5,-3,7,'difesa');

INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('razione di cibo',2,0,0,0,'consumabile');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('fagiolo magico',5,0,0,0,'consumabile');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('birra',-1,3,7,-2,'consumabile');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('cannabis',-2,10,0,-5,'consumabile');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('bile d orso',0,0,0,2,'consumabile');
INSERT INTO oggetto(nome,pf,per,att,dif,tipo) VALUES ('mon cheri',1,1,1,1,'consumabile');


CREATE TABLE possiede (
	id_personaggio INT NOT NULL,
	nome_oggetto VARCHAR(20) NOT NULL,
	indossato_si_no BOOLEAN NOT NULL,
	numero INT NOT NULL,
	PRIMARY KEY(id_personaggio,nome_oggetto,indossato_si_no),
	FOREIGN KEY(id_personaggio) REFERENCES personaggio(id) ON DELETE CASCADE,
	FOREIGN KEY(nome_oggetto) REFERENCES oggetto(nome) ON DELETE CASCADE
);


CREATE TABLE stanza (
	id INT NOT NULL,
	descrizione VARCHAR(400) NOT NULL,
	PRIMARY KEY(id)
);

INSERT INTO stanza(id,descrizione) VALUES (1,'Montagna');
INSERT INTO stanza(id,descrizione) VALUES (2,'Mare');
INSERT INTO stanza(id,descrizione) VALUES (3,'Spiaggia');
INSERT INTO stanza(id,descrizione) VALUES (4,'Fiume');
INSERT INTO stanza(id,descrizione) VALUES (5,'Caverna');
INSERT INTO stanza(id,descrizione) VALUES (6,'Bosco');
INSERT INTO stanza(id,descrizione) VALUES (7,'Radura');
INSERT INTO stanza(id,descrizione) VALUES (8,'Foresta');
INSERT INTO stanza(id,descrizione) VALUES (9,'Valle');
INSERT INTO stanza(id,descrizione) VALUES (10,'Citta');
INSERT INTO stanza(id,descrizione) VALUES (11,'Paese');
INSERT INTO stanza(id,descrizione) VALUES (12,'Villaggio');
INSERT INTO stanza(id,descrizione) VALUES (13,'Grotta');
INSERT INTO stanza(id,descrizione) VALUES (14,'Precipizio');
INSERT INTO stanza(id,descrizione) VALUES (15,'Lago');
INSERT INTO stanza(id,descrizione) VALUES (16,'Casa');
INSERT INTO stanza(id,descrizione) VALUES (17,'Tesoro');


CREATE TABLE gioca_in (
	id_personaggio INT NOT NULL,
	id_stanza INT NOT NULL,
	PRIMARY KEY(id_personaggio,id_stanza),
	FOREIGN KEY(id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE,
	FOREIGN KEY(id_stanza) REFERENCES stanza(id) ON DELETE CASCADE
);


CREATE TABLE attiva_mondo(
id_personaggio INT NOT NULL,
PRIMARY KEY(id_personaggio),
FOREIGN KEY(id_personaggio) REFERENCES personaggio(id) ON DELETE CASCADE
);


CREATE TABLE nemico(
id INT NOT NULL,
nome VARCHAR(25) NOT NULL,
descrizione VARCHAR(200) NOT NULL,
pf INT NOT NULL,
per INT NOT NULL,
dif INT NOT NULL,
danno INT NOT NULL,
PRIMARY KEY(id)
);

INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (1,'Sofien','Il carcerato',4,2,5,5);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (2,'Mariotto','Simone',4,2,5,5);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (3,'Mariotto','Fabiano',4,2,5,5);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (4,'Fabietto','il saggio',4,2,5,5);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (5,'Pange','il giocatore',4,2,5,5);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (6,'Rambo','Il cariola',4,2,5,5);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (7,'Corno','Lo sbronzo',4,2,5,5);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (8,'Abib','Il kebabbaro',4,2,5,5);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (9,'Mohamed','Munir',4,2,5,5);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (10,'Zeta','Il musicista',4,2,5,5);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (11,'Branch','La joia',4,2,5,5);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (12,'Sdru','il mastodontico amico',4,2,5,5);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (13,'Celeste','Il cotolengo',5,3,6,6);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (14,'Lele','El Trezza',5,3,6,6);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (15,'Frank','L ebreo',5,3,6,6);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (16,'Saba','Spaco Botilia',5,3,6,6);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (17,'Pannocchia','colui che vive al di sopra delle proprie possibilità',5,3,6,3);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (18,'Miguel','El pusher',6,4,7,7);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (19,'Paolo','Paulen',6,4,7,7);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (20,'Barney','Balla coi lupi',6,4,7,7);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (21,'Lollo','El Mocho',6,4,7,7);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (22,'Ciambe','L Ultra',6,4,7,7);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (23,'Ghiro','Ghirone',6,4,7,7);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (24,'Maik','Il terrone',6,4,7,7);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (25,'Der Raumdeuter','Colui che interpreta gli spazi',7,5,8,8);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (26,'MM11','O Cabajo',7,5,8,8);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (27,'Taran','Doc',15,15,15,15);
INSERT INTO nemico(id,nome,descrizione,pf,per,dif,danno) VALUES (28,'Junior','Noob',1,1,1,1);


CREATE TABLE protegge(
id_personaggio INT NOT NULL,
id_stanza INT NOT NULL,
id_nemico INT NOT NULL,
pf INT NOT NULL,
PRIMARY KEY(id_personaggio,id_stanza,id_nemico),
FOREIGN KEY(id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE,
FOREIGN KEY(id_stanza) REFERENCES stanza(id) ON DELETE CASCADE,
FOREIGN KEY(id_nemico) REFERENCES nemico(id) ON DELETE CASCADE
);

CREATE TABLE raggiunge(
id_cammino INT NOT NULL,
id_personaggio INT NOT NULL,
inizio_passaggio INT NOT NULL,
fine_passaggio INT NOT NULL,
visibile BOOLEAN NOT NULL,
PRIMARY KEY(id_cammino,id_personaggio),
FOREIGN KEY(id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE,
FOREIGN KEY(inizio_passaggio) REFERENCES stanza(id) ON DELETE CASCADE
);


CREATE TABLE contiene(
id_personaggio INT NOT NULL,
id_stanza INT NOT NULL,
nome_oggetto VARCHAR(20) NOT NULL,
visibile BOOLEAN NOT NULL,
numero INT NOT NULL,
PRIMARY KEY(id_personaggio,id_stanza,nome_oggetto,visibile),
FOREIGN KEY(id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE,
FOREIGN KEY(id_stanza) REFERENCES stanza(id) ON DELETE CASCADE,	
FOREIGN KEY(nome_oggetto) REFERENCES oggetto(nome) ON DELETE CASCADE
);


CREATE TABLE ingaggio(
id_personaggio INT NOT NULL,
nemico_ingaggiato INT NOT NULL,
PRIMARY KEY(id_personaggio,nemico_ingaggiato),
FOREIGN KEY(id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE,	
FOREIGN KEY(nemico_ingaggiato) REFERENCES nemico(id) ON DELETE CASCADE
);


CREATE TABLE danno_ricevuto(
id_personaggio INT NOT NULL,
danno INT NOT NULL,
PRIMARY KEY(id_personaggio),
FOREIGN KEY(id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE
);


CREATE TABLE si_trova_in(
id_personaggio INT NOT NULL,
stanza INT NOT NULL,
PRIMARY KEY(id_personaggio),
FOREIGN KEY(id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE,
FOREIGN KEY(stanza) REFERENCES stanza(id) ON DELETE CASCADE
);


CREATE TABLE effettua_ricerca_in(
id_personaggio INT NOT NULL,
stanza INT NOT NULL,
PRIMARY KEY(id_personaggio),
FOREIGN KEY(id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE,
FOREIGN KEY(stanza) REFERENCES stanza(id) ON DELETE CASCADE
);


CREATE TABLE ogg_da_equip(
id_personaggio INT NOT NULL,
oggetto VARCHAR(20) NOT NULL,
PRIMARY KEY(id_personaggio),
FOREIGN KEY(id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE,
FOREIGN KEY(oggetto) REFERENCES oggetto(nome) ON DELETE CASCADE
);


CREATE TABLE valoribase(
id_personaggio INT NOT NULL,
PER INT NOT NULL,
ATT INT NOT NULL,
DIF INT NOT NULL,
PRIMARY KEY(id_personaggio),
FOREIGN KEY(id_personaggio) REFERENCES personaggio(id) ON DELETE CASCADE
);


CREATE TABLE stanzeVisitate(
id_personaggio INT NOT NULL,
id_stanza INT NOT NULL,
FOREIGN KEY(id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE
);


CREATE TABLE esp_Totale(
id_personaggio INT NOT NULL,
esp INT,
PRIMARY KEY(id_personaggio),
FOREIGN KEY(id_personaggio) REFERENCES personaggio(id) ON DELETE CASCADE
);


CREATE VIEW oggetti_equip AS SELECT
id_personaggio,nome,PER,ATT,DIF,numero
FROM possiede,oggetto
WHERE nome = nome_oggetto AND indossato_si_no = TRUE;

CREATE VIEW oggetti_equip_cons AS SELECT
id_personaggio,nome,PF,PER,ATT,DIF,numero
FROM possiede,oggetto
WHERE nome = nome_oggetto AND indossato_si_no = TRUE AND tipo = 'consumabile';




////////////////////////////////////// FUNZIONI E TRIGGER //////////////////////////////////////////////////////////////




CREATE TRIGGER elimina_ogg AFTER UPDATE ON si_trova_in FOR EACH ROW EXECUTE PROCEDURE elimina_cons();

CREATE OR REPLACE FUNCTION elimina_cons() RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
ogg possiede.nome_oggetto%TYPE;
num INTEGER;
perOgg INTEGER;
attOgg INTEGER;
difOgg INTEGER;
perTot INTEGER;
attTot INTEGER;
difTOt INTEGER;
perPers INTEGER;
attPers INTEGER;
difPers INTEGER;
BEGIN
	INSERT INTO stanzeVisitate(id_personaggio,id_stanza) VALUES(NEW.id_personaggio,NEW.stanza);
	perTot = 0;
	attTot = 0;
	difTot = 0;	
	FOR ogg IN SELECT nome FROM oggetti_equip_cons WHERE id_personaggio = NEW.id_personaggio LOOP
		SELECT numero INTO num FROM oggetti_equip_cons WHERE nome = ogg;
		SELECT per,att,dif INTO perOgg,attOgg,difOgg FROM oggetti_equip_cons WHERE nome = ogg;
		perTot = perTot + perOgg * num;
		attTot = attTot + attOgg * num;
		difTot = difTot + difOgg * num;
		DELETE FROM possiede WHERE nome_oggetto = ogg AND id_personaggio = NEW.id_personaggio AND indossato_si_no = TRUE;
	END LOOP;
	SELECT per,att,dif INTO perPers,attPers,difPers FROM personaggio WHERE id = NEW.id_personaggio;
	perPers = perPers - perTot;
	attPers = attPers - attTot;
	difPers = difPers - difTot;
	UPDATE personaggio SET per = perPers,att = attPers,dif = difPers WHERE id = NEW.id_personaggio; 	
RETURN NULL;
END;
$$;	


CREATE TRIGGER personaggio_default AFTER INSERT ON utente FOR EACH ROW EXECUTE PROCEDURE pers_def();

CREATE OR REPLACE FUNCTION pers_def() RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO personaggio(id,nome,descrizione,PE,FORZ,INT,AGI,COS,PF,PER,ATT,DIF) VALUES(NEW.id,NEW.nome,'Personaggio base',0,0,0,0,0,0,0,0,0);
	INSERT INTO valoribase(id_personaggio,PER,ATT,DIF) VALUES(NEW.id,0,0,0);
	INSERT INTO esp_Totale(id_personaggio,esp) VALUES(NEW.id,0);
	INSERT INTO possiede(id_personaggio,nome_oggetto,indossato_si_no,numero) VALUES (new.id,'nessun arma',TRUE,1);
	INSERT INTO possiede(id_personaggio,nome_oggetto,indossato_si_no,numero) VALUES (new.id,'nessun armatura',TRUE,1);
	INSERT INTO possiede(id_personaggio,nome_oggetto,indossato_si_no,numero) VALUES (new.id,'spada',FALSE,1);
	INSERT INTO possiede(id_personaggio,nome_oggetto,indossato_si_no,numero) VALUES (new.id,'razione di cibo',FALSE,1);
RETURN NULL;
END;
$$;	


CREATE TRIGGER equipaggia_oggetto AFTER UPDATE ON ogg_da_equip FOR EACH ROW EXECUTE PROCEDURE equipaggia();

CREATE OR REPLACE FUNCTION equipaggia() RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
	type oggetto.tipo%TYPE;
	typeOgg oggetto.tipo%TYPE;
	nomeOgg possiede.nome_oggetto%TYPE;
	numOgg INTEGER;
BEGIN  
	SELECT tipo INTO type FROM oggetto INNER JOIN ogg_da_equip ON oggetto.nome = ogg_da_equip.oggetto WHERE id_personaggio = NEW.id_personaggio AND ogg_da_equip.oggetto = NEW.oggetto;
	IF EXISTS(SELECT nome_oggetto FROM possiede WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = NEW.oggetto AND indossato_si_no = FALSE) THEN
		IF type = 'attacco' THEN
			FOR nomeOgg IN SELECT nome_oggetto FROM possiede WHERE indossato_si_no = TRUE AND id_personaggio = NEW.id_personaggio LOOP
				SELECT tipo INTO typeOgg FROM possiede INNER JOIN oggetto ON nome_oggetto = nome WHERE nome_oggetto = nomeOgg;
				IF typeOgg = 'attacco' THEN
					UPDATE possiede SET indossato_si_no = FALSE WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = nomeOgg AND indossato_si_no = TRUE;
					UPDATE possiede SET indossato_si_no = TRUE WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = NEW.oggetto AND indossato_si_no = FALSE;
				END IF;
			END LOOP;
		ELSIF type = 'difesa' THEN
			FOR nomeOgg IN SELECT nome_oggetto FROM possiede WHERE indossato_si_no = TRUE AND id_personaggio = NEW.id_personaggio LOOP
				SELECT tipo INTO typeOgg FROM possiede INNER JOIN oggetto ON nome_oggetto = nome WHERE nome_oggetto = nomeOgg;			
				IF typeOgg = 'difesa' THEN
					UPDATE possiede SET indossato_si_no = FALSE WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = nomeOgg AND indossato_si_no = TRUE;
					UPDATE possiede SET indossato_si_no = TRUE WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = NEW.oggetto AND indossato_si_no = FALSE;
				END IF;
			END LOOP;
		ELSE
			IF EXISTS(SELECT nome_oggetto FROM possiede WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = NEW.oggetto AND indossato_si_no = TRUE) THEN
				SELECT numero INTO numOgg FROM possiede WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = NEW.oggetto AND indossato_si_no = TRUE;
				numOgg = numOgg + 1;
				UPDATE possiede SET numero = numOgg WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = NEW.oggetto AND indossato_si_no = TRUE;
				SELECT numero INTO numOgg FROM possiede WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = NEW.oggetto AND indossato_si_no = FALSE;
				IF numOgg > 1 THEN
					numOgg = numOgg - 1;
					UPDATE possiede SET numero = numOgg WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = NEW.oggetto AND indossato_si_no = FALSE;
				ELSE
					DELETE FROM possiede WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = NEW.oggetto AND indossato_si_no = FALSE;
				END IF;
			ELSE
				SELECT numero INTO numOgg FROM possiede WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = NEW.oggetto AND indossato_si_no = FALSE;
				IF numOgg > 1 THEN
					numOgg = numOgg - 1;
					UPDATE possiede SET numero = numOgg WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = NEW.oggetto AND indossato_si_no = FALSE;
					INSERT INTO possiede(id_personaggio,nome_oggetto,indossato_si_no,numero) VALUES (NEW.id_personaggio,NEW.oggetto,TRUE,1);
				ELSE
					UPDATE possiede SET indossato_si_no = TRUE WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = NEW.oggetto AND indossato_si_no = FALSE;
				END IF;
			END IF;
		END IF;
	END IF;
	RETURN NULL;
END;
$$;


CREATE TRIGGER infliggi_danno AFTER UPDATE ON danno_ricevuto FOR EACH ROW EXECUTE PROCEDURE infliggi();

CREATE OR REPLACE FUNCTION infliggi() RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
dan INTEGER;
iden INTEGER;
BEGIN
	SELECT danno, id_personaggio INTO dan, iden FROM danno_ricevuto WHERE id_personaggio = NEW.id_personaggio;
	UPDATE personaggio SET pf = pf - dan WHERE personaggio.id = iden; 
	RETURN NULL;
END;
$$;


CREATE TRIGGER aggiorna_valori AFTER INSERT OR UPDATE ON possiede FOR EACH ROW EXECUTE PROCEDURE aggiorna();

CREATE OR REPLACE FUNCTION aggiorna() RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
ogg possiede.nome_oggetto%TYPE;
num INTEGER;
pfOgg INTEGER;
perOgg INTEGER;
attOgg INTEGER;
difOgg INTEGER;
pfTot INTEGER;
perTot INTEGER;
attTot INTEGER;
difTOt INTEGER;
pfPers INTEGER;
perPers INTEGER;
attPers INTEGER;
difPers INTEGER;
BEGIN
	perTot = 0;
	attTot = 0;
	difTot = 0;
	FOR ogg IN SELECT nome FROM oggetti_equip WHERE id_personaggio = NEW.id_personaggio LOOP
		SELECT numero INTO num FROM oggetti_equip WHERE nome = ogg;
		SELECT per,att,dif INTO perOgg,attOgg,difOgg FROM oggetti_equip WHERE nome = ogg;
		perTot = perTot + perOgg * num;
		attTot = attTot + attOgg * num;
		difTot = difTot + difOgg * num;
	END LOOP;
	SELECT per,att,dif INTO perPers,attPers,difPers FROM valoribase WHERE id_personaggio = NEW.id_personaggio;
	perPers = perPers + perTot;
	attPers = attPers + attTot;
	difPers = difPers + difTot;
	UPDATE personaggio SET per = perPers,att = attPers,dif = difPers WHERE id = NEW.id_personaggio; 

	RETURN NULL;
END;
$$;


CREATE TRIGGER ingaggia AFTER UPDATE ON ingaggio FOR EACH ROW EXECUTE PROCEDURE combatti();

CREATE OR REPLACE FUNCTION combatti() RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
nemico INTEGER;
attacco INTEGER;
vita INTEGER;
pePers INTEGER;
esp INTEGER;
BEGIN
	SELECT nemico_ingaggiato INTO nemico FROM ingaggio WHERE id_personaggio = NEW.id_personaggio;

	SELECT pf INTO attacco FROM possiede INNER JOIN oggetto ON nome_oggetto = nome WHERE indossato_si_no = TRUE AND id_personaggio = NEW.id_personaggio AND oggetto.tipo = 'attacco';
	
	UPDATE protegge SET pf = pf - attacco WHERE id_nemico = nemico AND id_personaggio = NEW.id_personaggio;

	SELECT pf INTO vita FROM protegge WHERE id_nemico = nemico AND id_personaggio = NEW.id_personaggio;
	IF(vita <= 0) THEN
		SELECT pe INTO pePers FROM personaggio WHERE id = NEW.id_personaggio;
		SELECT danno INTO esp FROM nemico WHERE id = NEW.nemico_ingaggiato;
		pePers = pePers + esp;
		UPDATE personaggio SET pe = pePers WHERE id = NEW.id_personaggio;
		DELETE FROM protegge WHERE id_personaggio = NEW.id_personaggio AND id_nemico = nemico;
	END IF;
	RETURN NULL;
END;
$$;

UPDATE ingaggio SET nemico_ingaggiato = 3 WHERE id_personaggio = 88;

CREATE OR REPLACE FUNCTION get_random_number(INTEGER, INTEGER) RETURNS INTEGER AS $$
DECLARE
    start_int ALIAS FOR $1;
    end_int ALIAS FOR $2;
BEGIN
    RETURN trunc(random() * (end_int-start_int) + start_int);
END;
$$ LANGUAGE 'plpgsql' STRICT;


CREATE TRIGGER att_mondo AFTER INSERT ON attiva_mondo FOR EACH ROW EXECUTE PROCEDURE crea_Mondo();

CREATE OR REPLACE FUNCTION crea_Mondo() RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE

primoCasuale INTEGER;

pf INTEGER;
rand INTEGER;
countDue INTEGER;
countTre INTEGER;
countQuattro INTEGER;
countCinque INTEGER;
taran INTEGER;
junior INTEGER;
numeroJolly INTEGER;
fattoDue INTEGER;
fattoTre INTEGER;
fattoQuattro INTEGER;
fattoCinque INTEGER;

passaggio INTEGER;
secondastanza INTEGER;
numeropassaggi INTEGER;
numerocammino INTEGER;
numeroprimastanza INTEGER;
y INTEGER;
visibile INTEGER;

x INTEGER;
oggettoattacco oggetto.nome%TYPE;
oggettodifesa oggetto.nome%TYPE;
oggettoconsumabile oggetto.nome%TYPE;
numeroconsumabili INTEGER;
tipoconsumabile INTEGER;
consumabileperstanza INTEGER;
stanza INTEGER;

BEGIN
	primoCasuale = get_random_number(1,15);

	countDue = get_random_number(1,12);
	countTre = get_random_number(13,17);
	countQuattro = get_random_number(18,24);
	countCinque = get_random_number(25,26);
	taran = 0;
	junior = 0;
	numeroJolly = get_random_number(1,4);
	fattoDue = 0;
	fattoTre = 0;
	fattoQuattro = 0;
	fattoCinque = 0;

	secondastanza = 0;
	numerocammino = 2;

	UPDATE personaggio SET pe = 0 WHERE id = NEW.id_personaggio;

	WHILE 15 >= primoCasuale LOOP
		
		INSERT INTO gioca_in(id_personaggio,id_stanza) VALUES(NEW.id_personaggio,primoCasuale);

		rand = ((get_random_number(2,6))%5) + 2;
		
		IF ( (rand = 2) OR ( (fattoTre = 3) OR (fattoQuattro = 7) OR (fattoCinque = 2) OR (taran = 1) ) ) AND ( fattoDue < 3 ) THEN
			countDue = ((countDue)%12) + 1;

			SELECT nemico.pf INTO pf FROM nemico WHERE id = countDue;
			INSERT INTO protegge(id_personaggio,id_stanza,id_nemico,pf) VALUES(NEW.id_personaggio,primoCasuale,countDue,pf);
			countDue = ((countDue)%12)+ 1;
			SELECT nemico.pf INTO pf FROM nemico WHERE id = countDue;
			INSERT INTO protegge(id_personaggio,id_stanza,id_nemico,pf) VALUES(NEW.id_personaggio,primoCasuale,countDue,pf);
			countDue = ((countDue)%12) + 1;
			SELECT nemico.pf INTO pf FROM nemico WHERE id = countDue;
			INSERT INTO protegge(id_personaggio,id_stanza,id_nemico,pf) VALUES(NEW.id_personaggio,primoCasuale,countDue,pf);
			fattoDue = fattoDue + 1;
		
		ELSIF ( (rand = 3) OR (  (fattoDue = 3) OR (fattoQuattro = 7) OR (fattoCinque = 2) OR (taran = 1) ) ) AND ( fattoTre < 3 ) THEN
			countTre = ((countTre)%5) + 13;
			countDue = ((countDue)%12) + 1;
			SELECT nemico.pf INTO pf FROM nemico WHERE id = countDue;
			INSERT INTO protegge(id_personaggio,id_stanza,id_nemico,pf) VALUES(NEW.id_personaggio,primoCasuale,countDue,pf);	
			SELECT nemico.pf INTO pf FROM nemico WHERE id = countTre;		
			INSERT INTO protegge(id_personaggio,id_stanza,id_nemico,pf) VALUES(NEW.id_personaggio,primoCasuale,countTre,pf);
			fattoTre = fattoTre + 1;

		ELSIF ( (rand = 4) OR ( (fattoDue = 3) OR (fattotre = 3) OR (fattoCinque = 2) OR (junior = 1) ) ) AND ( fattoQuattro < 7 ) THEN
			countQuattro = ((countQuattro)%7) +18;
			SELECT nemico.pf INTO pf FROM nemico WHERE id = countQuattro;
			INSERT INTO protegge(id_personaggio,id_stanza,id_nemico,pf) VALUES(NEW.id_personaggio,primoCasuale,countQuattro,pf);
			fattoQuattro = fattoQuattro + 1;

		ELSIF ( (rand = 5) OR ( (fattoDue = 3) OR (fattotre = 3) OR (fattoQuattro = 7) OR (junior = 1) ) )AND ( fattoCinque < 2 ) THEN
			countCinque = ((countCinque)%2) + 25;
			countTre = ((countTre)%5) + 13;
			SELECT nemico.pf INTO pf FROM nemico WHERE id = countTre;
			INSERT INTO protegge(id_personaggio,id_stanza,id_nemico,pf) VALUES(NEW.id_personaggio,primoCasuale,countTre,pf);
			SELECT nemico.pf INTO pf FROM nemico WHERE id = countCinque;
			INSERT INTO protegge(id_personaggio,id_stanza,id_nemico,pf) VALUES(NEW.id_personaggio,primoCasuale,countCinque,pf);
			fattoCinque = fattoCinque + 1;

		ELSE
			IF (rand = 6) AND (taran = 0) AND (junior = 0) THEN
				IF numeroJolly = 1 THEN
					INSERT INTO protegge(id_personaggio,id_stanza,id_nemico,pf) VALUES(NEW.id_personaggio,primoCasuale,27,7);
					taran = 1;
				ELSE
					INSERT INTO protegge(id_personaggio,id_stanza,id_nemico,pf) VALUES(NEW.id_personaggio,primoCasuale,28,1);
					junior = 1;
				END IF;
			END IF;
		END IF;


		numeropassaggi = get_random_number(1,3);
		y = 0;

		IF secondastanza = 0 THEN
			INSERT INTO raggiunge(id_cammino,id_personaggio,inizio_passaggio,fine_passaggio,visibile) VALUES(1,NEW.id_personaggio,16,primoCasuale,TRUE);
			numeroprimastanza= primoCasuale;
		ELSE
			WHILE y < numeropassaggi LOOP
				visibile = get_random_number(1,4);
				IF visibile = 3 THEN
					INSERT INTO raggiunge(id_cammino,id_personaggio,inizio_passaggio,fine_passaggio,visibile) VALUES(numerocammino,NEW.id_personaggio,primoCasuale-1,primoCasuale,FALSE);
				ELSE
					INSERT INTO raggiunge(id_cammino,id_personaggio,inizio_passaggio,fine_passaggio,visibile) VALUES(numerocammino,NEW.id_personaggio,primoCasuale-1,primoCasuale,TRUE);
				END IF;
				passaggio = get_random_number(numeroprimastanza,17);
				numerocammino = numerocammino + 1;
				visibile = get_random_number(1,4);
				IF visibile = 3 THEN
					INSERT INTO raggiunge(id_cammino,id_personaggio,inizio_passaggio,fine_passaggio,visibile) VALUES(numerocammino,NEW.id_personaggio,primoCasuale,passaggio,FALSE);
				ELSE
					INSERT INTO raggiunge(id_cammino,id_personaggio,inizio_passaggio,fine_passaggio,visibile) VALUES(numerocammino,NEW.id_personaggio,primoCasuale,passaggio,TRUE);
				END IF;
				y = y + 1;
				numerocammino = numerocammino + 1;
			END LOOP;
		END IF;
		secondastanza = 1;

		primoCasuale = primoCasuale + 1;
	END LOOP;

	INSERT INTO gioca_in(id_personaggio,id_stanza) VALUES(NEW.id_personaggio,16);
	INSERT INTO gioca_in(id_personaggio,id_stanza) VALUES(NEW.id_personaggio,17);

	visibile = get_random_number(1,4);
	IF visibile = 3 THEN
		passaggio = get_random_number(numeroprimastanza,17);
		INSERT INTO raggiunge(id_cammino,id_personaggio,inizio_passaggio,fine_passaggio,visibile) VALUES(numerocammino,NEW.id_personaggio,passaggio,17,FALSE);
		passaggio = get_random_number(numeroprimastanza,17);
		numerocammino = numerocammino + 1;
		INSERT INTO raggiunge(id_cammino,id_personaggio,inizio_passaggio,fine_passaggio,visibile) VALUES(numerocammino,NEW.id_personaggio,passaggio,17,FALSE);
		passaggio = get_random_number(numeroprimastanza,17);
		numerocammino = numerocammino + 1;
		INSERT INTO raggiunge(id_cammino,id_personaggio,inizio_passaggio,fine_passaggio,visibile) VALUES(numerocammino,NEW.id_personaggio,passaggio,17,FALSE);
	ELSE
		passaggio = get_random_number(numeroprimastanza,17);
		INSERT INTO raggiunge(id_cammino,id_personaggio,inizio_passaggio,fine_passaggio,visibile) VALUES(numerocammino,NEW.id_personaggio,passaggio,17,TRUE);
		passaggio = get_random_number(numeroprimastanza,17);
		numerocammino = numerocammino + 1;
		INSERT INTO raggiunge(id_cammino,id_personaggio,inizio_passaggio,fine_passaggio,visibile) VALUES(numerocammino,NEW.id_personaggio,passaggio,17,TRUE);
		passaggio = get_random_number(numeroprimastanza,17);
		numerocammino = numerocammino + 1;
		INSERT INTO raggiunge(id_cammino,id_personaggio,inizio_passaggio,fine_passaggio,visibile) VALUES(numerocammino,NEW.id_personaggio,passaggio,17,TRUE);
	END IF;

	x = 1;
	WHILE x <= 5 LOOP
		IF x = 1 THEN
			oggettoattacco = 'spada a due mani';
			oggettodifesa = 'scudo';
		ELSIF x = 2 THEN
			oggettoattacco = 'lancia';
			oggettodifesa = 'armatura leggera';
		ELSIF x = 3 THEN
			oggettoattacco = 'ascia';
			oggettodifesa = 'armatura pesante';
		ELSIF x = 4 THEN
			oggettoattacco = 'balestra';
			oggettodifesa = 'elmo';
		ELSE
			oggettoattacco = 'arco';	
			oggettodifesa = 'barriera magica';
		END IF;
		stanza = get_random_number(numeroprimastanza,15);
		visibile  = get_random_number(1,3);
		IF visibile = 2 THEN
			INSERT INTO contiene(id_personaggio,id_stanza,nome_oggetto,visibile,numero) VALUES(NEW.id_personaggio,stanza,oggettoattacco,FALSE,1);
		ELSE
			INSERT INTO contiene(id_personaggio,id_stanza,nome_oggetto,visibile,numero) VALUES(NEW.id_personaggio,stanza,oggettoattacco,TRUE,1);
		END IF;
		stanza = get_random_number(numeroprimastanza,15);
		visibile  = get_random_number(1,3);
		IF visibile = 2 THEN
			INSERT INTO contiene(id_personaggio,id_stanza,nome_oggetto,visibile,numero) VALUES(NEW.id_personaggio,stanza,oggettodifesa,FALSE,1);
		ELSE
			INSERT INTO contiene(id_personaggio,id_stanza,nome_oggetto,visibile,numero) VALUES(NEW.id_personaggio,stanza,oggettodifesa,TRUE,1);
		END IF;
		x = x +1;
	END LOOP;

	x = 0;

	IF(numeroprimastanza >= 7) THEN
		numeroconsumabili = get_random_number(5,15);
	ELSE
		numeroconsumabili = get_random_number(3,8);
	END IF;

	WHILE x < numeroconsumabili LOOP

		stanza = get_random_number(numeroprimastanza,15);
		tipoconsumabile = get_random_number(1,6);
	
		IF tipoconsumabile = 1 THEN
			oggettoconsumabile = 'fagiolo magico';
		END IF;
		IF tipoconsumabile = 2 THEN
			oggettoconsumabile = 'birra';
		END IF;
		IF tipoconsumabile = 3 THEN
			oggettoconsumabile = 'cannabis';
		END IF;
		IF tipoconsumabile = 4 THEN
			oggettoconsumabile = 'bile d orso';
		END IF;
		IF tipoconsumabile = 5 THEN
			oggettoconsumabile ='mon cheri';
		END IF;

		visibile  = get_random_number(1,3);

		IF visibile = 2 THEN

			IF EXISTS (SELECT * FROM contiene WHERE id_personaggio = NEW.id_personaggio AND id_stanza = stanza AND nome_oggetto = oggettoconsumabile AND contiene.visibile = 'FALSE') THEN
				UPDATE contiene SET numero = numero + 1 WHERE id_personaggio = NEW.id_personaggio AND id_stanza = stanza AND nome_oggetto = oggettoconsumabile AND contiene.visibile = 'FALSE';
			ELSE
				INSERT INTO contiene(id_personaggio,id_stanza,nome_oggetto,visibile,numero) VALUES(NEW.id_personaggio,stanza,oggettoconsumabile,'FALSE',1);
			END IF;
		ELSE
			IF EXISTS (SELECT * FROM contiene WHERE id_personaggio = NEW.id_personaggio AND id_stanza = stanza AND nome_oggetto = oggettoconsumabile AND contiene.visibile = 'TRUE') THEN
				UPDATE contiene SET numero = numero + 1 WHERE id_personaggio = NEW.id_personaggio AND id_stanza = stanza AND nome_oggetto = oggettoconsumabile AND contiene.visibile = 'TRUE';
			ELSE
				INSERT INTO contiene(id_personaggio,id_stanza,nome_oggetto,visibile,numero) VALUES(NEW.id_personaggio,stanza,oggettoconsumabile,'TRUE',1);
			END IF;
		END IF;
		x = x + 1;
	END LOOP;

	INSERT INTO ingaggio(id_personaggio,nemico_ingaggiato) VALUES(NEW.id_personaggio,27);
	INSERT INTO danno_ricevuto(id_personaggio,danno) VALUES(NEW.id_personaggio,0);
	INSERT INTO si_trova_in(id_personaggio,stanza) VALUES(NEW.id_personaggio,16);
	INSERT INTO effettua_ricerca_in(id_personaggio,stanza) VALUES(NEW.id_personaggio,16);
	INSERT INTO ogg_da_equip(id_personaggio,oggetto) VALUES(NEW.id_personaggio,'nessun arma');
	RETURN NULL;
END;
$$;


CREATE TRIGGER raccogli_oggetti AFTER UPDATE ON si_trova_in FOR EACH ROW EXECUTE PROCEDURE raccogli();

CREATE OR REPLACE FUNCTION raccogli() RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
costituzione INTEGER;
numOgg INTEGER;
ogg oggetto.nome%TYPE;
num INTEGER;
numOggPoss INTEGER;
BEGIN
	SELECT cos INTO costituzione FROM personaggio WHERE id = NEW.id_personaggio;
	costituzione = ROUND(costituzione/2,1) + 2;
	SELECT SUM(numero) INTO numOgg FROM contiene WHERE id_personaggio = NEW.id_personaggio AND id_stanza = NEW.stanza AND visibile = TRUE;
	SELECT SUM(numero) INTO numOggPoss FROM possiede WHERE id_personaggio = NEW.id_personaggio;

	WHILE (numOgg > 0) AND (costituzione > numOggPoss) LOOP
		SELECT nome_oggetto, numero INTO ogg, num FROM contiene WHERE id_personaggio = NEW.id_personaggio AND id_stanza = NEW.stanza AND visibile = TRUE ORDER BY RANDOM() LIMIT 1;
		IF EXISTS(SELECT nome_oggetto FROM possiede WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = ogg AND indossato_si_no = FALSE) THEN
			UPDATE possiede SET numero = numero + 1 WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = ogg AND indossato_si_no = FALSE;
		ELSE
			INSERT INTO possiede(id_personaggio,nome_oggetto,indossato_si_no,numero) VALUES(NEW.id_personaggio,ogg,FALSE,1);
		END IF;

		IF num > 1 THEN
			UPDATE contiene SET numero = numero - 1 WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = ogg AND id_stanza= NEW.stanza AND visibile = TRUE;
		ELSE
			DELETE FROM contiene WHERE id_personaggio = NEW.id_personaggio AND id_stanza = NEW.stanza AND nome_oggetto = ogg AND visibile = TRUE;
		END IF;
		numOgg = numOgg - 1;
		SELECT SUM(numero) INTO numOggPoss FROM possiede WHERE id_personaggio = NEW.id_personaggio;
	END LOOP;
	RETURN NULL;
END;
$$;


CREATE TRIGGER ricerca_oggetti AFTER UPDATE ON effettua_ricerca_in FOR EACH ROW EXECUTE PROCEDURE ricerca();

CREATE OR REPLACE FUNCTION ricerca() RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
costituzione INTEGER;
x INTEGER;
ogg oggetto.nome%TYPE;
num INTEGER;
cammino INTEGER;
numOggPoss INTEGER;
OggInd INTEGER;

BEGIN
	SELECT cos INTO costituzione FROM personaggio WHERE id = NEW.id_personaggio;
	costituzione = ROUND(costituzione/2,1) + 2;
	x = get_random_number(1,3);
	IF x = 1 THEN
		IF EXISTS(SELECT id_cammino FROM raggiunge WHERE id_personaggio = NEW.id_personaggio AND inizio_passaggio = NEW.stanza AND visibile = FALSE AND id_cammino <= ALL( SELECT id_cammino FROM raggiunge WHERE id_personaggio = NeW.id_personaggio AND inizio_passaggio = NEW.stanza AND visibile = FALSE) )THEN
			SELECT id_cammino INTO cammino FROM raggiunge WHERE id_personaggio = NEW.id_personaggio AND inizio_passaggio = NEW.stanza AND visibile = FALSE AND id_cammino <= ALL( SELECT id_cammino FROM raggiunge WHERE id_personaggio = NeW.id_personaggio AND inizio_passaggio = NEW.stanza AND visibile = FALSE);
			UPDATE raggiunge SET visibile = TRUE WHERE id_personaggio = NEW.id_personaggio AND id_cammino = cammino;
		ELSE
			x = 2;
		END IF;
	END IF;
	IF x = 2 THEN
		SELECT SUM(numero) INTO numOggPoss FROM possiede WHERE id_personaggio = NEW.id_personaggio;
		IF (costituzione > numOggPoss) THEN
			IF EXISTS(SELECT nome_oggetto FROM contiene WHERE id_personaggio = NEW.id_personaggio AND id_stanza = NEW.stanza AND visibile = FALSE) THEN
				SELECT nome_oggetto, numero INTO ogg, num FROM contiene WHERE id_personaggio = NEW.id_personaggio AND id_stanza = NEW.stanza AND visibile = FALSE ORDER BY RANDOM() LIMIT 1;
				IF num > 1 THEN
					UPDATE contiene SET numero = numero - 1 WHERE id_personaggio = NEW.id_personaggio AND id_stanza = NEW.stanza AND nome_oggetto = ogg AND visibile = FALSE;
					IF EXISTS(SELECT numero FROM possiede WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = ogg AND indossato_si_no = FALSE) THEN
						SELECT numero INTO OggInd FROM possiede WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = ogg AND indossato_si_no = FALSE;
						UPDATE possiede SET numero = numero + 1 WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = ogg AND indossato_si_no = FALSE;
					ELSE
						INSERT INTO possiede(id_personaggio,nome_oggetto,indossato_si_no,numero) VALUES(NEW.id_personaggio,ogg,FALSE,1);
					END IF;
				ELSIF num = 1 THEN
					DELETE FROM contiene WHERE id_personaggio = NEW.id_personaggio AND id_stanza = NEW.stanza AND nome_oggetto = ogg AND visibile = FALSE;
					IF EXISTS(SELECT numero FROM possiede WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = ogg AND indossato_si_no = FALSE) THEN
						SELECT numero INTO OggInd FROM possiede WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = ogg AND indossato_si_no = FALSE;
						UPDATE possiede SET numero = numero + 1 WHERE id_personaggio = NEW.id_personaggio AND nome_oggetto = ogg AND indossato_si_no = FALSE;
					ELSE
						INSERT INTO possiede(id_personaggio,nome_oggetto,indossato_si_no,numero) VALUES(NEW.id_personaggio,ogg,FALSE,1);
					END IF;
				END IF;
			ELSE
				IF EXISTS(SELECT id_cammino FROM raggiunge WHERE id_personaggio = NEW.id_personaggio AND inizio_passaggio = NEW.stanza AND visibile = FALSE AND id_cammino <= ALL( SELECT id_cammino FROM raggiunge WHERE id_personaggio = NeW.id_personaggio AND inizio_passaggio = NEW.stanza AND visibile = FALSE) )THEN
					SELECT id_cammino INTO cammino FROM raggiunge WHERE id_personaggio = NEW.id_personaggio AND inizio_passaggio = NEW.stanza AND visibile = FALSE AND id_cammino <= ALL( SELECT id_cammino FROM raggiunge WHERE id_personaggio = NeW.id_personaggio AND inizio_passaggio = NEW.stanza AND visibile = FALSE);
					UPDATE raggiunge SET visibile = TRUE WHERE id_personaggio = NEW.id_personaggio AND id_cammino = cammino;
				END IF;
			END IF;
		ELSE
			IF EXISTS(SELECT id_cammino FROM raggiunge WHERE id_personaggio = NEW.id_personaggio AND inizio_passaggio = NEW.stanza AND visibile = FALSE AND id_cammino <= ALL( SELECT id_cammino FROM raggiunge WHERE id_personaggio = NeW.id_personaggio AND inizio_passaggio = NEW.stanza AND visibile = FALSE) )THEN
				SELECT id_cammino INTO cammino FROM raggiunge WHERE id_personaggio = NEW.id_personaggio AND inizio_passaggio = NEW.stanza AND visibile = FALSE AND id_cammino <= ALL( SELECT id_cammino FROM raggiunge WHERE id_personaggio = NeW.id_personaggio AND inizio_passaggio = NEW.stanza AND visibile = FALSE);
				UPDATE raggiunge SET visibile = TRUE WHERE id_personaggio = NEW.id_personaggio AND id_cammino = cammino;
			END IF;
		END IF;
	END IF;
	RETURN NULL;
END;
$$;