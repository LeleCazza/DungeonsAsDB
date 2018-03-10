<?php
	session_start();
	$connessione = pg_connect('dbname=postgres user=postgres'); 	
	if(chkEmail($_POST["email_reg"])){	
		$sql = "SELECT * FROM utente WHERE( email=$1)";
		$resource = pg_prepare($connessione, "cmd", $sql);
		$value  = array($_POST["email_reg"]);
		$resource = pg_execute($connessione, "cmd", $value);
		$row = pg_fetch_array($resource,NULL,PGSQL_ASSOC); 
		if(!$row){
			$sql = "INSERT INTO Utente(email,password,nome) VALUES ($1,$2,$3)";
			$resource = pg_prepare($connessione, "cmd2",  $sql);
			$value  = array($_POST["email_reg"],$_POST["password_reg"],$_POST["nome_reg"]);
			$resource = pg_execute($connessione, "cmd2",  $value);
			header('Location: http://localhost/index.php?registrato=true');
			}
		else
			header('Location: http://localhost/index.php?errore=3');
	}
	else
		header('Location: http://localhost/index.php?errore=2');

function chkEmail($email)
{
	// elimino spazi, "a capo" e altro alle estremità della stringa
	$email = trim($email);

	// controllo che ci sia una sola @ nella stringa
	$num_at = count(explode( '@', $email )) - 1;
	if($num_at != 1) {
		return false;
	}

	// controllo la presenza di ulteriori caratteri "pericolosi":
	if(strpos($email,';') || strpos($email,',') || strpos($email,' ')) {
		return false;
	}

	// la stringa rispetta il formato classico di una mail?
	if(!preg_match( '/^[\w\.\-]+@\w+[\w\.\-]*?\.\w{1,4}$/', $email)) {
		return false;
	}

	return true;
}

?>