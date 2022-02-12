source helpers.sh

BINDED_FILES=()

function is_file_binded() {
  local file=$1
  local binded_files=("${@:2}")

  local index=$( search_element "${file}" "${binded_files[@]}" )
  if [[ $index -lt 0 ]]; then
    return 1
  fi

  diff ${binded_files[$index]} $file
}

function bind() {
  local file=$1
  
  if [[ ! -f "${file}" ]]; then
    echo "Error : \"$file\" not found" > /dev/stderr
    exit 4
  elif is_file_binded "${file}" "${BINDED_FILES[@]}"; then
    return 0
  fi

  local file_dir_path=$( get_file_dir "${file}" )
  local content=$( cat "${file}" )
  
  OLDIFS=$IFS
  IFS=$'\n'
  local line
  for line in ${content}
  do
    IFS=$OLDIFS
    if is_source "${line}"; then
      local source_file="$( get_sourced_file "${line}" )"
      local resolved_path="${file_dir_path}/${source_file}"
      bind "${resolved_path}"
      continue
    fi
    echo "${line}"
  done

  IFS=$OLDIFS
  BINDED_FILES[${#BINDED_FILES[@]}]=${file}
}

function run() {
  local file=$1

  if [[ ! -f "${file}" ]]; then
    echo "Error : \"$file\" not found" > /dev/stderr
    exit 4
  fi

  echo "Binding files"
  local temp_dir=$( mktemp -d )
  local filename=$( get_filename "${file}" )
  local binded_file="${temp_dir}/${filename}"
  bind "${file}" 1> "${binded_file}"
 
  echo "Running script"
  chmod +x "${binded_file}"
  "${binded_file}" "${@:2}"
}