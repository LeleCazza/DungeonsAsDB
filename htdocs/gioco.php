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
			.stanz {
			    background-color: #FF831C;
			    border: none;
			    color: black;
			    padding: 5px 10px;
			    text-align: center;
			    font-size: 15px;
			    margin: 2px;
			    cursor: pointer;
			    top:-25px;
				left:100px;
			}
			.cerc {
			    background-color: #54BAE2;
			    border: none;
			    color: black;
			    padding: 5px 10px;
			    text-align: center;
			    font-size: 15px;
			    margin: 2px;
			    cursor: pointer;
			    top:-25px;
				left:100px;
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
    <li><a href="oggetti_posseduti.php">Oggetti posseduti</a></li>
    <li><a href="Logout.php">Log0ut</a></li>
</ul>
<?php
	echo "</br> <div style=\"margin-top: 4px\";\"margin-right:20px\">";
	$sql = "SELECT pf FROM personaggio WHERE id = $1";
	$resource = pg_prepare($connessione, "cmd", $sql);
	$value = array($_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd", $value);	
	$vita = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	$vita = $vita['pf']; 
	echo" <strong><font color=\"#FF0000\"> VITA PERSONAGGIO: $vita </font></strong></div>";
	if($vita <= 0)
		header("Location: http://localhost/gameover.php");
?>
<br/>
<br/>
<br/>
<?php
	if($_GET['stanza'] == 16 )
		echo " <strong>SEI A CASA!</strong>";

	$sql = "SELECT fine_passaggio FROM raggiunge WHERE id_personaggio = $1 AND inizio_passaggio=$2";
	$resource = pg_prepare($connessione, "cmd1", $sql);
	$value  = array($_SESSION["id"],16);
	$resource = pg_execute($connessione, "cmd1", $value);
	$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
	$valore = $valore['fine_passaggio'];

	if( isset($_GET['stanza']) ){
		$sql = "SELECT pf,numero FROM oggetti_equip_cons  WHERE id_personaggio = $1";
		$resource = pg_prepare($connessione, "cmd19", $sql);
		$value  = array($_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd19", $value);
		$pfTot = 0;
		while($valori =  pg_fetch_array($resource,NULL,PGSQL_ASSOC)){
			$pf = $valori['pf'];
			$numero = $valori['numero'];
			$pfTot = $pfTot + $pf*$numero;
		}
		if($pfTot < 0)
				$vita = $vita + $pfTot;
		else
				$vita = $vita - $pfTot;		

		$sql = "UPDATE personaggio SET pf = $1  WHERE id = $2";
		$resource = pg_prepare($connessione, "cmd20", $sql);
		$value  = array($vita,$_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd20", $value);

		unset($_SESSION["trovato_oggetto"]);
		unset($_SESSION["poca_cos"]);

		$_SESSION["cercato"] = "false";
		$_SESSION['stanza'] = $_GET['stanza'];
		$_SESSION['stop'] = "stop";

		$sql = "SELECT descrizione FROM stanza WHERE id = $1";
		$resource = pg_prepare($connessione, "cmd2", $sql);
		$value  = array($_SESSION['stanza']);
		$resource = pg_execute($connessione, "cmd2", $value);
		$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
		echo " SEI ENTRATO NELLA STANZA MAGICA: "; 
		$descrizione = $valore['descrizione'];
		if(	$descrizione == "Tesoro")
			header("Location: http://localhost/vittoria.php?");

		echo " <strong> $descrizione </strong> <br/><br/>";

		$sql = "SELECT SUM(numero) FROM possiede WHERE id_personaggio = $1";
		$resource = pg_prepare($connessione, "cmd3", $sql);
		$value  = array($_SESSION['id']);
		$resource = pg_execute($connessione, "cmd3", $value);	
		$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
		$numeroOggettiPrima = $valore['sum'];

		$sql = "UPDATE si_trova_in SET stanza = $1 WHERE id_personaggio = $2";
		$resource = pg_prepare($connessione, "cmd4", $sql);
		$value  = array($_SESSION['stanza'],$_SESSION['id']);
		$resource = pg_execute($connessione, "cmd4", $value);		

		$sql = "SELECT SUM(numero) FROM possiede WHERE id_personaggio = $1";
		$resource = pg_prepare($connessione, "cmd5", $sql);
		$value  = array($_SESSION['id']);
		$resource = pg_execute($connessione, "cmd5", $value);	
		$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
		$numeroOggettiDopo = $valore['sum'];

		if( ($numeroOggettiPrima + 1) == ($numeroOggettiDopo) )
			echo "<font color=\"#FF0000\">COMPLIMENTI!</font> HAI TROVATO UN OGGETTO, vai in <strong>Oggetti posseduti</strong> per vedere di cosa si tratta!</br>";
		if( ($numeroOggettiPrima + 1) < ($numeroOggettiDopo) )
			echo "<font color=\"#FF0000\">COMPLIMENTI!</font> HAI TROVATO DEGLI OGGETTI, vai in <strong>Oggetti posseduti</strong> per vedere di cosa si tratta!</br>";
		if($_SESSION["stanza"] != 16)
			echo "</br> <strong> <font color=\"#FF0000\"> SEI STATO ATTACCATO!! DECIDI CHI COLPIRE, SFERRA IL CONTRATTACCO!! </font></strong> <br/><br/>";
	}

	if(!isset($_SESSION['stop']))
		echo"<a href='gioco.php?stanza=$valore'><button class=\"stanz\"> ENTRA NELLA PRIMA STANZA </button></a>";

	if(isset($_SESSION['stop'])){
		$sql = "SELECT nome,descrizione,protegge.pf,dif,danno,protegge.id_nemico FROM protegge INNER JOIN nemico ON id_nemico = id WHERE id_stanza=$1 AND id_personaggio = $2";
		$resource = pg_prepare($connessione, "cmd6", $sql);
		$value  = array($_SESSION['stanza'],$_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd6", $value);	
		while($valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC)){
			echo" NOME NEMICO: "; 
			$nemico = $valore['nome'];
			echo" <strong> $nemico </strong>";
			echo" DESCRIZIONE: ";
			$descrizione = $valore['descrizione'];
			echo" <strong> $descrizione </strong>";
			echo" PF: " ;
			$pf = $valore['pf'];
			echo" <strong> $pf </strong>";
			echo" DIF: " ;
			$dif = $valore['dif'];
			echo" <strong> $dif </strong>";
			echo" DANNO: "; 
			$danno= $valore['danno'];
			echo" <strong> $danno </strong>";

			$id_nemico = $valore['id_nemico'];
			echo" <a href='gioco.php?nemico=$id_nemico'> <button class=\"button\"> ATTACCA </button></a>";
			echo"</br>";	
		}
		$sql = "SELECT count(*) FROM protegge WHERE id_stanza = $1 AND id_personaggio = $2";
		$resource = pg_prepare($connessione, "cmd7", $sql);
		$value = array($_SESSION['stanza'],$_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd7", $value);
		$numero = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
		$numero = $numero['count'];
		if( $numero > 1 ){
			echo "</br><em>rimangono da sconfiggere $numero nemici</em>";
			$_SESSION["piazzapulita"] = "false";
		}
		else if( $numero == 1 ){
			echo "</br><em>rimane da sconfiggere un solo nemico</em>";
			$_SESSION["piazzapulita"] = "false";
		}
		else{
			
			if($_SESSION["stanza"] != 16){
				echo "</br><em>hai sconfitto tutti i nemici</em></br>";
				echo "... oops ... hai già sconfitto tutti i nemici?!?! ... <strong>PAZZESCO!!</strong>";	
			}
			
			echo "</br></br><font color=\"#FF0000\">POTREBBERO</font> esserci dei passaggi segreti o degli oggetti nascosti nella stanza:";
			echo "<strong> VUOI SPENDERE 1 PF (Vita) E LANCIARE IL DADO PER CERCARLI?</strong>";
			echo"<a href='gioco.php?cerco=true'><button class=\"cerc\"> CERCA </button></a>";

			$_SESSION["piazzapulita"] = "true";
			$sql = "SELECT fine_passaggio FROM raggiunge WHERE inizio_passaggio = $1 AND id_personaggio = $2 AND visibile = $3";
			$resource = pg_prepare($connessione, "cmd8", $sql);
			$value = array($_SESSION['stanza'],$_SESSION["id"],"TRUE");
			$resource = pg_execute($connessione, "cmd8", $value);
			echo"</br>";
			echo"<strong></br>SCEGLI IN CHE STANZA DESIDERI ENTRARE: </strong>";
			$fantoccio = 1;
			while($stanza = pg_fetch_array($resource,NULL,PGSQL_ASSOC)){
				$stanza = $stanza['fine_passaggio'];
				echo"<a href='gioco.php?stanza=$stanza'><button class=\"stanz\"> STANZA $fantoccio </button></a>";
				$fantoccio = $fantoccio + 1;
				$x = 1;
			}
			if(!$x)
				echo "<font color=\"#FF0000\">apparentemente</font> non sembrano esserci passaggi...";
		}
	}

	if(isset($_GET['nemico'])){
		$nemico = $_GET['nemico'];
		header("Location: http://localhost/attacco.php?nemico=$nemico");
	}

	if( (($_GET['scontro']) == "successo") || (($_GET['scontro']) == "fallimento") ){
		unset($_SESSION["punteggio"]);
    	unset($_SESSION["lanciato"]);

		if(($_GET['scontro']) == "successo"){
			$sql = "UPDATE ingaggio SET nemico_ingaggiato = $1  WHERE id_personaggio = $2";
			$resource = pg_prepare($connessione, "cmd9", $sql);
			$value = array($_GET['ingaggiato'],$_SESSION["id"]);
			$resource = pg_execute($connessione, "cmd9", $value);
			header("Location: http://localhost/gioco.php?");
		}
	}

	if( (isset($_GET['stanza'])) || (isset($_SESSION['stop'])) ){
		if($_SESSION["piazzapulita"] == "false")
		{
			echo "</br></br>VUOI RIFUGIARTI IN UN'ALTRA STANZA? <strong>( i nemici cercheranno comunque di colpirti! ) </strong>";
			$sql = "SELECT fine_passaggio FROM raggiunge WHERE inizio_passaggio = $1 AND id_personaggio = $2 AND visibile = $3";
			$resource = pg_prepare($connessione, "cmd10", $sql);
			$value = array($_SESSION['stanza'],$_SESSION["id"],"TRUE");
			$resource = pg_execute($connessione, "cmd10", $value);
			$fantoccio = 1;
			while($stanza = pg_fetch_array($resource,NULL,PGSQL_ASSOC)){
				$stanza = $stanza['fine_passaggio'];
				echo"<a href='gioco.php?stanza=$stanza&scappato=true'><button class=\"stanz\"> STANZA $fantoccio </button></a>";
				$fantoccio = $fantoccio + 1;
				$y = 1;
			}
			if(!$y)
				echo "accidenti!, <font color=\"#FF0000\">apparentemente</font> non sembrano esserci passaggi...";

			if(isset($_GET['scappato']) ){
				$sql = "SELECT dif FROM personaggio WHERE id = $1";
				$resource = pg_prepare($connessione, "cmd11", $sql);
				$value = array($_SESSION["id"]);
				$resource = pg_execute($connessione, "cmd11", $value);
				$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				$dif = $valore['dif'];	

				$sql1 = "SELECT id_nemico FROM protegge WHERE id_stanza = $1 AND id_personaggio = $2";
				$resourc = pg_prepare($connessione, "cmd12", $sql1);
				$values = array($_SESSION["stanza"],$_SESSION["id"]);
				$resourc = pg_execute($connessione, "cmd12", $values);
			
				while($valore = pg_fetch_array($resourc,NULL,PGSQL_ASSOC)){
					$nemico = $valore["id_nemico"];

					$sql = "SELECT danno FROM nemico WHERE id = $1";
					$resource = pg_prepare($connessione, "cmd13", $sql);
					$value = array($nemico);
					$resource = pg_execute($connessione, "cmd13", $value);
					$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
					$danno = $valore['danno'];

					$parziale = $danno - $dif;
					$parziale = $parziale + rand(1,20); 
						
					if($parziale > 12){
						$sql = "UPDATE danno_ricevuto SET danno = $1 WHERE id_personaggio = $2";
						$resource = pg_prepare($connessione, "cmd14", $sql);
						$value = array($danno,$_SESSION["id"]);
						$resource = pg_execute($connessione, "cmd14", $value);
					}
				}
			}
		}
	}

	if($_GET["cerco"] == "true")
		header("Location: http://localhost/lanciadado.php?");

	if( $_GET["ricerca"] == "true"){
		
		$sql = "SELECT cos FROM personaggio WHERE id = $1";
		$resource = pg_prepare($connessione, "cmd15", $sql);
		$value = array($_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd15", $value);	
		$costituz = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
		$costituz = $costituz['cos'];
		$costituz = ceil($costituz/2);

		$sql = "SELECT SUM(numero) FROM possiede WHERE id_personaggio = $1";
		$resource = pg_prepare($connessione, "cmd16", $sql);
		$value  = array($_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd16", $value);	
		$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
		$numeroOggettiPrima = $valore['sum'];

		$sql = "UPDATE effettua_ricerca_in SET stanza = $1 WHERE id_personaggio = $2";
		$resource = pg_prepare($connessione, "cmd17", $sql);
		$value  = array($_SESSION["stanza"],$_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd17", $value);	

		$sql = "SELECT SUM(numero) FROM possiede WHERE id_personaggio = $1";
		$resource = pg_prepare($connessione, "cmd18", $sql);
		$value  = array($_SESSION["id"]);
		$resource = pg_execute($connessione, "cmd18", $value);	
		$valore = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
		$numeroOggettiDopo = $valore['sum'];

		if( ($numeroOggettiPrima + 1) == $numeroOggettiDopo )
			$_SESSION["trovato_oggetto"] = "true";
		else if ( ($numeroOggettiPrima + 1) == $costituz )
			$_SESSION["poca_cos"] = "true";
		header('Location: http://localhost/gioco.php');
	}
	if ( isset($_SESSION["trovato_oggetto"]) )
		echo "</br></br><font color=\"#FF0000\">GRANDE!</font> hai trovato un oggetto! vai in <strong>Oggetti posseduti</strong> per vedere di cosa si tratta!</br>";
	if ( isset($_SESSION["poca_cos"]) )
		echo "</br></br><font color=\"#FF0000\">PECCATO!</font> hai trovato un oggetto <font color=\"#FF0000\">MA</font> non puoi prenderlo perche' hai <strong>troppo poca COS!</strong></br>";

	unset($_SESSION["punteggio"]);
	unset($_SESSION["lanciato"]);
	unset($_SESSION["colpisci"]);
?>
</body>
</html>