#!/bin/sh
echo $BIND
echo $CONFIG
s3-sftp-proxy -bind $BIND -config $CONFIG
exec "$@"