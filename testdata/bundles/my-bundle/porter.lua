local name = "my-bundle"
local version = "0.1.0"
local description = "this application is extremely important"

-- Example of pushing to your personal Docker Hub account,
-- assuming USER env var matches your Docker Hub username
-- (make sure you create the "my-bundle" repo ahead of time)
local registryHost = "docker.io"
local registryRepo = os.getenv("USER") .. "/" .. name

-- Returns valid input for exec mixin
local function execEcho (desc, msg)
    return {description = desc, command = "bash", arguments = {"-c", "echo " .. msg}}
end

bundle = {
    name =  name,
    version = version,
    description = description,
    invocationImage = registryHost .. "/" .. registryRepo .. ":" .. version,
    mixins = {"exec"},
    install = {
        {
            exec = execEcho("Install " .. name, "Hello World")
        }
    },
    uninstall = {
        {
            exec = execEcho("Uninstall " .. name, "Goodbye World")
        }
    }
}