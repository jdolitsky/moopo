<img align="right" src="lupo.png" width="140px" />

# lupo

`lupo` is a pre-processor for [Porter](https://porter.sh/) which allows you to build bundles with Lua.

## Install

*Note: system should already have a working Porter installation (see [install instructions](https://porter.sh/install/))*

Just build from source and copy into PATH (requires git, make, and Go 1.11+):
```
(
  set -x && mkdir -p $GOPATH/src/github.com/jdolitsky/ && \
  cd $GOPATH/src/github.com/jdolitsky/ && \
  [ -d lupo/ ] || git clone git@github.com:jdolitsky/lupo.git && \
  cd lupo/ && make build && sudo mv bin/lupo /usr/local/bin/
)
```

Afterwards, simply use the `lupo` command in place of the `porter` command.

## How to use
