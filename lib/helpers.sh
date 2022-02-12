function is_source() {
  local inst=$1

  grep -q "^source " <<< ${inst}
}

function get_sourced_file() {
  local source_inst=$1

  cut -f2 -d" " <<< $source_inst
}

function get_file_dir() {
  local file_path=$1

  local file_dir="."
  if grep -q ".*/" <<< ${file_path} ; then
    file_dir="${file_path%/*}"
  fi
  
  echo "${file_dir}"
}

function search_element() {
	local searching_element=$1
	local array=("${@:2}")

	local element_index=0
	local array_ele
	for array_ele in "${array[@]}"
	do
		if grep -q "$searching_element" <<< $array_ele ; then
			echo $element_index
			return 0
		fi
		element_index=$(( $element_index + 1 ))
	done
	echo -1
	return 4
}

function get_filename() {
  local file=$1

  echo "${file##*/}"
}