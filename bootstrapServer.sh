#!/bin/bash

sudo apt update -y

sudo apt upgrade -y

sudo apt install python3 -y

sudo apt install python3-pip -y

sudo apt install python3-venv -y 

git clone https://github.com/username/projectName /home/ubuntu/projectName

cd projectName/

python3 -m venv venv

. venv/bin/activate

pip3 install flask

pip3 install stripe

pip3 install gunicorn

service_text=$(cat <<EOF
[Unit]
Description=Gunicorn daemon to serve my flaskapp
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/projectName
ExecStart=/home/ubuntu/projectName/venv/bin/gunicorn -b localhost:8000 app:app 2>&1
Restart=always

[Install]
WantedBy=multi-user.target
EOF
)

target_file="/etc/systemd/system/projectName.service"

echo "$service_text" | sudo tee "$target_file" > /dev/null

sudo systemctl daemon-reload

sudo systemctl start projectName

sudo systemctl enable projectName

sudo apt install nginx -y

sudo systemctl start nginx

sudo systemctl enable nginx

config_addition=$(cat <<EOF
# Default server configuration

upstream projectName {
        server 127.0.0.1:8000;
}

server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                proxy_pass http://projectName;
        }
        location /create-checkout-session {
                proxy_pass http://projectName;
        }
}
EOF
)

nginx_config_file="/etc/nginx/sites-available/default"

echo "$config_addition" | sudo tee "$nginx_config_file" > /dev/null

sudo systemctl restart nginx