Steps to reproduce the UMAP plot (Fig. 2)

1. Obtain the FASTA file of representatives from https://datashare.mpcdf.mpg.de/s/WrGg0x9jsuashqo and extract the sequences of the 1M sample (accessions listed in `reps_1M_ge5.tsv.zst`). Save as 1M.faa.
2. Install HuggingFace Transformers and the ProtT5 model available here: https://huggingface.co/Rostlab/prot_t5_xl_uniref50
3. Compute embeddings for the sequences: `./embed.py 1M.faa 1M.prott5.tsv`
4. Install UMAP and pandas. Compute UMAP: `./umap.sh` resulting in `1M.umap.tsv`
5. Download ASTRAL: https://scop.berkeley.edu/downloads/scopeseq-2.08/astral-scopedom-seqres-gd-sel-gs-bib-95-2.08.fa
   Download ECOD: http://prodata.swmed.edu/ecod/distributions/ecod.latest.F70.fasta.txt
   Download CATH: ftp://orengoftp.biochem.ucl.ac.uk/cath/releases/all-releases/v4_3_0/sequence-data/cath-domain-seqs-S95-v4_3_0.fa
6. Run DIAMOND against ASTRAL+ECOD+CATH: `./astral.sh` resulting in `astral.tsv` containing accessions of sequences annotated over >=60% of their range.
7. Download and extract Pfam: https://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam35.0/Pfam-A.hmm.gz
8. Run HMMER against Pfam: `./pfam.sh` resulting in `pfam.tsv` containing accessions of sequences annotated over >=60% of their range.
