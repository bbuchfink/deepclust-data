Script for running the main benchmark.

Data files needed: `arch80_all.tsv`, `nr_accessions.tsv.zst`

Software needed:

- MMseqs2
- DIAMOND
- FLSHclust: The code can be downloaded at https://zenodo.org/records/8371343.
  The `CODE.zip` archive is assumed to be extracted in `$HOME`. All dependencies
  are expected to be installed (see FLSHclust readme).
- clusteval
- seqtk

Setup: `./setup.sh`

Run: `./run.sh`
