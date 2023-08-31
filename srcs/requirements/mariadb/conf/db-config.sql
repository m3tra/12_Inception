CREATE DATABASE IF NOT EXISTS {$MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '{$MYSQL_USER}'@'%' IDENTIFIED BY '{$MYSQL_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON {$MYSQL_DATABASE}.* TO '{$MYSQL_USER}'@'%';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('{$MYSQL_ROOT_PASSWORD}');
FLUSH PRIVILEGES;
