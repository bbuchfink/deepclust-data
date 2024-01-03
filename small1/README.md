# Data files needed
small1.faa

# MMseqs2
- Requirements: MMseqs2 release 14
- Database creation: `mmseqs createdb small1.faa small1`
- Run benchmark: `./mmseqs.sh`
- `mmseqs createtsv small1 small1 mmseqs_out mmseqs_out.tsv`
