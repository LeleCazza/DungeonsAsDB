<?php
session_start();
$connessione = pg_connect('dbname=postgres user=postgres'); 
?>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <style type="text/css">
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
    </style>
    <title>Personaggio</title>
</head>
<body style="text-align: center;background-color:#f0e68c;">

<?php
	echo "<strong>COMPLIMENTI</strong> HAI SCARTATO IL LANCIO NUMERO ";
    echo"<strong>"; 
	echo $_GET["gender"];
    echo"</strong>";
	echo ", OTTIMA MOSSA!!";

	$sql = "SELECT valore FROM tre_dadi WHERE( numero_lancio<>$1 AND id=$2 )";
	$resource = pg_prepare($connessione, "cmd", $sql);
	$value  = array($_GET["gender"],$_SESSION["id"]);
	$resource = pg_execute($connessione, "cmd", $value); 

	$repeat=1;
	echo '<br \>';
	echo " <strong><font color=\"#FF0000\">VALORI OTTENUTI INSERIBILI =</font></strong> \"";
	while($row = pg_fetch_array($resource,NULL,PGSQL_ASSOC)){
        echo"<strong>"; 
        print_r($row['valore']);
        echo"</strong>";
        if($repeat < 4){
	        echo '", "';
	        $repeat++;
	    }
    }
    echo "\"";
?>

    <form name="caratteristiche" method="post">
        <p>FOR  <input type="text" name="FOR" required></p>
        <p>INT  <input type="text" name="INT" required></p>
        <p>AGI  <input type="text" name="AGI" required></p>
        <p>COS  <input type="text" name="COS" required></p>
        <button class = "cerc">CREA IL MIO PERSONAGGIO</button>
    </form>

<?php
	if(isset($_POST["FOR"])){
   		$valoriInseriti= array($_POST["FOR"],$_POST["INT"],$_POST["AGI"],$_POST["COS"]);
    	$valoriAccettabili =pg_fetch_all_columns($resource,0);
    	sort($valoriInseriti);
    	sort($valoriAccettabili);
    	$barato = 0;
    	for($x=0;$x<4;$x++){
    		if($valoriInseriti[$x] != $valoriAccettabili[$x])
    			$barato = 1; 
    	}
    	if($barato == 1){
    		echo " <strong><font color=\"#FF0000\">NON FARE IL FURBO!!</font></strong> SE SEI STATO SFORTUNATO LA COLPA E' SOLO DELLA TUA SFORTUNA!!";
    		echo '<br />';
    		echo "<strong>INSERISCI I VERI VALORI CHE HAI OTTENUTO!!</strong>";
    	}
    	else{       
            $sql = "UPDATE Personaggio SET forz=$1,int=$2,agi=$3,cos=$4 WHERE id=$5";
            $resource = pg_prepare($connessione, "cmd1",  $sql);
            $value  = array($_POST["FOR"],$_POST["INT"],$_POST["AGI"],$_POST["COS"],$_SESSION["id"]);
            $resource = pg_execute($connessione, "cmd1",  $value);

            $att = round(($_POST["FOR"] + $_POST["AGI"])/2);
            $dif = round(($_POST["COS"] + $_POST["AGI"])/2);
       
            $sql = "UPDATE Personaggio SET att=$1,dif=$2,per=$3,pf=$4 WHERE id=$5";
            $resource = pg_prepare($connessione, "cmd2",  $sql);
            $value  = array($att,$dif,$_POST["INT"],$_POST["COS"],$_SESSION["id"]);
            $resource = pg_execute($connessione, "cmd2",  $value);

            $sql = "UPDATE valoribase SET att=$1,dif=$2,per=$3 WHERE id_personaggio=$4";
            $resource = pg_prepare($connessione, "cmd3",  $sql);
            $value  = array($att,$dif,$_POST["INT"],$_SESSION["id"]);
            $resource = pg_execute($connessione, "cmd3",  $value);

            $_SESSION["Personaggio"] = true;

            echo " <strong><font color=\"#FF0000\"> PERFETTO</font></strong>, <strong>IL TUO PERSONAGGIO E' STATO CREATO:</strong> <br/>";
            echo "<u>per iniziare ti abbiamo regalato una Spada e una razione di cibo</u><br/><br/>";
            echo "<strong>SPADA:</strong> Punti Ferita: <strong>4</strong> ; Percezione <strong>+2</strong> ; Attacco <strong>+2</strong> ; Difesa <strong>-1</strong> <br/>";
            echo "<strong>RAZIONE DI CIBO:</strong> PuntiFerita <strong>+2</strong> <br/>";
            echo "<br/>";
            echo '<form name="inizio" action="home.php"> <button class = "cerc">INIZIA IL GIOCO</button> </form>';

            echo"<br/><strong><font color=\"#FF0000\">NOTA:</font></strong></br>";
            echo"<strong>A cosa servono</strong> Punti Ferita , Percezione , Attacco e Difesa ?</br>";
            echo"</br><li><strong><font color=\"#FF0000\">Punti Ferita: </font></strong>";
            echo"<strong>se relativi ad un arma</strong> sono il <font color=\"#FF0000\">danno</font> che causerai al nemico, ";
            echo"<strong>se relativi ad un oggetto</strong> sono i <font color=\"#FF0000\">punti vita</font> che l'oggetto fa recuperare o toglie";
            echo"</li>";

            echo"</br><li><strong><font color=\"#FF0000\">Percezione: </font></strong>";
            echo"<strong>più sarà alta</strong> la percezione, <strong>più si avrà possibilità</strong> di <font color=\"#FF0000\">cercare</font> con <strong>successo</strong> oggetti all'interno del gioco";
            echo"</li>";

            echo"</br><li><strong><font color=\"#FF0000\">Attacco: </font></strong>";
            echo"<strong>più sarà alto</strong> l'attacco, <strong>più si avrà possibilità</strong> di <font color=\"#FF0000\">colpire</font> con <strong>successo</strong> il nemico";
            echo"</li>";

            echo"</br><li><strong><font color=\"#FF0000\">Difesa: </font></strong>";
            echo"<strong>più sarà alta</strong> la difesa, <strong>più si avrà possibilità</strong> di <font color=\"#FF0000\">evitare</font> con <strong>successo</strong> l'attacco del nemico";
            echo"</li>";
          
        }
    }
?>

</body>
</html>