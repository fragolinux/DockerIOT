# LEMP SETUP

This will bring up a full LEMP stack (Linux/Nginx/MariaDB/PhpMyAdmin). BEWARE: 1st run will be slower because it needs to build the php container image, next runs will be much quicker.

Nginx docs folder is under `data/www` and contains a default `index.php` to show it works, exposed on default port `80` (no ssl for now, if requested I could add it, with self signed certificates).

PhpMyAdmin is on port `8080`, user is `root` and password is the same of MariaDB, which should be set in the `.env` file.
