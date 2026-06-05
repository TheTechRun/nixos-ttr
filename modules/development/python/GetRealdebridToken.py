#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import json
import sys
import time

# import sslkeylog
# sslkeylog.set_keylog("sslkeylog.txt")

if sys.version_info[0] == 2:
    from urllib2 import Request, urlopen, URLError
    from urllib import urlencode
else:
    from urllib.request import Request, urlopen
    from urllib.error import URLError
    from urllib.parse import urlencode

USER_AGENT = "pyLoad/0.4.20"
CLIENT_ID = "ECQHUYL5SW3IS"


def fetch_url(url, referer=None, user_agent=USER_AGENT, headers={}, post={}, size=None):
    hdr={
        'Accept': "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        'Accept-Language': "en-US,en;q=0.5",
        'Referer': referer or url,
        'User-Agent': user_agent
    }
    hdr.update(headers)

    data = urlencode(post).encode('ascii') or None

    req = Request(url, data=data, headers=hdr)
    return urlopen(req).read(size)

if __name__ == "__main__":
    try:
        json_data = json.loads(fetch_url("https://api.real-debrid.com/oauth/v2/device/code?client_id=%s&new_credentials=yes" % CLIENT_ID))
    except URLError as e:
        print (str(e))
        exit(-1)

    print ("\nPlease login to your real-debrid account, then go to %s\nand enter the code %s to authorize the request.\n" %
           (json_data['verification_url'], json_data['user_code']))

    device_code = json_data['device_code']
    check_interval = json_data['interval']
    for i in range(json_data['expires_in'], 0, -check_interval):
        try:
            print("\rWaiting for authorization... %s " % i, end='')
            time.sleep(check_interval)
            try:
                json_data = json.loads(fetch_url("https://api.real-debrid.com/oauth/v2/device/credentials?client_id=%s&code=%s" %
                                                 (CLIENT_ID, device_code)))
                break

            except URLError as e:
                if e.code == 403:
                    pass
                else:
                    print (str(e))
                    exit(-1)

        except KeyboardInterrupt:
            print("\nAborted.")
            exit(0)

    else:
        print("\nCode expired.")
        exit(-1)

    client_id = json_data['client_id']
    client_secret = json_data['client_secret']

    json_data = json.loads(fetch_url("https://api.real-debrid.com/oauth/v2/token",
                                     post={'client_id': client_id,
                                           'client_secret': client_secret,
                                           'code': device_code,
                                           'grant_type': "http://oauth.net/grant_type/device/1.0"}))

    refresh_token = json_data['refresh_token']
    print("\n\nYour username for RealDebridCom: %s/%s\nYour Password for RealdebridCom: %s\n" %
          (client_id, client_secret, refresh_token))
