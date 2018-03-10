<?php
    session_start();
    $connessione = pg_connect('dbname=postgres user=postgres'); 
	error_reporting(E_ERROR);

	unset($_SESSION["trovato_oggetto"]);
	unset($_SESSION["poca_cos"]);

	$sql = "SELECT per FROM personaggio WHERE id = $1";
	$resource = pg_prepare($connessione, "cmd", $sql);
	$value = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd", $value);
	$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	$per = $valore['per'];	

?>
<html lang="en">
<head>
    <meta charset="UTF-8"> <link rel="stylesheet" type="text/css">
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
		div.DADO{
		float:left;
		width:32px;
		background:#F5F5F5;
		border:#999 1px solid;
		padding:10px;
		font-size:24px;
		text-align:center;
		margin:5px;
		}	
		</style>
    <title>attacco</title>
</head>
<body style="text-align: center;background-color:#f0e68c;">

<form name="dadissimo" method="post">
    <input type="hidden" name="dado" value="">
    <div id="dado">
    </div>
    <button class="button" onclick="rollDado()"> LANCIA IL DADO DA 20 </button>
</form>

</body>
<script>
function rollDado(){
    var x = document.getElementById("dado");
    var dado = Math.floor(Math.random() * 20) + 1;
    document.dadissimo.dado.value = dado;
}
</script>

<?php

    if( isset($_POST["dado"]) && !isset($_SESSION["punteggio"]) ){
    	$_SESSION["punteggio"] = $_POST["dado"];
    	$_SESSION["lanciato"] = "true";
    }
    if( isset($_SESSION["lanciato"])){
		$valoreDado = $_SESSION["punteggio"];
		if( !isset($_SESSION["colpisci"]) ){
			$sql = "UPDATE danno_ricevuto SET danno = $1 WHERE id_personaggio = $2";
			$resource = pg_prepare($connessione, "cmd1", $sql);
			$value = array(1,$_SESSION["id"]);
			$resource = pg_execute($connessione, "cmd1", $value);	
			$_SESSION["colpisci"] = "toltoUno";
		}	
		$sql = "SELECT pf FROM personaggio WHERE id = $1";
		$resource = pg_prepare($connessione, "cmd2", $sql);
		$value = array($_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd2", $value);	
		$vita = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
		$vita = $vita['pf'];

		if ($valoreDado < $per){
			echo" <strong><font color=\"#FF0000\"> VITA PERSONAGGIO: $vita </font></strong>";
			echo"</br><a href='gioco.php?ricerca=true'> <button class=\"button\"> CLICCA PER VEDERE COS'HAI TROVATO </button></a>";
		}
		else{
			echo" <strong><font color=\"#FF0000\"> VITA PERSONAGGIO: $vita </font></strong>";
			echo"</br><a href='gioco.php?'> <button class=\"button\"> CLICCA PER TORNARE ALLA STANZA </button></a>";
		}
	}
?>