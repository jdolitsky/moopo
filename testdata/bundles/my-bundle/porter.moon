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