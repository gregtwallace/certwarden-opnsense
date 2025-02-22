# remove all CW Client folders (this is for dev use, not for removing a properly installed plugin)

# folders
rm -rf /usr/local/opnsense/mvc/app/views/GregTWallace/CertWardenClient
rm -rf /usr/local/opnsense/mvc/app/models/GregTWallace/CertWardenClient
rm -rf /usr/local/opnsense/mvc/app/controllers/GregTWallace/CertWardenClient
rm -rf /usr/local/opnsense/scripts/GregTWallace/CertWardenClient

# files
rm -f /usr/local/opnsense/service/conf/actions.d/actions_certwardenclient.conf
rm -f /usr/local/etc/certwardenclient.conf
