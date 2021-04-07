#!/bin/sh

set -eu

for i in `seq 10`
do
	"${1:-bash}" test.sh
	sha256sum 'mirror.txt'
done
