##Crear carpeta donde se instalara###################
mkdir /opt/odoo
###Crear tantas carpetas como odoo se vayan a instalara############
####carpeta 1#####
cd /opt/odoo
mkdir p1.intresco.co
cd p1.intresco.co
mkdir addons
mkdir config
cd config
touch odoo.conf
cat <<EOF > odoo.conf
[options]
addons_path = mnt/extra-addons
data_dir = /var/lib/odoo
admin_passwd = admin
db_host = db1
db_password = odoo
db_port = 5432
db_user = odoo
csv_internal_sep = ,
list_db = True
proxy_mode = True
dbfilter = .*
EOF
chmod 777 odoo.conf
cd /opt/odoo
chmod 777 -R p1.intresco.co
####carpeta 2#####
mkdir p2.intresco.co
cd p2.intresco.co
mkdir addons
mkdir config
cd config
touch odoo.conf
cat <<EOF > odoo.conf
[options]
addons_path = mnt/extra-addons
data_dir = /var/lib/odoo
admin_passwd = admin
db_host = db2
db_password = odoo
db_port = 5432
db_user = odoo
csv_internal_sep = ,
list_db = True
proxy_mode = True
dbfilter = .*
EOF
chmod 777 odoo.conf
cd /opt/odoo
chmod 777 -R p2.intresco.co
###carpeta 3#####
mkdir p3.intresco.co
cd p3.intresco.co
mkdir addons
mkdir config
cd config
touch odoo.conf
cat <<EOF > odoo.conf
[options]
addons_path = mnt/extra-addons
data_dir = /var/lib/odoo
admin_passwd = admin
db_host = db3
db_password = odoo
db_port = 5432
db_user = odoo
csv_internal_sep = ,
list_db = True
proxy_mode = True
dbfilter = .*
EOF
chmod 777 odoo.conf
cd /opt/odoo
chmod 777 -R p3.intresco.co
####carpeta 4#####
mkdir p4.intresco.co
cd p4.intresco.co
mkdir addons
mkdir config
cd config
touch odoo.conf
cat <<EOF > odoo.conf
[options]
addons_path = mnt/extra-addons
data_dir = /var/lib/odoo
admin_passwd = admin
db_host = db4
db_password = odoo
db_port = 5432
db_user = odoo
csv_internal_sep = ,
list_db = True
proxy_mode = True
dbfilter = .*
EOF
chmod 777 odoo.conf
cd /opt/odoo
chmod 777 -R p4.intresco.co
####carpeta 5#####
mkdir p5.intresco.co
cd p5.intresco.co
mkdir addons
mkdir config
cd config
touch odoo.conf
cat <<EOF > odoo.conf
[options]
addons_path = mnt/extra-addons
data_dir = /var/lib/odoo
admin_passwd = admin
db_host = db5
db_password = odoo
db_port = 5432
db_user = odoo
csv_internal_sep = ,
list_db = True
proxy_mode = True
dbfilter = .*
EOF
chmod 777 odoo.conf
cd /opt/odoo
chmod 777 -R p5.intresco.co
mkdir nginx
chmod 777 nginx
cd nginx
mkdir conf
cd conf
touch default.conf
cat <<EOF > default.conf
############aplicacion_1#######################################
upstream odoo1 {
       server odoo1:8069;
}
server {
listen [::]:80;
listen 80;
server_name p1.intresco.co www.p1.intresco.co;
location ^~ /.well-known/acme-challenge {
             root /var/www/html/;
             allow all;
}
# increase proxy buffer to handle some Odoo web requests
proxy_buffers 16 64k;
proxy_buffer_size 128k;
# Specifies the maximum accepted body size of a client request,
# as indicated by the request header Content-Length.
client_max_body_size 200m;
location / {
proxy_pass http://odoo1;
# force timeouts if the backend dies
proxy_connect_timeout 75s;
proxy_read_timeout 600s;
proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
proxy_redirect off;
# set headers
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
# cache some static data in memory for 60mins.
# under heavy load this should relieve stress on the OpenERP web interface a bit.
location ~* /web/static/ {
proxy_cache_valid 200 60m;
proxy_buffering on;
expires 864000;
proxy_pass http://odoo1;
}
}

############aplicacion_2#######################################
upstream odoo2 {
       server odoo2:8069;
}
server {
listen [::]:80;
listen 80;
server_name p2.intresco.co www.p2.intresco.co;
location ^~ /.well-known/acme-challenge {
             root /var/www/html/;
             allow all;
}
# increase proxy buffer to handle some Odoo web requests
proxy_buffers 16 64k;
proxy_buffer_size 128k;
# Specifies the maximum accepted body size of a client request,
# as indicated by the request header Content-Length.
client_max_body_size 200m;
#
location / {
proxy_pass http://odoo2;
# force timeouts if the backend dies
proxy_connect_timeout 75s;
proxy_read_timeout 600s;
proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
proxy_redirect off;
# set headers
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
# cache some static data in memory for 60mins.
# under heavy load this should relieve stress on the OpenERP web interface a bit.
location ~* /web/static/ {
proxy_cache_valid 200 60m;
proxy_buffering on;
expires 864000;
proxy_pass http://odoo2;
}
}
############aplicacion_3#######################################
upstream odoo3 {
       server odoo3:8069;
}
server {
listen [::]:80;
listen 80;
server_name p3.intresco.co www.p3.intresco.co;
location ^~ /.well-known/acme-challenge {
             root /var/www/html/;
             allow all;
}
# increase proxy buffer to handle some Odoo web requests
proxy_buffers 16 64k;
proxy_buffer_size 128k;
# Specifies the maximum accepted body size of a client request,
# as indicated by the request header Content-Length.
client_max_body_size 200m;

#
location / {
proxy_pass http://odoo3;
# force timeouts if the backend dies
proxy_connect_timeout 75s;
proxy_read_timeout 600s;
proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
proxy_redirect off;
# set headers
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
# cache some static data in memory for 60mins.
# under heavy load this should relieve stress on the OpenERP web interface a bit.
location ~* /web/static/ {
proxy_cache_valid 200 60m;
proxy_buffering on;
expires 864000;
proxy_pass http://odoo3;
}
}

############aplicacion_4#######################################
upstream odoo4 {
       server odoo4:8069;
}
server {
listen [::]:80;
listen 80;
server_name p4.intresco.co www.p4.intresco.co;
location ^~ /.well-known/acme-challenge {
             root /var/www/html/;
             allow all;
}
# increase proxy buffer to handle some Odoo web requests
proxy_buffers 16 64k;
proxy_buffer_size 128k;
# Specifies the maximum accepted body size of a client request,
# as indicated by the request header Content-Length.
client_max_body_size 200m;
#
location / {
proxy_pass http://odoo3;
# force timeouts if the backend dies
proxy_connect_timeout 75s;
proxy_read_timeout 600s;
proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
proxy_redirect off;
# set headers
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
# cache some static data in memory for 60mins.
# under heavy load this should relieve stress on the OpenERP web interface a bit.
location ~* /web/static/ {
proxy_cache_valid 200 60m;
proxy_buffering on;
expires 864000;
proxy_pass http://odoo3;
}
}
############aplicacion_5#######################################
upstream odoo5 {
       server odoo5:8069;
}
server {
listen [::]:80;
listen 80;
server_name p5.intresco.co www.p5.intresco.co;
location ^~ /.well-known/acme-challenge {
             root /var/www/html/;
             allow all;
}
# increase proxy buffer to handle some Odoo web requests
proxy_buffers 16 64k;
proxy_buffer_size 128k;
# Specifies the maximum accepted body size of a client request,
# as indicated by the request header Content-Length.
client_max_body_size 200m;
#
location / {
proxy_pass http://odoo3;
# force timeouts if the backend dies
proxy_connect_timeout 75s;
proxy_read_timeout 600s;
proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
proxy_redirect off;
# set headers
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
# cache some static data in memory for 60mins.
# under heavy load this should relieve stress on the OpenERP web interface a bit.
location ~* /web/static/ {
proxy_cache_valid 200 60m;
proxy_buffering on;
expires 864000;
proxy_pass http://odoo3;
}
}
EOF
cd /opt/odoo
chmod 777 -R nginx
touch docker-compose.yml
chmod docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3'
services:
  odoo1:
    container_name: odoo1
    image: odoo:12
    depends_on:
      - db1
    ports:
      - "8074:8069"
    volumes:
      - odoo-web-data1:/var/lib/odoo
      - ./p1.intresco.co/config:/etc/odoo
      - ./p1.intresco.co/addons:/mnt/extra-addons
  db1:
    container_name: db1
    image: postgres:10
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=odoo
      - POSTGRES_USER=odoo
      - PGDATA=/var/lib/postgresql/data/pgdata
  odoo2:
    container_name: odoo2
    image: odoo:12
    depends_on:
      - db2
    ports:
      - "8075:8069"
    volumes:
      - odoo-web-data2:/var/lib/odoo
      - ./p2.intresco.co/config:/etc/odoo
      - ./p2.intresco.co/addons:/mnt/extra-addons
  db2:
    container_name: db2
    image: postgres:10
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=odoo
      - POSTGRES_USER=odoo
      - PGDATA=/var/lib/postgresql/data/pgdata
  odoo3:
    container_name: odoo3
    image: odoo:12
    depends_on:
      - db3
    ports:
      - "8076:8069"
    volumes:
      - odoo-web-data3:/var/lib/odoo
      - ./p3.intresco.co/config:/etc/odoo
      - ./p3.intresco.co/addons:/mnt/extra-addons
  db3:
    container_name: db3
    image: postgres:10
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=odoo
      - POSTGRES_USER=odoo
      - PGDATA=/var/lib/postgresql/data/pgdata
  odoo4:
    container_name: odoo4
    image: odoo:13
    depends_on:
      - db4
    ports:
      - "8077:8069"
    volumes:
      - odoo-web-data4:/var/lib/odoo
      - ./p4.intresco.co/config:/etc/odoo
      - ./p4.intresco.co/addons:/mnt/extra-addons
  db4:
    container_name: db4
    image: postgres:10
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=odoo
      - POSTGRES_USER=odoo
      - PGDATA=/var/lib/postgresql/data/pgdata
  odoo5:
    container_name: odoo5
    image: odoo:13
    depends_on:
      - db5
    ports:
      - "8078:8069"
    volumes:
      - odoo-web-data5:/var/lib/odoo
      - ./p5.intresco.co/config:/etc/odoo
      - ./p5.intresco.co/addons:/mnt/extra-addons
  db5:
    container_name: db5
    image: postgres:10
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=odoo
      - POSTGRES_USER=odoo
      - PGDATA=/var/lib/postgresql/data/pgdata
  nginx:
    container_name: nginx
    image: nginx:latest
    restart: unless-stopped
    ports:
      - 80:80
      - 443:443
    volumes:
      - ./nginx/conf:/etc/nginx/conf.d
      - ./certbot/conf:/etc/nginx/ssl
      - ./certbot/data:/var/www/html
  certbot:
    container_name: certbot
    image: certbot/certbot:latest
    command: certonly --webroot --webroot-path=/var/www/html --email info@intresco.co --agree-tos --no-eff-email -d p1.intresco.co -d www.p1.intresco.co
    command: certonly --webroot --webroot-path=/var/www/html --email info@intresco.co --agree-tos --no-eff-email -d p2.intresco.co -d www.p2.intresco.co
    command: certonly --webroot --webroot-path=/var/www/html --email info@intresco.co --agree-tos --no-eff-email -d p3.intresco.co -d www.p3.intresco.co
    command: certonly --webroot --webroot-path=/var/www/html --email info@intresco.co --agree-tos --no-eff-email -d p4.intresco.co -d www.p4.intresco.co
    command: certonly --webroot --webroot-path=/var/www/html --email info@intresco.co --agree-tos --no-eff-email -d p5.intresco.co -d www.p5.intresco.co
    volumes:
      - ./certbot/conf:/etc/letsencrypt
      - ./certbot/data:/var/www/html
volumes:
  odoo-web-data1:
  odoo-web-data2:
  odoo-web-data3:
  odoo-web-data4:
  odoo-web-data5:
  odoo-db-data:
EOF
mkdir certbot
cd cerbot
mkdir conf
mkdir data
cd conf
mkdir live
touch options-ssl-nginx.conf
cat <<EOF > options-ssl-nginx.conf
ssl_session_cache shared:le_nginx_SSL:10m;
ssl_session_timeout 1440m;
ssl_session_tickets off;
ssl_protocols TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers off;
ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
EOF
touch ssl-dhparams.pem
cat <<EOF > ssl-dhparams.pem
-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEA//////////+t+FRYortKmq/cViAnPTzx2LnFg84tNpWp4TZBFGQz
+8yTnc4kmz75fS/jY2MMddj2gbICrsRhetPfHtXV/WVhJDP1H18GbtCFY2VVPe0a
87VXE15/V8k1mE8McODmi3fipona8+/och3xWKE2rec1MKzKT0g6eXq8CrGCsyT7
YdEIqUuyyOP7uWrat2DX9GgdT0Kj3jlN9K5W7edjcrsZCwenyO4KbXCeAvzhzffi
7MA0BM0oNC9hkXL+nOmFg/+OTxIy7vKBg8P+OxtMb61zO7X8vC7CIAXFjvGDfRaD
ssbzSibBsu/6iGtCOGEoXJf//////////wIBAg==
-----END DH PARAMETERS-----
EOF
cd /opt/odoo
chmod 600 -R certbot
