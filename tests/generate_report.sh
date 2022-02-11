SEPARATOR=$( seq -f"-" -s"\0" 20 )

BOLD="\033[1m"
NORMAL="\033[0m"

function display_failed_tests() {
	local failed_tests=("${@}")
	
	echo -e "\n${BOLD}FAILED TEST CASES${NORMAL}"
	local heading test
	for test in "${failed_tests[@]}"
	do
		if [[ $heading != $(echo "$test" | cut -f2 -d"|" ) ]]; then
			heading=$(echo "$test" | cut -f2 -d"|" )
			echo -e "\n${BOLD}$heading${NORMAL}"
		fi
		
		echo -e "\t$( echo "$test" | cut -f3 -d"|")"
		echo -e "\t\tInputs : $( echo "$test" | cut -f4 -d"|")"
		echo -e "\t\tExpected : $( echo "$test" | cut -f5 -d"|")"
		echo -e "\t\tActual : $( echo "$test" | cut -f6 -d"|")"
	done	
}

function display_test_results() {
	local tests=("$@")
	
	local failed_tests=()
	local test heading test_result
	for test in "${tests[@]}"
	do
		if [[ $heading != $(echo "$test" | cut -f2 -d"|" ) ]]; then
			heading=$(echo "$test" | cut -f2 -d"|" )
			echo -e "\n${BOLD}$heading${NORMAL}"
		fi
		echo -en "\t"
		test_result="\033[0;32m✔\033[0m"
		if [[ $( echo "$test" | cut -f1 -d"|" ) == "fail" ]]; then
			test_result="\033[0;31m✗\033[0m"
			failed_tests[${#failed_tests[@]}]="$test"
		fi
		echo -ne "${test_result} "
		echo "${test}" | cut -f3 -d"|"
	done
	echo $SEPARATOR
	echo "FAILED : ${#failed_tests[@]}/${#tests[@]}"
	echo $SEPARATOR

	[[ ${#failed_tests[@]} -le 0 ]] && return 0
	display_failed_tests "${failed_tests[@]}"
}

function generate_report() {
	local tests=("$@")
	clear
	echo "Test Report : "
	display_test_results "${tests[@]}"
}
