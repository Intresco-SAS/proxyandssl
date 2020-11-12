dom="electroventiladores.intresco.co"
oIP="18.191.194.218"
apt-get install nginx -y
cd
git clone https://github.com/agavariat/dominio.git
mv dominio/dominio /etc/nginx/sites-available/$dom
cd /etc/nginx/sites-available
cat <<EOF > $dom
server {
  server_name $dom www.$dom $oIP;
  listen 80;
  access_log /var/log/nginx/testing-access.log;
  error_log /var/log/nginx/testing-error.log;
  location /longpolling {
  proxy_connect_timeout 3600;
  proxy_read_timeout 3600;
  proxy_send_timeout 3600;
  send_timeout 3600;
  proxy_pass http://127.0.0.1:8072;
  }
  location / {
  proxy_connect_timeout 3600;
  proxy_read_timeout 3600;
  proxy_send_timeout 3600;
  send_timeout 3600;
  proxy_pass http://127.0.0.1:8069;
  proxy_set_header Host \$host:\$server_port;
  proxy_set_header X-Forwarded-Host \$host;
  proxy_set_header X-Real-IP \$remote_addr;
  proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
  }
  gzip on;
  gzip_min_length 1000;
  }
upstream odoo {
    server 127.0.0.1:8069 weight=1 fail_timeout=0;
}
upstream odoo-im {
    server 127.0.0.1:8072 weight=1 fail_timeout=0;
  }
EOF

ln -s /etc/nginx/sites-available/$dom /etc/nginx/sites-enabled/$dom
cd /etc/odoo
echo "proxy_mode = True" >> odoo.conf
echo "xmlrpc_interface = 127.0.0.1" >> odoo.conf
echo "netrpc_interface = 127.0.0.1" >> odoo.conf
cd /etc/nginx/sites-enabled
rm default
cd /etc/nginx/sites-available
rm default
cd
ufw allow 22
ufw allow 8069
ufw allow 'Nginx Full'
ufw enable
service odoo restart
service nginx restart
apt-get update
apt-get install software-properties-common
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt-get install -y python3-certbot-nginx
certbot --nginx
cd /etc/nginx/
sed -i '12iclient_max_body_size 100M;' nginx.conf
