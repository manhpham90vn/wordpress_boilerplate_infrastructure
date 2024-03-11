#!/bin/bash

sudo chown -R apache:apache /usr/share/nginx/html
sudo find /usr/share/nginx/html -type d -exec chmod 755 {} \;
sudo find /usr/share/nginx/html -type f -exec chmod 644 {} \;