<?php
$domain = $_SERVER['SERVER_NAME'];
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