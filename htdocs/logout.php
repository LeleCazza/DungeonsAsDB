<?php
session_start();
$connessione = pg_connect('dbname=postgres user=postgres');
error_reporting(E_ERROR);
session_destroy();
header('Location: http://localhost/index.php');
?>