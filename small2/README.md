Scripts needed to reproduce the benchmark on a 10M input file (supplementary fig. 1)

Software needed:

- DIAMOND v2.1.9
- MMseqs2 release 14
- USEARCH 64-bit v11.0.667: Available commercially from https://drive5.com/
- CD-HIT v4.8.1: https://github.com/weizhongli/cdhit
- FLSHclust: The code can be downloaded at https://zenodo.org/records/8371343.
  The `CODE.zip` archive is assumed to be extracted in `$HOME`. All dependencies
  are expected to be installed (see FLSHclust readme). In `CODE/FLSH/flsh.py`, we
  set the default sequence identity cutoff from `0.3` to `0.2` (line 88), as
  changing this parameter on the command line did not work correctly for us.
- LAST release 1540: https://gitlab.com/mcfrith/last
- clusteval
- seqtk
- zstd
