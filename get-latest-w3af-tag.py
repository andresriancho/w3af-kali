#!/usr/bin/env python

import sys
import requests
import semver

from requests.auth import HTTPBasicAuth

# hackish ugly
TOKEN = '5f524d5c0a775091c8d5b9fa6b8e96682cba393d'[::-1]
URL = 'https://api.github.com/repos/andresriancho/w3af/tags'

data = requests.get(URL, auth=HTTPBasicAuth(TOKEN, 'x-oauth-basic')).json()
try:
    tag_names = [x['name'] for x in data]
except TypeError:
    print('Unexpected data: "%s"' % data)
    sys.exit(1)

valid_tags = []

for tag_name in tag_names:
    try:
        semver.parse(tag_name)
    except ValueError:
        pass
    else:
        valid_tags.append(tag_name)

valid_tags.sort(semver.compare)
print valid_tags[-1]