#!/bin/bash

nohup python2.7 $ASSET_DIR/scripts/server.py 127.0.0.1:8080 &
python my_py.py
exit 0
