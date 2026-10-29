#!/usr/bin/env python3 
import os
import time
import urllib.request

    creds_path = "/etc/crowdsec/local_api_credentials.yaml"
    print(f"Waiting for CrowdSec credentials file at {creds_path}...")
      while not os.path.exists(creds_path):
        time.sleep(2)
    print("Credentials file found. Starting exporter logic...")

