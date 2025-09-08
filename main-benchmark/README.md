Script for running the main benchmark.

Data files needed: `arch80_all.tsv`, `nr_accessions.tsv.zst`

Software needed:

- MMseqs2 release 14
- DIAMOND v2.1.13 for the bi-directional runs. DIAMOND v2.1.9 (compiled using `-DEXTRA=ON`)
  for the uni-directional runs.
- FLSHclust: The code can be downloaded at https://zenodo.org/records/8371343.
  The `CODE.zip` archive is assumed to be extracted in `$HOME`. All dependencies
  are expected to be installed (see FLSHclust readme). In `CODE/FLSH/flsh.py`, we
  set the default sequence identity cutoff from `0.3` to `0.2` (line 88), as
  changing this parameter on the command line did not work correctly for us.
- clusteval
- seqtk
- zstd

Setup: `./setup.sh`

Run: `./run.sh`

To plot Fig. 1a: Insert runtimes (in hours) into `Fig1a_data.tsv`, run `Fig1a.R`.

To plot Fig. 1b: Insert runtimes (in hours) into `Fig1b_data.tsv`, run `Fig1b.R`.

To plot Fig. 1c+d: Run `Fig1c.R`.

The script `diamond-uni-30-90.sh` can be used for a benchmarking run with 90%
uni-directional coverage and 30% sequence identity, mentioned in the methods section
but not included in the main benchmark.