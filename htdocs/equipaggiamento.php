<?php
session_start();
$connessione = pg_connect('dbname=postgres user=postgres');
error_reporting(E_ERROR);

$sql = "SELECT pf FROM personaggio WHERE id = $1";
$resource = pg_prepare($connessione, "cmd", $sql);
$value = array($_SESSION["id"]);
$resource = pg_execute($connessione, "cmd", $value);	
$vita = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
$vita = $vita['pf']; 

?>
<html>  
	<head>
		<meta charset="utf-8"><link rel="stylesheet" type="text/css">
	<style type="text/css">
		ul#menu {
		    font-family: Verdana, sans-serif;
		    font-size: 11px;
		    margin-top: 10px;
		    margin-left: 440px;
		    padding: 0;
		    list-style: none;
		}
			  
		ul#menu li {
		    background-color: #FF831C;
		    border-bottom: 5px solid #54BAE2;
		    display: block;
		    width: 150px;
		    height: 30px;
		    margin: 2px;
		    float: left;
		}
		  
		ul#menu li a {
		    color: #fff;
		    display: block;
		    font-weight: bold;
		    line-height: 30px;
		    text-decoration: none;
		    width: 150px;
		    height: 30px;
		    text-align: center;
		}
		  
		ul#menu li.active, ul#menu li:hover {
		    background-color: #54BAE2;
		    border-bottom: 5px solid #FF831C;
		}
		</style>
	</style>
	</head>
<body style="text-align: center;background-color:#f0e68c;">
<ul id="menu">
    <li><a href="equipaggiamento.php">Equipaggiamento</a></li>
    <li><a href="gioco.php">Torna al gioco</a></li>
    <li><a href="oggetti_posseduti.php">Oggetti posseduti</a></li>
    <li><a href="logout.php">LogOut</a></li>
</ul>
</body>
<br/>
<br/>
<p> IL TUO PERSONAGGIO RISULTA COSI' EQUIPAGGIATO: </p>
<?php
    if(isset($_GET["oggetto"]) ){
 	 	$sql = "UPDATE ogg_da_equip SET oggetto = $1 WHERE id_personaggio=$2";
		$resource = pg_prepare($connessione, "cmd1", $sql);
		$value  = array($_GET["oggetto"],$_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd1", $value);

		if(!isset($_SESSION["consuma"]))
		{
			$sql = "SELECT pf,tipo FROM oggetto WHERE nome = $1";
			$resource = pg_prepare($connessione, "cmd2", $sql);
			$value  = array($_GET["oggetto"]);
			$resource = pg_execute($connessione, "cmd2", $value);
			$valori =  pg_fetch_array($resource,NULL,PGSQL_ASSOC);
			$pf = $valori['pf'];
			$tipo = $valori['tipo'];
			if($tipo == "consumabile")
			{
				$vita = $vita + $pf;
				$sql = "UPDATE personaggio SET pf = $1 WHERE id = $2";
				$resource = pg_prepare($connessione, "cmd3", $sql);
				$value  = array($vita,$_SESSION["id"]);
				$resource = pg_execute($connessione, "cmd3", $value);
			}
			$_SESSION["consuma"] = "consumato!";
		}
	}
	$sql = "SELECT * FROM possiede WHERE( id_personaggio=$1 AND indossato_si_no=TRUE)";
	$resource = pg_prepare($connessione, "cmd4", $sql);
	$value  = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd4", $value);

	while($row = pg_fetch_array($resource,NULL,PGSQL_ASSOC)){
        $oggetto = $row['nome_oggetto']; 
        $numero = $row['numero'];

        $sql = "SELECT pf,per,att,dif,tipo FROM oggetto WHERE nome=$1";
		$resourc = pg_prepare($connessione, "cmd5", $sql);
		$value  = array($oggetto);
		$resourc = pg_execute($connessione, "cmd5", $value);
		
		while($valori = pg_fetch_array($resourc,NULL,PGSQL_ASSOC)){
			if($valori['tipo'] == 'attacco'){
				echo "<strong>ARMA: </strong>";
				echo "<strong><font color=\"#FF0000\">$oggetto</font></strong>";
			}
			if($valori['tipo'] == 'difesa'){
				echo "<strong>ARMATURA: </strong>";
				echo "<strong><font color=\"#FF0000\">$oggetto</font></strong>";
			}
			if($valori['tipo'] == 'consumabile'){
				echo "<strong>OGGETTO UTILIZZATO: </strong>";
				echo "<strong><font color=\"#FF0000\">$oggetto</font></strong>";
			}
			echo "<em> Punti Ferita: </em>";
			echo"<strong>";
			print_r($valori['pf']);
			echo"</strong>";
			echo "<em>; Percezione: </em>";
			echo"<strong>";
			print_r($valori['per']);
			echo"</strong>";
			echo "<em>; Attacco: </em>";
			echo"<strong>";
			print_r($valori['att']);
			echo"</strong>";
			echo "<em>; Difesa: </em>";
			echo"<strong>";
			print_r($valori['dif']);
			echo"</strong>";
			$tipo = $valori['tipo'];
			if($tipo == 'consumabile')
				echo " <strong><font color=\"#FF0000\">x$numero</font></strong>";
		}
		echo "<br/>";
    }   
?>


<p> LE CARATTERISTICHE DEL TUO PERSONAGGIO COSI' EQUIPAGGIATO SONO: </p>
<?php
	$sql = "SELECT per,att,dif FROM personaggio WHERE id=$1 ";
	$resource = pg_prepare($connessione, "cmd6", $sql);
	$value  = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd6", $value);
	$row = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	echo "<strong>PERCEZIONE = </strong>";
	print_r($row['per']);
	echo"</br>";
	echo "<strong>ATTACCO = </strong>";
	print_r($row['att']);
	echo"</br>";
	echo "<strong>DIFESA = </strong>";
	print_r($row['dif']);
	echo"</br>";

$sql = "SELECT pf FROM personaggio WHERE id = $1";
$resource = pg_prepare($connessione, "cmd7", $sql);
$value = array($_SESSION["id"]);
$resource = pg_execute($connessione, "cmd7", $value);	
$vita = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
$vita = $vita['pf']; 
echo" <strong><font color=\"#FF0000\"> VITA PERSONAGGIO: $vita </font></strong></div>";
if($vita <= 0)
	header("Location: http://localhost/gameover.php");	
?>
</html>