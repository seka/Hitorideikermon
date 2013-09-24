<html>
<head></head>
<body>
<?php
	if(!empty($_POST["userid"]) && ($_POST["pass"])){
		//ログイン時のIDとパスワードの情報をセッションに記憶
		$_SESSION["userid"] = $_POST["userid"];
		$_SESSION["pass"] = $_POST["pass"];
		/********************************/
		/*  データベース接続処理        */
		/********************************/
		//MySQLに接続
		
		$mysql_con = mysql_connect("localhost","dekiruyo","hack3admin");
		
		//MySQLに接続し、接続の確認
		if($mysql_con == false){
			echo "MySQL接続：接続失敗<br>";
		}else{
			//echo "MySQL接続：接続完了<br>";
		}
		
		//データベースに接続し、接続の確認
		if(mysql_select_db("dekiruyo",$mysql_con)){
			//echo "DB接続：接続完了<br>";
		}else{
			//接続に失敗したときにMySQLの接続を切る
			die("DB接続：接続失敗<br>");
		}
		//文字エンコーディングを設定
		mysql_set_charset("utf8");

		/********************************/
		/*  データ表示処理              */
		/********************************/
		//DBから該当する情報を取得
		//echo $_POST["userid"];
		$mytbl = mysql_query("SELECT * FROM account WHERE userid = \"".$_POST["userid"]."\" AND pass = \"".$_POST["pass"]."\"",$mysql_con);
		if(!$mytbl){
			//エラーの場合はカットする
			die(mysql_error());		
			print "エラーカット";
		}
		//データを取得
		$data = mysql_fetch_array($mytbl);
		
		//MySQLの接続終了
		mysql_close($mysql_con);
		$login_url = "http://{$_SERVER["HTTP_HOST"]}/route.html";
		header("Location:{$login_url}");
		exit;
    	}else{ echo"ID または、パスワードの入力がありません<br><a href=\"top.html\">ログインページに戻る</a><br>";}
?>
</body>
</html>
