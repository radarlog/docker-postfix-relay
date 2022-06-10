FROM alpine:3.16

ENV RUNTIME_DEPS cyrus-sasl-login postfix postfix-pcre

RUN set -e \
    && cd /tmp \
    #
    # Install dependencies
    && apk --no-cache add --update $RUNTIME_DEPS \
    #
    # Clean up
    && rm -rf /tmp/* /var/cache/apk/*

ENV LOCAL_NETWORKS 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 127.0.0.0/8

RUN set -e \
    && postalias /etc/postfix/aliases \
    && postconf -e "maillog_file = /dev/stdout" \
    && postconf -e "mynetworks = $LOCAL_NETWORKS" \
    && postconf -e "smtpd_delay_reject = yes" \
    && postconf -e "smtpd_helo_required = yes" \
    && postconf -e "smtpd_helo_restrictions = permit_mynetworks,reject_invalid_helo_hostname,permit" \
    && postconf -e "smtpd_sender_restrictions = permit_mynetworks" \
    && postconf -e "smtp_header_checks = regexp:/etc/postfix/smtp_header_checks" \
    && postconf -e "smtp_sasl_auth_enable = yes" \
    && postconf -e "smtp_sasl_security_options = noanonymous" \
    && postconf -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" \
    && postconf -e "smtp_sasl_type = cyrus" \
    && postconf -e "smtp_sasl_tls_security_options = noanonymous" \
    && postconf -e "smtp_tls_security_level = encrypt" \
    && postconf -e "smtp_tls_wrappermode = yes" \
    && postconf -e "smtputf8_enable = no"

COPY smtp_header_checks /etc/postfix/smtp_header_checks
COPY entrypoint.sh /bin/entrypoint.sh

VOLUME ["/var/spool/postfix"]

EXPOSE 25

ENTRYPOINT ["entrypoint.sh"]
