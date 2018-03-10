<?php
session_start();
$connessione = pg_connect('dbname=postgres user=postgres');
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
			.butto {
			    background-color: #FF831C;
			    border: none;
			    color: white;
			    padding: 10px 20px;
			    text-align: center;
			    font-size: 15px;
			    margin: 2px;
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
    <li><a href="home.php">Home</a></li>
    <li><a href="gioca.php">Gioca</a></li>
    <li><a href="Logout.php">LogOut</a></li>
</ul>
<br/>
<br/>
<?php
	$sql = "SELECT nome FROM personaggio WHERE id = $1";
	$resource = pg_prepare($connessione, "cmd", $sql);
	$value = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd", $value);
	$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	$nome = $valore['nome'];	
	echo "<h1>Benvenuto in DungeonsAsDB $nome !!</h1>";

	$sql = "SELECT esp FROM esp_totale WHERE id_personaggio = $1";
	$resource = pg_prepare($connessione, "cmd1", $sql);
	$value = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd1", $value);
	$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	$esp = $valore['esp'];
	echo "<h3> ESPERIENZA ACCUMULATA: <strong><font color=\"#FF0000\">$esp</font></strong></h3>";	
?>
<form method = "post" action="home.php" >
  <textarea name="message" rows="10" cols="30">qui puoi aggiungere una descrizione del tuo personaggio</textarea>
  <br>
  <input class="button" type="submit" value="AGGIORNA DESCRIZIONE">
</form>
<?php
	if(isset($_POST["message"])){
		$sql = "UPDATE personaggio SET descrizione = $1 WHERE id = $2";
		$resource = pg_prepare($connessione, "cmd2", $sql);
		$value = array($_POST["message"],$_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd2", $value);
	}

	$sql = "SELECT descrizione FROM personaggio WHERE id = $1";
	$resource = pg_prepare($connessione, "cmd3", $sql);
	$value = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd3", $value);
	$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	$desc = $valore['descrizione'];
	echo "<h3> DESCRIZIONE : </h3>";	
	echo "<p><strong><font color=\"#FF0000\">$desc</font></strong></p>";

	if(isset($_GET["fine"])){
		unset($_SESSION["cercato"]);
		unset($_SESSION["stanza"]);
		unset($_SESSION["stop"]);
		unset($_SESSION["piazzapulita"]);
		unset($_SESSION["fine"]);
		header("Location: http://localhost/home.php");
	}
?>

<a href="gioca.php"><button class = "butto">Gioca</button></a>

</body>
</html>