source ../lib/helpers.sh

function test_is_source() {
    local test_description=$1
    local expected=$2
    local inst=$3

    local actual
    is_source "${inst}"
    actual=$?

    local test_result=$( verify_expectations "$actual" "$expected" )
    local inputs="Instruction : $inst"
    append_test_case $test_result "is_source|$test_description|$inputs|$expected|$actual"
}

function test_cases_is_source() {
    local test_description="should check if instruction is a source instruction"
    local expected=0
    local inst="source file.sh"

    test_is_source "$test_description" "$expected" "$inst"
}

function test_get_sourced_file() {
    local test_description=$1
    local expected=$2
    local inst=$3

    local actual=$( get_sourced_file "${inst}" )

    local test_result=$( verify_expectations "$actual" "$expected" )
    local inputs="Instruction : $inst"
    append_test_case $test_result "get_sourced_file|$test_description|$inputs|$expected|$actual"
}

function test_cases_get_sourced_file() {
    local test_description="should give sourced file name"
    local expected="file.sh"
    local inst="source file.sh"

    test_get_sourced_file "$test_description" "$expected" "$inst"
}

function test_get_file_dir() {
    local test_description=$1
    local expected=$2
    local file=$3

    local actual=$( get_file_dir ${file} )

    local test_result=$( verify_expectations "$actual" "$expected" )
    local inputs="Instruction : $file"
    append_test_case $test_result "get_file_dir|$test_description|$inputs|$expected|$actual"
}

function test_cases_get_file_dir() {
    local test_description="should give file directory"
    local expected="dir/dir2"
    local file="dir/dir2/file.sh"

    test_get_file_dir "$test_description" "$expected" "$file"
}