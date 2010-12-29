<?php

include 'vars.php';

if(strlen($_FILES['file']['name'])>1) {
    $target_path = "upload/";
    if($_FILES['file']['type']=='application/rdf+xml') {
    $target_path = $target_path . basename( $_FILES['file']['name']); 
    if(move_uploaded_file($_FILES['file']['tmp_name'], $target_path)) {
                    $xml=file_get_contents($target_path);
                    $remote_talis='api.talis.com/stores/$store/meta';
                    $poster = curl_init();
                    curl_setopt($poster, CURLOPT_VERBOSE, TRUE);
                    curl_setopt($poster, CURLOPT_HTTPHEADER,array("Content-Type: application/rdf+xml"));
                    curl_setopt($poster, CURLOPT_URL, $remote_talis);
                    curl_setopt($poster, CURLOPT_FOLLOWLOCATION, TRUE);
                    curl_setopt($poster, CURLOPT_RETURNTRANSFER, TRUE);
                    curl_setopt($poster, CURLOPT_HEADER, TRUE);
                    curl_setopt($poster, CURLOPT_HTTPAUTH, CURLAUTH_DIGEST);
                    curl_setopt($poster, CURLOPT_USERPWD, $user + ':' + $pwd);
                    curl_setopt($poster, CURLOPT_POST, TRUE);
                    curl_setopt($poster, CURLOPT_POSTFIELDS, $xml);
                    $raw_response = curl_exec($poster);
                    curl_close($poster);
		   if($raw_response) {
			header("Location: sparql-editor.html");
			}
    } else{
            $error="There was an error uploading the file, please try again!";
    }
    }
    else {
        $error="Incorect file type!";
    }
}
?>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" type="text/css" href="common.css" />
<link rel="stylesheet" type="text/css" href="meniu.css" />
</head>
<body>
<div id="meniu">
		<a href="http://www.science3point0.com">S3.0 Home</a>
        <a href="index.php">RDF Uploader</a>
        <a href="sparql-editor.html">Query editor</a>
</div>
<div id="hr"></div>
<div id="fform">
<form method="POST" enctype="multipart/form-data" action="index.php">
<p>RDF/XML file: <input type="file" name="file">&nbsp;&nbsp;<input type="submit" value="Upload"></p>
</form>
<?php
    if(strlen($error)>1) {
        echo "<p>$error</p>";
    }
?>
</div>
<div id="bottom">
<img src="opendata.png" alt="opendata" />
    <img src="http://i.creativecommons.org/p/zero/1.0/80x15.png" style="border-style: none;" alt="CC0" />
<p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
  </a>
  <br />
  To the extent possible under law,
  <a rel="dct:publisher"
     href="http://www.science3point0.com/opendata/">
    <span property="dct:title">Science3.0</span></a>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">CC0 RDF Hosting For Scientists</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
      content="GB" about="http://www.science3point0.com/opendata/">
  United Kingdom</span>.
</p>
</div>
</body>
</html>
