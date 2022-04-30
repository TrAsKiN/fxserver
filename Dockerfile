FROM alpine:edge

ARG artifact=".+"

RUN adduser -S cfx && \
    apk -U upgrade && \
    apk -U add --no-cache curl jq xz wget alpine-conf libstdc++

WORKDIR /home/cfx

RUN hash=$(curl -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/citizenfx/fivem/tags?per_page=100" | \
        jq -r 'first(.[] | {name: .name | match("v1.0.0.('${artifact}')").captures | .[].string, hash: .commit.sha} | join("-"))') && \
    wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$hash/fx.tar.xz && \
    tar xf fx.tar.xz && rm fx.tar.xz

RUN apk del curl jq xz wget

EXPOSE 30120/tcp 30120/udp 40120

ENTRYPOINT ["sh", "/home/cfx/run.sh"]
