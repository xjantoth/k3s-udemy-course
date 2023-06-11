#!/usr/bin/env python
# https://paulbrice.com/terraform/python/2017/12/18/external-provider-terraform.html

"""Script to test the external data provider in Terraform"""

import sys
import json
import time
import requests
from subprocess import check_output

    
limit = 20
sleep_time = 20

def check_api(host):
    count = 0
    while count < limit:
        try:
            response = requests.get(f"https://{host}:6443", timeout=5, verify=False)
            data = response.json()
            if data['kind'] == 'Status' and data['code'] == 401:
                #print(data)
                #print("K3S up.")
                return True
        except Exception as e:
            #print(f"this is the reason: {e}")
            time.sleep(sleep_time)
        count += 1
    #print("K3S did not come up withing reasonable time.")
    return False

def get_token(host, ssh_private_key_path):
    """SSH to K3S master and generate a token"""
    try:
        token = check_output(
            ['ssh',
             '-i', ssh_private_key_path,
             '-o', 'IdentitiesOnly=yes',
             '-o', 'StrictHostKeyChecking=no',
             '-o', 'UserKnownHostsFile=/dev/null',
             '-l', 'ubuntu', host, 'sudo' , 'cat', '/var/lib/rancher/k3s/server/node-token'
                ]
            )
        return str(token.decode().rstrip())
    except Exception as e:
        #print(f"this is the reason why k3s token could not be generated: {e}")
        return "no_k3s_token"


def main():
    lines =  {x.strip() for x in sys.stdin}
    for line in lines:
        if line:
            data = json.loads(line)
            # data = {"host": "1.2.3.4"}

    host = data.get('host', None)
    ssh_private_key_path = data.get('ssh_private_key_path', None)
    

    if host and ssh_private_key_path:
        if check_api(host):
            token = get_token(host, ssh_private_key_path)
            if token != 'no_k3s_token':
                #print(f"token: {token}")
                data['cmd'] = token
    else:
        #print("I do not have k3s token")
        data['cmd'] = "no_token_found"

    del data['ssh_private_key_path']

    #print("result --- :", data)
    #sys.stdout.write(json.dumps(data))

    json.dump(data, sys.stdout)
    sys.stdout.flush()


if __name__ == '__main__':
    """
    Execute k3s join commnad retrieval
    """
    main()
