<?php
header("Content-Type: text/html");

// remove magic quotes
set_magic_quotes_runtime(0); 
function stripslashes_deep($value) {
        $value = is_array($value) ? array_map(array($this, "stripslashes_deep"), $value) : stripslashes($value);
        return $value;
}
    
$SPARQL_SERVICE = $_GET['endpoint'];
$SPARQL_QUERY =  stripslashes_deep($_GET['query']);
$SPARQL_RESULT = $SPARQL_SERVICE . "?query=" . urlencode(stripslashes(urldecode($SPARQL_QUERY)));
//print_r($SPARQL_RESULT);
// urlencode
//
$doc = new DOMDocument();
$doc->load($SPARQL_RESULT);
$xsl = new DomDocument();
$xsl->load("sparql-html.xsl");
$proc = new XsltProcessor();
$xsl = $proc->importStylesheet($xsl);
print $proc->transformToXML($doc);
?>
