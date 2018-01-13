export DEEP_LEARNING_USER="ubuntu"
export DEEP_LEARNING_SERVER=""
export DEEP_LEARNING_KEY=""
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION="us-east-2"

get_conda_activate_command () {
	PATH_TO_CONDA="/home/$DEEP_LEARNING_USER/anaconda3"
	CONDA_ENV="tensorflow_p36"
	COMMAND_ACTIVATE="source ${PATH_TO_CONDA}/bin/activate $CONDA_ENV"
	echo $COMMAND_ACTIVATE
}

connect_ec2 () {
	usage () {
	 echo "Connect to aws ec2 intances in various manners"
	  echo "options:"
			echo "-h      show help"
			echo "-p      specify local port for port forwarding"
			echo "-d      specify directory to run commands from"
			echo "-x      specify server port forward port"
			echo "-s      specify server name"
			echo "-u      specify user"
			echo "-c      specify command to run on server"
			echo "-i      specify key to use to connect"
			echo "-f      specify whether to force port forwarding"
			echo "-b      specify whether to run in background"
			
	  1>&2; exit 1;
	}

	PORT=8888
	PORT_SERVER=8888
	KEY=$DEEP_LEARNING_KEY
	SERVER=$DEEP_LEARNING_SERVER
	USER_CONNECT=$DEEP_LEARNING_USER
	DIR_ROOT="/home/$USER_CONNECT"
	SHOULD_RUN_COMMAND=false
	SHOULD_PORT_FORWARD=false
	SHOULD_RUN_IN_BACKGROUND=false
	VERBOSE=false
	JUPYTER_FILE_NAME="jupyter.txt"
	while getopts "h?p:d:x:c:s:i:v:f:u:b:" args; do
		case $args in
		    h|\?)
		usage;
		exit;;
	    d ) DIR_ROOT=${OPTARG}
		if [ "$VERBOSE" = true ]; then echo "UPDATED Directory Root: $DIR_ROOT"; fi;; 
	    p ) PORT=${OPTARG}
		SHOULD_PORT_FORWARD=true
		if [ "$VERBOSE" = true ]; then echo "Updated Port: $PORT"; fi;;
	    x ) PORT_SERVER=${OPTARG}
		SHOULD_PORT_FORWARD=true
		if [ "$VERBOSE" = true ]; then echo "Updated Port: $PORT_SERVER"; fi ;;
	    c ) COMMAND=${OPTARG}
		SHOULD_RUN_COMMAND=true
		if [ "$VERBOSE" = true ]; then echo "Updated Command: $COMMAND"; fi;;
	    u) USER_CONNECT=${OPTARG}
		#DIR_ROOT="/home/$USER_CONNECT"
		if [ "$VERBOSE" = true ]; then echo "Updated User: $USER_CONNECT"; fi;;
	    s) SERVER=${OPTARG}
		if [ "$VERBOSE" = true ]; then echo "Updated Server $SERVER"; fi;;
	    i ) KEY=${OPTARG}
		if [ "$VERBOSE" = true ]; then echo "Updated Key: $KEY"; fi;;
	    j ) COMMAND="$(get_conda_activate_command) && jupyter notebook > $JUPYTER_FILE_NAME 2>&1"
		SHOULD_PORT_FORWARD=true
		SHOULD_RUN_COMMAND=true
		if [ "$VERBOSE" = true ]; then echo "Updated Comand: $COMMAND"; fi;;
	    v ) VERBOSE=true
		if [ "$VERBOSE" = true ]; then echo "Updated Verbosity: $VERBOSE"; fi;;
	    b ) SHOULD_RUN_IN_BACKGROUND=true
		if [ "$VERBOSE" = true ]; then echo "Updated Should Run in Background: $SHOULD_RUN_IN_BACKGROUND"; fi;;
	    f ) SHOULD_PORT_FORWARD=true
		if [ "$VERBOSE" = true ]; then echo "Updated Should Port Forawrd: $SHOULD_PORT_FORWARD"; fi;;
	    : )
		if [ "$VERBOSE" = true ]; then echo "Missing option argument for -$OPTARG" >&2; exit 1; fi;;
	    *  )
		if [ "$VERBOSE" = true ]; then echo "Unimplemented option: -$OPTARG" >&2; exit 1; fi;;
	  esac
	done
	#RUN_COMMAND="-t \"cd $HOME_DIR"
	if [ "$SHOULD_RUN_COMMAND" = true ]; then
		#RUN_COMMAND="$RUN_COMMAND && $COMMAND"
		RUN_COMMAND="-t \"cd $DIR_ROOT && $COMMAND\""
	fi
	#RUN_COMMAND="${RUN_COMMAND}\""
	if [ "$SHOULD_PORT_FORWARD" = true ]; then
		PORT_FORWARD="-L localhost:${PORT}:localhost:${PORT_SERVER} "
	else
		PORT_FORWARD=""
	fi
	
	if [ "$SHOULD_RUN_IN_BACKGROUND" = true ]; then
		BACKGROUND_COMMAND="-fN "
	else
		BACKGROUND_COMMAND=""
	fi

	OPTIONS_SSH="${PORT_FORWARD}-i $KEY ${BACKGROUND_COMMAND}"
	C="ssh $OPTIONS_SSH ${USER_CONNECT}@${SERVER} $RUN_COMMAND"
	if [ "$VERBOSE" = true ]; then echo $C; fi
	eval $C
}

open_web_page () {
	/usr/bin/open -a "/Applications/Google Chrome.app" $1
}

load_jupyter_notebook () {
	PORT_SERVER_JUPYTER=8888
	PORT_LOCAL=${1:-8888}
	TMP_FILE_NAME="jupyter.tmp"
	FILE_LOAD_NAME="jupyter.txt"
	COMMAND="cat $FILE_LOAD_NAME | grep 'Copy/paste' -A2 | grep '?token='" 
	connect_ec2 -c $COMMAND | sed "s/${PORT_SERVER_JUPYTER}/${PORT_LOCAL}/" > $TMP_FILE_NAME
	URL_JUPYTER=$(cat $TMP_FILE_NAME | tail -1 | tr -d '[:space:]')
	rm $TMP_FILE_NAME
	connect_ec2 -p $PORT_LOCAL -x $PORT_SERVER_JUPYTER -b1 >/dev/null 2>&1
	open_web_page $URL_JUPYTER	
}

start_deep_learning_notebook () {
	connect_ec2 -j
}

save_to_deep_learning () {
	scp -i $DEEP_LEARNING_KEY $1 $DEEP_LEARNING_USER@$DEEP_LEARNING_SERVER:$2
}

run_on_deep_learning_notebook () {
	RUN_PROGRAM="python"
	COMMAND_ACTIVATE=$(get_conda_activate_command)
	save_to_deep_learning $1
	connect_ec2 -c "$COMMAND_ACTIVATE && $RUN_PROGRAM $1"
}

start_deep_learning_notebook() {
	connect_ec2 "$@" -f 1 -c "$(get_conda_activate_command) && jupyter notebook"
}
