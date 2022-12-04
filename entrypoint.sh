#!/bin/sh
set -e

SASL_PASSWD_FILE=/etc/postfix/sasl_passwd

postconf -e "relayhost = [$RELAY_HOST]:$RELAY_PORT"

echo "[$RELAY_HOST]:$RELAY_PORT $RELAY_USER:$RELAY_PASS" > $SASL_PASSWD_FILE
chmod 600 $SASL_PASSWD_FILE
postmap $SASL_PASSWD_FILE

postfix check

exec $@
