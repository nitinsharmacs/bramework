CONFIG_FILE=".config.bm"
BUILD_FILE="build/build"
BIND_FILE="$BUILD_FILE.temp"

function init() {
	local keys=("project_name|Project Name" "developers|Developers Name")
	local value
	local key
	local date=$( date "+%Y-%m-%d")
	local version=1
	local project_name

	for key in "${keys[@]}"
	do
		local field=$( echo $key | cut -d"|" -f1 )

		read -p "$( echo $key | cut -d"|" -f2 ) : " value

		[[ $field == "project_name" ]] && { mkdir $value ; project_name=$value ;}

		echo "$field=$value" >>  ${project_name}/${CONFIG_FILE}
	done
	echo "version=${version}" >> ${project_name}/${CONFIG_FILE}
	echo "date=${date}" >> ${project_name}/${CONFIG_FILE}
}

function bind() {
	local file_path=$1
		
	local line
	while IFS= read -r line
	do
		if echo $line | grep -q "^source"
		then
		
			bind $( echo $line | cut -f2 -d" " )
			continue
		fi
		echo $line >> "../$BIND_FILE"
	done < "../$file_path"
	
}

function strip_code(){
	local file_path=$1
	
	local separator
	local special_keywords="^do\ *$|^then\ *$|^.*if.*;\ *then|^else|^function.*\(\)|^{$" # keywords to make separator as space
	
	local do_translation
	local quote
	local echo_n_switch="-n"
	
	local line 	
	while IFS= read -r  line
	do
		separator=";"
		
		# variable with multiline value
		if	echo $line | grep -q ".*=[\'\"]"
		then
			do_translation=1
			echo_n_switch=""
			quote=`echo $line | cut -d"=" -f2 | cut -c1`
		fi
		
		if (( do_translation==1 )) && echo $line | grep -q "${quote}$"
		then
			echo_n_switch="-n"
			do_translation=0
		fi
		
		# removing empty lines and comments
		if  echo $line | egrep -q "^#|^$" 
		then
			continue
		fi
		
		# adding space instead of ; for some special keywords
		if echo $line | egrep -q "$special_keywords"
		then
			separator=" "
		fi
		
		(( do_translation == 0 )) &&	line=`echo "$line" | tr "\n" "$separator" | tr "\t" "\0"`
		
		echo $echo_n_switch "$line" >> $BUILD_FILE
	done < "$file_path"
}