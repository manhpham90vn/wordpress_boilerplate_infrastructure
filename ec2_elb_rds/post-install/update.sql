CREATE DATABASE wordpress;
USE wordpress;
UPDATE wp_options SET option_value = 'https://runtimedev.com' WHERE option_name = 'siteurl';
UPDATE wp_options SET option_value = 'https://runtimedev.com' WHERE option_name = 'home';