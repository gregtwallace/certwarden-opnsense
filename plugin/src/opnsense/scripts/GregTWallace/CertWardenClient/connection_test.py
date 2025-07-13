#!/usr/local/bin/python3

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
def main():
  if not os.path.exists(CERTWARDEN_CLIENT_CONFIG):
    return "Failed: Plugin not configured."
  
  cnf = ConfigParser()
  cnf.read(CERTWARDEN_CLIENT_CONFIG)
  if not cnf.has_section('settings'):
    return "Failed: Plugin not configured."

  # get config values to test
  hostname = cnf.get('settings', 'CertWardenHostname')
  port = cnf.get('settings', 'CertWardenPort')

  return check_health(hostname, port)


# run main and print result (essentially "returns" the value to OPNsense)
print(main())
