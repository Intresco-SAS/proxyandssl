dom="gve.intresco.co"
oIP="54.183.157.202"
apt-get install nginx -y
cd
git clone https://github.com/agavariat/dominio.git
mv dominio/dominio /etc/nginx/sites-available/$dom
cd /etc/nginx/sites-available
cat <<EOF > $dom
upstream odoosrv {
	server 127.0.0.1:8069 weight=1 fail_timeout=0;
}
 upstream odoolong {
	server 127.0.0.1:8072 weight=1 fail_timeout=0;
}
server {
        server_name $dom www.$dom $oIP;
        access_log /var/log/nginx/testing-access.log;
        error_log /var/log/nginx/testing-error.log;
        proxy_buffers 16 64k;
        proxy_buffer_size 128k;
        #client_max_body_size 4M;
        gzip on;
        gzip_min_length 1000;
        gzip_disable "msie6";
        gzip_vary on;
        gzip_proxied any;
        gzip_comp_level 6;
        gzip_http_version 1.1;
	gzip_types text/css
		   text/javascript
		   text/xml
		   text/plain
		   image/bmpg
		   image/gif
		   image/jpeg
		   image/jpg
                   image/png
                   image/svg+xml
                   image/x-icon
                   application/javascript
                   application/json
                   application/rss+xml
                   application/vnd.ms-fontobject
                   application/x-font-ttf
                   application/x-javascript
                   application/xml
                   application/xml+rss;
        location / {
        proxy_connect_timeout 3600;
        proxy_read_timeout 3600;
        proxy_send_timeout 3600;
        send_timeout 3600;
        proxy_pass http://odoosrv;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;
        proxy_redirect off;
       }
        location /longpolling {
	proxy_pass http://odoolong;
	proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;
	proxy_redirect off;
        proxy_connect_timeout 3600;
        proxy_read_timeout 3600;
        proxy_send_timeout 3600;
        send_timeout 3600;
       }
}
EOF
cd /etc/nginx/sites-available
sed -i '46i\
	proxy_set_header Host $host:$server_port;\
        proxy_set_header X-Forwarded-Host $host;\
        proxy_set_header X-Real-IP $remote_addr;\
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\
        proxy_set_header X-Forwarded-Proto $scheme;' $dom
cd /etc/nginx/sites-available
sed -i '56i\
	proxy_set_header Host $host;\
	proxy_set_header X-Forwarded-Host $host;\
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\
	proxy_set_header X-Forwarded-Proto $scheme;\
	proxy_set_header X-Real-IP $remote_addr;' $dom
ln -s /etc/nginx/sites-available/$dom /etc/nginx/sites-enabled/$dom
cd /etc/nginx/
sed -i '12i\
	client_max_body_size 1000M;\
	server {\
                listen 80;\
        location / {\
                proxy_pass http://odoolong;\
                   }\
                }' nginx.conf
cd /etc/odoo
sed 's/proxy_mode = False/#proxy_mode = False/g' odoo.conf
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
