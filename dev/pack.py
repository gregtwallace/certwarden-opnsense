import os.path
import tarfile


# this script's location
script_dir = dirname = os.path.dirname(__file__)

# paths relevant to this script
plugin_src = os.path.join(script_dir, "../plugin/src/opnsense")
output_filename = os.path.join(script_dir, "../dev/cw.tar.gz")

# pack it
with tarfile.open(output_filename, "w:gz") as tar:
    tar.add(plugin_src, arcname=os.path.basename(plugin_src))
