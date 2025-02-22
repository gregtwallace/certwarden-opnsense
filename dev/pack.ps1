# pack the plugin for testing on the dev instance of OPNsense
Push-Location

# assumes this script is called from the repo root path
Set-Location "./plugin/src"

tar -cvzf "../../dev/cw.tar.gz" .

Pop-Location
