# Postfix
[Postfix](http://www.postfix.org/) is a free and open-source mail transfer agent (MTA)
that routes and delivers electronic mail.

## FEATURES
Current docker image is built from [alpine](https://hub.docker.com/_/alpine/) for using as a relay server.

## USAGE

```shell
docker run --name radarlog_postfix_relay \
    -e RELAY_HOST=some_relay_host \
    -e RELAY_PORT=some_relay_port
    -e RELAY_USER=some_relay_user
    -e RELAY_PASS=some_relay_pass
    -p 25:25 \
    radarlog/postfix-relay
```

