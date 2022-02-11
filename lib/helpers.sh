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