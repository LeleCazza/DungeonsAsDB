<?php
    session_start();
    $connessione = pg_connect('dbname=postgres user=postgres'); 
?>
<html lang="en">
<head>
    <meta charset="UTF-8"> <link rel="stylesheet" type="text/css">
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
    <title>Dadi</title>
</head>
<body style="text-align: center;background-color:#f0e68c;">
<h1> segui i passi per creare il tuo personaggio: </h1>
<p> per iniziare <strong>lancia 5 volte i dadi</strong>, i valori che usciranno verranno usati come <strong>statistiche del tuo personaggio</strong> e <font color="#FF0000">non saranno modificabili</font>... <u>lancia con molta attenzione</u></p>
<?php

	$sql = "SELECT forz FROM personaggio WHERE id = $1";
    $resource = pg_prepare($connessione, "cmd4", $sql);
    $value  = array($_SESSION["id"]);
    $resource = pg_execute($connessione, "cmd4", $value);
    $row = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
   	$row = $row['forz'];
   	if($row != 0)
   		header('Location: http://localhost/home.php');
?>

    <form name="dadissimo" method="post">
        <input type="hidden" name="dado" value="">
            <div style="margin-left: 430px" id="dado" class="DADO">
                <?php
                    if ( isset($_POST["dado"]) )
                        echo $_POST["dado"];
                ?>
            </div>
        <input type="hidden" name="dado1" value="">
            <div id="dado1" class="DADO">
                <?php
                    if ( isset($_POST["dado1"]) )
                        echo $_POST["dado1"];
                ?>
            </div>
        <input type="hidden" name="dado2" value="">
            <div id="dado2" class="DADO">            
                <?php
                    if ( isset($_POST["dado2"]) )
                        echo $_POST["dado2"];
                ?>
            </div>
            <button style="margin-right:600px"class = "cerc" onclick="rollDado1(),rollDado2(),rollDado3()"> Lancia i dadi </button>
    </form>

</body>
<script>
function rollDado1(){
    var x = document.getElementById("dado");
    var dado = Math.floor(Math.random() * 6) + 1;
    x.innerHTML = dado;
    document.dadissimo.dado.value = dado;
}

function rollDado2(){
    var x = document.getElementById("dado1");
    var dado = Math.floor(Math.random() * 6) + 1;
    x.innerHTML = dado;
    document.dadissimo.dado1.value = dado;
}

function rollDado3(){
    var x = document.getElementById("dado2");
    var dado = Math.floor(Math.random() * 6) + 1;
    x.innerHTML = dado;
    document.dadissimo.dado2.value = dado;
}
</script>

<?php
    if( isset($_POST["dado"]) && isset($_POST["dado1"]) && isset($_POST["dado2"]) )
    {        

        $sql = "SELECT id FROM tre_dadi WHERE( id=$1 )";
        $resource = pg_prepare($connessione, "cmd1", $sql);
        $value  = array($_SESSION["id"]);
        $resource = pg_execute($connessione, "cmd1", $value);
        $row = pg_num_rows($resource); 
        if($row<5)
        {   
            if($row == 0)
                $numero_lancio = "1";
            if($row == 1)
                $numero_lancio = "2";
            if($row == 2)
                $numero_lancio = "3";
            if($row == 3)
                $numero_lancio = "4";
            if($row == 4)
                $numero_lancio = "5";
            $sql = "INSERT INTO tre_dadi VALUES ($1,$2,$3)";
            $resource = pg_prepare($connessione, "cmd2", $sql);
            $value  = array($_SESSION["id"],$numero_lancio,$_POST["dado"] + $_POST["dado1"] + $_POST["dado2"] );
            $resource = pg_execute($connessione, "cmd2", $value);
        }
        if($row >= 4)
        {
            $sql = "SELECT numero_lancio,valore FROM tre_dadi WHERE(id=$1)";
            $resource = pg_prepare($connessione, "cmd3", $sql);
            $value  = array($_SESSION["id"]);
            $resource = pg_execute($connessione, "cmd3", $value);

            echo '<br />';
            echo '<br />';

            while($row = pg_fetch_array($resource,NULL,PGSQL_ASSOC))
            {
                echo "LANCIO NUMERO: ";
                print_r($row['numero_lancio']);
                echo ",  PUNTEGGIO OTTENUTO: ";
                echo"<strong>";
                print_r($row['valore']);
                echo"</strong>";
                echo '<br />';
            }
            echo '<br />';
            echo "<strong>CHE LANCIO VUOI SCARTARE?</strong>";
            echo '<form action= "personaggio.php?">
                    <input type="radio" name="gender" value="1" checked> LANCIO NUMERO: 1<br />
                    <input type="radio" name="gender" value="2"> LANCIO NUMERO: 2<br />
                    <input type="radio" name="gender" value="3"> LANCIO NUMERO: 3<br /> 
                    <input type="radio" name="gender" value="4"> LANCIO NUMERO: 4<br />
                    <input type="radio" name="gender" value="5"> LANCIO NUMERO: 5<br />
                    <button class = "cerc">SCARTA!</button> 
                  </form> ';
        }        
    }       
?>

</html>