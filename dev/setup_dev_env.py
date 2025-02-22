# used to clone https://github.com/opnsense/core so the IDE doesn't complain about
# things like `Undefined type`

import os
import shutil
import subprocess
import sys


# this script's location
script_dir = dirname = os.path.dirname(__file__)

# paths relevant to this script
base_dir = os.path.join(script_dir, "../")
core_dir = os.path.join(base_dir, "./core")

try:
  # confirm core dir exists as expected
  coreExists = os.path.exists(core_dir)
  if not coreExists:
    raise Exception("core dir is missing")
  
  # confirm the top level git path is the expected one
  gitDir = subprocess.check_output(["git", "rev-parse", "--show-toplevel"], cwd=core_dir).strip().decode('ascii')
  if (os.path.realpath(core_dir, strict=True) != os.path.realpath(gitDir, strict=True)):
    raise Exception("core dir git project not found")

  # if, so try to git pull
  pullOutput = subprocess.check_output(["git", "pull"], cwd=core_dir).strip().decode('ascii')
  print(pullOutput)

except:
  redoCore = input("Error encountered with core or git. Delete ./core path and re clone (y/N)? ")
  if not (redoCore == "Y" or redoCore == "y"):
    sys.exit("error: problem with core")
  
  # remove old core
  shutil.rmtree(core_dir)

  # clone it again
  cloneOutput = subprocess.check_output(["git", "clone", "https://github.com/opnsense/core"], cwd=base_dir).strip().decode('ascii')
  print(cloneOutput)
