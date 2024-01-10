#!/usr/bin/env python3

from Bio import SeqIO
from Bio.Seq import Seq
import sys

i=0
for record in SeqIO.parse(sys.stdin, "fasta"):
    record.id = str(i)
    record.description=""
    i+=1
    SeqIO.write(record, sys.stdout, "fasta")
