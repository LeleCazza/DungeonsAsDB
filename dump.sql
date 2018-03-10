--
-- PostgreSQL database dump
--

-- Dumped from database version 10.0
-- Dumped by pg_dump version 10.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: aggiorna(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION aggiorna() RETURNS trigger
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


ALTER FUNCTION public.aggiorna() OWNER TO postgres;

--
-- Name: aggiorna_pf(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION aggiorna_pf() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
ogg possiede.nome_oggetto%TYPE;
num INTEGER;
pfOgg INTEGER;
pfTot INTEGER;
pfPers INTEGER;
BEGIN
	pfTot = 0;
	FOR ogg IN SELECT nome FROM oggetti_equip_cons WHERE id_personaggio = NEW.id_personaggio LOOP
		SELECT numero INTO num FROM oggetti_equip_cons WHERE nome = ogg;
		SELECT pf INTO pfOgg FROM oggetti_equip_cons WHERE nome = ogg;
		pfTot = pfTot + pfOgg * num;
	END LOOP;
	SELECT pf INTO pfPers FROM personaggio WHERE id = NEW.id_personaggio;
	pfPers = pfPers + pfTot;
	UPDATE personaggio SET pf = pfPers WHERE id = NEW.id_personaggio; 	
	RETURN NULL;
END;
$$;


ALTER FUNCTION public.aggiorna_pf() OWNER TO postgres;

--
-- Name: combatti(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION combatti() RETURNS trigger
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


ALTER FUNCTION public.combatti() OWNER TO postgres;

--
-- Name: crea_mondo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crea_mondo() RETURNS trigger
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


ALTER FUNCTION public.crea_mondo() OWNER TO postgres;

--
-- Name: elimina_cons(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION elimina_cons() RETURNS trigger
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


ALTER FUNCTION public.elimina_cons() OWNER TO postgres;

--
-- Name: equipaggia(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION equipaggia() RETURNS trigger
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


ALTER FUNCTION public.equipaggia() OWNER TO postgres;

--
-- Name: get_random_number(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_random_number(integer, integer) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
    start_int ALIAS FOR $1;
    end_int ALIAS FOR $2;
BEGIN
    RETURN trunc(random() * (end_int-start_int) + start_int);
END;
$_$;


ALTER FUNCTION public.get_random_number(integer, integer) OWNER TO postgres;

--
-- Name: infliggi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION infliggi() RETURNS trigger
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


ALTER FUNCTION public.infliggi() OWNER TO postgres;

--
-- Name: pers_def(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pers_def() RETURNS trigger
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


ALTER FUNCTION public.pers_def() OWNER TO postgres;

--
-- Name: raccogli(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION raccogli() RETURNS trigger
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


ALTER FUNCTION public.raccogli() OWNER TO postgres;

--
-- Name: ricerca(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ricerca() RETURNS trigger
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


ALTER FUNCTION public.ricerca() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: attiva_mondo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE attiva_mondo (
    id_personaggio integer NOT NULL
);


ALTER TABLE attiva_mondo OWNER TO postgres;

--
-- Name: contiene; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE contiene (
    id_personaggio integer NOT NULL,
    id_stanza integer NOT NULL,
    nome_oggetto character varying(20) NOT NULL,
    visibile boolean NOT NULL,
    numero integer NOT NULL
);


ALTER TABLE contiene OWNER TO postgres;

--
-- Name: danno_ricevuto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE danno_ricevuto (
    id_personaggio integer NOT NULL,
    danno integer NOT NULL
);


ALTER TABLE danno_ricevuto OWNER TO postgres;

--
-- Name: effettua_ricerca_in; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE effettua_ricerca_in (
    id_personaggio integer NOT NULL,
    stanza integer NOT NULL
);


ALTER TABLE effettua_ricerca_in OWNER TO postgres;

--
-- Name: esp_totale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE esp_totale (
    id_personaggio integer NOT NULL,
    esp integer
);


ALTER TABLE esp_totale OWNER TO postgres;

--
-- Name: gioca_in; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE gioca_in (
    id_personaggio integer NOT NULL,
    id_stanza integer NOT NULL
);


ALTER TABLE gioca_in OWNER TO postgres;

--
-- Name: ingaggio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ingaggio (
    id_personaggio integer NOT NULL,
    nemico_ingaggiato integer NOT NULL
);


ALTER TABLE ingaggio OWNER TO postgres;

--
-- Name: nemico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nemico (
    id integer NOT NULL,
    nome character varying(25) NOT NULL,
    descrizione character varying(200) NOT NULL,
    pf integer NOT NULL,
    per integer NOT NULL,
    dif integer NOT NULL,
    danno integer NOT NULL
);


ALTER TABLE nemico OWNER TO postgres;

--
-- Name: ogg_da_equip; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ogg_da_equip (
    id_personaggio integer NOT NULL,
    oggetto character varying(20) NOT NULL
);


ALTER TABLE ogg_da_equip OWNER TO postgres;

--
-- Name: oggetto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE oggetto (
    nome character varying(20) NOT NULL,
    pf integer,
    per integer NOT NULL,
    att integer NOT NULL,
    dif integer NOT NULL,
    tipo character varying(15) NOT NULL
);


ALTER TABLE oggetto OWNER TO postgres;

--
-- Name: possiede; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE possiede (
    id_personaggio integer NOT NULL,
    nome_oggetto character varying(20) NOT NULL,
    indossato_si_no boolean NOT NULL,
    numero integer NOT NULL
);


ALTER TABLE possiede OWNER TO postgres;

--
-- Name: oggetti_equip; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW oggetti_equip AS
 SELECT possiede.id_personaggio,
    oggetto.nome,
    oggetto.per,
    oggetto.att,
    oggetto.dif,
    possiede.numero
   FROM possiede,
    oggetto
  WHERE (((oggetto.nome)::text = (possiede.nome_oggetto)::text) AND (possiede.indossato_si_no = true));


ALTER TABLE oggetti_equip OWNER TO postgres;

--
-- Name: oggetti_equip_cons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW oggetti_equip_cons AS
 SELECT possiede.id_personaggio,
    oggetto.nome,
    oggetto.pf,
    oggetto.per,
    oggetto.att,
    oggetto.dif,
    possiede.numero
   FROM possiede,
    oggetto
  WHERE (((oggetto.nome)::text = (possiede.nome_oggetto)::text) AND (possiede.indossato_si_no = true) AND ((oggetto.tipo)::text = 'consumabile'::text));


ALTER TABLE oggetti_equip_cons OWNER TO postgres;

--
-- Name: personaggio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE personaggio (
    id integer NOT NULL,
    nome character varying(15) NOT NULL,
    descrizione character varying(500),
    pe integer NOT NULL,
    forz integer NOT NULL,
    "int" integer NOT NULL,
    agi integer NOT NULL,
    cos integer NOT NULL,
    pf integer NOT NULL,
    per integer NOT NULL,
    att integer NOT NULL,
    dif integer NOT NULL
);


ALTER TABLE personaggio OWNER TO postgres;

--
-- Name: protegge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE protegge (
    id_personaggio integer NOT NULL,
    id_stanza integer NOT NULL,
    id_nemico integer NOT NULL,
    pf integer NOT NULL
);


ALTER TABLE protegge OWNER TO postgres;

--
-- Name: raggiunge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE raggiunge (
    id_cammino integer NOT NULL,
    id_personaggio integer NOT NULL,
    inizio_passaggio integer NOT NULL,
    fine_passaggio integer NOT NULL,
    visibile boolean NOT NULL
);


ALTER TABLE raggiunge OWNER TO postgres;

--
-- Name: si_trova_in; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE si_trova_in (
    id_personaggio integer NOT NULL,
    stanza integer NOT NULL
);


ALTER TABLE si_trova_in OWNER TO postgres;

--
-- Name: stanza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE stanza (
    id integer NOT NULL,
    descrizione character varying(400) NOT NULL
);


ALTER TABLE stanza OWNER TO postgres;

--
-- Name: stanzevisitate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE stanzevisitate (
    id_personaggio integer NOT NULL,
    id_stanza integer NOT NULL
);


ALTER TABLE stanzevisitate OWNER TO postgres;

--
-- Name: tre_dadi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tre_dadi (
    id integer NOT NULL,
    numero_lancio integer NOT NULL,
    valore integer NOT NULL
);


ALTER TABLE tre_dadi OWNER TO postgres;

--
-- Name: utente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE utente (
    id integer NOT NULL,
    email character varying(50) NOT NULL,
    password character(8) NOT NULL,
    nome character varying(20)
);


ALTER TABLE utente OWNER TO postgres;

--
-- Name: utente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE utente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE utente_id_seq OWNER TO postgres;

--
-- Name: utente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE utente_id_seq OWNED BY utente.id;


--
-- Name: valoribase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE valoribase (
    id_personaggio integer NOT NULL,
    per integer NOT NULL,
    att integer NOT NULL,
    dif integer NOT NULL
);


ALTER TABLE valoribase OWNER TO postgres;

--
-- Name: utente id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY utente ALTER COLUMN id SET DEFAULT nextval('utente_id_seq'::regclass);


--
-- Data for Name: attiva_mondo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY attiva_mondo (id_personaggio) FROM stdin;
\.


--
-- Data for Name: contiene; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY contiene (id_personaggio, id_stanza, nome_oggetto, visibile, numero) FROM stdin;
\.


--
-- Data for Name: danno_ricevuto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY danno_ricevuto (id_personaggio, danno) FROM stdin;
\.


--
-- Data for Name: effettua_ricerca_in; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY effettua_ricerca_in (id_personaggio, stanza) FROM stdin;
\.


--
-- Data for Name: esp_totale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY esp_totale (id_personaggio, esp) FROM stdin;
\.


--
-- Data for Name: gioca_in; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY gioca_in (id_personaggio, id_stanza) FROM stdin;
\.


--
-- Data for Name: ingaggio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ingaggio (id_personaggio, nemico_ingaggiato) FROM stdin;
\.


--
-- Data for Name: nemico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY nemico (id, nome, descrizione, pf, per, dif, danno) FROM stdin;
1	Sofien	Il carcerato	4	2	5	5
2	Mariotto	Simone	4	2	5	5
3	Mariotto	Fabiano	4	2	5	5
4	Fabietto	il saggio	4	2	5	5
5	Pange	il giocatore	4	2	5	5
6	Rambo	Il cariola	4	2	5	5
7	Corno	Lo sbronzo	4	2	5	5
8	Abib	Il kebabbaro	4	2	5	5
9	Mohamed	Munir	4	2	5	5
10	Zeta	Il musicista	4	2	5	5
11	Branch	La joia	4	2	5	5
12	Sdru	il mastodontico amico	4	2	5	5
13	Celeste	Il cotolengo	5	3	6	6
14	Lele	El Trezza	5	3	6	6
15	Frank	L ebreo	5	3	6	6
16	Saba	Spaco Botilia	5	3	6	6
17	Pannocchia	colui che vive al di sopra delle proprie possibilit…	5	3	6	3
18	Miguel	El pusher	6	4	7	7
19	Paolo	Paulen	6	4	7	7
20	Barney	Balla coi lupi	6	4	7	7
21	Lollo	El Mocho	6	4	7	7
22	Ciambe	L Ultra	6	4	7	7
23	Ghiro	Ghirone	6	4	7	7
24	Maik	Il terrone	6	4	7	7
25	Der Raumdeuter	Colui che interpreta gli spazi	7	5	8	8
26	MM11	O Cabajo	7	5	8	8
27	Taran	Doc	15	15	15	15
28	Junior	Noob	1	1	1	1
\.


--
-- Data for Name: ogg_da_equip; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ogg_da_equip (id_personaggio, oggetto) FROM stdin;
\.


--
-- Data for Name: oggetto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY oggetto (nome, pf, per, att, dif, tipo) FROM stdin;
nessun arma	0	0	0	0	attacco
spada	4	2	2	-1	attacco
spada a due mani	6	-1	3	-3	attacco
lancia	5	2	3	1	attacco
ascia	7	-2	4	-1	attacco
balestra	3	5	5	-1	attacco
arco	2	8	2	-3	attacco
nessun armatura	0	0	0	0	difesa
scudo	0	-5	1	4	difesa
armatura leggera	0	0	-2	2	difesa
armatura pesante	0	-3	-4	6	difesa
elmo	0	3	0	1	difesa
barriera magica	0	-5	-3	7	difesa
razione di cibo	2	0	0	0	consumabile
fagiolo magico	5	0	0	0	consumabile
birra	-1	3	7	-2	consumabile
cannabis	-2	10	0	-5	consumabile
bile d orso	0	0	0	2	consumabile
mon cheri	1	1	1	1	consumabile
\.


--
-- Data for Name: personaggio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY personaggio (id, nome, descrizione, pe, forz, "int", agi, cos, pf, per, att, dif) FROM stdin;
\.


--
-- Data for Name: possiede; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY possiede (id_personaggio, nome_oggetto, indossato_si_no, numero) FROM stdin;
\.


--
-- Data for Name: protegge; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY protegge (id_personaggio, id_stanza, id_nemico, pf) FROM stdin;
\.


--
-- Data for Name: raggiunge; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY raggiunge (id_cammino, id_personaggio, inizio_passaggio, fine_passaggio, visibile) FROM stdin;
\.


--
-- Data for Name: si_trova_in; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY si_trova_in (id_personaggio, stanza) FROM stdin;
\.


--
-- Data for Name: stanza; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY stanza (id, descrizione) FROM stdin;
1	Montagna
2	Mare
3	Spiaggia
4	Fiume
5	Caverna
6	Bosco
7	Radura
8	Foresta
9	Valle
10	Citta
11	Paese
12	Villaggio
13	Grotta
14	Precipizio
15	Lago
16	Casa
17	Tesoro
\.


--
-- Data for Name: stanzevisitate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY stanzevisitate (id_personaggio, id_stanza) FROM stdin;
\.


--
-- Data for Name: tre_dadi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tre_dadi (id, numero_lancio, valore) FROM stdin;
\.


--
-- Data for Name: utente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY utente (id, email, password, nome) FROM stdin;
\.


--
-- Data for Name: valoribase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY valoribase (id_personaggio, per, att, dif) FROM stdin;
\.


--
-- Name: utente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('utente_id_seq', 101, true);


--
-- Name: attiva_mondo attiva_mondo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attiva_mondo
    ADD CONSTRAINT attiva_mondo_pkey PRIMARY KEY (id_personaggio);


--
-- Name: contiene contiene_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY contiene
    ADD CONSTRAINT contiene_pkey PRIMARY KEY (id_personaggio, id_stanza, nome_oggetto, visibile);


--
-- Name: danno_ricevuto danno_ricevuto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY danno_ricevuto
    ADD CONSTRAINT danno_ricevuto_pkey PRIMARY KEY (id_personaggio);


--
-- Name: effettua_ricerca_in effettua_ricerca_in_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY effettua_ricerca_in
    ADD CONSTRAINT effettua_ricerca_in_pkey PRIMARY KEY (id_personaggio);


--
-- Name: esp_totale esp_totale_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY esp_totale
    ADD CONSTRAINT esp_totale_pkey PRIMARY KEY (id_personaggio);


--
-- Name: gioca_in gioca_in_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gioca_in
    ADD CONSTRAINT gioca_in_pkey PRIMARY KEY (id_personaggio, id_stanza);


--
-- Name: ingaggio ingaggio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ingaggio
    ADD CONSTRAINT ingaggio_pkey PRIMARY KEY (id_personaggio, nemico_ingaggiato);


--
-- Name: nemico nemico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nemico
    ADD CONSTRAINT nemico_pkey PRIMARY KEY (id);


--
-- Name: ogg_da_equip ogg_da_equip_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ogg_da_equip
    ADD CONSTRAINT ogg_da_equip_pkey PRIMARY KEY (id_personaggio);


--
-- Name: oggetto oggetto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY oggetto
    ADD CONSTRAINT oggetto_pkey PRIMARY KEY (nome);


--
-- Name: personaggio personaggio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personaggio
    ADD CONSTRAINT personaggio_pkey PRIMARY KEY (id);


--
-- Name: possiede possiede_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY possiede
    ADD CONSTRAINT possiede_pkey PRIMARY KEY (id_personaggio, nome_oggetto, indossato_si_no);


--
-- Name: protegge protegge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY protegge
    ADD CONSTRAINT protegge_pkey PRIMARY KEY (id_personaggio, id_stanza, id_nemico);


--
-- Name: raggiunge raggiunge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY raggiunge
    ADD CONSTRAINT raggiunge_pkey PRIMARY KEY (id_cammino, id_personaggio);


--
-- Name: si_trova_in si_trova_in_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY si_trova_in
    ADD CONSTRAINT si_trova_in_pkey PRIMARY KEY (id_personaggio);


--
-- Name: stanza stanza_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stanza
    ADD CONSTRAINT stanza_pkey PRIMARY KEY (id);


--
-- Name: tre_dadi tre_dadi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tre_dadi
    ADD CONSTRAINT tre_dadi_pkey PRIMARY KEY (id, numero_lancio);


--
-- Name: utente utente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY utente
    ADD CONSTRAINT utente_pkey PRIMARY KEY (id);


--
-- Name: valoribase valoribase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY valoribase
    ADD CONSTRAINT valoribase_pkey PRIMARY KEY (id_personaggio);


--
-- Name: possiede aggiorna_valori; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER aggiorna_valori AFTER INSERT OR UPDATE ON possiede FOR EACH ROW EXECUTE PROCEDURE aggiorna();


--
-- Name: attiva_mondo att_mondo; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER att_mondo AFTER INSERT ON attiva_mondo FOR EACH ROW EXECUTE PROCEDURE crea_mondo();


--
-- Name: si_trova_in elimina_ogg; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER elimina_ogg AFTER UPDATE ON si_trova_in FOR EACH ROW EXECUTE PROCEDURE elimina_cons();


--
-- Name: ogg_da_equip equipaggia_oggetto; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER equipaggia_oggetto AFTER UPDATE ON ogg_da_equip FOR EACH ROW EXECUTE PROCEDURE equipaggia();


--
-- Name: danno_ricevuto infliggi_danno; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER infliggi_danno AFTER UPDATE ON danno_ricevuto FOR EACH ROW EXECUTE PROCEDURE infliggi();


--
-- Name: ingaggio ingaggia; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ingaggia AFTER UPDATE ON ingaggio FOR EACH ROW EXECUTE PROCEDURE combatti();


--
-- Name: utente personaggio_default; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER personaggio_default AFTER INSERT ON utente FOR EACH ROW EXECUTE PROCEDURE pers_def();


--
-- Name: si_trova_in raccogli_oggetti; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER raccogli_oggetti AFTER UPDATE ON si_trova_in FOR EACH ROW EXECUTE PROCEDURE raccogli();


--
-- Name: effettua_ricerca_in ricerca_oggetti; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ricerca_oggetti AFTER UPDATE ON effettua_ricerca_in FOR EACH ROW EXECUTE PROCEDURE ricerca();


--
-- Name: attiva_mondo attiva_mondo_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attiva_mondo
    ADD CONSTRAINT attiva_mondo_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES personaggio(id) ON DELETE CASCADE;


--
-- Name: contiene contiene_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY contiene
    ADD CONSTRAINT contiene_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE;


--
-- Name: contiene contiene_id_stanza_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY contiene
    ADD CONSTRAINT contiene_id_stanza_fkey FOREIGN KEY (id_stanza) REFERENCES stanza(id) ON DELETE CASCADE;


--
-- Name: contiene contiene_nome_oggetto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY contiene
    ADD CONSTRAINT contiene_nome_oggetto_fkey FOREIGN KEY (nome_oggetto) REFERENCES oggetto(nome) ON DELETE CASCADE;


--
-- Name: danno_ricevuto danno_ricevuto_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY danno_ricevuto
    ADD CONSTRAINT danno_ricevuto_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE;


--
-- Name: effettua_ricerca_in effettua_ricerca_in_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY effettua_ricerca_in
    ADD CONSTRAINT effettua_ricerca_in_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE;


--
-- Name: effettua_ricerca_in effettua_ricerca_in_stanza_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY effettua_ricerca_in
    ADD CONSTRAINT effettua_ricerca_in_stanza_fkey FOREIGN KEY (stanza) REFERENCES stanza(id) ON DELETE CASCADE;


--
-- Name: esp_totale esp_totale_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY esp_totale
    ADD CONSTRAINT esp_totale_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES personaggio(id) ON DELETE CASCADE;


--
-- Name: gioca_in gioca_in_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gioca_in
    ADD CONSTRAINT gioca_in_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE;


--
-- Name: gioca_in gioca_in_id_stanza_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gioca_in
    ADD CONSTRAINT gioca_in_id_stanza_fkey FOREIGN KEY (id_stanza) REFERENCES stanza(id) ON DELETE CASCADE;


--
-- Name: ingaggio ingaggio_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ingaggio
    ADD CONSTRAINT ingaggio_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE;


--
-- Name: ingaggio ingaggio_nemico_ingaggiato_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ingaggio
    ADD CONSTRAINT ingaggio_nemico_ingaggiato_fkey FOREIGN KEY (nemico_ingaggiato) REFERENCES nemico(id) ON DELETE CASCADE;


--
-- Name: ogg_da_equip ogg_da_equip_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ogg_da_equip
    ADD CONSTRAINT ogg_da_equip_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE;


--
-- Name: ogg_da_equip ogg_da_equip_oggetto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ogg_da_equip
    ADD CONSTRAINT ogg_da_equip_oggetto_fkey FOREIGN KEY (oggetto) REFERENCES oggetto(nome) ON DELETE CASCADE;


--
-- Name: personaggio personaggio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personaggio
    ADD CONSTRAINT personaggio_id_fkey FOREIGN KEY (id) REFERENCES utente(id) ON DELETE CASCADE;


--
-- Name: possiede possiede_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY possiede
    ADD CONSTRAINT possiede_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES personaggio(id) ON DELETE CASCADE;


--
-- Name: possiede possiede_nome_oggetto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY possiede
    ADD CONSTRAINT possiede_nome_oggetto_fkey FOREIGN KEY (nome_oggetto) REFERENCES oggetto(nome) ON DELETE CASCADE;


--
-- Name: protegge protegge_id_nemico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY protegge
    ADD CONSTRAINT protegge_id_nemico_fkey FOREIGN KEY (id_nemico) REFERENCES nemico(id) ON DELETE CASCADE;


--
-- Name: protegge protegge_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY protegge
    ADD CONSTRAINT protegge_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE;


--
-- Name: protegge protegge_id_stanza_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY protegge
    ADD CONSTRAINT protegge_id_stanza_fkey FOREIGN KEY (id_stanza) REFERENCES stanza(id) ON DELETE CASCADE;


--
-- Name: raggiunge raggiunge_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY raggiunge
    ADD CONSTRAINT raggiunge_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE;


--
-- Name: raggiunge raggiunge_inizio_passaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY raggiunge
    ADD CONSTRAINT raggiunge_inizio_passaggio_fkey FOREIGN KEY (inizio_passaggio) REFERENCES stanza(id) ON DELETE CASCADE;


--
-- Name: si_trova_in si_trova_in_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY si_trova_in
    ADD CONSTRAINT si_trova_in_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE;


--
-- Name: si_trova_in si_trova_in_stanza_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY si_trova_in
    ADD CONSTRAINT si_trova_in_stanza_fkey FOREIGN KEY (stanza) REFERENCES stanza(id) ON DELETE CASCADE;


--
-- Name: stanzevisitate stanzevisitate_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stanzevisitate
    ADD CONSTRAINT stanzevisitate_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES attiva_mondo(id_personaggio) ON DELETE CASCADE;


--
-- Name: tre_dadi tre_dadi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tre_dadi
    ADD CONSTRAINT tre_dadi_id_fkey FOREIGN KEY (id) REFERENCES utente(id) ON DELETE CASCADE;


--
-- Name: valoribase valoribase_id_personaggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY valoribase
    ADD CONSTRAINT valoribase_id_personaggio_fkey FOREIGN KEY (id_personaggio) REFERENCES personaggio(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

