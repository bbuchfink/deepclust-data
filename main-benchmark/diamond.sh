/usr/bin/time diamond deepclust -d $1 -o out -M 2000G --mutual-cover 85 --swipe-task-size 10000000 \
        --anchored-swipe --connected-component-depth 1 1 3 3 3 3 -e 0.1 --cluster-steps faster_lin fast_lin \
        fast default sensitive very-sensitive --no-reassign --round-approx-id 27 0 --round-coverage 87 85
../util/get-eval.sh out diamond
