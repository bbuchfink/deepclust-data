#!/usr/bin/env python3

import sys

for line in sys.stdin:
    f = line.split(' ')
    for x in f:
        if len(x) > 1:
            print(f[0].rstrip() + '\t' + x.rstrip())
