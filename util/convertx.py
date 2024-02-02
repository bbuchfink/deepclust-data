#!/usr/bin/env python3
import sys
from Bio import SeqIO
out = open(sys.argv[2], "w")
for record in SeqIO.parse(sys.argv[1], "fasta"):
	record.seq = str(record.seq).replace('X', '*')
	SeqIO.write(record, out, "fasta")
