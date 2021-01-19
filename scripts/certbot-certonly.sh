# Note: certbot require port 80 or 443

sudo systemctl stop nginx
sudo systemctl stop httpd

sudo docker run -it --rm --name certbot \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -p "80:80" \
    certbot/certbot certonly
