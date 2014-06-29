USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

UPDATE user SET password=PASSWORD("dont_use_root_user") WHERE user='root';

UPDATE user SET password=PASSWORD("") WHERE user='redmine';
CREATE DATABASE IF NOT EXISTS `redmine` CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL ON `redmine`.* to 'redmine'@'%' IDENTIFIED BY '';
