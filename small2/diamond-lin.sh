diamond deepclust -d 10M.faa -o out -M 2000G --mutual-cover 80 --swipe-task-size 10000000 \
        --anchored-swipe --connected-component-depth 1 1 3 --cluster-steps faster_lin fast_lin \
	shapes-30x10_lin --no-reassign --round-coverage 87 87 --round--approx-id 27 27
../util/get-eval-small.sh out "diamond-linear"
