/usr/bin/time diamond deepclust -d $1 -o out -M 2000G --mutual-cover 80 --swipe-task-size 10000000 \
        --anchored-swipe --connected-component-depth 1 1 2 --cluster-steps faster_lin fast_lin \
	shapes-30x10_lin --no-reassign -e 0.1
../util/get-eval.sh out "diamond-lin"