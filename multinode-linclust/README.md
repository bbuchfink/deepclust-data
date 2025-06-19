Instructions to run the linear mode of DIAMOND DeepClust on multiple nodes (extended data fig. 1).
The benchmark was run using DIAMOND v2.1.12. The feature is still experimental in this version, and
only available when compiled using the CMake options `-DEXTRA=ON` and `-DWITH_ZSTD=ON`. `run.sh` is
a SLURM batch script to run the clustering on up to 32 nodes. The `--parallel-tmpdir` option needs
to point to a shared working directory across all nodes.

The input database was the ~19bn experimental study dataset, available in Parquet format (see Data
Availability). This workflow expects the input database to be a 2-column TSV file listing all files
containing the sequences. The first column is the path to a FASTA file containing the sequences,
the second column is the number of sequences in that file. To be efficient, the database should be
split into sufficiently small files. For running the benchmark, we split the database into 8,724
files each containing ~400 million sequence letters.
