FROM alpine:latest

RUN apk update && apk upgrade && apk add --no-cache libgcc libstdc++ curl jq xz wget tzdata
ARG zone=Etc/UTC
RUN cp /usr/share/zoneinfo/${zone} /etc/localtime

ARG artifact=".+"
RUN adduser -S cfx
WORKDIR /home/cfx
RUN mkdir server
RUN hash=$(curl -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/citizenfx/fivem/tags?per_page=100" | \
        jq -r 'first(.[] | {name: .name | match("v1.0.0.('${artifact}')").captures | .[].string, hash: .commit.sha} | join("-"))') && \
    wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$hash/fx.tar.xz
RUN tar xf fx.tar.xz

RUN apk del curl jq xz wget tzdata

EXPOSE 30120/tcp 30120/udp
EXPOSE 40120

ENTRYPOINT ["sh", "/home/cfx/run.sh"]
