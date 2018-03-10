<?php
    session_start();
    $connessione = pg_connect('dbname=postgres user=postgres'); 
	error_reporting(E_ERROR);
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
<?php
	$sql = "SELECT att FROM personaggio WHERE( id=$1 )";
    $resource = pg_prepare($connessione, "cmd", $sql);
    $value  = array($_SESSION["id"]);
    $resource = pg_execute($connessione, "cmd", $value);
    $valor = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
    $valor = $valor['att'];
    echo "$valor ( è il tuo attacco attuale) ";

    echo " - ";

   	$nemico = $_GET['nemico'];
    $sql = "SELECT dif FROM nemico WHERE id =$1 ";
    $resource = pg_prepare($connessione, "cmd1", $sql);
    $value  = array($_GET['nemico']);
    $resource = pg_execute($connessione, "cmd1", $value);
    $valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
    $valore = $valore['dif'];

    echo "$valore ( è la difesa del nemico) ";
    echo "=";
    $risultato = $valor - $valore;
    echo " $risultato <br/><br/>";
   	echo "<strong>Per riuscire nell'attacco hai ancora bisogno di </strong>";
   	$parziale = 12 - $risultato;
   	if($parziale < 0)
   		$parziale = -1;
   	$parziale = $parziale + 1;
   	echo "<strong>$parziale punti </strong><br/><br/>";
?>
<form name="dadissimo" method="post">
    <input type="hidden" name="dado" value="">
    <div style="margin-left: 500px" id="dado" class="DADO">
        <?php
            if ( isset($_POST["dado"]) )
                echo $_POST["dado"];
        ?>
    </div>
    <button style="margin-right:600px" class="button" onclick="rollDado()"> LANCIA IL DADO DA 20 </button>
</form>

<script>
function rollDado(){
    var x = document.getElementById("dado");
    var dado = Math.floor(Math.random() * 20) + 1;
    x.innerHTML = dado;
    document.dadissimo.dado.value = dado;
}
</script>
<?php
    if( isset($_POST["dado"]) && !isset($_SESSION["punteggio"]) ){
    	$_SESSION["punteggio"] = $_POST["dado"];
    	$_SESSION["rand"] = rand(1,20); 
    	$_SESSION["lanciato"] = "true";
    }
    if( isset($_SESSION["lanciato"])){
		$valoreDado = $_SESSION["punteggio"];
		$nemicoAttaccato = $_GET["nemico"];
	    $bonus = $risultato + $valoreDado;
		echo "</br></br>$risultato + $valoreDado = $bonus"; 
		
		if ($bonus > 12)
			echo "<strong><font color=\"#FF0000\">  COMPLIMENTI, IL TUO ATTACCO E' ANDATO A BUON FINE</font></strong></br></br>";
		else
			echo "<strong>  CHE SFORTUNA!!, IL TUO ATTACCO NON E' ANDATO A BUON FINE</strong></br></br>";

		$sql = "SELECT dif FROM personaggio WHERE id = $1";
		$resource = pg_prepare($connessione, "cmd2", $sql);
		$value = array($_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd2", $value);
		$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
		$dif = $valore['dif'];	

		$sql1 = "SELECT id_nemico FROM protegge WHERE id_stanza = $1 AND id_personaggio = $2";
		$resourc = pg_prepare($connessione, "cmd3", $sql1);
		$values = array($_SESSION["stanza"],$_SESSION["id"]);
		$resourc = pg_execute($connessione, "cmd3", $values);
		
		while($valore = pg_fetch_array($resourc,NULL,PGSQL_ASSOC)){
			$nemico = $valore["id_nemico"];

			$sql = "SELECT nome,danno FROM nemico WHERE id = $1";
			$resource = pg_prepare($connessione, "cmd4", $sql);
			$value = array($nemico);
			$resource = pg_execute($connessione, "cmd4", $value);
			$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
			$nemico_sfidato = $valore['nome'];
			$danno = $valore['danno'];

			$parziale = $danno - $dif;
			echo "<strong>$danno ( è l'attacco del nemico) -</strong>";
			echo "<strong> $dif ( è la tua difesa attuale) = $parziale</strong></br>";
		 	$rand = $_SESSION["rand"];
		 	$rand = (($rand * $nemico)%20 + 1);
			$parzial = $parziale + $rand;
			
			echo "<strong><font color=\"#FF0000\">$nemico_sfidato</font> ha lanciato il dado e ottenuto il punteggio di $rand</strong></br>";
			echo " <strong> QUINDI: $parziale + $rand = $parzial </strong>";
			
			if($parzial > 12){
				$sql = "UPDATE danno_ricevuto SET danno = $1 WHERE id_personaggio = $2";
				$resource = pg_prepare($connessione, "cmd5", $sql);
				$value = array($danno,$_SESSION["id"]);
				$resource = pg_execute($connessione, "cmd5", $value);
				echo " <strong><em><font color=\"#FF0000\">IL NEMICO E' RIUCITO A COLPIRTI!!!</font></em></br></br></strong>";
			}
			if($parzial <= 12)
				echo " <strong><em>IL NEMICO NON E' RIUCITO A COLPIRTI!!!</em></strong></br></br>";
		}
			if ($bonus > 12)
				echo"</br><a href='gioco.php?scontro=successo&ingaggiato=$nemicoAttaccato'> <button class=\"button\"> CLICCA PER VEDERE L'ESITO DELLO SCONTRO </button></a>";
			else
				echo"</br><a href='gioco.php?scontro=fallimento&ingaggiato=$nemicoAttaccato'> <button class=\"button\"> CLICCA PER VEDERE L'ESITO DELLO SCONTRO </button></a>";
	}
?>
</body>
</html>