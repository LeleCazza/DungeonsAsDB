<?php
	session_start();
	$connessione = pg_connect('dbname=postgres user=postgres'); 
	$_SESSION["email"]=$_POST["email"];
	$_SESSION["password"]=$_POST["password"];

	$sql = "SELECT id FROM utente WHERE(email=$1)";
	$resource = pg_prepare($connessione, "cmd5", $sql);
	$value  = array($_SESSION["email"]);
	$resource = pg_execute($connessione, "cmd5", $value);
	$id = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	$id = $id['id'];
	$_SESSION["id"]=$id; 

	$sql = "SELECT * FROM utente WHERE( email=$1 AND password=$2 )";
	$resource = pg_prepare($connessione, "cmd", $sql);
	$value  = array($_POST["email"],$_POST["password"]);
	$resource = pg_execute($connessione, "cmd", $value);
	$row = pg_fetch_array($resource,NULL,PGSQL_ASSOC); 
	if($row){
		$_SESSION["logged"] =true;

		header('Location: http://localhost/dadi.php');	
	}
	else
		header('Location: http://localhost/index.php?errore=1');
?>