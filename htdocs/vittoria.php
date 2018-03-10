<?php
    session_start();
    $connessione = pg_connect('dbname=postgres user=postgres'); 
	error_reporting(E_ERROR);
?>
<html>  
	<head>
		<meta charset="utf-8"><link rel="stylesheet" type="text/css">
		<style>
		.button {
			    background-color: #4CAF50;
			    border: none;
			    color: white;
			    padding: 5px 10px;
			    text-align: center;
			    font-size: 15px;
			    margin: 2px;
			    cursor: pointer;
			}
		</style>
	</head>
<body style="text-align: center;background-color:#f0e68c;">
<h1> CONGRATULAZIONI HAI VINTO!!!!! </h1>
<h3><font color="#FF0000">HAI TROVATO IL TESORO</font> attraversando stanze magiche, raccogliendo oggetti e affrontando terribili nemici!! </h3>
<?php
if(!isset($_SESSION["fine"])){
	$sql = "SELECT pe FROM personaggio WHERE id = $1";
	$resource = pg_prepare($connessione, "cmd", $sql);
	$value = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd", $value);
	$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	$per = $valore['pe'];	
	echo "<strong>INCREDIBILE!</strong> HAI OTTENUTO UN PUNTEGGIO DANNO PARI A <font color=\"#FF0000\">$per</font> !!</br>";
	
	$sql = "SELECT COUNT(DISTINCT id_stanza) FROM stanzevisitate WHERE id_personaggio = $1";
	$resource = pg_prepare($connessione, "cmd1", $sql);
	$value = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd1", $value);
	$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	$count = $valore['count'];		
	echo "<strong>STRABILIANTE!</strong> HAI VISITATO BEN <font color=\"#FF0000\">$count</font> STANZE !!</br>";
	$count = $count * 10 + $per;
	echo "</br>ESPERIENZA GUADAGNATA = <strong><font color=\"#FF0000\">$count</font></strong>";

	$sql = "SELECT esp FROM esp_totale WHERE id_personaggio = $1";
	$resource = pg_prepare($connessione, "cmd2", $sql);
	$value = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd2", $value);
	$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	$espTot = $valore['esp'];		

	$espTot = $espTot + $count;

	$sql = "UPDATE esp_totale SET esp = $1 WHERE id_personaggio = $2 ";
	$resource = pg_prepare($connessione, "cmd3", $sql);
	$value = array($espTot,$_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd3", $value);
	$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	echo"</br>";
	$_SESSION["fine"] = "FINE!";
}

echo"</br><a href='home.php?fine=true'> <button class=\"button\"> CLICCA PER USCIRE</button></a>";
?>
</body>
</html>