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
		    cursor: pointer;
		}
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
	</head>
<body style="text-align: center;background-color:#f0e68c;">
<ul id="menu">
    <li><a href="equipaggiamento.php">Equipaggiamento</a></li>
    <li><a href="gioco.php">Torna al gioco</a></li>
    <li><a href="oggetti_posseduti.php">Oggetti posseduti</a></li>
    <li><a href="logout.php">LogOut</a></li>
</ul>
<br/>
<br/>
<p> QUESTI SONO I TUOI OGGETTI: </p>
<?php
	unset($_SESSION["consuma"]);

	$sql = "SELECT nome_oggetto,numero,indossato_si_no FROM possiede WHERE( id_personaggio=$1)";
	$resource = pg_prepare($connessione, "cmd", $sql);
	$value  = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd", $value);
	while($row = pg_fetch_array($resource,NULL,PGSQL_ASSOC)){
		echo"<ul style = \"list-style-type: none;\">";
        $oggetto = $row['nome_oggetto'];
        $numero = $row['numero'];
        $indossato = $row['indossato_si_no'];
        echo "<li><strong>$oggetto: </strong>";

        $sql = "SELECT pf,per,att,dif,tipo FROM oggetto WHERE nome=$1";
		$resourc = pg_prepare($connessione, "cmd1", $sql);
		$value  = array($oggetto);
		$resourc = pg_execute($connessione, "cmd1", $value);
		while($valori = pg_fetch_array($resourc,NULL,PGSQL_ASSOC)){
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
			echo "<em>; Tipo: </em>";
			echo"<strong>";
			print_r($valori['tipo']);
			echo"</strong>";
			$tipo = $valori['tipo'];
			if($tipo == 'consumabile')
				echo " <strong>x$numero</strong>";
		}
		if($indossato != 't')
			echo" <a href='equipaggiamento.php?oggetto=$oggetto'> <button class=\"button\"> EQUIPAGGIA </button></li></a>";
		else
			echo"<strong><font color=\"#FF0000\"> EQUIPAGGIATO!</font></li></strong>";
		echo"</ul>";
    }
?>
</body>
</html>