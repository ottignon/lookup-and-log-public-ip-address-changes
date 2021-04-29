#!/bin/bash

certbot renew --webroot --preferred-challenges http --post-hook "/etc/haproxy/scripts/haproxy_ssl_consolidation.sh && rc-service haproxy reload" --quiet
alpine-haproxy-1:~# cat /etc/haproxy/scripts/haproxy_ssl_consolidation.sh
#!/bin/bash
# Loop through all Let's Encrypt certificates
for CERTIFICATE in `find /etc/letsencrypt/live/* -type d`; do
  CERTIFICATE=`basename $CERTIFICATE`
  # Combine certificate and private key to single file
  cat /etc/letsencrypt/live/$CERTIFICATE/fullchain.pem /etc/letsencrypt/live/$CERTIFICATE/privkey.pem > /etc/haproxy/ssl/$CERTIFICATE.pem
done
