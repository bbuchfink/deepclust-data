#!/bin/bash
set -e

echo "$1"
f="$1"
plddt=$(head -n 7 {} | tail -n 5 | cut -f 2 -d ":" | sed 's/ //g' | sed 's/,//g' | tr '\n' ' ')
dcdb=$(grep -c ">" /PATH_TO_AF2_MSAS/msas/bfd_uniref_hits.a3m)
uniref30=$(grep -c "UniRef" /PATH_TO_AF2_MSAS/msas/bfd_uniref_hits.a3m)
mgnify=$(grep "#=GS" /PATH_TO_AF2_MSAS/msas/mgnify_hits.sto | awk '{print $6}' | sort -u | wc -l)
pdb=$(grep -c ">" /PATH_TO_AF2_MSAS/msas/pdb_hits.hhr)
uniref90=$(grep "#=GS" /PATH_TO_AF2_MSAS/msas/uniref90_hits.sto | awk '{print $2}' | cut -f1 -d "/" | sort -u | wc -l)
echo "$f $plddt$dcdb $uniref30 $mgnify $pdb $uniref90" >> msa_sizes