#!/usr/bin/env python3

import csv
import sys

def parse_line(line):
    parts = line.split()
    index = parts[0]
    sequence_id = parts[2].lstrip('>').rstrip('...')

    return index, sequence_id

def process_file():
    writer = csv.writer(sys.stdout, delimiter='\t')

    current_cluster = None
    for line in sys.stdin:
        line = line.strip()
        if line.startswith('>Cluster'):
            current_cluster = line.split()[1]
        elif line:
            index, seq_id = parse_line(line)
            writer.writerow([current_cluster, seq_id])

process_file()
