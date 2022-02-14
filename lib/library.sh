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

function parse() {
  local line=$1

  local separator=";"
   # keywords to make separator as space
  local special_keywords="^do\ *$|^then\ *$|^.*if.*;\ *then|^else|^function.*\(\)|^{$"

  line=$( trim "${line}" )
  if egrep -q "${special_keywords}" <<< "${line}"; then
    separator=" "
  elif egrep -q "^$|^#" <<< "${line}"; then
    return 0
  fi
  echo "${line}" | tr "\n" "${separator}"
}

function minify() {
  local content=$1

  oldIFS=$IFS
  IFS=$'\n'
  echo "#! /bin/bash"
  local line
  for line in ${content}
  do
    parse "${line}"
  done
  IFS=$oldIFS
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
 
  echo -e "Running script\n\n"
  chmod +x "${binded_file}"
  "${binded_file}" "${@:2}"
}

function build() {
  local file=$1

  if [[ ! -f "${file}" ]]; then
    echo "Error : \"$file\" not found" > /dev/stderr
    exit 4
  fi

  echo "Binding files"
  local binded_content
  binded_content="$(bind "${file}")"
  if [[ $? -ne 0 ]]; then
    exit $?
  fi
 
  echo "Creating build file"
  rm -rf build &> /dev/null
  mkdir build

  local filename=$( get_filename "${file}" )
  local build_file="build/${filename}"
  minify "${binded_content}" > "${build_file}"

  echo "Created build file successfully !"
  echo "Use \"brm deploy\" command to deploy your build file"
}