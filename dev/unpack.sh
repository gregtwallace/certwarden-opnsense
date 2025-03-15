# unpacks the file to the correct path of an OPNsense installation for testing
tar xfz "./cw.tar.gz" -C /usr/local

# make scripts executable
chmod +x /usr/local/opnsense/scripts/GregTWallace/CertWardenClient/*

# do some reloading
/usr/local/etc/rc.d/configd restart
/usr/local/opnsense/mvc/script/run_migrations.php GregTWallace/CertWardenClient
/usr/local/etc/rc.configure_plugins POST_INSTALL
/usr/local/sbin/configctl template reload GregTWallace/CertWardenClient
