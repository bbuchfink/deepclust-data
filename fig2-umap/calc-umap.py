#!/usr/bin/env python3
import umap
import numpy
import pandas
from sklearn.datasets import load_digits

data = pandas.read_csv('umap_input.tsv', sep='\t')
t = umap.UMAP().fit_transform(data)
numpy.savetxt("umap_output.tsv", t, delimiter="\t")
