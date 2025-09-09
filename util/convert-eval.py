#!/usr/bin/env python3

import sys

for line in sys.stdin:
    f=line.split('\t')
    for i in range(0,int(f[0])):
        sys.stdout.write(f[1])