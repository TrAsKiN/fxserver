# FX Server for Docker

## Tags

- `latest`, `recommended`, `optional`
- All build numbers listed [here](https://hub.docker.com/r/traskin/fxserver/tags)

## Usage

### With shell command
```shell
docker run -di --name fxserver -v ${pwd}:/home/cfx/server-data -p 30120:30120/tcp -p 30120:30120/udp -p 40120:40120 traskin/fxserver:latest
```

### With Docker Compose
```yaml
version: "3.9"
services:
  fxserver:
    image: traskin/fxserver:latest
    ports:
      - 30120:30120/tcp
      - 30120:30120/udp
      - 40120:40120
    volumes:
      - .:/home/cfx/server-data
    tty: true
```
