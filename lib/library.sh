source helpers.sh
source bind.sh
source minify.sh

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
  local bind_status
  binded_content="$(bind "${file}")"
  bind_status=$?
  if [[ ${bind_status} -ne 0 ]]; then
    exit ${bind_status}
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

function deploy() {
  local location=$1

  local file
  file=$( ls build 2> /dev/null )
  if [[ $? -ne 0 || -z $file ]]; then
    echo "No build to deploy" > /dev/stderr
    echo "Use \"brm build\" to make build" > /dev/stderr
    return 1
  fi

  local target_file="${location}/${file%%.*}"
  cp "build/${file}" "${target_file}"
  chmod +x "${target_file}"

  echo "Deployed Successfully to ${location} !"
}