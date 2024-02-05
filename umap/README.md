Steps to reproduce the UMAP plot (Fig. 2)

1. Obtain the FASTA file of representatives from https://datashare.mpcdf.mpg.de/s/WrGg0x9jsuashqo and extract the sequences of the 1M sample (accessions listed in `reps_1M_ge5.tsv.zst`). Save as 1M.faa.
2. Install HuggingFace Transformers and the ProtT5 model available here: https://huggingface.co/Rostlab/prot_t5_xl_uniref50
3. Compute embeddings for the sequences: `./embed.py 1M.faa 1M.prott5.tsv`
4. Install UMAP and pandas. Compute UMAP: `./umap.sh` resulting in `1M.umap.tsv`
