<?php
session_start();
$connessione = pg_connect('dbname=postgres user=postgres');
error_reporting(E_ERROR);

	$sql = "SELECT id_personaggio FROM attiva_mondo WHERE id_personaggio = $1;";
	$resource = pg_prepare($connessione, "cmd1", $sql);
	$value  = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd1", $value);
	$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	$valore = $valore['id_personaggio'];

	if($valore == $_SESSION["id"] ){
		$sql = "DELETE FROM attiva_mondo WHERE id_personaggio = $1";
		$resource = pg_prepare($connessione, "cmd2", $sql);
		$value  = array($_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd2", $value);

		$sql = "DELETE FROM possiede WHERE id_personaggio = $1";
		$resource = pg_prepare($connessione, "cmd3", $sql);
		$value  = array($_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd3", $value);

		$sql = "INSERT INTO possiede(id_personaggio,nome_oggetto,indossato_si_no,numero) VALUES ($1,$2,$3,$4)";
		$resource = pg_prepare($connessione, "cmd4", $sql);
		$value  = array($_SESSION["id"],'nessun arma',"TRUE",1);
		$resource = pg_execute($connessione, "cmd4", $value);

		$sql = "INSERT INTO possiede(id_personaggio,nome_oggetto,indossato_si_no,numero) VALUES ($1,$2,$3,$4)";
		$resource = pg_prepare($connessione, "cmd5", $sql);
		$value  = array($_SESSION["id"],'razione di cibo',"FALSE",1);
		$resource = pg_execute($connessione, "cmd5", $value);

		$sql = "INSERT INTO possiede(id_personaggio,nome_oggetto,indossato_si_no,numero) VALUES ($1,$2,$3,$4)";
		$resource = pg_prepare($connessione, "cmd6", $sql);
		$value  = array($_SESSION["id"],'nessun armatura',"TRUE",1);
		$resource = pg_execute($connessione, "cmd6", $value);

		$sql = "INSERT INTO possiede(id_personaggio,nome_oggetto,indossato_si_no,numero) VALUES ($1,$2,$3,$4)";
		$resource = pg_prepare($connessione, "cmd7", $sql);
		$value  = array($_SESSION["id"],'spada',"FALSE",1);
		$resource = pg_execute($connessione, "cmd7", $value);

		$sql = "SELECT cos FROM personaggio WHERE id = $1;";
		$resource = pg_prepare($connessione, "cmd8", $sql);
		$value  = array($_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd8", $value);
		$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
		$cos = $valore['cos'];

		$sql = "UPDATE personaggio SET pf=$1 WHERE id=$2";
        $resource = pg_prepare($connessione, "cmd9",  $sql);
        $value  = array($cos,$_SESSION["id"]);
        $resource = pg_execute($connessione, "cmd9",  $value);
	}
	
	$sql = "INSERT INTO attiva_mondo(id_personaggio) VALUES ($1);";
	$resource = pg_prepare($connessione, "cmd", $sql);
	$value  = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd", $value);
	header('Location: http://localhost/gioco.php');
?>