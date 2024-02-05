#!/bin/bash

cut -f1 --complement 1M.prott5.tsv > umap_input.tsv
./calc-umap.py
paste <(cut -f1 1M.prott5.tsv) umap_output.tsv > 1M.umap.tsv
