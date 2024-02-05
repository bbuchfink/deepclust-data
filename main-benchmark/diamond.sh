/usr/bin/time diamond deepclust -d $1 -o out -M 2000G --mutual-cover 80 --swipe-task-size 10000000 \
        --anchored-swipe --connected-component-depth 1 1 3 3 3 1 -e 0.1 --cluster-steps faster_lin fast_lin \
        fast default sensitive very-sensitive --no-reassign
../util/get-eval.sh out diamond
