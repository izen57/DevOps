#!/bin/sh
#stub_status

IS_UP=$(systemctl is-active --quiet nginx.service && echo 1 || echo 0)
if [ $IS_UP -lt 1 ]
then
EXPORT="
nginx_up $IS_UP"
else
STUB_STATUS_PAGE=$(curl http://localhost/metrics)
CONS_ACTIVE=$(echo $STUB_STATUS_PAGE | awk '{print $3}')
CONS_ACCEPT=$(echo $STUB_STATUS_PAGE | awk '{print $8}')
CONS_HANDLE=$(echo $STUB_STATUS_PAGE | awk '{print $9}')
REQUESTS=$(echo $STUB_STATUS_PAGE | awk '{print $10}')
READING=$(echo $STUB_STATUS_PAGE | awk '{print $12}')
WRITING=$(echo $STUB_STATUS_PAGE | awk '{print $14}')
WAITING=$(echo $STUB_STATUS_PAGE | awk '{print $16}')

EXPORT="
nginx_connections_active $CONS_ACTIVE\n\
nginx_connections_accepted $CONS_ACCEPT\n\
nginx_connections_handled $CONS_HANDLE\n\
nginx_http_requests_total $REQUESTS\n\
nginx_connections_reading $READING\n\
nginx_connections_writing $WRITING\n\
nginx_connections_waiting $WAITING\n\
nginx_up $IS_UP"
fi

echo "$EXPORT" > /var/lib/node_exporter/textfile_collector/nginx_status.prom
