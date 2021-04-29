#!/bin/bash

certbot renew --webroot --preferred-challenges http --post-hook "/etc/haproxy/scripts/haproxy_ssl_consolidation.sh && rc-service haproxy reload" --quiet
