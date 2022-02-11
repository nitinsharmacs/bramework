#! /bin/bash

source lib/library.sh

function build() {
	local file_path=$1
	rm $BUILD_FILE 2> /dev/null
	rm $BIND_FILE 2> /dev/null
	
	mkdir .temp
	cd .temp
	bind "$file_path"
	cd ..
	rmdir .temp 2> /dev/null
	
	strip_code "$BIND_FILE"
	rm "$BIND_FILE"
}

build $1