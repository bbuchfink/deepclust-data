Script for running the main benchmark.

Data files needed: `arch80_all.tsv`, `nr_accessions.tsv.zst`

Software needed:

- MMseqs2 release 14
- DIAMOND v2.1.9
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
To plot Fig. 1c: Run `Fig1c.R` with parameter `prec` to plot precision or `sens`
to plot sensitivity.