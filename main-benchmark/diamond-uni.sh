/usr/bin/time diamond deepclust -d $1.dmnd -o $1.tsv -M 2000G --member-cover 80 --cluster-steps faster_lin \
	fast_lin fast default more-sensitive \
    very-sensitive --swipe-task-size 10000000 --anchored-swipe \
	--no-reassign -e 0.1 --connected-component-depth 1 1 3 3 3 1