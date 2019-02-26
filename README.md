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
name = "my-bundle"
version = "0.1.0"
description = "this application is extremely important"

-- Example of pushing to your personal Docker Hub account,
-- assuming USER env var matches your Docker Hub username
-- (make sure you create the "my-bundle" repo ahead of time)
registry_host = "docker.io"
registry_repo = os.getenv("USER").."/"..name

-- Class that represents our app
class MyApp
    new: =>
        @bundle = {
            name: name,
            version: version,
            description: description,
            invocationImage: registry_host.."/"..registry_repo..":"..version,
            mixins: {},
            install: {},
            uninstall: {}
        }

    add_mixin: (mixin) =>
        table.insert(@bundle.mixins, mixin)

    add_install_step: (step) =>
        table.insert(@bundle.install, step)

    add_uninstall_step: (step) =>
        table.insert(@bundle.uninstall, step)

-- Method that returns valid input for exec mixin
echo = (desc, msg) ->
    {exec: {description: desc, command: "bash", arguments: { "-c", "echo "..msg}}}

-- Create bundle and modify
app = MyApp!
app\add_mixin("exec")
app\add_install_step(echo("Install "..name, "Hello World"))
app\add_uninstall_step(echo("Uninstall "..name, "Goodbye World"))

-- Export bundle
export bundle = app.bundle
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

If a file named `porter.moon` is detected in the working directory, `moopo` will attempt to use this to generate a `porter.yaml` file in the format expected by Porter, then run Porter itself.

Note: if there is an existing `porter.yaml`, it will be completely overwritten. You may even wish to place `porter.yaml` (and `porter.lua`) in your `.gitignore`, as it is dynamically generated each run.
