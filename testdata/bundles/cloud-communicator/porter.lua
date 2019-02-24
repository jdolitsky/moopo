local name = "my-installer"
local version = "0.1.0"

-- Example of pushing to your personal Docker Hub account,
-- assuming USER env var matches your Docker Hub username
local registryHost = "docker.io"
local registryRepo = os.getenv("USER") .. "/" .. name

local command = "/usr/local/bin/talk-to-the-cloud"
local provider = "aws"
local installArgs = {"--setup", "--provider", provider, "-f", provider .. "-setup.conf"}
local uninstallArgs = {"--teardown", "--provider", provider, "-f", provider .. "-teardown.conf"}

bundle = {
    name =  name,
    version = version,
    description = "this thing talks to the cloud. no joke.",
    invocationImage = registryHost .. "/" .. registryRepo .. ":" .. version,
    mixins = {"exec"},
    install = {
        {
            description = "Install " .. name,
            exec = {command = command, arguments = installArgs}
        }
    },
    uninstall = {
        {
            description = "Uninstall " .. name,
            exec = {command = command, arguments = uninstallArgs}
        }
    }
}