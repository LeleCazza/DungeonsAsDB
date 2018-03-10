<?php
    session_start();
    $connessione = pg_connect('dbname=postgres user=postgres'); 
	error_reporting(E_ERROR);
?>
<html>  
	<head>
		<meta charset="utf-8"><link rel="stylesheet" type="text/css" >
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
</br>
<h1> OOOOOOOH NOOOOOOOOO!!!!! SEI MORTO.. </h1>
<img src="OHNO.jpg" alt="OOOH NOOO" width="1000" height="377">
</br>
</br><a href='home.php?fine=true'> <button class="button"> CLICCA PER USCIRE</button></a>
</body>
</html>