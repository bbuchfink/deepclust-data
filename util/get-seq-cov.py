#!/usr/bin/env python3

import sys

query = ""
cov = []

def get_cov():
    if len(cov) == 0:
        return
    n = 0
    for i in range(0, len(cov)):
        if cov[i] == 1:
            n += 1
    print(query + '\t' + str(float(n)/float(len(cov))))

for line in sys.stdin:
    f = line.split('\t')
    if f[0] != query:
        get_cov()
        query = f[0]
        cov = [0] * int(f[1])
    for i in range(int(f[2])-1, int(f[3])):
        cov[i] = 1

get_cov()
