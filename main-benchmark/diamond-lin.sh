/usr/bin/time diamond deepclust -d $1.dmnd -o $1.tsv -M 2000G --mutual-cover 80 \
       --swipe-task-size 10000000 \
       --connected-component-depth 2 -e 0.1 --cluster-steps faster_lin fast_lin \
       shapes-6x10_lin shapes-30x10_lin --no-reassign --anchored-swipe