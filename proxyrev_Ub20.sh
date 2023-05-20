dom="chila.intresco.co"
oIP="146.190.73.24"
ndb="INTRESCO"

apt update
apt-get install nginx -y
cd
git clone https://github.com/agavariat/dominio.git
mv dominio/dominio /etc/nginx/sites-available/$dom
cd /etc/nginx/sites-available
cat <<EOF > $dom
upstream odoosrv$ndb {
	server 127.0.0.1:8069 weight=1 fail_timeout=0;
}
 upstream odoolong$ndb {
	server 127.0.0.1:8072 weight=1 fail_timeout=0;
}
server {
    listen 80;
    server_name $dom www.$dom $oIP;
}
server {
    listen 443 ssl;
    server_name $dom www.$dom $oIP;      
    # increase maximum accepted body size
	client_max_body_size 2000m;
    # increase proxy buffer to handle large Odoo web requests
    proxy_buffers 16 64k;
    proxy_buffer_size 128k;
    # general proxy config
    proxy_connect_timeout 3600s;
    proxy_send_timeout 3600s;
    proxy_read_timeout 3600s;
    proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;
    # proxy headers
    
    # for the dbfilter_from_header module
	proxy_set_header X-Odoo-dbfilter $ndb;
    # default settings
	proxy_redirect off;
	proxy_buffering off;
    # enable ssl
   
    #log file locations
	access_log /var/log/nginx/odoo-access.log;
	error_log /var/log/nginx/odoo-error.log;
    # enable gzip
	gzip_types text/css text/less text/plain text/xml application/xml application/json application/javascript;
	gzip on;
    # proxy requests to the appropriate upstream
	location / {
		proxy_redirect off;
		proxy_pass http://odoosrv$ndb;	
	}
	location /longpolling {
		proxy_redirect off;
		proxy_pass http://odoolong$ndb;
	}
}
EOF
cd /etc/nginx/sites-available
sed -i '24i\
	return 301 https://chila.intresco.co$request_uri;' $dom
cd /etc/nginx/sites-available
sed -i '31i\
	proxy_set_header Host $host;
	proxy_set_header X-Forwarded-Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
	proxy_set_header X-Forwarded-Proto $scheme;' $dom
ln -s /etc/nginx/sites-available/$dom /etc/nginx/sites-enabled/$dom
cd /etc/odoo
find /etc/odoo/ -name "*.conf" -print | xargs sed -i "s/proxy_mode = False/#proxy_mode = False/"
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
systemctl restart nginx
apt-get update
apt-get install software-properties-common
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
sudo apt install certbot python3-certbot-nginx
certbot --nginx -d $dom -d www.$dom
