#!/usr/bin/env python3
from Bio import SeqIO
out = open("10Mx.faa", "w")
for record in SeqIO.parse("10M.faa", "fasta"):
	record.seq = str(record.seq).replace('X', '*')
	SeqIO.write(record, out, "fasta")
