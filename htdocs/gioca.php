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
		    padding: 15px 32px;
		    text-align: center;
		    text-decoration: none;
		    display: inline-block;
		    font-size: 16px;
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
    <li><a href="logout.php">LogOut</a></li>
</ul>
<br/>
<br/>
<br/>
<br/>
<form name="gioca" method="post" action="carica_mondo.php"> 
<button class="button">INIZIA UNA NUOVA AVVENTURA</button>
</form>
</body>
</html>