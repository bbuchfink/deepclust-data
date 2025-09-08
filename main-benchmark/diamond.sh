/usr/bin/time diamond deepclust -d $1.dmnd -o $1.tsv -M 2000G --mutual-cover 80 \
        --swipe-task-size 10000000 --round-approx-id 27 0 --round-coverage 87 85 \
       --connected-component-depth 3 -e 0.1 --cluster-steps faster_lin fast_lin \
       fast default sensitive very-sensitive --no-reassign --anchored-swipe