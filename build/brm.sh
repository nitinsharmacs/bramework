#! /bin/bash
function is_source() { local inst=$1;grep -q "^source " <<< ${inst};};function get_sourced_file() { local source_inst=$1;cut -f2 -d" " <<< $source_inst;};function get_file_dir() { local file_path=$1;local file_dir=".";if grep -q ".*/" <<< ${file_path} ; then file_dir="${file_path%/*}";fi;echo "${file_dir}";};function search_element() { local searching_element=$1;local array=("${@:2}");local element_index=0;local array_ele;for array_ele in "${array[@]}";do if grep -q "$searching_element" <<< $array_ele ; then echo $element_index;return 0;fi;element_index=$(( $element_index + 1 ));done;echo -1;return 4;};function get_filename() { local file=$1;echo "${file##*/}";};function trim() { sed "s:^ *::;s:^\t*::;s: *$::;s:\t*$::" <<< "${1}";};BINDED_FILES=();function is_file_binded() { local file=$1;local binded_files=("${@:2}");local index=$( search_element "${file}" "${binded_files[@]}" );if [[ $index -lt 0 ]]; then return 1;fi;diff ${binded_files[$index]} $file;};function bind() { local file=$1;if [[ ! -f "${file}" ]]; then echo "Error : \"$file\" not found" > /dev/stderr;exit 4;elif is_file_binded "${file}" "${BINDED_FILES[@]}"; then return 0;fi;local file_dir_path=$( get_file_dir "${file}" );local content=$( cat "${file}" );OLDIFS=$IFS;IFS=$'\n';local line;for line in ${content};do IFS=$OLDIFS;if is_source "${line}"; then local source_file="$( get_sourced_file "${line}" )";local resolved_path="${file_dir_path}/${source_file}";bind "${resolved_path}";continue;fi;echo "${line}";done;IFS=$OLDIFS;BINDED_FILES[${#BINDED_FILES[@]}]=${file};};function parse() { local line=$1;local separator=";";local special_keywords="^do\ *$|^then\ *$|^.*if.*;\ *then|^else|^function.*\(\)|^{$";line=$( trim "${line}" );if egrep -q "${special_keywords}" <<< "${line}"; then separator=" ";elif egrep -q "^$|^#" <<< "${line}"; then return 0;fi;echo "${line}" | tr "\n" "${separator}";};function minify() { local content=$1;oldIFS=$IFS;IFS=$'\n';echo "#! /bin/bash";local line;for line in ${content};do parse "${line}";done;IFS=$oldIFS;};function run() { local file=$1;if [[ ! -f "${file}" ]]; then echo "Error : \"$file\" not found" > /dev/stderr;exit 4;fi;echo "Binding files";local temp_dir=$( mktemp -d );local filename=$( get_filename "${file}" );local binded_file="${temp_dir}/${filename}";bind "${file}" 1> "${binded_file}";echo -e "Running script\n\n";chmod +x "${binded_file}";"${binded_file}" "${@:2}";};function build() { local file=$1;if [[ ! -f "${file}" ]]; then echo "Error : \"$file\" not found" > /dev/stderr;exit 4;fi;echo "Binding files";local binded_content;local bind_status;binded_content="$(bind "${file}")";bind_status=$?;if [[ ${bind_status} -ne 0 ]]; then exit ${bind_status};fi;echo "Creating build file";rm -rf build &> /dev/null;mkdir build;local filename=$( get_filename "${file}" );local build_file="build/${filename}";minify "${binded_content}" > "${build_file}";echo "Created build file successfully !";echo "Use \"brm deploy\" command to deploy your build file";};function deploy() { local location=$1;if [[ -z $location ]]; then echo "Enter a deploy location" >> /dev/stderr;return 1;fi;local file;file=$( ls build 2> /dev/null );if [[ $? -ne 0 || -z $file ]]; then echo "No build to deploy" > /dev/stderr;echo "Use \"brm build\" to make build" > /dev/stderr;return 1;fi;local target_file="${location}/${file%%.*}";cp "build/${file}" "${target_file}";chmod +x "${target_file}";echo "Deployed Successfully to ${location} !";};function main() { local command=$1;local args=("${@:2}");if [[ ${command} == "run" ]]; then run "${args[@]}";elif [[ ${command} == "build" ]]; then build "${args[@]}";elif [[ ${command} == "deploy" ]]; then deploy "${args[@]}";fi;};main "${@}";