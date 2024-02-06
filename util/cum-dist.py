#!/usr/bin/env python3

import sys

N=float(sys.argv[1])
n=0.0
interval = 0.001
last = 0.0
last_value = -1.0

for line in sys.stdin:
    n += 1.0
    if (n / N) >= (last + interval):
        last += interval
        value = float(line)
        if value != last_value:
            sys.stdout.write(str(last) + '\t' + str(value) + '\n')
            last_value = value

