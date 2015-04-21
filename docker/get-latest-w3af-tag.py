#!/usr/bin/env python

import requests

url = 'https://api.github.com/repos/andresriancho/w3af/releases'

data = requests.get(url).json()
print data[0]['tag_name']
