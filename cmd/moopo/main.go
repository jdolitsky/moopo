package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"os/user"
	"path"
	"unicode"

	"github.com/Azure/golua/lua"
	"github.com/Azure/golua/std"
	"github.com/jdolitsky/goluamapper"
	"gopkg.in/yaml.v2"
)

const (
	yamlPath           = "porter.yaml"
	luaScriptPath      = "porter.lua"
	luaScriptGlobalVar = "bundle"
	postRunExecutable  = "porter"

	moonScriptPath       = "porter.moon"
	moonScriptExecutable = "moonc"
)

func main() {
	convertMoonToLua()
	convertLuaToYaml()
	runPorter()
}

func convertMoonToLua() {
	// Is porter.moon is not present, skip conversion
	if _, err := os.Stat(moonScriptPath); os.IsNotExist(err) {
		return
	}

	cmd := exec.Command(moonScriptExecutable, "-o", luaScriptPath, moonScriptPath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Run()
	check(err)
}

func convertLuaToYaml() {
	// Is porter.lua is not present, skip conversion
	if _, err := os.Stat(luaScriptPath); os.IsNotExist(err) {
		return
	}

	// Fire up Lua
	state := lua.NewState()
	defer state.Close()
	std.Open(state)

	// Evaluate the Lua script (porter.lua)
	err := state.ExecFile(luaScriptPath)
	check(err)

	// Extract the "bundle" global var and convert to Go obj
	var bundle map[interface{}]interface{}
	state.GetGlobal(luaScriptGlobalVar)
	mapper := goluamapper.NewMapper(goluamapper.Option{NameFunc: lowerCamelCase})
	err = mapper.Map(state.Pop(), &bundle)
	check(err)

	// Convert to YAML and save to porter.yaml
	out, err := yaml.Marshal(bundle)
	check(err)
	err = ioutil.WriteFile(yamlPath, out, 0644)
	check(err)
}

func runPorter() {
	// Run Porter CLI as subproccess, passing along any arguments
	cmd := exec.Command(postRunExecutable, os.Args[1:]...)
	usr, err := user.Current()
	check(err)
	cmd.Env = append([]string{
		fmt.Sprintf("PORTER_HOME=%s", path.Join(usr.HomeDir, ".porter"))},
		os.Environ()...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	check(err)
}

func lowerCamelCase(s string) string {
	a := []rune(s)
	a[0] = unicode.ToLower(a[0])
	return string(a)
}

func check(e error) {
	if e != nil {
		fmt.Println(e)
		os.Exit(1)
	}
}
