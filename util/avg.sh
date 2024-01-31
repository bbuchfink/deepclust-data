#!/bin/bash
awk '{ sum += $1; n++ } END { print sum / n }'
