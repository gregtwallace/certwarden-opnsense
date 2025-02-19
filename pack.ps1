# pack the plugin for testing on the dev instance of OPNsense
Push-Location

Set-Location "./plugin/src"
tar -cvzf "../../cw.tar.gz" .

Pop-Location
