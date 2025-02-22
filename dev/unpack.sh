# unpacks the file to the correct path of an OPNsense installation for testing
tar xfz "./cw.tar.gz" -C /usr/local

# make scripts executable
chmod +x /usr/local/opnsense/scripts/GregTWallace/CertWardenClient/*
