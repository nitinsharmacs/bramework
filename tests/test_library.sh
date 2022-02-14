source ../lib/library.sh

TEST_DATA="tests/data"

function test_is_file_binded() {
  local test_description=$1
  local expected=$2
  local file=$3
  local binded_files=("${@:4}")

  local actual
  is_file_binded $file "${binded_files[@]}"
  actual=$?

  local test_result=$( verify_expectations "$actual" "$expected" )
  local inputs="File : $file, Binded Files : ${binded_files[*]}"
  append_test_case $test_result "is_file_binded|$test_description|$inputs|$expected|$actual"
}

function test_cases_is_file_binded() {
  local test_description="should verify if file already binded"
  local expected=0
  local file="${TEST_DATA}/samples/source.sh"
  local binded_files=("lib/helpers.sh" "${TEST_DATA}/samples/source.sh")
  test_is_file_binded "$test_description" "$expected" "$file" "${binded_files[@]}"

  test_description="should verify if file is not binded"
  expected=1
  file="builde.sh"
  binded_files=("lib/helpers.sh" "${TEST_DATA}/samples/source.sh")
  test_is_file_binded "$test_description" "$expected" "$file" "${binded_files[@]}"
}

function test_bind() {
  local test_description=$1
  local expected=$2
  local expected_file=$3
  local entry_file=$4

  $( bind $entry_file &> "${TEST_DATA}/bind/actual" )

  local actual_file="${TEST_DATA}/bind/actual"
  local actual
  diff ${expected_file} ${actual_file} &> /dev/null
  actual=$?
    
  local test_result=$( verify_expectations "$actual" "$expected" )
  local inputs="Entry File : $entry_file"
  append_test_case $test_result "bind|$test_description|$inputs|$expected|$actual"
}

function test_cases_bind() {
  local test_description="should bind sourced files"
  local expected=0
  local expected_file="${TEST_DATA}/bind/expected"
  local entry_file="${TEST_DATA}/samples/source.sh"

  test_bind "$test_description" "$expected" "${expected_file}" "$entry_file"

  test_description="should give error if any source file not found"
  expected=0
  expected_file="${TEST_DATA}/bind/expected_error"
  entry_file="${TEST_DATA}/samples/sourc.sh"

  test_bind "$test_description" "$expected" "${expected_file}" "$entry_file"
}

function test_minify() {
  local test_description=$1
  local expected=$2
  local expected_file=$3
  local file=$4
  
  local content=$( cat "${file}" )
  $( minify "${content}" &> "${TEST_DATA}/minify/actual" )

  local actual_file="${TEST_DATA}/minify/actual"
  local actual
  diff ${expected_file} ${actual_file} &> /dev/null
  actual=$?
    
  local test_result=$( verify_expectations "$actual" "$expected" )
  local inputs="File : $file"
  append_test_case $test_result "minify|$test_description|$inputs|$expected|$actual"
}

function test_cases_minify() {
  local test_description="should minify if statements"
  local expected=0
  local expected_file="${TEST_DATA}/minify/if/expected.sh"
  local file="${TEST_DATA}/minify/if/source.sh"

  test_minify "$test_description" "$expected" "${expected_file}" "$file"

  test_description="should minify loops"
  expected=0
  expected_file="${TEST_DATA}/minify/loops/expected.sh"
  file="${TEST_DATA}/minify/loops/source.sh"

  test_minify "$test_description" "$expected" "${expected_file}" "$file"

  test_description="should minify function"
  expected=0
  expected_file="${TEST_DATA}/minify/function/expected.sh"
  file="${TEST_DATA}/minify/function/source.sh"

  test_minify "$test_description" "$expected" "${expected_file}" "$file"
}

function test_run() {
  local test_description=$1
  local expected=$2
  local expected_file=$3
  local entry_file=$4

  $( run $entry_file &> "${TEST_DATA}/run/actual" )

  local actual_file="${TEST_DATA}/run/actual"
  local actual
  diff ${expected_file} ${actual_file} &> /dev/null
  actual=$?
    
  local test_result=$( verify_expectations "$actual" "$expected" )
  local inputs="Entry File : $entry_file"
  append_test_case $test_result "run|$test_description|$inputs|$expected|$actual"
}

function test_cases_run() {
  local test_description="should run the scripts"
  local expected=0
  local expected_file="${TEST_DATA}/run/expected"
  local entry_file="${TEST_DATA}/samples/run_sample.sh"

  test_run "$test_description" "$expected" "${expected_file}" "$entry_file"

  test_description="should give error if entry file doesn't exist"
  expected=0
  expected_file="${TEST_DATA}/run/expected_error"
  entry_file="${TEST_DATA}/samples/run_sampl.sh"

  test_run "$test_description" "$expected" "${expected_file}" "$entry_file"

  test_description="should give error if any of the source file is missing"
  expected=0
  expected_file="${TEST_DATA}/run/expected_error2"
  entry_file="${TEST_DATA}/samples/run_sample_error.sh"

  test_run "$test_description" "$expected" "${expected_file}" "$entry_file"
}