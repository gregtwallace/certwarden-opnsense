# used to clone https://github.com/opnsense/core so the IDE doesn't complain about
# things like `Undefined type`

# save original dir
Push-Location

# try to update the core repo
try {
  if (Test-Path -Path "./core") {
    Set-Location "./core"
  } else {
    throw "core path missing"
  }

  $res = git pull
  Write-Host $res
  if ($null -eq $res) {
    throw "git pull failed"
  }
  Pop-Location

} catch {
  # update failed, delete folder and clone
  # Return to original dir
  Pop-Location

  $doClone = Read-Host -Prompt "Failed to git pull `core` repo. Delete `./core` directory and clone from GitHub? (Yy)"
  
  if (($doClone -eq "Y") -or ($doClone -eq "y") -or ($doClone -eq "")) {
    if (Test-Path -Path "./core") {
      Get-ChildItem -Path "./core" -Recurse | Remove-Item -Force -Recurse -Confirm:$false
      Remove-Item "./core" -Force -Recurse -Confirm:$false
    }

    git clone "https://github.com/opnsense/core"
  }
}
