#!/bin/sh
if [ -r /usr/share/w3af/w3af_gui ] ; then 
   /usr/bin/python /usr/share/w3af/w3af_gui $@
fi
