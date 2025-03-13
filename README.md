# ruvchain-docker / ruvchain

Run [ruvchain-go](https://ruvcoindev.github.io/) node in a Docker container

## Usage

```bash
## Build container (optional)
$ docker build -t ruvcoindev/ruvchain .

## Create config and action file (if you don't the config will be
## generated on first run)
$ tree
.
└── ruvchain.conf

0 directories, 2 files

## Execute ruvchain node
$ docker run --rm -ti --net=host --cap-add=NET_ADMIN --device=/dev/net/tun -v $(pwd):/config ruvchain/ruvchain
```
