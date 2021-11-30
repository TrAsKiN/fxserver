FROM alpine:latest

ARG artifact=".+"

RUN apk update
RUN apk add --no-cache curl jq xz wget tzdata

RUN adduser -S cfx
WORKDIR /home/cfx
RUN hash=$(curl -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/citizenfx/fivem/tags?per_page=100" | \
        jq -r 'first(.[] | {name: .name | match("v1.0.0.('${artifact}')").captures | .[].string, hash: .commit.sha} | join("-"))') && \
    wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$hash/fx.tar.xz
RUN tar xf fx.tar.xz && rm fx.tar.xz

RUN cp /home/cfx/alpine/etc/apk/repositories /etc/apk/repositories
RUN apk -U upgrade
RUN apk add --no-cache libgcc libstdc++
RUN apk del curl jq xz wget tzdata

EXPOSE 30120/tcp 30120/udp
EXPOSE 40120

ENTRYPOINT ["sh", "/home/cfx/run.sh"]
