<?php
$domain = $_SERVER['SERVER_NAME'];

if (filter_var($domain, FILTER_VALIDATE_IP)) {
    $domain = 'app3.com';
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Nom du domaine</title>
</head>
<body>
    <h1><?php echo htmlspecialchars($domain); ?></h1>
</body>
</html>