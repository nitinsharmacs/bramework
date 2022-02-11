source lib/helpers.sh
function bind() {
  local file=$1

  if [[ ! -f ${file} ]]; then
    echo "Error : \"$file\" not found"
    exit 4
  fi

  local file_dir_path=$( get_file_dir ${file} )
  local content=$( cat ${file} )
  
  OLDIFS=$IFS
  IFS=$'\n'
  local line
  for line in ${content}
  do
    if is_source ${line}; then
      local source_file="${file_dir_path}/$( get_sourced_file "${line}" )"
      bind "${source_file}"
      continue
    fi
    echo "${line}"
  done

  IFS=$OLDIFS
}