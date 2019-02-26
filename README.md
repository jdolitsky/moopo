<img align="right" src="lupo.png" width="140px" />

# moopo

`moopo` is a pre-processor for [Porter](https://porter.sh/) which allows you to build bundles with [MoonScript](https://moonscript.org/).

See also: [lupo](https://github.com/jdolitsky/lupo)

## Install

*Note: MoonScript should be installed, and system should already have a working Porter installation (see [install instructions](https://porter.sh/install/)). There must also be a `luac` executable in PATH (temporarily required by [Azure/golua](https://github.com/Azure/golua)).*

Just build from source and copy into PATH (requires git, make, and Go 1.11+):
```
(
  set -x && mkdir -p $GOPATH/src/github.com/jdolitsky/ && \
  cd $GOPATH/src/github.com/jdolitsky/ && \
  [ -d moopo/ ] || git clone git@github.com:jdolitsky/moopo.git && \
  cd moopo/ && make build && sudo mv bin/moopo /usr/local/bin/
)
```

## How to use

Simply use the `moopo` command in place of the `porter` command.

Replace your existing `porter.yaml` bundle definition with `porter.moon`.

Here is a simple `porter.moon` example (notice global `bundle` variable):
```moon
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- prints 2
```

Run `moopo` to build the bundle from `porter.moon`:
```
$ moopo build
Copying dependencies ===>
Copying mixins ===>
Copying mixin exec ===>
Copying mixin porter ===>
...
```

If a file named `porter.moon` is detected in the working directory, `moopo` will attempt to use this to generate a `porter.moon` file in the format expected by Porter, then run Porter itself.

Note: if there is an existing `porter.moon`, it will be completely overwritten. You may even wish to place `porter.moon` in your `.gitignore`, as it is dynamically generated each run.
