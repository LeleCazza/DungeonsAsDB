<?php
session_start();
?>
<html>  
	<head>
		<meta charset="utf-8"><link rel="stylesheet" type="text/css">
		<style type="text/css">
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
<body style="text-align: center;margin-top: 30px;background-color:#f0e68c;">
		<h2><strong><font color="#FF0000">REGISTRAZIONE</font></strong></h2>   
	<form name="form_registration" method="post" action="registration.php">
		<p><strong>Email:</strong> <input type="text" name="email_reg" required placeholder=" max 50 caratteri"></p>
	<br/>
		<p><strong>Password:</strong> <input type="password" name="password_reg" required placeholder=" max 8 caratteri"></p>
	<br/>
		<p><strong>Nome:</strong> <input type="text" name="nome_reg" placeholder=" max 20 caratteri"></p>
		<button class="button">Registrati</button>
		<?php
			if (isset($_GET['errore']) && $_GET['errore'] ==2 )
				echo "<font color=\"#FF0000\">Email non valida</font>";
			if (isset($_GET['registrato']) && $_GET['registrato'] ==true )
				echo"</br><strong><font color=\"#FF0000\">REGISTRAZIONE EFFETTUATA, ORA E' POSSIBILE FARE IL LOG IN</font></strong>";
			if (isset($_GET['errore']) && $_GET['errore'] ==3 )
				echo "<font color=\"#FF0000\">Email è già stata registrata o non è valida</font>";
		?>
	</form>

		<h2><strong><font color="#FF0000">LOG IN</font></strong></h2>   
	<form name="form_login" method="post" action="login.php">
		<p><strong>Email:</strong> <input type="text" name="email" required></p>
	<br/>
		<p><strong>Password:</strong> <input type="password" name="password" required></p>
		<button class="button">Accedi</button>
		<?php
			if (isset($_GET['errore']) && $_GET['errore'] ==1 )
				echo "<font color=\"#FF0000\">Email o Password non valida</front>";
		?>
	</form>
<body>
</html>