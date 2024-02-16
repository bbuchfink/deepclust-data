cut -f1 $1 | sort | uniq -c | sed -e 's/^[[:space:]]*//' | sort -n -k1,1
