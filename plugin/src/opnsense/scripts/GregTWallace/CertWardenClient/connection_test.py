#!/usr/local/bin/python3

import json
import os
import requests

from configparser import ConfigParser

HEALTH_ENDPOINT = "/certwarden/api/health"
CERTWARDEN_CLIENT_CONFIG = "/usr/local/etc/certwardenclient.conf"

# check_health sends an HTTPS request to the specified host:port of a (hopefully) Cert
# Warden instance and returns that status
def check_health(hostname, port):
  # check health endpoint
  try:
    response = requests.get("https://" + hostname + ":" + str(port) + "/certwarden/api/health")
  except:
    # failed to do request
    return "Failed: Health endpoint request failed."
  # if response ok, return status 'ok'
  if response.ok:
    return "ok"

  # repsonse not ok -> failed
  return "Failed: Health endpoint response not ok."


# main
result = "Failed: Config file not found."

if os.path.exists(CERTWARDEN_CLIENT_CONFIG):
    cnf = ConfigParser()
    cnf.read(CERTWARDEN_CLIENT_CONFIG)
    if cnf.has_section('settings'):
      # get config values to test
      hostname = cnf.get('settings', 'CertWardenHostname')
      port = cnf.get('settings', 'CertWardenPort')

      result = check_health(hostname, port)

    else:
      result = "Failed: Config file missing `settings` section."

# print essentially "returns" the value to OPNsense
print(result)
