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
core_git_dir = os.path.join(core_dir, "./.git")

try:
  # confirm core dir exists as expected
  coreExists = os.path.exists(core_dir)
  if not coreExists:
    raise Exception("core dir is missing")

  coreGitExists = os.path.exists(core_git_dir)
  if not coreGitExists:
    raise Exception("core git dir is missing")

  # if, so try to git pull
  process = subprocess.Popen(["git", "pull"], cwd=core_dir, stdout=subprocess.PIPE)
  output = process.communicate()[0]
  print(output)

except:
  redoCore = input("Error encountered with core or git. Delete ./core path and re clone (y/N)? ")
  if not (redoCore == "Y" or redoCore == "y"):
    sys.exit("error: problem with core")
  
  # remove old core
  shutil.rmtree(core_dir)

  # clone it again
  process = subprocess.Popen(["git", "clone", "https://github.com/opnsense/core"], cwd=base_dir, stdout=subprocess.PIPE)
  output = process.communicate()[0]
  print(output)
