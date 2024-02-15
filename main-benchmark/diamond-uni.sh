/usr/bin/time diamond deepclust -d nr.dmnd -o out -M 2000G --member-cover 80 --cluster-steps faster_lin \
	fast_lin fast default more-sensitive \
       	very-sensitive --masking 0 --swipe-task-size 10000000 --anchored-swipe \
	--no-reassign -e 0.1 --connected-component-depth 1 1 3 3 3 1
../util/get-eval.sh out diamond-uni
