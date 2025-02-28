#!/usr/local/bin/python3

import json
import os
import requests

from configparser import ConfigParser

# API Endpoints
CW_API_CERT_PATH = "/certwarden/api/v1/download/certificates"
CW_API_PRIVATE_KEY_PATH = "/certwarden/api/v1/download/privatekeys"

# Config
CERTWARDEN_CLIENT_CONFIG = "/usr/local/etc/certwardenclient.conf"



# fetch_from_cw is a function to do an API call to cert warden
def fetch_from_cw(hostname, port, objName, objAPIKey, endpointPath):
  endpoint = "https://" + hostname + ":" + str(port) + endpointPath + "/" + objName
  headers = {
    "User-Agent": "OPNsense Firewall",
    "x-api-key": objAPIKey
  }

  # do request
  result = {}
  try:
    response = requests.get(url=endpoint, headers=headers)
    if response.status_code != 200:
      result = {
        "status": "failed",
        "message": f"status code {response.status_code}"
      }
    else:
      result = {
        "status": "ok",
        "data": response.content.decode("utf-8")
      }

  except:
    result = {
        "status": "failed",
        "message": "unknown request error"
      }

  return result



# main
def main():
  try:
    # verify config exists
    if not os.path.exists(CERTWARDEN_CLIENT_CONFIG):
      return {
        "status": "failed",
        "message": "config file not found"
      }

    # read config
    cnf = ConfigParser()
    cnf.read(CERTWARDEN_CLIENT_CONFIG)
    if not cnf.has_section('settings'):
      return {
        "status": "failed",
        "message": "config file missing `settings` section"
      }

    # get config values
    hostname = cnf.get('settings', 'CertWardenHostname')
    port = cnf.get('settings', 'CertWardenPort')

    certName = cnf.get('settings', 'CertificateName')
    certAPIKey = cnf.get('settings', 'CertificateAPIKey')
    keyName = cnf.get('settings', 'PrivateKeyName')
    keyAPIKey = cnf.get('settings', 'PrivateKeyAPIKey')

    # fetch cert
    certResult = fetch_from_cw(hostname, port, certName, certAPIKey, CW_API_CERT_PATH)
    if not certResult["status"] == "ok":
      return {
        "status": "failed",
        "message": f"cert fetch failed {certResult['message']}"
      }
    
    # fetch key
    keyResult = fetch_from_cw(hostname, port, keyName, keyAPIKey, CW_API_PRIVATE_KEY_PATH)
    if not keyResult["status"] == "ok":
      return {
        "status": "failed",
        "message": f"key fetch failed {keyResult['message']}"
      }

    # return result
    return {
      "status": "ok",
      "certificate": certResult["data"],
      "private_key": keyResult["data"],
    }

  except:
    return {
      "status": "failed",
      "message": "unknown error"
    }



# run main -- print essentially "returns" the value to OPNsense
print(json.dumps(main()))
